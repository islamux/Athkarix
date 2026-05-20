import type { TrackerState, Subtask, Milestone, AgentLogEntry } from './types.js'

const statusIcon = (status: string): string => {
  switch (status) {
    case 'done': return '[x]'
    case 'in_progress': return '[~]'
    case 'review': return '[r]'
    case 'blocked': return '[!]'
    default: return '[ ]'
  }
}

export function buildTaskContext(state: TrackerState, subtask: Subtask, milestone: Milestone): string {
  const lines: string[] = []
  lines.push(`# Task Context: ${subtask.label}`)
  lines.push('')
  lines.push(`**Task ID:** ${subtask.id}`)
  lines.push(`**Status:** ${subtask.status}`)
  lines.push(`**Priority:** ${subtask.priority}`)
  lines.push(`**Execution Mode:** ${subtask.execution_mode}`)
  lines.push(`**Assignee:** ${subtask.assignee ?? 'unassigned'}`)
  lines.push(`**Done:** ${subtask.status === 'done'}`)
  lines.push('')

  lines.push(`## Milestone: ${milestone.title}`)
  lines.push(`- **Milestone ID:** ${milestone.id}`)
  lines.push(`- **Domain:** ${milestone.domain}`)
  lines.push(`- **Phase:** ${milestone.phase}`)
  lines.push(`- **Week:** ${milestone.week}`)
  lines.push(`- **Planned:** ${milestone.planned_start ?? '—'} → ${milestone.planned_end ?? '—'}`)
  lines.push(`- **Actual:** ${milestone.actual_start ?? '—'} → ${milestone.actual_end ?? '—'}`)
  lines.push(`- **Drift:** ${milestone.drift_days} days`)
  lines.push('')

  if (subtask.prompt) {
    lines.push('## Prompt')
    lines.push(subtask.prompt)
    lines.push('')
  }

  if (subtask.builder_prompt) {
    lines.push('## Builder Prompt')
    lines.push(subtask.builder_prompt)
    lines.push('')
  }

  if (subtask.acceptance_criteria.length > 0) {
    lines.push('## Acceptance Criteria')
    for (const ac of subtask.acceptance_criteria) {
      lines.push(`- ${ac}`)
    }
    lines.push('')
  }

  if (subtask.constraints.length > 0) {
    lines.push('## Constraints')
    for (const c of subtask.constraints) {
      lines.push(`- ${c}`)
    }
    lines.push('')
  }

  if (subtask.context_files.length > 0) {
    lines.push('## Context Files')
    for (const f of subtask.context_files) {
      lines.push(`- \`${f}\``)
    }
    lines.push('')
  }

  if (subtask.reference_docs.length > 0) {
    lines.push('## Reference Docs')
    for (const d of subtask.reference_docs) {
      lines.push(`- ${d}`)
    }
    lines.push('')
  }

  const taskHistory = (state.agent_log || []).filter((l: AgentLogEntry) => l.target_id === subtask.id)
  if (taskHistory.length > 0) {
    lines.push('## Revision History')
    for (const entry of taskHistory.slice(-20)) {
      lines.push(`- **${entry.timestamp}** [${entry.action}] ${entry.description}`)
    }
    lines.push('')
  }

  if (subtask.notes) {
    lines.push('## Notes')
    lines.push(subtask.notes)
    lines.push('')
  }

  const siblings = milestone.subtasks.filter(s => s.id !== subtask.id)
  if (siblings.length > 0) {
    lines.push('## Sibling Tasks')
    for (const s of siblings) {
      lines.push(`- ${statusIcon(s.status)} \`${s.id}\` — ${s.label} (${s.status})`)
    }
    lines.push('')
  }

  if (subtask.depends_on.length > 0) {
    lines.push('## Upstream Dependencies')
    for (const depId of subtask.depends_on) {
      const dep = findTaskInState(state, depId)
      if (dep) {
        lines.push(`- ${statusIcon(dep.subtask.status)} \`${depId}\` — ${dep.subtask.label}`)
      } else {
        lines.push(`- \`${depId}\` — not found`)
      }
    }
    lines.push('')
  }

  const downstream = findDownstreamDeps(state, subtask.id)
  if (downstream.length > 0) {
    lines.push('## Downstream Dependents')
    for (const d of downstream) {
      lines.push(`- ${statusIcon(d.subtask.status)} \`${d.subtask.id}\` — ${d.subtask.label} (milestone: ${d.milestone.title})`)
    }
    lines.push('')
  }

  const milestoneTasks = milestone.subtasks
  const doneCount = milestoneTasks.filter((t: Subtask) => t.status === 'done').length
  lines.push('## Exit Criteria')
  lines.push(`Milestone "${milestone.title}" is complete when all subtasks are done (${doneCount}/${milestoneTasks.length} complete).`)
  lines.push('')

  return lines.join('\n')
}

export function buildTaskSummary(state: TrackerState, subtask: Subtask, milestone: Milestone): string {
  const lines: string[] = []
  lines.push(`# Task: ${subtask.label}`)
  lines.push('')
  lines.push(`**ID:** ${subtask.id} | **Status:** ${subtask.status} | **Priority:** ${subtask.priority}`)
  lines.push(`**Milestone:** ${milestone.title} (${milestone.id})`)
  lines.push(`**Assignee:** ${subtask.assignee ?? 'unassigned'} | **Mode:** ${subtask.execution_mode}`)
  lines.push('')

  if (subtask.acceptance_criteria.length > 0) {
    lines.push('**Acceptance Criteria:**')
    for (const ac of subtask.acceptance_criteria) {
      lines.push(`- ${ac}`)
    }
    lines.push('')
  }

  if (subtask.constraints.length > 0) {
    lines.push('**Constraints:**')
    for (const c of subtask.constraints) {
      lines.push(`- ${c}`)
    }
    lines.push('')
  }

  if (subtask.context_files.length > 0) {
    lines.push('**Context Files:** ' + subtask.context_files.map(f => `\`${f}\``).join(', '))
    lines.push('')
  }

  const taskHistory = (state.agent_log || []).filter((l: AgentLogEntry) => l.target_id === subtask.id)
  if (taskHistory.length > 0) {
    lines.push('**Recent History:**')
    for (const entry of taskHistory.slice(-5)) {
      lines.push(`- ${entry.timestamp} [${entry.action}] ${entry.description}`)
    }
    lines.push('')
  }

  return lines.join('\n')
}

export function buildProjectStatus(state: TrackerState): string {
  const { project, milestones } = state
  const all = [...milestones.active, ...milestones.backlog].map((m: Milestone) => ({ ...m, subtasks: m.subtasks || [] }))
  const lines: string[] = []
  lines.push(`# Project Status: ${project.name}`)
  lines.push('')
  lines.push(`- **Current Week:** ${project.current_week}`)
  lines.push(`- **Start Date:** ${project.start_date}`)
  lines.push(`- **Target Date:** ${project.target_date}`)
  lines.push(`- **Schedule Status:** ${project.schedule_status}`)
  lines.push(`- **Overall Progress:** ${project.overall_progress}%`)
  lines.push('')

  const allTasks = all.flatMap((m: Milestone) => m.subtasks)
  const byStatus: Record<string, number> = {}
  for (const t of allTasks) {
    byStatus[t.status] = (byStatus[t.status] || 0) + 1
  }
  lines.push('## Task Breakdown')
  for (const [status, count] of Object.entries(byStatus)) {
    lines.push(`- ${status}: ${count}`)
  }
  lines.push('')

  lines.push('## Milestone Summary')
  lines.push(`- **Active:** ${milestones.active.length}`)
  lines.push(`- **Backlog:** ${milestones.backlog.length}`)
  lines.push(`- **Completed:** ${milestones.completed.length}`)
  lines.push('')

  const keyMilestones = all.filter((m: Milestone) => m.is_key_milestone)
  if (keyMilestones.length > 0) {
    lines.push('## Key Milestones')
    for (const m of keyMilestones) {
      const done = m.subtasks.filter((t: Subtask) => t.status === 'done').length
      const total = m.subtasks.length
      lines.push(`- **${m.key_milestone_label ?? m.title}** (week ${m.week}) — drift: ${m.drift_days ?? 0}d — progress: ${total > 0 ? Math.round((done / total) * 100) : 0}%`)
    }
    lines.push('')
  }

  if (state.dashboard) {
    lines.push('## Dashboard')
    lines.push(`- **Focus:** ${state.dashboard.current_focus}`)
    lines.push(`- **Active Milestone:** ${state.dashboard.active_milestone}`)
    lines.push(`- **Next Priority:** ${state.dashboard.next_priority}`)
    lines.push(`- **Blockers:** ${state.dashboard.blockers}`)
    lines.push(`- **Health:** ${state.dashboard.health}`)
    lines.push('')
  }

  return lines.join('\n')
}

export function buildMilestoneOverview(milestone: Milestone, state: TrackerState): string {
  const lines: string[] = []
  lines.push(`# Milestone: ${milestone.title}`)
  lines.push('')
  lines.push(`**ID:** ${milestone.id}`)
  lines.push(`**Domain:** ${milestone.domain}`)
  lines.push(`**Phase:** ${milestone.phase}`)
  lines.push(`**Week:** ${milestone.week}`)
  lines.push(`**Planned:** ${milestone.planned_start ?? '—'} → ${milestone.planned_end ?? '—'}`)
  lines.push(`**Actual:** ${milestone.actual_start ?? '—'} → ${milestone.actual_end ?? '—'}`)
  lines.push(`**Drift:** ${milestone.drift_days} days`)
  if (milestone.is_key_milestone) {
    lines.push(`**Key Milestone:** ${milestone.key_milestone_label ?? 'Yes'}`)
  }
  lines.push('')

  if (milestone.dependencies.length > 0) {
    lines.push(`**Dependencies:** ${milestone.dependencies.join(', ')}`)
    lines.push('')
  }

  const done = milestone.subtasks.filter(t => t.status === 'done').length
  const total = milestone.subtasks.length
  lines.push(`## Progress: ${done}/${total} tasks complete (${total > 0 ? Math.round((done / total) * 100) : 0}%)`)
  lines.push('')

  if (milestone.subtasks.length > 0) {
    lines.push('## Tasks')
    for (const t of milestone.subtasks) {
      const assignee = t.assignee ? ` → ${t.assignee}` : ''
      lines.push(`- ${statusIcon(t.status)} \`${t.id}\` ${t.label}${assignee}`)
    }
    lines.push('')
  }

  if (milestone.notes.length > 0) {
    lines.push('## Notes')
    for (const n of milestone.notes) {
      lines.push(`- ${n}`)
    }
    lines.push('')
  }

  return lines.join('\n')
}

function findTaskInState(state: TrackerState, taskId: string): { subtask: Subtask; milestone: Milestone } | null {
  const all = [...state.milestones.active, ...state.milestones.backlog]
  for (const m of all) {
    const s = m.subtasks.find((t: Subtask) => t.id === taskId)
    if (s) return { subtask: s, milestone: m }
  }
  return null
}

function findDownstreamDeps(state: TrackerState, taskId: string): { subtask: Subtask; milestone: Milestone }[] {
  const all = [...state.milestones.active, ...state.milestones.backlog]
  const results: { subtask: Subtask; milestone: Milestone }[] = []
  for (const m of all) {
    for (const s of m.subtasks) {
      if (s.depends_on.includes(taskId)) {
        results.push({ subtask: s, milestone: m })
      }
    }
  }
  return results
}
