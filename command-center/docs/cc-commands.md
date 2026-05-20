# Command Center CLI Reference

All commands must be run from the **project root directory**.

> **Prerequisite:** Run `pnpm install && pnpm build` first.

---

## Quick Reference

| Command | Description |
|:--------|:------------|
| `pnpm ccui` | Launch TUI dashboard |
| `pnpm cc:mcp` | Start MCP server (AI access to tracker) |
| `pnpm cc:status` | Project status overview |
| `pnpm cc:list` | List and filter tasks |
| `pnpm cc:agents` | List registered agents |
| `pnpm cc:activity` | Recent activity feed |
| `pnpm cc:task <id>` | Full context for a task |
| `pnpm cc:mstone <id>` | Milestone overview with progress |
| `pnpm cc:start <id> [--agent_id]` | Start a task |
| `pnpm cc:complete <id> <summary>` | Mark task ready for review |
| `pnpm cc:approve <id> [feedback]` | Approve and mark done |
| `pnpm cc:reject <id> <feedback>` | Reject, send back to in_progress |
| `pnpm cc:reset <id>` | Reset task to todo |
| `pnpm cc:block <id> <reason>` | Block a task |
| `pnpm cc:unblock <id> [--resolution]` | Unblock a task |
| `pnpm cc:activate <milestone_id>` | Move milestone from backlog to active |
| `pnpm cc:complete-milestone <milestone_id>` | Move active milestone to completed |
| `pnpm cc:register-agent <id> <name> <type>` | Register or update an agent |

---

## Core Commands

### `pnpm ccui`
Launch the interactive terminal UI dashboard. 4 views: Swim Lane, Task Board, Agent Hub, Calendar.
```
pnpm ccui
```
Keyboard shortcuts within the TUI:
| Key | Action |
|-----|--------|
| `1`-`4` | Switch tabs |
| `[` `]` | Cycle milestones |
| `r` | Reload from disk |
| `t` | Toggle dark/light theme |
| `q` | Quit |

### `pnpm cc:mcp`
Start the MCP server, exposing project-tracker data for programmatic AI access.
```
pnpm cc:mcp
```

---

## Information Commands

### `pnpm cc:status`
Get a high-level project status overview — current week, overall progress, schedule drift.
```
pnpm cc:status
```

### `pnpm cc:list`
List tasks with optional filters.
```
pnpm cc:list
pnpm cc:list --milestone_id feat_search
pnpm cc:list --status todo
pnpm cc:list --domain features
```

### `pnpm cc:agents`
List all registered AI agents and their roles.
```
pnpm cc:agents
```

### `pnpm cc:activity`
View recent activity feed. Optionally filter by agent or limit results.
```
pnpm cc:activity
pnpm cc:activity --agent_id nextjs-specialist
pnpm cc:activity --limit 5
```

### `pnpm cc:task <id>`
Get full context for a specific task — status, milestone, acceptance criteria, dependencies, revision history.
```
pnpm cc:task feat_search_001
```

### `pnpm cc:mstone <id>`
Get milestone overview with progress bars for each subtask.
```
pnpm cc:mstone feat_search
```

---

## Task Lifecycle Commands

### `pnpm cc:start <task_id> [--agent_id]`
Start a task — sets status to `in_progress` and optionally assigns an agent.
```
pnpm cc:start feat_search_001
pnpm cc:start feat_search_001 --agent_id explorer
```

### `pnpm cc:complete <task_id> <summary>`
Mark a task as ready for review. Provide a brief summary of what was done.
```
pnpm cc:complete feat_search_001 "Implemented full-text search"
```

### `pnpm cc:approve <task_id> [feedback]`
Approve a completed task — marks it as `done`. Optional feedback.
```
pnpm cc:approve feat_search_001
pnpm cc:approve feat_search_001 "Works well, good coverage"
```

### `pnpm cc:reject <task_id> <feedback>`
Reject a completed task — sends it back to `in_progress`. Feedback is required.
```
pnpm cc:reject feat_search_001 "Search results not showing on mobile"
```

### `pnpm cc:reset <task_id>`
Reset a task back to `todo` status, clearing all progress fields.
```
pnpm cc:reset feat_search_001
```

### `pnpm cc:block <task_id> <reason>`
Block a task with an explanation.
```
pnpm cc:block feat_search_001 "Waiting for API changes"
```

### `pnpm cc:unblock <task_id> [--resolution]`
Unblock a previously blocked task.
```
pnpm cc:unblock feat_search_001
pnpm cc:unblock feat_search_001 --resolution "API updated"
```

---

## Milestone Lifecycle Commands

### `pnpm cc:activate <milestone_id>`
Move a milestone from backlog to active, updating the dashboard focus.
```
pnpm cc:activate docs_refresh
```

### `pnpm cc:complete-milestone <milestone_id>`
Move an active milestone to completed. All subtasks should be done before running.
```
pnpm cc:complete-milestone docs_refresh
```

---

## Agent Management

### `pnpm cc:register-agent <id> <name> <type> [--color] [--parent_id] [--permissions]`
Register a new agent or update an existing one.
```
pnpm cc:register-agent orchestrator Orchestrator orchestrator --color "#FF6B6B"
pnpm cc:register-agent explorer Explorer sub-agent --parent_id orchestrator --permissions READ
```

---

## MCP Tools (Additional)

The MCP server exposes these additional tools beyond the CLI shortcuts above:

| Tool | Description |
|------|-------------|
| `enrich_task` | Add prompts, acceptance criteria, context files, constraints to a task |
| `log_action` | Log a custom action entry on a task |
| `update_task` | Change priority, assignee, execution_mode, or notes |
| `create_milestone` | Create a new milestone |
| `add_milestone_task` | Add a subtask to a milestone |
| `add_milestone_note` | Append a note to a milestone |
| `set_milestone_dates` | Set actual start/end dates |
| `update_drift` | Manually set drift days |
| `get_task_history` | Full chronological history of a task |

Access these via the MCP protocol or directly:
```
PROJECT_ROOT=$(pwd) node packages/mcp/dist/cli.js <command> <args>
```
