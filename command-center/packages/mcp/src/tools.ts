import { readTracker, findTask, getMilestoneById, allMilestones } from './services/tracker.service.js'
import {
  startTask, completeTask, approveTask, rejectTask,
  resetTask, blockTask, unblockTask, updateTask,
  logAction, enrichTask,
} from './services/task.service.js'
import {
  addMilestoneNote, setMilestoneDates, updateDrift,
  createMilestone, addMilestoneTask, activateMilestone,
  moveMilestoneToCompleted,
} from './services/milestone.service.js'
import { registerAgent } from './services/agent.service.js'
import type { Agent, AgentLogEntry, Milestone, Subtask } from './types.js'
import {
  buildTaskContext, buildTaskSummary, buildProjectStatus,
  buildMilestoneOverview,
} from './context.js'
import { z } from 'zod'

type ToolResult = { content: Array<{ type: string; text: string }>; isError?: boolean }

function ok(text: string): ToolResult {
  return { content: [{ type: 'text', text }] }
}

function err(text: string): ToolResult {
  return { content: [{ type: 'text', text }], isError: true }
}

function serviceToTool(result: { ok: boolean; data?: string; error?: string }): ToolResult {
  return result.ok ? ok(result.data!) : err(result.error!)
}

// Validate args against inputSchema using Zod
function validateArgs(args: Record<string, any>, inputSchema: any): { success: boolean; data?: Record<string, any>; error?: string } {
  try {
    const schema = z.object(
      Object.fromEntries(
        Object.entries(inputSchema.properties || {}).map(([key, val]: [string, any]) => {
          let zodType: any
          switch (val.type) {
            case 'string': zodType = z.string(); break
            case 'number': zodType = z.number(); break
            case 'boolean': zodType = z.boolean(); break
            case 'array': zodType = z.array(z.any()); break
            default: zodType = z.any()
          }
          return [key, inputSchema.required?.includes(key) ? zodType : zodType.optional()]
        })
      )
    )
    const result = schema.safeParse(args)
    if (!result.success) {
      return { success: false, error: `Invalid args: ${result.error.issues.map((e: any) => `${e.path.join('.')}: ${e.message}`).join(', ')}` }
    }
    return { success: true, data: result.data }
  } catch (e: any) {
    return { success: false, error: `Validation error: ${e.message}` }
  }
}

export async function handleTool(name: string, args: Record<string, any>): Promise<ToolResult> {
  try {
    const defs = getToolDefinitions()
    const def = defs.find(d => d.name === name)
    if (!def) return err(`Unknown tool: ${name}`)

    // Validate args against inputSchema using Zod
    if (def.inputSchema) {
      const validation = validateArgs(args, def.inputSchema)
      if (!validation.success) {
        return err(validation.error!)
      }
      args = validation.data! // Use validated + coerced args
    }

    switch (name) {
      // ── READ TOOLS ──────────────────────────────────────────
      case 'get_task_context': {
        const state = readTracker()
        const found = findTask(state, args.task_id)
        if (!found) return err(`Task not found: ${args.task_id}`)
        return ok(buildTaskContext(state, found.subtask, found.milestone))
      }
      case 'get_task_summary': {
        const state = readTracker()
        const found = findTask(state, args.task_id)
        if (!found) return err(`Task not found: ${args.task_id}`)
        return ok(buildTaskSummary(state, found.subtask, found.milestone))
      }
      case 'get_project_status':
        return ok(buildProjectStatus(readTracker()))
      case 'get_milestone_overview': {
        const state = readTracker()
        const milestone = getMilestoneById(state, args.milestone_id)
        if (!milestone) return err(`Milestone not found: ${args.milestone_id}`)
        return ok(buildMilestoneOverview(milestone, state))
      }
      case 'list_tasks':
        return toolListTasks(args)
      case 'get_task_history': {
        const state = readTracker()
        const entries = (state.agent_log || [])
          .filter((l: AgentLogEntry) => l.target_id === args.task_id)
          .sort((a: AgentLogEntry, b: AgentLogEntry) => a.timestamp.localeCompare(b.timestamp))
        if (entries.length === 0) return ok(`No history for task: ${args.task_id}`)
        const lines = [`# History for ${args.task_id}`, '']
        for (const e of entries) {
          lines.push(`- **${e.timestamp}** [${e.action}] ${e.description} (${e.agent_id})`)
        }
        return ok(lines.join('\n'))
      }
      case 'list_agents': {
        const state = readTracker()
        const agents = state.agents || []
        const lines = ['# Agents', '']
        for (const a of agents) {
          lines.push(`## ${a.name} (\`${a.id}\`)`)
          lines.push(`- **Type:** ${a.type}`)
          lines.push(`- **Status:** ${a.status}`)
          lines.push(`- **Permissions:** ${a.permissions.join(', ')}`)
          lines.push(`- **Last Action:** ${a.last_action_at ?? 'never'}`)
          lines.push(`- **Session Actions:** ${a.session_action_count}`)
          if (a.parent_id) lines.push(`- **Parent:** ${a.parent_id}`)
          lines.push('')
        }
        return ok(lines.join('\n'))
      }
      case 'get_activity_feed':
        return toolGetActivityFeed(args)

      // ── WRITE: TASK LIFECYCLE ───────────────────────────────
      case 'start_task':
        return serviceToTool(startTask(args.task_id, args.agent_id))
      case 'complete_task':
        return serviceToTool(completeTask(args.task_id, args.summary, args.agent_id))
      case 'approve_task':
        return serviceToTool(approveTask(args.task_id, args.feedback))
      case 'reject_task':
        return serviceToTool(rejectTask(args.task_id, args.feedback))
      case 'reset_task':
        return serviceToTool(resetTask(args.task_id))
      case 'block_task':
        return serviceToTool(blockTask(args.task_id, args.reason))
      case 'unblock_task':
        return serviceToTool(unblockTask(args.task_id, args.resolution))
      case 'update_task':
        return serviceToTool(updateTask(args.task_id, args))
      case 'log_action':
        return serviceToTool(logAction(args.task_id, args.action, args.description, args.agent_id, args.tags))

      // ── WRITE: TASK ENRICHMENT ──────────────────────────────
      case 'enrich_task':
        return serviceToTool(enrichTask(args.task_id, args))

      // ── WRITE: MILESTONE MANAGEMENT ─────────────────────────
      case 'add_milestone_note':
        return serviceToTool(addMilestoneNote(args.milestone_id, args.note))
      case 'set_milestone_dates':
        return serviceToTool(setMilestoneDates(args.milestone_id, args))
      case 'update_drift':
        return serviceToTool(updateDrift(args.milestone_id, args.drift_days))
      case 'activate_milestone':
        return serviceToTool(activateMilestone(args.milestone_id))
      case 'complete_milestone':
        return serviceToTool(moveMilestoneToCompleted(args.milestone_id))
      case 'create_milestone':
        return serviceToTool(createMilestone(args.id, args.title, args))
      case 'add_milestone_task':
        return serviceToTool(addMilestoneTask(args.milestone_id, args.label, args))

      // ── WRITE: AGENT MANAGEMENT ─────────────────────────────
      case 'register_agent':
        return serviceToTool(registerAgent(args.agent_id, args.name, args.type, args.permissions, args))

      default:
        return err(`Unknown tool: ${name}`)
    }
  } catch (e: any) {
    return err(`Error: ${e.message}`)
  }
}

function toolListTasks(args: Record<string, any>): ToolResult {
  const state = readTracker()
  let milestones = allMilestones(state)

  if (args.milestone_id) {
    milestones = milestones.filter((m: Milestone) => m.id === args.milestone_id)
  }
  if (args.domain) {
    milestones = milestones.filter((m: Milestone) => m.domain === args.domain)
  }

  const lines: string[] = []
  for (const m of milestones) {
    let tasks = m.subtasks
    if (args.status) {
      tasks = tasks.filter((t: Subtask) => t.status === args.status)
    }
    if (tasks.length === 0) continue
    lines.push(`## ${m.title} (${m.id})`)
    lines.push('')
    for (const t of tasks) {
      const icon = t.status === 'done' ? '[x]' : t.status === 'in_progress' ? '[~]' : t.status === 'review' ? '[r]' : t.status === 'blocked' ? '[!]' : '[ ]'
      const assignee = t.assignee ? ` → ${t.assignee}` : ''
      lines.push(`- ${icon} \`${t.id}\` ${t.label}${assignee}`)
    }
    lines.push('')
  }

  if (lines.length === 0) return ok('No tasks match the given filters.')
  return ok(lines.join('\n'))
}

function toolGetActivityFeed(args: Record<string, any>): ToolResult {
  const state = readTracker()
  let entries = [...(state.agent_log || [])].sort((a: AgentLogEntry, b: AgentLogEntry) => b.timestamp.localeCompare(a.timestamp))
  if (args.agent_id) {
    entries = entries.filter((e: AgentLogEntry) => e.agent_id === args.agent_id)
  }
  const limit = typeof args.limit === 'number' ? args.limit : 30
  entries = entries.slice(0, limit)

  if (entries.length === 0) return ok('No activity entries found.')

  const lines: string[] = ['# Activity Feed', '']
  let currentDate = ''
  for (const e of entries) {
    const date = e.timestamp.split('T')[0]
    if (date !== currentDate) {
      currentDate = date
      lines.push(`## ${date}`)
    }
    lines.push(`- **${e.timestamp}** [${e.agent_id}] ${e.action}: ${e.description}`)
  }
  return ok(lines.join('\n'))
}

// ════════════════════════════════════════════════════════════
//  TOOL DEFINITIONS (unchanged schema)
// ════════════════════════════════════════════════════════════

export function getToolDefinitions() {
  return [
    {
      name: 'get_task_context',
      description: 'Get full context (~8K tokens) for a task including metadata, acceptance criteria, constraints, context files, revision history, and dependencies',
      inputSchema: {
        type: 'object' as const,
        properties: { task_id: { type: 'string', description: 'Task ID' } },
        required: ['task_id'],
      },
    },
    {
      name: 'get_task_summary',
      description: 'Get a slim summary (~500 tokens) of a task with key metadata, acceptance criteria, constraints, and context files',
      inputSchema: {
        type: 'object' as const,
        properties: { task_id: { type: 'string', description: 'Task ID' } },
        required: ['task_id'],
      },
    },
    {
      name: 'get_project_status',
      description: 'Get current project status including week, schedule status, progress, and task breakdown',
      inputSchema: { type: 'object' as const, properties: {}, required: [] },
    },
    {
      name: 'get_milestone_overview',
      description: 'Get milestone details including progress, drift, task list with status icons, and dependencies',
      inputSchema: {
        type: 'object' as const,
        properties: { milestone_id: { type: 'string', description: 'Milestone ID' } },
        required: ['milestone_id'],
      },
    },
    {
      name: 'list_tasks',
      description: 'List and filter tasks by milestone, status, or domain. Returns grouped Markdown output.',
      inputSchema: {
        type: 'object' as const,
        properties: {
          milestone_id: { type: 'string', description: 'Filter by milestone ID' },
          status: { type: 'string', description: 'Filter by status (todo, in_progress, review, done, blocked)' },
          domain: { type: 'string', description: 'Filter by domain' },
        },
        required: [],
      },
    },
    {
      name: 'get_task_history',
      description: 'Get chronological history of all actions on a task from the agent log',
      inputSchema: {
        type: 'object' as const,
        properties: { task_id: { type: 'string', description: 'Task ID' } },
        required: ['task_id'],
      },
    },
    {
      name: 'list_agents',
      description: 'List all registered agents with their type, status, permissions, and activity stats',
      inputSchema: { type: 'object' as const, properties: {}, required: [] },
    },
    {
      name: 'get_activity_feed',
      description: 'Get recent activity feed sorted by time, optionally filtered by agent. Returns grouped Markdown.',
      inputSchema: {
        type: 'object' as const,
        properties: {
          agent_id: { type: 'string', description: 'Filter by agent ID' },
          limit: { type: 'number', description: 'Max entries to return (default 30)' },
        },
        required: [],
      },
    },
    {
      name: 'start_task',
      description: 'Start a task: set status to in_progress, assign agent, auto-stamp milestone actual_start',
      inputSchema: {
        type: 'object' as const,
        properties: {
          task_id: { type: 'string', description: 'Task ID' },
          agent_id: { type: 'string', description: 'Agent ID to assign (default: orchestrator)' },
        },
        required: ['task_id'],
      },
    },
    {
      name: 'complete_task',
      description: 'Mark a task as ready for review with a completion summary',
      inputSchema: {
        type: 'object' as const,
        properties: {
          task_id: { type: 'string', description: 'Task ID' },
          summary: { type: 'string', description: 'Completion summary' },
          agent_id: { type: 'string', description: 'Agent ID' },
        },
        required: ['task_id', 'summary'],
      },
    },
    {
      name: 'approve_task',
      description: 'Approve a reviewed task: mark done, auto-stamp milestone actual_end, unblock dependents',
      inputSchema: {
        type: 'object' as const,
        properties: {
          task_id: { type: 'string', description: 'Task ID' },
          feedback: { type: 'string', description: 'Optional approval feedback' },
        },
        required: ['task_id'],
      },
    },
    {
      name: 'reject_task',
      description: 'Reject a reviewed task: send back to in_progress with revision feedback',
      inputSchema: {
        type: 'object' as const,
        properties: {
          task_id: { type: 'string', description: 'Task ID' },
          feedback: { type: 'string', description: 'Rejection feedback (required)' },
        },
        required: ['task_id', 'feedback'],
      },
    },
    {
      name: 'reset_task',
      description: 'Reset a task to todo, clearing all progress fields',
      inputSchema: {
        type: 'object' as const,
        properties: { task_id: { type: 'string', description: 'Task ID' } },
        required: ['task_id'],
      },
    },
    {
      name: 'block_task',
      description: 'Block a task with a reason',
      inputSchema: {
        type: 'object' as const,
        properties: {
          task_id: { type: 'string', description: 'Task ID' },
          reason: { type: 'string', description: 'Reason for blocking (required)' },
        },
        required: ['task_id', 'reason'],
      },
    },
    {
      name: 'unblock_task',
      description: 'Unblock a blocked task, returning it to todo or in_progress',
      inputSchema: {
        type: 'object' as const,
        properties: {
          task_id: { type: 'string', description: 'Task ID' },
          resolution: { type: 'string', description: 'Resolution note' },
        },
        required: ['task_id'],
      },
    },
    {
      name: 'update_task',
      description: 'Update task fields: priority, assignee, execution_mode, or notes',
      inputSchema: {
        type: 'object' as const,
        properties: {
          task_id: { type: 'string', description: 'Task ID' },
          priority: { type: 'string', description: 'New priority' },
          assignee: { type: 'string', description: 'New assignee' },
          execution_mode: { type: 'string', description: 'New execution mode (human, agent, pair)' },
          notes: { type: 'string', description: 'New notes' },
        },
        required: ['task_id'],
      },
    },
    {
      name: 'log_action',
      description: 'Log a custom action on a task',
      inputSchema: {
        type: 'object' as const,
        properties: {
          task_id: { type: 'string', description: 'Task ID' },
          action: { type: 'string', description: 'Action name' },
          description: { type: 'string', description: 'Action description' },
          tags: { type: 'array', items: { type: 'string' }, description: 'Tags' },
          agent_id: { type: 'string', description: 'Agent ID' },
        },
        required: ['task_id', 'action', 'description'],
      },
    },
    {
      name: 'enrich_task',
      description: 'Enrich a task with prompt, builder_prompt, acceptance_criteria, constraints, context_files, or reference_docs. Arrays are replaced, not merged.',
      inputSchema: {
        type: 'object' as const,
        properties: {
          task_id: { type: 'string', description: 'Task ID' },
          prompt: { type: 'string', description: 'Task prompt' },
          builder_prompt: { type: 'string', description: 'Builder prompt' },
          acceptance_criteria: { type: 'array', items: { type: 'string' }, description: 'Acceptance criteria (replaces existing)' },
          constraints: { type: 'array', items: { type: 'string' }, description: 'Constraints (replaces existing)' },
          context_files: { type: 'array', items: { type: 'string' }, description: 'Context files (replaces existing)' },
          reference_docs: { type: 'array', items: { type: 'string' }, description: 'Reference docs (replaces existing)' },
        },
        required: ['task_id'],
      },
    },
    {
      name: 'add_milestone_note',
      description: 'Append a note to a milestone',
      inputSchema: {
        type: 'object' as const,
        properties: {
          milestone_id: { type: 'string', description: 'Milestone ID' },
          note: { type: 'string', description: 'Note text' },
        },
        required: ['milestone_id', 'note'],
      },
    },
    {
      name: 'set_milestone_dates',
      description: 'Set actual start/end dates for a milestone, auto-calculate drift, recalculate schedule status',
      inputSchema: {
        type: 'object' as const,
        properties: {
          milestone_id: { type: 'string', description: 'Milestone ID' },
          actual_start: { type: 'string', description: 'Actual start date (YYYY-MM-DD)' },
          actual_end: { type: 'string', description: 'Actual end date (YYYY-MM-DD)' },
        },
        required: ['milestone_id'],
      },
    },
    {
      name: 'update_drift',
      description: 'Manually set drift days for a milestone, recalculate schedule status',
      inputSchema: {
        type: 'object' as const,
        properties: {
          milestone_id: { type: 'string', description: 'Milestone ID' },
          drift_days: { type: 'number', description: 'Drift in days' },
        },
        required: ['milestone_id', 'drift_days'],
      },
    },
    {
      name: 'create_milestone',
      description: 'Create a new milestone with empty subtasks, dependencies, and notes',
      inputSchema: {
        type: 'object' as const,
        properties: {
          id: { type: 'string', description: 'Unique milestone ID' },
          title: { type: 'string', description: 'Milestone title' },
          domain: { type: 'string', description: 'Domain' },
          phase: { type: 'string', description: 'Phase' },
          planned_start: { type: 'string', description: 'Planned start date (YYYY-MM-DD)' },
          planned_end: { type: 'string', description: 'Planned end date (YYYY-MM-DD)' },
        },
        required: ['id', 'title'],
      },
    },
    {
      name: 'add_milestone_task',
      description: 'Add a new task to a milestone. Auto-generates task ID as {milestone_id}_{NNN}.',
      inputSchema: {
        type: 'object' as const,
        properties: {
          milestone_id: { type: 'string', description: 'Milestone ID' },
          label: { type: 'string', description: 'Task label' },
          priority: { type: 'string', description: 'Priority (default: medium)' },
          acceptance_criteria: { type: 'array', items: { type: 'string' }, description: 'Acceptance criteria' },
          constraints: { type: 'array', items: { type: 'string' }, description: 'Constraints' },
          depends_on: { type: 'array', items: { type: 'string' }, description: 'Task dependencies' },
          execution_mode: { type: 'string', description: 'Execution mode (human, agent, pair)' },
        },
        required: ['milestone_id', 'label'],
      },
    },
    {
      name: 'activate_milestone',
      description: 'Move a milestone from backlog to active, updating dashboard focus',
      inputSchema: {
        type: 'object' as const,
        properties: {
          milestone_id: { type: 'string', description: 'Milestone ID to activate' },
        },
        required: ['milestone_id'],
      },
    },
    {
      name: 'complete_milestone',
      description: 'Move an active milestone to completed, removing it from the active list and adding it to completed milestones',
      inputSchema: {
        type: 'object' as const,
        properties: {
          milestone_id: { type: 'string', description: 'Milestone ID to complete' },
        },
        required: ['milestone_id'],
      },
    },
    {
      name: 'register_agent',
      description: 'Register a new agent or update an existing one',
      inputSchema: {
        type: 'object' as const,
        properties: {
          agent_id: { type: 'string', description: 'Unique agent ID' },
          name: { type: 'string', description: 'Agent display name' },
          type: { type: 'string', description: 'Agent type (orchestrator, sub-agent, human, external)' },
          permissions: { type: 'array', items: { type: 'string' }, description: 'Permissions list' },
          color: { type: 'string', description: 'Display color (hex)' },
          parent_id: { type: 'string', description: 'Parent agent ID' },
        },
        required: ['agent_id', 'name', 'type', 'permissions'],
      },
    },
  ]
}

