# Task Workflow

## State Machine

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
           │        └────┬─────┘
           │             │ approve_task()
           │        ┌────▼─────┐
           │        │   DONE   │
           │        └──────────┘
           │ reject_task()
           └──► back to IN PROGRESS
```

## State Transitions

| Current | Trigger | MCP Tool | Next |
|---------|---------|----------|------|
| todo | Operator says "prepare task X" | `get_task_context` | todo (enriched) |
| todo | Operator says "start task X" | `start_task` | in_progress |
| in_progress | Build/typecheck/lint pass | `complete_task` | review |
| review | Operator gives code feedback | `reject_task` | in_progress |
| review | Operator approves | `approve_task` | done |
| any | Blocker encountered | `block_task` | blocked |
| blocked | Blocker resolved | `unblock_task` | todo or in_progress |

## Prepare Phase

When the operator says "prepare task X":

1. `get_task_context(task_id)` — read the task
2. Dispatch Explorer agent — investigate codebase, return relevant files/patterns
3. Dispatch Researcher agent — lookup external docs, best practices
4. Ask operator clarifying questions if needed
5. Write prompt file at `docs/prompts/{task_id}.md`
6. `enrich_task(task_id)` — update acceptance criteria, constraints, context files
7. Task stays in `todo` — do NOT call `start_task`

## Start Phase

When the operator says "start task X":

1. `start_task(task_id)` — moves to `in_progress`
2. `get_task_context(task_id)` — read enriched task
3. Implement the work
4. Run build/typecheck/lint until clean
5. Dispatch Post-Build Auditor — code review + security scan
6. `complete_task(task_id, summary)` — moves to `review`

## Review Phase

- **Code changes required**: `reject_task(task_id, feedback)` → back to in_progress → fix → resubmit
- **Conversational feedback** (questions only): answer, keep in review

## Approve Phase

Only when operator explicitly says "approve/complete/done":

1. `approve_task(task_id)` — moves to `done`
2. Auto-unblock cascade runs

## General Rules

- Always call `start_task` before writing code
- Always call `complete_task` after finishing
- Use `log_action` for significant events
- Use `block_task` if you hit an unresolvable blocker
- Address ALL prior revision feedback before resubmitting

## Agent Roles

### Explorer Agent

**When**: First agent in prepare phase
**Input**: Task ID
**What to do**:
- Read context files listed in the task
- Search for relevant files (glob, grep)
- Understand architecture, data models, conventions
- Identify what exists vs what needs creating
- **MUST call**: `log_action(task_id, "exploration_complete", summary, agent_id: "explorer")`

### Researcher Agent

**When**: Second agent in prepare phase, receives Explorer findings
**Input**: Task ID + compressed Explorer brief (max 500 tokens)
**What to do**:
- Review Explorer findings
- Lookup external docs for APIs, libraries, frameworks
- Research best practices and gotchas
- **MUST call**: `log_action(task_id, "research_complete", summary, agent_id: "researcher")`

### Post-Build Auditor

**When**: After implementation, before `complete_task`
**Input**: Task ID + list of modified files
**What to do**:
- Run build, typecheck, lint — fix if possible
- Code review: check acceptance criteria, patterns, edge cases
- Security scan: injection, secrets, input sanitization
- **MUST call**: `log_action(task_id, "audit_complete", summary, agent_id: "post-build-auditor")`
