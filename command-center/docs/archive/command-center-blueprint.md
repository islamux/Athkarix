# Command Center Blueprint

> A complete build specification for an AI-agent-powered project command center.
> Feed this document to any capable coding agent (Claude Code, Codex, Cursor, etc.)
> and it will build the entire system across multiple phases.

---

## About This Document

### What This Builds

Two deliverables:

1. **MCP Server** — A globally-installed Node.js package exposing 24 tools over stdio. AI agents call these tools to read project state, manage tasks, dispatch sub-agents, and log activity. Also includes a CLI for shell access to the same tools.

2. **TUI Terminal App** — A terminal dashboard built with Node.js + blessed with 4 views: Swim Lane (strategic timeline), Task Board (tactical Kanban), Agent Hub (real-time agent monitoring), and Calendar (completion history). The app watches `project-tracker.json` via chokidar and renders project state in real time.

Both deliverables share a single source of truth: `project-tracker.json`, a JSON file that lives at the root of the user's project. The MCP server reads/writes it via tool calls. The Electron app watches it via `fs.watch` and renders it. External agents update it through the MCP server. The Electron app also writes back when the operator makes changes in the UI (dragging tasks, editing dates, etc.).

### Architecture

```
┌────────────────────────────────────────────────┐
│              Operator (Human)                  │
│           Electron Desktop App                 │
└───────────────────┬────────────────────────────┘
                    │ fs.watch + IPC
┌───────────────────▼────────────────────────────┐
│            project-tracker.json                │
│          (Single Source of Truth)               │
└───────────────────▲────────────────────────────┘
                    │ readTracker / writeTracker
┌───────────────────┴────────────────────────────┐
│          MCP Server (stdio transport)          │
│         24 tools + CLI interface               │
└───────────────────▲────────────────────────────┘
                    │ MCP protocol
        ┌───────────┴───────────┐
        │                       │
  ┌─────▼──────┐         ┌─────▼──────┐
  │ Claude Code│         │   Codex    │
  │  (or any   │         │  (or any   │
  │   agent)   │         │   agent)   │
  └────────────┘         └────────────┘
```

### Stack

| Layer | Technology |
|-------|-----------|
| TUI App | Node.js + blessed |
| UI Framework | React 19 |
| State Management | Zustand 5 |
| Styling | Tailwind CSS v4 |
| Drag & Drop | @dnd-kit/core + @dnd-kit/sortable |
| Fonts | Inter (UI) + JetBrains Mono (code/numbers) |
| MCP Server | Node.js + @modelcontextprotocol/sdk |
| Language | TypeScript (strict mode, ES modules) |

### How to Use This Document

This document is organized into 10 sequential phases. Each phase builds on the previous one and ends with a checkpoint describing what should work at that point. An implementing agent should:

1. Read the entire document first to understand the full scope
2. Execute phases 1-9 in order (each produces working artifacts)
3. Execute phase 10 to create workflow documentation and agent role templates
4. After all phases complete, tell the user: "The Command Center skeleton is built. Provide your project manifesto and roadmap to populate it with your project data."

### What Happens After Building (Hydration)

The command center starts as an empty skeleton. After the build is complete, the user provides:

1. **Project manifesto** — Product vision, domains, workflows, principles
2. **Project roadmap** — Timeline, phases, milestones, deliverables, dependencies

The agent then reads these documents and populates the tracker by calling MCP tools:
- Extract domains from the manifesto → create swim lane lanes
- Extract milestones from the roadmap → call `create_milestone()` for each
- Extract deliverables → call `add_milestone_task()` for each
- Extract timeline → set `planned_start` / `planned_end` dates
- Map dependencies → set milestone `dependencies` arrays
- Register the user's agent roster → call `register_agent()` for each
- Assign domain colors from the palette (see Phase 9)

This hydration process is NOT part of this blueprint. The implementing agent should be aware it will happen after the build.

---

## PHASE 1: TRACKER SCHEMA

The tracker is a single JSON file (`project-tracker.json`) at the project root. All consumers (MCP server, Electron app, external agents) read and write this file. This phase defines its exact schema.

### TypeScript Interfaces

```typescript
// ─── Root State ───────────────────────────────────────────────

interface TrackerState {
  project: ProjectMeta
  milestones: Milestone[]
  agents: Agent[]
  agent_log: AgentLogEntry[]
  schedule: { phases: Phase[] }
}

// ─── Project Metadata ─────────────────────────────────────────

interface ProjectMeta {
  name: string                    // Project display name
  start_date: string              // YYYY-MM-DD, first day of work
  target_date: string             // YYYY-MM-DD, target completion
  current_week: number            // Live-calculated: 1-based week number
  schedule_status: 'on_track' | 'behind' | 'ahead'
  overall_progress: number        // 0.0 to 1.0 (done / total tasks)
}

// ─── Milestone ────────────────────────────────────────────────

interface Milestone {
  id: string                      // snake_case unique identifier
  title: string                   // Human-readable name
  domain: string                  // Category (populated during hydration)
  week: number                    // Start week (1-based)
  phase: string                   // Phase this milestone belongs to
  planned_start: string | null    // YYYY-MM-DD
  planned_end: string | null      // YYYY-MM-DD
  actual_start: string | null     // YYYY-MM-DD (auto-set when first task starts)
  actual_end: string | null       // YYYY-MM-DD (auto-set when all tasks done)
  drift_days: number              // Positive = behind, negative = ahead, 0 = on track
  is_key_milestone: boolean       // True for major release/deadline milestones
  key_milestone_label: string | null  // e.g., "V1.0 Launch", "Beta Release"
  subtasks: Subtask[]             // Ordered list of tasks within this milestone
  dependencies: string[]          // IDs of milestones that must complete first
  notes: string[]                 // Exit criteria and notes
}

// ─── Subtask (Task) ───────────────────────────────────────────

interface Subtask {
  id: string                      // Format: {milestone_id}_{NNN} (zero-padded)
  label: string                   // Task description
  status: 'todo' | 'in_progress' | 'review' | 'done' | 'blocked'
  done: boolean                   // Completion flag (mirrors status === 'done')
  assignee: string | null         // Agent ID or human name
  blocked_by: string | null       // Who/what blocked this task
  blocked_reason: string | null   // Why it's blocked
  completed_at: string | null     // ISO 8601 timestamp
  completed_by: string | null     // Who completed it
  priority: string                // "P1" | "P2" | "P3" | "P4"
  notes: string | null            // Free-form notes

  // Agent enrichment fields (populated during prepare phase)
  prompt: string | null           // Task description/prompt
  context_files: string[]         // File paths the agent should read first
  reference_docs: string[]        // URLs or doc paths for research
  acceptance_criteria: string[]   // Checklist of what "done" means
  constraints: string[]           // Rules the implementation must follow

  // Execution configuration
  agent_target: string | null     // Suggested agent role (e.g., 'explorer', 'builder')
  execution_mode: 'human' | 'agent' | 'pair'
  depends_on: string[]            // IDs of subtasks that must complete first
  last_run_id: string | null      // Unique run identifier for the last execution
  builder_prompt: string | null   // Path to per-task prompt file (e.g., docs/prompts/task_001.md)
}

// ─── Agent ────────────────────────────────────────────────────

interface Agent {
  id: string                      // Unique identifier (e.g., 'claude_code', 'codex')
  name: string                    // Display name
  type: 'orchestrator' | 'sub-agent' | 'human' | 'external'
  parent_id?: string              // For sub-agents: ID of parent orchestrator
  color: string                   // Hex color for UI display (e.g., '#22c55e')
  status: string                  // 'active' | 'idle'
  permissions: string[]           // e.g., ['read', 'write']
  last_action_at: string | null   // ISO 8601 timestamp of last MCP tool call
  session_action_count: number    // Running count of actions in current session
}

// ─── Agent Log Entry ──────────────────────────────────────────

interface AgentLogEntry {
  id: string                      // Unique log entry ID (e.g., 'log_{timestamp}_{random}')
  agent_id: string                // Which agent performed the action
  action: string                  // Action type (e.g., 'task_started', 'task_blocked',
                                  //   'exploration_complete', 'audit_complete')
  target_type: string             // 'subtask' | 'milestone' | 'agent'
  target_id: string               // ID of the affected entity
  description: string             // Human-readable description of what happened
  timestamp: string               // ISO 8601 timestamp
  tags: string[]                  // Categorization (e.g., ['start', 'mcp'], ['write', 'commit'])
}

// ─── Schedule Phase ───────────────────────────────────────────

interface Phase {
  id: string                      // Unique phase identifier
  title: string                   // Display name (e.g., "Foundation", "Core Features")
  start_week: number              // First week of this phase (1-based)
  end_week: number                // Last week of this phase (inclusive)
}
```

### Empty Initial Tracker

Create this file at `{PROJECT_ROOT}/project-tracker.json`:

```json
{
  "project": {
    "name": "My Project",
    "start_date": "2026-01-01",
    "target_date": "2026-06-30",
    "current_week": 1,
    "schedule_status": "on_track",
    "overall_progress": 0
  },
  "milestones": [],
  "agents": [],
  "agent_log": [],
  "schedule": {
    "phases": []
  }
}
```

> **Checkpoint:** The tracker file exists at the project root with valid JSON matching the schema. No milestones or agents yet — those come from hydration.

---

## PHASE 2: MCP SERVER

A globally-installed Node.js package that exposes 24 tools over MCP stdio transport, plus a CLI for shell access.

### Project Structure

```
command-center-mcp/
├── package.json
├── tsconfig.json
├── src/
│   ├── index.ts          # MCP server entry (stdio transport)
│   ├── tools.ts          # Tool definitions + handlers
│   ├── tracker.ts        # TypeScript types + read/write utilities
│   ├── context.ts        # Context builder functions (Markdown output)
│   └── cli.ts            # CLI interface (maps shell commands to tool handlers)
```

### package.json

```json
{
  "name": "command-center-mcp",
  "version": "1.0.0",
  "description": "MCP server + CLI for the project Command Center",
  "type": "module",
  "main": "dist/index.js",
  "bin": {
    "command-center": "dist/cli.js"
  },
  "scripts": {
    "build": "tsc",
    "dev": "tsc --watch"
  },
  "dependencies": {
    "@modelcontextprotocol/sdk": "^1.12.1"
  },
  "devDependencies": {
    "typescript": "^5.7.0",
    "@types/node": "^22.0.0"
  }
}
```

### tsconfig.json

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ES2022",
    "moduleResolution": "bundler",
    "outDir": "dist",
    "rootDir": "src",
    "strict": true,
    "esModuleInterop": true,
    "resolveJsonModule": true,
    "declaration": true,
    "sourceMap": true
  },
  "include": ["src/**/*"]
}
```

### Server Entry (src/index.ts)

Set up an MCP server with stdio transport:
- Server name: `"command-center"`
- Version: `"1.0.0"`
- Transport: `StdioServerTransport` from `@modelcontextprotocol/sdk/server/stdio`
- Register `ListToolsRequestSchema` handler → returns all tool definitions
- Register `CallToolRequestSchema` handler → routes to `handleTool(name, args)`
- Log startup message to stderr: `"Command Center MCP server running on stdio"`

### Tracker Utilities (src/tracker.ts)

Include the TypeScript interfaces from Phase 1, plus these utility functions:

**Path Resolution:**
```
PROJECT_ROOT = process.env.PROJECT_ROOT
             ?? readDotEnv('PROJECT_ROOT')   // fallback: read from .env file
TRACKER_PATH = path.join(PROJECT_ROOT, 'project-tracker.json')
```

**readTracker(): TrackerState**
- Read and parse TRACKER_PATH
- Return parsed state

**writeTracker(state: TrackerState): void**
- Recompute derived fields before writing:
  - `overall_progress = done_count / total_count` across all milestones
  - `current_week` = live calculation (see selector formula in Phase 4)
  - `schedule_status` = recalculate from milestone drift (see below)
- Write JSON with 2-space indent to TRACKER_PATH

**findTask(state, taskId): { subtask, milestone } | null**
- Search all milestones' subtasks for matching ID
- Return the subtask and its parent milestone, or null

**touchAgent(state, agentId = 'orchestrator'): void**
- Find agent by ID in `state.agents[]`
- Set `last_action_at` to current ISO timestamp
- Increment `session_action_count` by 1
- Set `status` to `'active'`
- Called by every write tool to keep Agent Hub current

**autoUnblockDependents(state, completedTaskId, completedMilestoneId): string[]**
- Called when a task is approved (moved to done)
- Returns array of descriptions of what was unblocked
- Logic:
  1. Find all subtasks across ALL milestones whose `depends_on` contains `completedTaskId`
  2. For each: check if ALL items in their `depends_on` array now have `status === 'done'`
  3. If yes AND the subtask has `status === 'blocked'`: set `status = 'todo'`, clear `blocked_by` and `blocked_reason`
  4. If the parent milestone is now fully complete (all subtasks done): check all milestones whose `dependencies` array contains `completedMilestoneId`
  5. For each downstream milestone: check if ALL its dependency milestones are fully complete
  6. If yes: unblock any blocked tasks in that downstream milestone
  7. Log each auto-unblock action to `agent_log`

**Schedule Status Calculation:**
```
max_drift = Math.max(...milestones.map(m => m.drift_days))
min_drift = Math.min(...milestones.map(m => m.drift_days))
if (max_drift > 3) → 'behind'
else if (min_drift < -3) → 'ahead'
else → 'on_track'
```

### Context Builders (src/context.ts)

These functions assemble Markdown text returned by read tools. Agents consume this Markdown as context for their work.

**buildTaskContext(state, subtask, milestone): string**

Returns comprehensive Markdown (~8K tokens) with these sections:
1. **Task metadata** — ID, status, priority, execution mode, assignee, notes, blocked reason
2. **Acceptance criteria** — Checklist format (`- [ ] criterion`)
3. **Constraints** — Bullet list
4. **Context files** — Paths the agent should read first
5. **Reference docs** — URLs/paths for research
6. **Revision history** — From `agent_log` entries where `target_id === task_id` and `action === 'revision_requested'`. Shows revision number, feedback, and timestamp.
7. **Builder prompt** — If `builder_prompt` path exists, read the file and include its content
8. **Milestone info** — Domain, phase, week, planned dates, drift
9. **Exit criteria** — `milestone.notes[]`
10. **Sibling tasks** — All other subtasks in the same milestone with their status and progress count
11. **Upstream dependencies** — Milestones in `milestone.dependencies[]` with their completion percentage
12. **Downstream milestones** — Milestones that depend on this milestone

**buildTaskSummary(state, subtask, milestone): string**

Slim version (~500 tokens) for post-build verification. Includes only:
- Task metadata (ID, label, status, domain)
- Acceptance criteria
- Constraints
- Context files
- Revision history

**buildProjectStatus(state): string**

Returns Markdown with:
- Project name, start date, target date, current week
- Schedule status
- Progress: done/total tasks, in-progress count, blocked count
- Milestone count
- Current phase name

**buildMilestoneOverview(milestone, state): string**

Returns Markdown with:
- Milestone ID, domain, phase, week, planned dates
- Progress: done/total with percentage
- Drift days
- Key milestone label (if any)
- Exit criteria (milestone.notes)
- Task list with status icons: done=`done`, in_progress=`in progress`, blocked=`blocked`, todo=`todo`
- Dependencies and their completion status

### Tool Definitions (src/tools.ts)

24 tools organized into 4 categories. Every write tool calls `touchAgent()` and pushes an entry to `agent_log`.

---

#### READ TOOLS (8 tools)

**1. get_task_context**

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| task_id | string | yes | The subtask ID |

Handler:
1. Call `findTask(state, task_id)` — return error if not found
2. Call `buildTaskContext(state, subtask, milestone)`
3. Return Markdown text

---

**2. get_task_summary**

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| task_id | string | yes | The subtask ID |

Handler:
1. Call `findTask(state, task_id)` — return error if not found
2. Call `buildTaskSummary(state, subtask, milestone)`
3. Return Markdown text

---

**3. get_project_status**

No parameters.

Handler:
1. Call `buildProjectStatus(state)`
2. Return Markdown text

---

**4. get_milestone_overview**

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| milestone_id | string | yes | The milestone ID |

Handler:
1. Find milestone by ID — return error if not found
2. Call `buildMilestoneOverview(milestone, state)`
3. Return Markdown text

---

**5. list_tasks**

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| milestone_id | string | no | Filter by milestone |
| status | string | no | Filter: 'todo', 'in_progress', 'review', 'done', 'blocked' |
| domain | string | no | Filter by domain name |

Handler:
1. Collect all subtasks across milestones, applying filters
2. Group by milestone
3. Return Markdown list with status icons and priority badges

---

**6. get_task_history**

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| task_id | string | yes | The subtask ID |

Handler:
1. Filter `agent_log` entries where `target_id === task_id`
2. Return chronological Markdown list with action, description, agent, timestamp, tags
3. Return "No history found" if empty

---

**7. list_agents**

No parameters.

Handler:
1. For each agent in `state.agents`:
   - Determine active status: `Date.now() - last_action_at < 30 minutes` → ACTIVE, else IDLE
   - Calculate weekly stats from `agent_log` (action count, tag breakdown)
2. Return Markdown report with agent details, status, permissions, weekly stats

---

**8. get_activity_feed**

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| agent_id | string | no | Filter by agent |
| limit | number | no | Max entries (default: 30) |

Handler:
1. Sort `agent_log` by timestamp descending
2. Apply agent_id filter if provided
3. Take first `limit` entries
4. Group by date
5. Return Markdown with day headers and per-entry details (agent name, action, description, target, tags, time)

---

#### WRITE TOOLS — Task Lifecycle (9 tools)

**9. start_task**

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| task_id | string | yes | The subtask ID |
| agent_id | string | no | Who is starting (default: 'orchestrator') |

Handler:
1. Find task — error if not found
2. Set `task.status = 'in_progress'`
3. Set `task.assignee = agent_id` (if not already assigned)
4. Set `task.last_run_id = 'run_' + Date.now()`
5. **Auto-stamp milestone**: If `milestone.actual_start` is null, set it to today's date. Calculate drift: `drift_days = (actual_start - planned_start) in days`
6. Push `agent_log` entry: action `'task_started'`, tags `['start', 'mcp']`
7. Call `touchAgent(state, agent_id)`
8. Call `writeTracker(state)`
9. Return confirmation with milestone/task names

---

**10. complete_task**

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| task_id | string | yes | The subtask ID |
| summary | string | yes | 1-3 sentence summary of work done |
| agent_id | string | no | Who completed (default: 'orchestrator') |

Handler:
1. Find task — error if not found
2. Set `task.status = 'review'` (NOT done — requires operator approval)
3. Clear `blocked_by` and `blocked_reason`
4. Push `agent_log` entry: action `'task_submitted_for_review'`, description = summary
5. Call `touchAgent(state, agent_id)`
6. Call `writeTracker(state)`
7. Return confirmation with summary and milestone progress (done/total)

---

**11. approve_task** (OPERATOR ONLY)

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| task_id | string | yes | The subtask ID |
| feedback | string | no | Optional approval feedback |

Handler:
1. Find task — error if not found
2. Verify `task.status === 'review'` — error if not
3. Set `task.status = 'done'`, `task.done = true`
4. Set `task.completed_at = new Date().toISOString()`
5. Set `task.completed_by` to operator name
6. **Auto-stamp milestone**: If ALL subtasks in the milestone are now done, set `milestone.actual_end` to today
7. Call `autoUnblockDependents(state, task_id, milestone_id)` — cascade unblocking
8. Push `agent_log` entry: action `'task_approved'`, agent_id = operator
9. Call `touchAgent(state, operator_id)`
10. Call `writeTracker(state)`
11. Return confirmation with milestone progress + auto-unblock details

---

**12. reject_task** (OPERATOR ONLY)

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| task_id | string | yes | The subtask ID |
| feedback | string | yes | What needs to change |

Handler:
1. Find task — error if not found
2. Verify `task.status === 'review'` — error if not
3. Set `task.status = 'in_progress'`
4. Count prior revisions: count `agent_log` entries where `target_id === task_id` AND `action === 'revision_requested'`
5. Push `agent_log` entry: action `'revision_requested'`, description includes revision number and feedback text
6. Call `touchAgent(state, operator_id)`
7. Call `writeTracker(state)`
8. Return confirmation with revision number and feedback

---

**13. reset_task** (OPERATOR ONLY)

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| task_id | string | yes | The subtask ID |

Handler:
1. Find task — error if not found
2. Set `status = 'todo'`, `done = false`
3. Clear: `assignee`, `blocked_by`, `blocked_reason`, `completed_at`, `completed_by`, `last_run_id`
4. Push `agent_log` entry: action `'task_reset'`
5. Call `writeTracker(state)`
6. Return confirmation with previous status

---

**14. block_task**

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| task_id | string | yes | The subtask ID |
| reason | string | yes | Why the task is blocked |

Handler:
1. Find task — error if not found
2. Set `task.status = 'blocked'`
3. Set `task.blocked_reason = reason`
4. Set `task.blocked_by` to agent_id (default 'orchestrator')
5. Push `agent_log` entry: action `'task_blocked'`
6. Call `touchAgent(state, agent_id)`
7. Call `writeTracker(state)`
8. Return confirmation

---

**15. unblock_task**

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| task_id | string | yes | The subtask ID |
| resolution | string | no | How the block was resolved |

Handler:
1. Find task — error if not found
2. Verify `task.status === 'blocked'` — error if not
3. Set `task.status` to `'in_progress'` if `last_run_id` exists, else `'todo'`
4. Clear `blocked_by` and `blocked_reason`
5. Push `agent_log` entry: action `'task_unblocked'`, description includes resolution
6. Call `touchAgent(state, agent_id)`
7. Call `writeTracker(state)`
8. Return confirmation with previous blocker reason and new status

---

**16. update_task**

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| task_id | string | yes | The subtask ID |
| priority | string | no | New priority (P1/P2/P3/P4) |
| assignee | string | no | New assignee (empty string to unassign) |
| execution_mode | string | no | 'human', 'agent', or 'pair' |
| notes | string | no | Updated notes |

Handler:
1. Find task — error if not found
2. Only update fields that are provided (non-undefined)
3. Push `agent_log` entry: action `'task_updated'`, description lists all changes
4. Call `touchAgent(state, agent_id)`
5. Call `writeTracker(state)`
6. Return confirmation with change list

---

**17. log_action**

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| task_id | string | yes | The target entity ID |
| action | string | yes | Action label (e.g., 'file_created', 'test_passed') |
| description | string | yes | What happened |
| tags | string[] | no | Categorization tags |
| agent_id | string | no | Who performed (default: 'orchestrator') |

Handler:
1. Create `AgentLogEntry` with unique ID, timestamp, provided fields
2. Append `'mcp'` to tags array
3. Push to `state.agent_log`
4. Call `touchAgent(state, agent_id)`
5. Call `writeTracker(state)`
6. Return confirmation

---

#### WRITE TOOLS — Task Enrichment (1 tool)

**18. enrich_task**

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| task_id | string | yes | The subtask ID |
| prompt | string | no | Task description/prompt |
| builder_prompt | string | no | Path to per-task prompt file |
| acceptance_criteria | string[] | no | Replaces existing criteria |
| constraints | string[] | no | Replaces existing constraints |
| context_files | string[] | no | Replaces existing file list |
| reference_docs | string[] | no | Replaces existing doc list |

Handler:
1. Find task — error if not found
2. Only update fields that are provided (non-undefined)
3. Arrays REPLACE existing values (not merge)
4. Push `agent_log` entry: action `'task_enriched'`, description lists changes
5. Call `touchAgent(state, agent_id)`
6. Call `writeTracker(state)`
7. Return confirmation

---

#### WRITE TOOLS — Milestone Management (5 tools)

**19. add_milestone_note**

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| milestone_id | string | yes | The milestone ID |
| note | string | yes | Exit criterion or note text |

Handler:
1. Find milestone — error if not found
2. Append `note` to `milestone.notes[]`
3. Push `agent_log` entry: action `'milestone_note_added'`
4. Call `writeTracker(state)`
5. Return confirmation with total note count

---

**20. set_milestone_dates**

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| milestone_id | string | yes | The milestone ID |
| actual_start | string | no | YYYY-MM-DD |
| actual_end | string | no | YYYY-MM-DD |

Handler:
1. Find milestone — error if not found
2. Update `actual_start` and/or `actual_end` if provided
3. **Auto-calculate drift**: `drift_days = (actual_start - planned_start)` in calendar days (positive = behind, negative = ahead)
4. **Recalculate schedule_status** using the formula in Tracker Utilities
5. Push `agent_log` entry: action `'milestone_dates_set'`
6. Call `writeTracker(state)`
7. Return confirmation with changes and schedule status

---

**21. update_drift**

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| milestone_id | string | yes | The milestone ID |
| drift_days | number | yes | Positive = behind, negative = ahead |

Handler:
1. Find milestone — error if not found
2. Set `milestone.drift_days` to provided value
3. **Recalculate schedule_status**
4. Push `agent_log` entry: action `'drift_updated'`, description shows old → new
5. Call `writeTracker(state)`
6. Return confirmation

---

**22. create_milestone**

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| id | string | yes | Unique snake_case ID |
| title | string | yes | Display name |
| domain | string | no | Category (default: 'general') |
| phase | string | no | Phase name (default: same as id) |
| planned_start | string | no | YYYY-MM-DD |
| planned_end | string | no | YYYY-MM-DD |

Handler:
1. Check if milestone ID already exists — error if duplicate
2. Create new Milestone with empty subtasks, dependencies, notes
3. Set defaults for all optional fields
4. Append to `state.milestones`
5. Call `writeTracker(state)`
6. Return confirmation

---

**23. add_milestone_task**

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| milestone_id | string | yes | Parent milestone ID |
| label | string | yes | Task description |
| priority | string | no | Default: 'P2' |
| acceptance_criteria | string[] | no | What "done" means |
| constraints | string[] | no | Implementation rules |
| depends_on | string[] | no | Task IDs this depends on |
| execution_mode | string | no | Default: 'agent' |

Handler:
1. Find milestone — error if not found
2. Generate task ID: `{milestone_id}_{NNN}` where NNN is zero-padded count + 1
3. Create Subtask with `status = 'todo'`, `done = false`, all optional fields set to defaults
4. Append to `milestone.subtasks`
5. Call `writeTracker(state)`
6. Return confirmation with new task ID

---

#### WRITE TOOLS — Agent Management (1 tool)

**24. register_agent**

| Param | Type | Required | Description |
|-------|------|----------|-------------|
| agent_id | string | yes | Unique identifier |
| name | string | yes | Display name |
| type | string | yes | 'orchestrator', 'sub-agent', 'human', 'external' |
| permissions | string[] | yes | e.g., ['read', 'write'] |
| color | string | no | Hex color (default: '#9B9BAA') |
| parent_id | string | no | Parent orchestrator ID (for sub-agents) |

Handler:
1. If agent exists: update all fields, set `status = 'active'`, set `last_action_at = now`
2. If new: create Agent with `session_action_count = 0`, `status = 'active'`
3. Push `agent_log` entry: action `'agent_registered'` or `'agent_updated'`
4. Call `writeTracker(state)`
5. Return confirmation

---

### CLI Interface (src/cli.ts)

Map shell commands to the same `handleTool()` function used by MCP. Examples:

```bash
command-center get-task-context <task_id>
command-center start-task <task_id>
command-center complete-task <task_id> "<summary>"
command-center list-tasks [--milestone id] [--status todo] [--domain name]
command-center list-agents
command-center register-agent <id> "<name>" <type> --permissions read,write
```

Output goes to stdout. Errors go to stderr with exit code 1.

### MCP Configuration

Users add this to their `.mcp.json` (or equivalent for their agent platform):

```json
{
  "command-center": {
    "command": "command-center-mcp",
    "env": {
      "PROJECT_ROOT": "/absolute/path/to/project"
    }
  }
}
```

### Error Handling Pattern

All tools use the same error response format:
```typescript
{ content: [{ type: 'text', text: errorMessage }], isError: true }
```

Common errors:
- Task not found: `"Task '{id}' not found in any milestone"`
- Milestone not found: `"Milestone '{id}' not found"`
- Invalid status transition: `"Task '{id}' is in status '{status}', expected 'review'"`

> **Checkpoint:** After building and running `npm run build`, the CLI should work. Test with `command-center get-project-status` — it should return the empty project status from the initial tracker. Test `command-center create-milestone test_milestone "Test Milestone"` — it should create a milestone in the tracker JSON.

---

## PHASE 3: ELECTRON SHELL

A cross-platform desktop app that watches the tracker file and renders project state.

### Project Structure

```
command-center/
├── package.json
├── electron.vite.config.ts
├── tsconfig.json
├── postcss.config.mjs
├── .env                          # PROJECT_ROOT path
├── src/
│   ├── main/
│   │   ├── index.ts              # Electron main process
│   │   └── config.ts             # Project root resolution
│   ├── preload/
│   │   └── index.ts              # Context isolation bridge
│   └── renderer/
│       ├── index.html
│       ├── main.tsx              # React entry point
│       ├── App.tsx               # Root component
│       ├── store.ts              # Zustand store
│       ├── styles.css            # Tailwind + theme variables
│       └── env.d.ts              # Window type augmentation
```

### Dependencies

```json
{
  "dependencies": {
    "react": "^19.0.0",
    "react-dom": "^19.0.0",
    "zustand": "^5.0.0",
    "@dnd-kit/core": "^6.0.0",
    "@dnd-kit/sortable": "^8.0.0",
    "@dnd-kit/utilities": "^3.0.0",
    "@fontsource/inter": "^5.0.0",
    "@fontsource/jetbrains-mono": "^5.0.0"
  },
  "devDependencies": {
    "electron": "^41.0.0",
    "electron-vite": "^5.0.0",
    "@vitejs/plugin-react": "^4.0.0",
    "tailwindcss": "^4.0.0",
    "@tailwindcss/vite": "^4.0.0",
    "@tailwindcss/postcss": "^4.0.0",
    "typescript": "^5.7.0",
    "@types/react": "^19.0.0",
    "@types/react-dom": "^19.0.0",
    "@types/node": "^22.0.0"
  },
  "scripts": {
    "dev": "electron-vite dev",
    "build": "electron-vite build",
    "preview": "electron-vite preview"
  }
}
```

### electron.vite.config.ts

```typescript
import { defineConfig } from 'electron-vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  main: { build: { outDir: 'out/main' } },
  preload: { build: { outDir: 'out/preload' } },
  renderer: {
    plugins: [react()],
    build: { outDir: 'out/renderer' }
  }
})
```

### Main Process (src/main/index.ts)

**Window Creation:**
```typescript
const mainWindow = new BrowserWindow({
  width: 1400,
  height: 900,
  minWidth: 1200,
  minHeight: 800,
  backgroundColor: '#0A0A10',
  titleBarStyle: 'hiddenInset',                   // macOS frameless
  trafficLightPosition: { x: 16, y: 16 },         // macOS traffic lights
  show: false,                                     // Show when ready
  webPreferences: {
    preload: path.join(__dirname, '../preload/index.js'),
    contextIsolation: true,
    nodeIntegration: false
  }
})

mainWindow.once('ready-to-show', () => mainWindow.show())
```

Note: On Windows/Linux, `titleBarStyle: 'hiddenInset'` and `trafficLightPosition` are ignored. The default frame is used instead. The app works cross-platform without OS-specific branching.

**IPC Handlers (4 total):**

| Channel | Direction | Description |
|---------|-----------|-------------|
| `tracker:read` | renderer → main | Returns tracker JSON string or null |
| `tracker:write` | renderer → main | Writes JSON string to disk, returns `{success, error?}` |
| `tracker:path` | renderer → main | Returns absolute tracker file path |
| `tracker:fileInfo` | renderer → main | Returns `{exists, size, lastModified, watcherActive}` |

**File Watcher:**
```
let lastWriteTime = 0

fs.watch(TRACKER_PATH, (eventType) => {
  if (eventType !== 'change') return
  // Skip if we wrote within the last 1000ms (avoids reacting to own writes)
  if (Date.now() - lastWriteTime < 1000) return

  const content = fs.readFileSync(TRACKER_PATH, 'utf-8')
  try {
    JSON.parse(content)  // Validate before sending
    mainWindow.webContents.send('tracker:updated', content)
  } catch {
    // Ignore corrupt JSON (file might be mid-write)
  }
})
```

The `tracker:write` IPC handler sets `lastWriteTime = Date.now()` before writing, creating a 1-second window where the file watcher ignores changes (preventing infinite loops from own writes).

**App Lifecycle:**
- `app.whenReady()` → create window + start file watcher
- `app.on('activate')` → recreate window if none exist (macOS)
- `app.on('window-all-closed')` → quit (except macOS)
- `app.on('before-quit')` → close file watcher

### Config (src/main/config.ts)

Resolve the project root:
1. Check `PROJECT_ROOT` environment variable
2. Fallback: read `.env` file for `PROJECT_ROOT=...`
3. Export `TRACKER_PATH = path.join(PROJECT_ROOT, 'project-tracker.json')`

### Preload Bridge (src/preload/index.ts)

```typescript
contextBridge.exposeInMainWorld('api', {
  platform: process.platform,
  tracker: {
    read: ()              => ipcRenderer.invoke('tracker:read'),
    write: (json: string) => ipcRenderer.invoke('tracker:write', json),
    getPath: ()           => ipcRenderer.invoke('tracker:path'),
    getFileInfo: ()       => ipcRenderer.invoke('tracker:fileInfo'),
    onUpdated: (cb: (json: string) => void) => {
      const handler = (_event: any, json: string) => cb(json)
      ipcRenderer.on('tracker:updated', handler)
      return () => ipcRenderer.removeListener('tracker:updated', handler)
    }
  }
})
```

### Window Type Augmentation (src/renderer/env.d.ts)

```typescript
interface TrackerAPI {
  read(): Promise<string | null>
  write(json: string): Promise<{ success: boolean; error?: string }>
  getPath(): Promise<string>
  getFileInfo(): Promise<{ exists: boolean; size: number; lastModified: string; watcherActive: boolean }>
  onUpdated(callback: (json: string) => void): () => void
}

interface Window {
  api: {
    platform: string
    tracker: TrackerAPI
  }
}
```

### Renderer Entry (src/renderer/main.tsx)

```typescript
import React from 'react'
import { createRoot } from 'react-dom/client'
import '@fontsource/inter/300.css'
import '@fontsource/inter/400.css'
import '@fontsource/inter/500.css'
import '@fontsource/inter/600.css'
import '@fontsource/inter/700.css'
import '@fontsource/jetbrains-mono/400.css'
import '@fontsource/jetbrains-mono/500.css'
import App from './App'
import './styles.css'

createRoot(document.getElementById('root')!).render(
  <React.StrictMode><App /></React.StrictMode>
)
```

> **Checkpoint:** Run `npm run dev`. The Electron app should launch, show a loading screen, read the tracker JSON, and display an empty state. The file watcher should be active. No views yet — just the shell.

---

## PHASE 4: STORE & TAB SYSTEM

### Zustand Store (src/renderer/store.ts)

**State Interface:**
```typescript
interface AppState {
  tracker: TrackerState | null
  loading: boolean
  error: string | null
  synced: boolean
  activeTab: TabId
  selectedMilestoneId: string | null
  theme: 'dark' | 'light'

  // Actions
  setTracker: (data: TrackerState) => void      // External updates (no write-back)
  updateTracker: (updater: (draft: TrackerState) => void) => void  // UI mutations (triggers write-back)
  setActiveTab: (tab: TabId) => void
  setSelectedMilestoneId: (id: string | null) => void
  setLoading: (v: boolean) => void
  setError: (err: string | null) => void
  setSynced: (v: boolean) => void
  toggleTheme: () => void
}

type TabId = 'swim-lane' | 'task-board' | 'agent-hub' | 'calendar'
```

**updateTracker Action (Mutation + Write-Back):**
```typescript
updateTracker: (updater) => {
  const tracker = get().tracker
  if (!tracker) return
  const next = JSON.parse(JSON.stringify(tracker))  // Deep clone
  updater(next)                                      // Apply mutations

  // Recompute derived fields
  const total = next.milestones.reduce((s, m) => s + m.subtasks.length, 0)
  const done = next.milestones.reduce((s, m) =>
    s + m.subtasks.filter(t => t.done).length, 0)
  next.project.overall_progress = total > 0 ? parseFloat((done / total).toFixed(4)) : 0
  next.project.current_week = selectCurrentWeek(next)
  next.project.schedule_status = selectScheduleStatus(next)

  set({ tracker: next })
  scheduleWriteBack(next)
}
```

**Write-Back Debounce:**
```typescript
let writeTimer: ReturnType<typeof setTimeout> | null = null
let suppressExternalRefresh = false

function scheduleWriteBack(tracker: TrackerState) {
  if (writeTimer) clearTimeout(writeTimer)
  writeTimer = setTimeout(() => {
    suppressExternalRefresh = true
    window.api.tracker.write(JSON.stringify(tracker, null, 2))
    setTimeout(() => { suppressExternalRefresh = false }, 700)
  }, 500)
}
```

**External Change Listener:**
```typescript
// Registered once on App mount
window.api.tracker.onUpdated((json) => {
  if (suppressExternalRefresh) return  // Skip own writes
  try {
    const data = JSON.parse(json)
    data.project.current_week = selectCurrentWeek(data)
    useStore.getState().setTracker(data)  // setTracker does NOT trigger write-back
  } catch { /* ignore corrupt JSON */ }
})
```

**Theme Persistence:**
- Read from `localStorage.getItem('command-center-theme')` on init, default `'dark'`
- Write to `localStorage` on toggle

### Derived Selectors (Pure Functions)

```typescript
function selectCurrentWeek(tracker: TrackerState | null): number {
  if (!tracker) return 1
  const start = new Date(tracker.project.start_date)
  const now = new Date()
  const diffDays = (now.getTime() - start.getTime()) / (1000 * 60 * 60 * 24)
  const totalWeeks = Math.ceil(
    (new Date(tracker.project.target_date).getTime() - start.getTime())
    / (1000 * 60 * 60 * 24 * 7)
  )
  return Math.max(1, Math.min(totalWeeks, Math.floor(diffDays / 7) + 1))
}

function selectCurrentWeekFractional(tracker: TrackerState | null): number {
  // Same as above but returns decimal (e.g., 3.4 = day 3 of week 3)
  // Used for NOW marker positioning on swim lane
  if (!tracker) return 1
  const start = new Date(tracker.project.start_date)
  const now = new Date()
  const diffDays = (now.getTime() - start.getTime()) / (1000 * 60 * 60 * 24)
  const totalWeeks = /* same calculation */
  return Math.max(1, Math.min(totalWeeks + 0.99, diffDays / 7 + 1))
}

function selectCurrentPhase(tracker: TrackerState | null): string {
  const week = selectCurrentWeek(tracker)
  const phase = tracker?.schedule.phases.find(
    p => week >= p.start_week && week <= p.end_week
  )
  return phase?.title ?? ''
}

function selectScheduleStatus(tracker: TrackerState | null): 'on_track' | 'behind' | 'ahead' {
  if (!tracker || tracker.milestones.length === 0) return 'on_track'
  const drifts = tracker.milestones.map(m => m.drift_days)
  if (Math.max(...drifts) > 3) return 'behind'
  if (Math.min(...drifts) < -3) return 'ahead'
  return 'on_track'
}

function selectOverallProgress(tracker: TrackerState | null): number {
  return tracker?.project.overall_progress ?? 0
}

function selectMilestoneProgress(milestone: Milestone): { done: number; total: number; pct: number } {
  const total = milestone.subtasks.length
  const done = milestone.subtasks.filter(t => t.done).length
  return { done, total, pct: total > 0 ? Math.round((done / total) * 100) : 0 }
}
```

### Root Component (src/renderer/App.tsx)

**Layout:**
```
┌─────────────────────────────────────────────┐
│ [Draggable Title Bar - 12px]                │  ← WebkitAppRegion: 'drag'
├────────────────────────┬────────────────────┤
│ [TabBar]               │ [StatusBar]        │  ← WebkitAppRegion: 'no-drag'
├────────────────────────┴────────────────────┤
│                                             │
│ [Active View - flex-1]                      │
│                                             │
└─────────────────────────────────────────────┘
```

**States:**
- Loading: centered spinner with "Loading tracker..." message
- Error: error message with instructions
- Loaded: TabBar + StatusBar + active view

**Theme Application:**
```typescript
useEffect(() => {
  document.documentElement.dataset.theme = theme
}, [theme])
```

### TabBar Component

4 tabs with icons and labels:

| Tab | ID | Icon |
|-----|----|------|
| Swim Lane | `swim-lane` | Timeline/hexagon icon |
| Task Board | `task-board` | Grid/kanban icon |
| Agent Hub | `agent-hub` | Lightning/bolt icon |
| Calendar | `calendar` | Calendar grid icon |

**Activity indicator:** The Agent Hub tab shows a small pulsing dot if any `agent_log` entry has a timestamp within the last 30 minutes.

**Visual:** Pill-shaped buttons, active tab has accent background. Non-draggable region (clicks must work).

### StatusBar Component

Renders in the top-right area, left to right:

1. **Week + Phase** — "WEEK 3 · Core Features" (from selectors)
2. **Progress bar** — Small horizontal bar, accent color fill proportional to `overall_progress`
3. **Progress text** — "12/27 (44%)" in monospace font
4. **Schedule chip** — "ON TRACK" (green), "BEHIND" (red), or "AHEAD" (green)
5. **Sync indicator** — Green dot if `synced`, red if not + label
6. **Theme toggle** — Sun/moon icon button

> **Checkpoint:** All 4 tabs render (can be placeholder divs). Clicking tabs switches the active view. StatusBar shows project metadata. Theme toggle works. Store syncs with tracker file.

---

## PHASE 5: SWIM LANE VIEW

### Wireframe

```
┌──────────┬──────────────────────────────────────────────────────────────────┐
│          │  W1       W2       W3    ▎  W4       W5       W6       W7       │
│          │  01-01    01-08    01-15 ▎  01-22    01-29    02-05    02-12    │
├──────────┼─ Phase A (tinted bg) ───▎── Phase B (tinted bg) ───────────────┤
│          │                         ▎                                       │
│ Domain A │    (●6/11)────(●3/8)    ▎                                       │
│ ████████ │                         ▎                                       │
│          │                         ▎                                       │
├──────────┤                         ▎                                       │
│          │                         ▎                                       │
│ Domain B │       (●4/4)            ▎     (●2/7)────(●0/5)                  │
│ ████████ │                         ▎                                       │
│          │                         ▎                                       │
├──────────┤                         ▎                                       │
│          │                         ▎                                       │
│ Domain C │                    (●1/3) ▎         (●0/6)                      │
│ ████████ │                         ▎                                       │
│          │                         ▎                                       │
├──────────┤                         ▎                                       │
│          │      ◆ Beta Release     ▎                    ◆ V1.0 Launch     │
└──────────┴─────────────────────────┴───────────────────────────────────────┘
                                     ▎
                                   NOW marker (vertical line + date label)
```

Legend:
- `(●6/11)` = Milestone node (progress ring with done/total)
- `────` = Connection line between adjacent milestones in same lane
- `◆` = Major milestone marker (at bottom)
- `████████` = Domain color bar (left label area)
- `▎` = NOW marker (vertical line at fractional week position)
- Phase backgrounds are translucent tinted rectangles spanning their week range

### Constants

| Constant | Value | Description |
|----------|-------|-------------|
| `WEEK_W` | 100 | Width of each week column in pixels |
| `LANE_H` | 200 | Height of each swim lane |
| `LABEL_W` | 140 | Width of sticky left domain labels |
| `HEADER_H` | 44 | Height of week header row |
| `NODE_R` | 20 | Radius of normal milestone nodes |
| `KEY_NODE_R` | 26 | Radius of key milestone nodes |
| `PANEL_W` | 480 | Width of detail panel slide-out |
| `TOTAL_W` | `WEEK_W * totalWeeks` | Total scrollable width |

`totalWeeks` is calculated dynamically from `project.start_date` and `project.target_date`.

### Layout Sections (rendered in order, back to front)

**1. Phase Background Bands**
- For each phase in `schedule.phases`: render a translucent rectangle
- X position: `(phase.start_week - 1) * WEEK_W`
- Width: `(phase.end_week - phase.start_week + 1) * WEEK_W`
- Height: full swim lane area
- Color: use phase color at ~5% opacity

**2. Week Grid Lines**
- Vertical lines at each week boundary
- Style: 1px, `rgba(255,255,255,0.03)` (dark theme)

**3. NOW Marker**
- Vertical line at fractional week position
- X position: `(selectCurrentWeekFractional(tracker) - 1) * WEEK_W + LABEL_W`
- Style: 2px solid accent color
- Label at top: "NOW" + current date in small text
- Auto-scroll the container to center on the NOW marker on initial load

**4. Week Headers**
- Row of week labels: "W1", "W2", etc.
- Below each: date string (start date of that week, formatted as MM-DD)

**5. Swim Lanes**
- One lane per unique domain in `milestones[].domain`
- Each lane has:
  - **Left label**: Domain name, rotated 90° vertically, colored background matching domain color
  - **Milestone nodes**: Positioned at `(milestone.week - 1) * WEEK_W` horizontally, centered vertically in lane
  - **Stacking**: When multiple milestones share the same week in the same lane, stack them vertically with 56px spacing
  - **Connection lines**: Horizontal lines between adjacent milestones in the same domain, sorted by week

**6. Major Milestone Markers**
- Below the swim lanes, render markers for milestones where `is_key_milestone === true`
- Each marker: diamond shape + `key_milestone_label` text
- Dashed vertical line extending up through all lanes at that week position

### Milestone Node Rendering (SVG)

Each node is an SVG group:

```
<g transform="translate(cx, cy)">
  <!-- Background circle -->
  <circle r={NODE_R} fill="rgba(17,17,24,0.95)" stroke="rgba(255,255,255,0.06)" stroke-width="1" />

  <!-- Progress arc -->
  <circle r={NODE_R - 2}
    fill="none"
    stroke={domainColor}
    stroke-width="2.5"
    stroke-dasharray={`${(done/total) * circumference} ${circumference}`}
    transform="rotate(-90)"  <!-- Start from 12 o'clock -->
  />

  <!-- Center text -->
  <text font-family="JetBrains Mono" font-size="9" fill="white" text-anchor="middle" dy="3">
    {done}/{total}
  </text>
</g>
```

Where `circumference = 2 * Math.PI * (NODE_R - 2)`.

**Key milestone glow:** For nodes where `is_key_milestone === true`, use `KEY_NODE_R` instead of `NODE_R`, and add a CSS `box-shadow: 0 0 16px 3px {domainColor}30`.

**Selection indicator:** When a node is selected (clicked), add a 2px border ring at `NODE_R + 2`.

### Drift Visualization

When `milestone.drift_days !== 0`:

1. **Ghost node**: Render a dashed-outline circle at the PLANNED position (where the node would be if on schedule)
   - Same radius as the actual node
   - Dashed stroke, low opacity (30%)

2. **Actual node**: Render at the ACTUAL position (shifted by drift)
   - Shift amount: `drift_days * (WEEK_W / 7)` pixels

3. **Connecting bar**: Horizontal bar between ghost and actual positions
   - Color: red if `drift_days > 0` (behind), green if `drift_days < 0` (ahead)
   - Height: 4px

4. **Drift badge**: Below the actual node, show "X DAYS BEHIND" (red) or "X DAYS AHEAD" (green)

### Milestone Detail Panel

A slide-out panel from the right side, width `PANEL_W` (480px):

**Header:**
- Domain color tag + "W{week}" badge + key milestone label (if any)
- Milestone title
- First note (line-clamp-2)
- Close button (×)
- Progress bar: done/total with percentage, colored by domain

**Sections:**

1. **Schedule** — 2×2 grid:
   - Planned Start / Planned End (date inputs, editable)
   - Actual Start / Actual End (read-only, auto-calculated)
   - Drift label if non-zero: "X DAYS BEHIND/AHEAD"
   - Save button (calls `updateTracker` to persist date changes)

2. **Subtasks Checklist** — Scrollable list:
   - Per task: checkbox toggle, label, assignee badge, status color dot, priority badge
   - Clicking checkbox toggles `task.done` and sets `completed_at`
   - Shows done/total count in section header

3. **Dependencies** — If `milestone.dependencies` is non-empty:
   - List upstream milestones with mini progress rings (24px SVG)
   - Show title, done/total, week number for each

4. **Notes** — Exit criteria:
   - Existing notes displayed as read-only cards
   - Textarea + Add button to append new notes
   - Adding a note calls `updateTracker` to append to `milestone.notes[]`

### Interactions

- **Click milestone node** → open detail panel (set `panelTarget` state)
- **Horizontal scroll** → pan timeline left/right
- **Close panel** → click × button or backdrop
- **Auto-scroll on load** → scroll to center the NOW marker

### Empty State

When `milestones[]` is empty:
- Show the week grid and NOW marker
- Show empty lanes with placeholder text: "Milestones will appear here after hydration"
- No detail panel available

> **Checkpoint:** Swim Lane renders with week grid, NOW marker at the correct fractional week, and empty lane placeholders. If you manually add a milestone to the tracker JSON, it should appear as a node in the correct lane and week position.

---

## PHASE 6: TASK BOARD VIEW

### Wireframe

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  ◐ 6/11  Domain · W3 · Milestone Title         ← [Select ▼] →   Next ▸   │
├─────────────────────────────────────────────────────────────────────────────┤
│  [All: 11]   [My Tasks: 3]   [Agent Tasks: 5]   [Blocked: 1]              │
├──────────────┬──────────────┬──────────────┬──────────────┬────────────────┤
│  ▎ TO DO (5) │▎IN PROGRESS 3│▎ REVIEW (2)  │▎  DONE (1)   │▎ BLOCKED (1)  │
│  ───────────-│  ──────────  │  ──────────  │  ──────────  │  ───────────  │
│ ┌──────────┐ │ ┌──────────┐ │ ┌──────────┐ │ ┌──────────┐ │ ┌──────────┐ │
│ │▌P2 domain│ │ │▌P1 domain│ │ │▌P1 domain│ │ │▌✓ domain │ │ │▌⊘ domain │ │
│ │ Title    │ │ │ Title    │ │ │ Title    │ │ │ Title    │ │ │ Title    │ │
│ │ desc...  │ │ │ desc...  │ │ │          │ │ │ 04/10    │ │ │ Reason:  │ │
│ │    @agent│ │ │    @agent│ │ │  @human  │ │ │          │ │ │ dep...   │ │
│ └──────────┘ │ └──────────┘ │ └──────────┘ │ └──────────┘ │ └──────────┘ │
│ ┌──────────┐ │ ┌──────────┐ │              │              │              │
│ │▌P3 domain│ │ │▌P2 domain│ │              │              │              │
│ │ Title    │ │ │ Title    │ │              │              │              │
│ └──────────┘ │ └──────────┘ │              │              │              │
│              │              │              │              │              │
│  ··DROP··    │              │              │              │              │
└──────────────┴──────────────┴──────────────┴──────────────┴──────────────┘
```

### Column Definitions

| Column ID | Label | Color | Description |
|-----------|-------|-------|-------------|
| `todo` | TO DO | `#9B9BAA` (muted) | New tasks |
| `in_progress` | IN PROGRESS | `#585CF0` (accent) | Currently being worked |
| `review` | REVIEW | `#f59e0b` (amber) | Awaiting operator approval |
| `done` | DONE | `#22c55e` (green) | Completed |
| `blocked` | BLOCKED | `#ef4444` (red) | Blocked by dependency or issue |

### ContextBar Component

**Props:** `milestones: Milestone[]`, `activeMilestoneIndex: number`, `onMilestoneChange: (index) => void`

**Layout (left to right):**
1. Progress ring (36px SVG, same rendering as swim lane nodes)
2. Info block: domain tag + "W{week}" badge, milestone title, "Week X · done/total tasks"
3. Navigation: ← button, select dropdown, → button (disabled at boundaries)
4. Separator: vertical border
5. Next-up section: if next milestone exists, show small progress ring (24px) + title. Otherwise "FINAL MILESTONE"

### FilterBar Component

**Filters:**

| FilterType | Label | Filter Logic |
|------------|-------|-------------|
| `all` | All | No filter |
| `my_tasks` | My Tasks | `assignee === operator_name` |
| `agent_tasks` | Agent Tasks | `assignee !== null && assignee !== operator_name` |
| `blocked` | Blocked | `status === 'blocked'` |

Render as pill buttons with count badges. Active filter has accent background.

### KanbanColumn Component

**Props:** `column: {id, label, color}`, `subtasks: Subtask[]`, `domain: string`, `onCardClick: (subtask) => void`

**Layout:**
1. Column header: 4px-wide color bar on left + label (10px bold uppercase) + count badge
2. Drop zone: `useDroppable` from @dnd-kit/core, highlights with accent background when an item is dragged over
3. `SortableContext` with `verticalListSortingStrategy`, containing `TaskCard` components
4. Empty state: "DROP HERE" placeholder with dashed border, minimum height 120px

### TaskCard Component

**Props:** `subtask: Subtask`, `domain: string`, `onClick: () => void`

Uses `useSortable` hook from @dnd-kit/sortable for drag behavior.

**Layout:**
1. **Left border**: 3px wide, colored by `execution_mode`:
   - `agent` → `#ef4444` (red)
   - `human` → `#22c55e` (green)
   - `pair` → `#3b82f6` (blue)
   - In-progress tasks: add a subtle pulsing animation to the border
2. **Top row**: domain color tag (small pill) + priority badge ("P1", "P2", etc.)
3. **Title**: first segment of label (split at first colon or dash)
4. **Description**: remainder of label after the split, line-clamp-2, muted color
5. **Blocker bar**: if `status === 'blocked'`, show red-tinted bar with `blocked_reason` text
6. **Assignee chip**: right-aligned at bottom, agent name. If assigned to an agent (not human), show a small pulsing dot indicator

### TaskDetailModal Component

Full-screen overlay modal opened when clicking a task card.

**Header (sticky):**
- Domain tag + priority badge + execution mode tag
- Task title + task ID (with copy button)
- Close button (×)
- Tab navigation: [Details] | [History]

**Details Tab:**
- 2-column grid: Status select dropdown, Priority select
- 2-column grid: Assignee select (agents + operator), Execution mode toggle (human/agent/pair)
- Blocked checkbox + reason text input
- Dependencies section (if `depends_on` is non-empty): list with progress indicators
- Sibling tasks section: scrollable list of other tasks in the same milestone with status dots
- Notes textarea (free-form)
- Parent milestone link: "Part of {milestone title}" with optional "View in Swim Lane" button (switches tab)

**History Tab:**
- Chronological log from `agent_log` where `target_id === task.id`
- Per entry: agent ID, action, description, tags (styled pills), timestamp
- Focus on review cycle: `task_submitted_for_review`, `revision_requested`, `task_approved` entries

**Footer (sticky):**
- Status display: "Status: {current_status}"
- Cancel button + Save Changes button (accent color)
- Save writes changes via `updateTracker()`

**Interactions:**
- Escape key closes modal
- If blocked checkbox toggled ON: set status to blocked
- If blocked checkbox toggled OFF: set status to todo
- Assignee dropdown includes: "Unassigned", operator name, + all agents from `state.agents[]`

### Drag-Drop Logic

Using @dnd-kit/core with `PointerSensor` (5px activation distance) and `KeyboardSensor`:

**On drag end:**
1. Identify source column (find which column contains the dragged task ID)
2. Identify target column (the droppable zone the task was dropped on)
3. If same column: do nothing
4. Update `task.status` to the target column ID
5. Side effects by target column:
   - `done` → set `completed_at = now`, `completed_by = operator`, clear `blocked_*`
   - `blocked` → set `blocked_by = 'manual'`, clear `completed_*`
   - Any other → clear `blocked_*` if moving FROM blocked

Collision detection: `closestCorners` strategy from @dnd-kit.

### Empty State

When no subtasks exist in the selected milestone:
- Show 5 empty columns with headers
- Center text: "No tasks yet — tasks will appear after hydration"

> **Checkpoint:** Task board renders with 5 columns and milestone carousel. Drag-drop works between columns. If you manually add subtasks to a milestone in the tracker JSON, they appear as cards in the correct columns. Clicking a card opens the detail modal.

---

## PHASE 7: AGENT HUB VIEW

### Wireframe

```
┌───────────────────────────┬─────────────────────────────────────────────────┐
│  CONNECTED AGENTS         │  ACTIVITY FEED                                  │
│  ─────────────────────    │  [All] [Agent1] [Agent2] [Manual] [System]      │
│                           │  [🔍 Search...]                                 │
│  ▼ Orchestrator Name      │  ─────────────────────────────────────────────   │
│    ● Agent Name           │  TODAY                                          │
│      ACTIVE · 2m ago      │  ● agent · started task_005 · [START] [MCP]     │
│      [READ] [WRITE]       │    10:30 AM                                     │
│                           │                                                 │
│    ○ Sub-Agent Name       │  ● agent · completed build · [WRITE]            │
│      IDLE · 2h ago        │    10:15 AM                                     │
│      [READ]               │  ─────────────────────────────────────────────   │
│                           │  YESTERDAY                                      │
│  ─────────────────────    │  ● agent · exploration_complete · [MCP]         │
│  SHARED STATE FILE        │    04:30 PM                                     │
│  ─────────────────────    │                                                 │
│  Path: project-tracker    │  [Load More]                                    │
│  Watcher: ● Active        │                                                 │
│  Milestones: 9            │  ─────────────────────────────────────────────   │
│  Subtasks: 0              │  AGENT PERFORMANCE (THIS WEEK)                  │
│  Log entries: 0           │  ┌──────────┐ ┌──────────┐ ┌──────────┐        │
│                           │  │ ● Agent1 │ │ ● Agent2 │ │ ● Agent3 │        │
│  ─────────────────────    │  │ 24 acts  │ │ 12 acts  │ │ 3 acts   │        │
│  CONTEXT INJECTION        │  └──────────┘ └──────────┘ └──────────┘        │
│  ─────────────────────    │                                                 │
│  WEEK 3, Phase: Core      │                                                 │
│  Progress: 45% (12/27)    │                                                 │
│  Schedule: ON TRACK       │                                                 │
│  Blocked: 2               │                                                 │
│  [Copy to Clipboard]      │                                                 │
│                           │                                                 │
│  ─────────────────────    │                                                 │
│  TODAY'S SUMMARY          │                                                 │
│  ─────────────────────    │                                                 │
│  Completed: 3             │                                                 │
│  In Progress: 5           │                                                 │
│  Blocked: 1               │                                                 │
│  ─── Contributions ───    │                                                 │
│  ● Agent1: 5 actions      │                                                 │
│  ● Agent2: 2 actions      │                                                 │
└───────────────────────────┴─────────────────────────────────────────────────┘
```

### Left Column (fixed width: 340px)

#### Panel 1: Connected Agents

- Read `state.agents[]`
- Group agents hierarchically:
  - Orchestrators (type === 'orchestrator') at top level
  - Sub-agents nested under their parent (matched by `parent_id`)
  - Standalone agents (no parent, not orchestrator) listed separately
- Per agent card:
  - Color dot (agent.color) + name
  - Status: "ACTIVE" with pulsing green dot if `isAgentActive(agent)`, "IDLE" with gray dot otherwise
  - Time since last action: "2m ago", "1h ago", etc. (from `last_action_at`)
  - Permission badges: small pills showing each permission (e.g., [READ], [WRITE])
  - Session action count
- Orchestrator sections are collapsible (toggle arrow)
- "Connect New Agent" button at bottom — shows a tooltip explaining how to register agents via the MCP `register_agent` tool

**isAgentActive(agent):**
```typescript
return agent.last_action_at != null &&
  (Date.now() - new Date(agent.last_action_at).getTime()) < 30 * 60 * 1000  // 30 minutes
```

#### Panel 2: Shared State File Info

- File path: "project-tracker.json"
- Watcher status: green dot "Active" if `synced`, red "Inactive" otherwise
- Counts (computed from tracker):
  - Milestones: `state.milestones.length`
  - Subtasks: sum of all `milestone.subtasks.length`
  - Log entries: `state.agent_log.length`
- Schema validation indicator (always "Valid" if tracker loaded successfully)

#### Panel 3: Context Injection Preview

Auto-generated one-line context string:

```
WEEK {current_week}, Phase: {current_phase}, Progress: {pct}% ({done}/{total}), Schedule: {schedule_status}, Blocked: {blocked_count}
```

- "Copy to Clipboard" button → copies the string, shows checkmark feedback for 2 seconds

#### Panel 4: Today's Summary

- Three stat boxes in a row: Completed (count), In Progress (count), Blocked (count)
  - Computed by filtering ALL subtasks by status
- Contribution breakdown:
  - Filter `agent_log` where timestamp is today
  - Group by `agent_id`, count actions per agent
  - Sort by count descending
  - Show: agent color dot + agent name + action count

### Right Column (flex-1)

#### Activity Feed

**Filter tabs:** "All" + one tab per registered agent (using agent name and color dot) + "Manual" (agent_id matches operator) + "System" (automated/MCP actions)

**Search box:** Filters entries where description contains the search string (case-insensitive)

**Feed entries:**
- Sorted by timestamp descending
- Grouped by day with headers:
  - "TODAY" if same date
  - "YESTERDAY" if previous date
  - Otherwise: "MON APR 14" (abbreviated day + month + date)
- Per entry:
  - Agent color dot + bold agent name (in agent's color)
  - Description text
  - Target ID reference (e.g., "task_005")
  - Tag pills (styled, see below)
  - Timestamp right-aligned: "10:30 AM"

**Tag Pill Styles:**

| Tag | Background | Text Color |
|-----|-----------|------------|
| WRITE | green/10 | green |
| COMMIT | accent/10 | accent |
| START | blue/10 | blue |
| ALERT | red/10 | red |
| NOTE | muted/10 | muted |
| MCP | accent/10 | accent |

**Pagination:** Show 30 entries initially. "Load More" button at bottom loads next 30.

#### Agent Performance Stats

Below the activity feed:

- **Scope:** This calendar week only (filter `agent_log` by timestamp)
- Per agent: horizontal card with:
  - Agent color dot + name
  - Total actions count
  - Breakdown by common tags (count of entries tagged 'write', 'start', 'alert')
- Horizontal scroll if many agents

### Empty State

When `agents[]` is empty and `agent_log[]` is empty:
- Connected Agents: "No agents registered yet. Agents register via the MCP register_agent tool."
- Activity Feed: icon + "No activity recorded yet"
- Performance Stats: hidden
- Context Injection + Today's Summary: still functional (computed from tracker)

> **Checkpoint:** Agent Hub renders with 4 left panels and the activity feed. Context Injection shows correct project stats. Copy button works. If you manually add an agent and log entries to the tracker JSON, they appear in the Connected Agents panel and Activity Feed.

---

## PHASE 8: CALENDAR VIEW

### Wireframe

```
┌──────────────────────────────────────────────────────────────────────────────┐
│  ◀ Prev     Week 3 · Jan 15 – Jan 21, 2026 · 3 completed      Today Next ▶ │
├──────────┬──────────┬──────────┬──────────┬──────────┬──────────┬───────────┤
│   MON    │   TUE    │   WED    │   THU    │   FRI    │   SAT    │   SUN     │
│   15     │   16     │   17     │   18     │   19     │   20     │   21      │
│  ═══     │          │  ═══     │          │          │          │           │
│ ┌──────┐ │          │ ┌──────┐ │          │          │          │           │
│ │█ Task│ │          │ │█ Task│ │          │          │          │           │
│ │ ✓    │ │          │ │ ✓    │ │          │          │          │           │
│ │domain│ │          │ │domain│ │          │          │          │           │
│ └──────┘ │          │ └──────┘ │          │          │          │           │
│ ┌──────┐ │          │          │          │          │          │           │
│ │█ Task│ │          │          │          │          │          │           │
│ │ ✓    │ │          │          │          │          │          │           │
│ └──────┘ │          │          │          │          │          │           │
└──────────┴──────────┴──────────┴──────────┴──────────┴──────────┴───────────┘
         ▲
         Today indicator (colored bar under header)
```

### Week Grid Layout

- **7 columns** (Mon–Sun), equal width
- **Header per column:** Day abbreviation (MON, TUE, etc.) + date number + month name if 1st of month or first day of week
- **Today indicator:** Accent-colored bar below the header of today's column
- **Task chips:** Stacked vertically in the column of their completion date

### Task Placement Logic

This calendar shows ONLY completed tasks:

1. Collect all subtasks across all milestones where `status === 'done'` AND `completed_at` is not null
2. Parse `completed_at` to a date
3. Place each task chip in the column matching that date
4. If a task's `completed_at` falls outside the currently displayed week, it doesn't appear

### Task Chip Component

Small card for each completed task:

- **Left border:** 3px, colored by domain
- **Label:** Task label (truncated to one line)
- **Domain tag:** Small colored pill with domain name
- **Checkmark:** Green checkmark icon indicating completion
- **Style:** Muted background, slightly transparent to avoid visual heaviness

### Navigation

- **Prev/Next buttons:** Move to previous/next week
- **Today button:** Jump to the week containing today's date
- **Header:** "Week {N} · {start_date} – {end_date} · {count} completed"

### Week Calculation

- Week 1 starts on the Monday of the week containing `project.start_date`
- Each subsequent week is 7 days
- Total weeks calculated from `project.start_date` to `project.target_date`

### Empty State

When no completed tasks exist:
- Show the week grid with headers
- Center text in the grid: "Completed tasks will appear here as work is finished"

> **Checkpoint:** Calendar renders with 7-column week grid. Today indicator highlights the correct day. Week navigation works. If you manually set a subtask's `status` to `done` and add a `completed_at` timestamp in the tracker JSON, it appears as a chip in the correct day column.

---

## PHASE 9: DESIGN SYSTEM

### Color Palette

**Dark Theme (default):**

| Token | CSS Variable | Value | Usage |
|-------|-------------|-------|-------|
| Dark | `--theme-dark` | `#0A0A10` | App background |
| Surface | `--theme-surface` | `#111118` | Card/panel backgrounds |
| Border | `--theme-border` | `#1a1a2e` | Borders, dividers |
| Muted | `--theme-muted` | `#9B9BAA` | Secondary text, inactive elements |
| Primary Text | `--theme-primary-text` | `#FFFFFF` | Primary text |
| Scrollbar Thumb | `--theme-scrollbar-thumb` | `rgba(255,255,255,0.08)` | Scrollbar |
| Selection | `--theme-selection` | `rgba(88,92,240,0.3)` | Text selection |
| Progress Track | `--theme-progress-track` | `rgba(255,255,255,0.1)` | Progress bar background |

**Light Theme:**

| Token | CSS Variable | Value |
|-------|-------------|-------|
| Dark | `--theme-dark` | `#F8F9FA` |
| Surface | `--theme-surface` | `#FFFFFF` |
| Border | `--theme-border` | `#E5E7EB` |
| Muted | `--theme-muted` | `#6B7280` |
| Primary Text | `--theme-primary-text` | `#1A1A2E` |

**Fixed Colors (same in both themes):**

| Token | Value | Usage |
|-------|-------|-------|
| Accent | `#585CF0` | Primary action color, active states |
| Accent Light | `#8286FF` | Hover states, secondary accent |
| On Track | `#22c55e` | Schedule on track, done status |
| Behind | `#ef4444` | Schedule behind, blocked status, errors |
| Review | `#f59e0b` | Review/pending status |

**Domain Color Palette (assigned during hydration):**

When the user's manifesto is processed, each domain gets the next color from this list:

```
1. #f59e0b  (amber)
2. #22c55e  (green)
3. #8286FF  (indigo)
4. #ef4444  (red)
5. #14B8A6  (teal)
6. #EC4899  (pink)
7. #F97316  (orange)
8. #6366F1  (violet)
9. #06B6D4  (cyan)
10. #9B9BAA (muted gray — fallback)
```

Store the domain → color mapping in the tracker (e.g., as a field on each milestone's domain, or as a separate config object). All views reference this mapping for consistent domain coloring.

### Typography

| Role | Font | Weights | Usage |
|------|------|---------|-------|
| UI Text | Inter | 300, 400, 500, 600, 700 | All labels, descriptions, buttons |
| Code/Numbers | JetBrains Mono | 400, 500 | Task IDs, progress counts, timestamps, JSON |

### CSS Structure (src/renderer/styles.css)

```css
@import "tailwindcss";

@theme {
  --color-dark: var(--theme-dark);
  --color-surface: var(--theme-surface);
  --color-border: var(--theme-border);
  --color-accent: #585CF0;
  --color-accent-light: #8286FF;
  --color-muted: var(--theme-muted);
  --color-primary-text: var(--theme-primary-text);
  --color-on-track: #22c55e;
  --color-behind: #ef4444;
  --font-sans: 'Inter', ui-sans-serif, system-ui, sans-serif;
  --font-mono: 'JetBrains Mono', ui-monospace, monospace;
}

:root, [data-theme="dark"] {
  --theme-dark: #0A0A10;
  --theme-surface: #111118;
  --theme-border: #1a1a2e;
  --theme-muted: #9B9BAA;
  --theme-primary-text: #FFFFFF;
  --theme-scrollbar-thumb: rgba(255,255,255,0.08);
  --theme-scrollbar-thumb-hover: rgba(255,255,255,0.15);
}

[data-theme="light"] {
  --theme-dark: #F8F9FA;
  --theme-surface: #FFFFFF;
  --theme-border: #E5E7EB;
  --theme-muted: #6B7280;
  --theme-primary-text: #1A1A2E;
  --theme-scrollbar-thumb: rgba(0,0,0,0.12);
  --theme-scrollbar-thumb-hover: rgba(0,0,0,0.25);
}
```

### Custom Scrollbar

```css
::-webkit-scrollbar { width: 6px; height: 6px; }
::-webkit-scrollbar-track { background: transparent; }
::-webkit-scrollbar-thumb {
  background: var(--theme-scrollbar-thumb);
  border-radius: 3px;
}
::-webkit-scrollbar-thumb:hover {
  background: var(--theme-scrollbar-thumb-hover);
}
```

### Component Patterns

**Tag/Badge:** Small pill with colored background at 10% opacity, colored text. Border-radius: 4px. Padding: 2px 6px. Font-size: 10px. Font-weight: 500.

**Progress Ring (SVG):** Reusable across views. Props: `size` (diameter), `done`, `total`, `color`. Renders background track circle + colored arc using stroke-dasharray.

**Modal Backdrop:** Fixed inset, z-index 50, `bg-black/50`. Click backdrop to close.

**Panel Slide-in:** Absolute positioned, right: 0, z-index 40. Slides in from right with CSS transform transition (200ms ease-out).

> **Checkpoint:** All views use consistent colors, fonts, and component patterns. Theme toggle switches between dark and light modes. Scrollbars are styled. Tags, badges, and progress rings are consistent across all views.

---

## PHASE 10: WORKFLOW STATE MACHINE

This phase creates workflow documentation and agent role templates that describe how AI agents interact with the command center via MCP tools. These are reference documents — the implementing agent should create them as files in the user's project.

### Task Lifecycle States

```
                    ┌──────────┐
                    │   TODO   │
                    └────┬─────┘
                         │ start_task()
                    ┌────▼─────┐         block_task()    ┌──────────┐
                    │IN PROGRESS├───────────────────────►│ BLOCKED  │
                    └────┬─────┘                         └────┬─────┘
                         │ complete_task()                     │ unblock_task()
                    ┌────▼─────┐                              │
           ┌────────┤  REVIEW  │◄─────────────────────────────┘
           │        └────┬─────┘         (returns to previous state)
           │             │ approve_task()
           │        ┌────▼─────┐
           │        │   DONE   │
           │        └──────────┘
           │ reject_task()
           │
           └──► back to IN PROGRESS
```

### State Transition Table

| Current State | Trigger | MCP Tool | Agent Dispatch | Next State |
|--------------|---------|----------|---------------|------------|
| `todo` | Operator says "prepare task X" | `get_task_context` | Explorer, then Researcher | `todo` (enriched) |
| `todo` | Operator says "start task X" | `start_task` | — | `in_progress` |
| `in_progress` | Implementation complete | — | — | `in_progress` |
| `in_progress` | Build/typecheck/lint pass | — | Post-Build Auditor | `in_progress` |
| `in_progress` | Auditor passes | `complete_task` | — | `review` |
| `review` | Operator gives code feedback | `reject_task` | — | `in_progress` |
| `review` | Operator approves | `approve_task` | — | `done` |
| `any` | Blocker encountered | `block_task` | — | `blocked` |
| `blocked` | Blocker resolved | `unblock_task` | — | `todo` or `in_progress` |

### Prepare Phase (Enrichment)

When the operator says "prepare task X":

1. **Get context:** Call `get_task_context(task_id)` to read the task
2. **Dispatch Explorer agent:**
   - Pass the task_id and ask it to investigate the codebase
   - Explorer returns: relevant files, existing patterns, gaps, integration points
   - Explorer MUST call `log_action(task_id, "exploration_complete", summary, agent_id: "explorer")`
3. **Dispatch Researcher agent:**
   - Pass the task_id AND a compressed brief of explorer findings (max 500 tokens — file paths, patterns, gaps, not raw output)
   - Researcher looks up external docs, API references, best practices
   - Researcher MUST call `log_action(task_id, "research_complete", summary, agent_id: "researcher")`
4. **Ask operator** clarifying questions if ambiguity remains (skip if already answered)
5. **Write prompt file** at `docs/prompts/{task_id}.md` incorporating explorer findings + researcher findings + operator context
6. **Enrich task:** Call `enrich_task(task_id)` with updated acceptance criteria, constraints, context files, reference docs, and `builder_prompt` path
7. **Task stays in `todo`** — do NOT call `start_task`

### Start Phase (Implementation)

When the operator says "start task X":

1. **Start:** Call `start_task(task_id)` — moves to `in_progress`
2. **Get context:** Call `get_task_context(task_id)` to read the enriched task
3. **Implement:** The orchestrator (or builder agent) does the work
4. **Validate:** Run the project's build/typecheck/lint commands
   - If any fail: fix errors and re-run until clean
5. **Dispatch Post-Build Auditor:**
   - Pass `task_id` AND an explicit list of modified files
   - Auditor performs: build validation, code review, security scan
   - Auditor MUST call `log_action(task_id, "audit_complete", summary, agent_id: "post-build-auditor")`
   - If auditor returns "FIXED": re-run build/typecheck/lint
   - If auditor returns "FAIL" it could not resolve: do NOT call `complete_task` — report to operator
6. **Complete:** Call `complete_task(task_id, summary)` — moves to `review`

### Review Phase

When the operator gives feedback on a task in `review`:

- **If feedback involves ANY code changes** (refactoring, fixes, additions, modifications):
  1. IMMEDIATELY call `reject_task(task_id, feedback)` — moves back to `in_progress`
  2. Do the work
  3. Re-run validation + auditor
  4. Call `complete_task(task_id, summary)` to resubmit

- **If feedback is purely conversational** (questions, "explain why you..."):
  - Answer the question, keep task in `review`

### Approve Phase

When the operator explicitly says "approve task X" / "complete task X" / "done":

1. Call `approve_task(task_id)` — moves to `done`
2. Auto-unblock cascade runs (downstream dependent tasks are unblocked if all their dependencies are now satisfied)

This is the ONLY way a task reaches `done`. Never call `approve_task` without explicit operator instruction.

### General Rules

- Always call `start_task` before implementation. Never write code for a task in `todo`.
- Always call `complete_task` after finishing. Never leave a task stuck in `in_progress`.
- Use `log_action` to record significant events (files created, tests passed, architecture decisions).
- Use `block_task` if you hit a blocker you cannot resolve.
- If a task has revision history (from prior `reject_task` calls), address ALL prior feedback before resubmitting.

### Agent Role Templates

Create these as agent definition files in whatever format the user's agent platform requires.

---

#### Explorer Agent

**Role:** Codebase investigator. Dispatched during the prepare phase to understand what exists before building.

**When dispatched:** First agent in the prepare phase.

**Input:** Task ID.

**Tools needed:** File reading, file search (glob), content search (grep), shell commands (read-only).

**Responsibilities:**
- Read context files listed in the task
- Search for domain-relevant files using glob patterns
- Search for patterns, function names, and imports using grep
- Read key files to understand architecture, data models, and conventions
- Identify what exists vs. what needs creating or modifying
- Check upstream milestones to understand foundation

**What to look for:**
- Existing patterns to follow (naming, file structure, abstractions)
- Utilities, helpers, and shared code to reuse
- Data models and relationships
- Integration points where new code connects
- Potential conflicts with sibling or in-progress tasks

**Depth adjustment:**
- Simple tasks (config, static pages): quick scan, 5-10 files
- Moderate tasks (new routes, API integrations): thorough scan, trace full data flows
- Complex tasks (new domains, architecture changes): deep investigation, map all dependencies

**Output:** Structured findings with: relevant files (paths + why), existing patterns, dependencies and integration points, gaps.

**MUST call:** `log_action(task_id, "exploration_complete", description, agent_id: "explorer")`

---

#### Researcher Agent

**Role:** External documentation and best-practices lookup. Dispatched during the prepare phase after the Explorer.

**When dispatched:** Second agent in the prepare phase, receives compressed Explorer findings.

**Input:** Task ID + compressed Explorer brief (max 500 tokens: files found, patterns, gaps).

**Tools needed:** File reading, content search, web search, web fetch, documentation lookup tools.

**Responsibilities:**
- Review the Explorer's findings to understand what the task requires
- Look up external documentation for APIs, libraries, and frameworks used by the project
- Research best practices and known gotchas for the technologies involved
- Identify any documentation relevant to the task's domain

**Output:** Structured research report with: API references (exact signatures, required fields, return types), best practices, gotchas (things that could go wrong), questions for the operator (with recommendations).

**MUST call:** `log_action(task_id, "research_complete", description, agent_id: "researcher")`

---

#### Post-Build Auditor Agent

**Role:** Quality gate. Dispatched after implementation, before `complete_task`. Reviews code quality and security in a single pass.

**When dispatched:** After the orchestrator finishes implementation and build/typecheck/lint pass.

**Input:** Task ID + explicit list of modified files.

**Tools needed:** File reading, content search, file editing, shell commands.

**Responsibilities (single pass — read each file once, apply all checks):**

**Step 1: Build Validation**
- Run the project's build, typecheck, and lint commands
- If any fail: fix with file edits and re-run
- If cannot fix: report FAIL immediately

**Step 2: Code Review**
- Read all modified files
- Check each acceptance criterion against the code
- Verify codebase patterns are followed (naming, structure, conventions)
- Check for edge cases at system boundaries
- Check for unused imports or dead code
- If issues found: fix directly

**Step 3: Security Scan**
- In the same files already read, check for:
  - Injection vulnerabilities (SQL, XSS, command injection)
  - Hardcoded secrets or API keys
  - User input not sanitized before database queries
  - Error messages that leak internal details
- If issues found: fix directly

**Output:** Structured report:
```
## Build Validation: PASS | FIXED | FAIL
## Code Review: PASS | FIXED
## Security: PASS | FIXED
## Overall: PASS | FIXED | FAIL
```

**MUST call:** `log_action(task_id, "audit_complete", description, agent_id: "post-build-auditor")`

---

### Files to Create

Phase 10 should produce these files in the user's project:

1. **Workflow documentation** — A markdown file describing the task lifecycle, state transitions, agent dispatch points, and MCP tool call sequences. Place at a logical location (e.g., `docs/workflow.md` or `.claude/rules/task-workflow.md`).

2. **Agent role definitions** — One file per agent role (Explorer, Researcher, Post-Build Auditor) in whatever format the user's agent platform requires. Include the role description, when dispatched, tools needed, responsibilities, and required `log_action` call.

3. **MCP configuration** — The `.mcp.json` file (or equivalent) pointing to the globally-installed `command-center-mcp` package with the `PROJECT_ROOT` environment variable.

> **Checkpoint:** Workflow documentation exists in the project. Agent role definitions are created. MCP configuration points to the command center server. An agent can call `get_project_status` via MCP and receive a valid response.

---

## POST-BUILD: HYDRATION NOTICE

After all 10 phases are complete, the implementing agent should tell the user:

---

**The Command Center skeleton is built and running.**

All four views render with empty states:
- **Swim Lane** — Week grid with NOW marker, empty domain lanes
- **Task Board** — 5-column Kanban with milestone carousel, no cards
- **Agent Hub** — Connected Agents panel, Activity Feed, Context Injection (showing project metadata)
- **Calendar** — Week grid with day headers, no completed tasks

The MCP server is installed and operational. All 24 tools respond correctly.

**To populate the command center with your project data, provide:**

1. **Your project manifesto** — Product vision, domains/areas of work, key workflows, principles. This determines the swim lane lanes and domain colors.

2. **Your project roadmap** — Timeline with phases, milestones, deliverables, dependencies, and target dates. This populates the milestones, subtasks, and schedule.

I will read these documents and:
- Extract your domains → create swim lane lanes with assigned colors
- Extract your phases → create schedule phases with week ranges
- Extract your milestones → call `create_milestone()` for each with planned dates
- Extract your deliverables → call `add_milestone_task()` for each as subtasks
- Map dependencies → set milestone `dependencies` arrays
- Register your agent roster → call `register_agent()` for each AI agent you use

After hydration, all four views will be populated and the task workflow will be ready for use.

---
