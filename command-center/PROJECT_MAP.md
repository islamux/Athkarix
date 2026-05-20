# PROJECT_MAP — Command Center

> Auto-generated system map. Used by AI agents during Phase 2 (Analyze Impact).

## [TECH_STACK]

| Layer | Technology |
|:------|:-----------|
| Runtime | Node.js 20+ |
| Language | TypeScript 5.7 (strict, ES modules) |
| Package Manager | pnpm 9+ (workspace monorepo) |
| MCP Server | @modelcontextprotocol/sdk |
| TUI | blessed |
| File Watcher | chokidar + fs.watch |
| Validation | zod v4 |
| CLI | Node.js (stdio) |

## [ARCHITECTURE]

```
packages/shared/     → Types + Zod schemas (shared across all packages)
    src/types.ts     → ProjectMeta, Subtask, Milestone, Agent, TrackerState, etc.
    src/schema.ts    → Zod validation schemas for all types

docs/
    improvement-plan.md → Current prioritized improvement plan, acceptance criteria, and tracker task candidates

packages/mcp/        → MCP server + CLI
    src/index.ts     → MCP server entry (stdio transport)
    src/tools.ts     → 26 tool definitions + handlers
    src/context.ts   → Markdown context builders (task context, project status, etc.)
    src/cli.ts       → CLI interface mapping shell args to tool handlers
    src/tracker.ts   → Re-exports from services/
    src/schema.ts    → Zod schema for TrackerState
    src/types.ts     → TypeScript interfaces (mirrors shared/)
    src/services/
        tracker.service.ts     → Read/write tracker, findTask, computeProgress
        task.service.ts        → Task lifecycle: start, complete, approve, reject, etc.
        milestone.service.ts   → Milestone management: activate, complete, create
        agent.service.ts       → Agent registration
        agent-dispatch.service.ts  → Agent dispatch, permission checks, heartbeats
        task-index.service.ts  → Fast task lookup index
        migration.service.ts   → Schema migration runner
    src/storage/
        tracker-file.ts    → Atomic file I/O with locking
        backup.ts          → Automatic backup on write
        log-rotation.ts    → Agent log rotation (>500 entries)

packages/tui/        → Terminal UI dashboard
    src/index.ts     → Entry point (blessed screen, key bindings, file watcher)
    src/store.ts     → TrackerState loader (reads file, validates with schema)
    src/config.ts    → Project root discovery
    src/theme.ts     → Dark/light theme tokens, status colors
    src/types.ts     → Re-exports types from shared
    src/components/
        tab-bar.ts       → Top tab navigation (1-4)
        status-bar.ts    → Bottom status bar (week, progress, health)
    src/views/
        swim-lane.ts     → Milestone timeline with progress bars
        task-board.ts    → Kanban board (todo/in_progress/review/done/blocked)
        agent-hub.ts     → Registered agents + recent activity
        calendar.ts      → Project timeline + completed milestones by date
```

## [SYSTEM_FLOW]

1. User runs `pnpm ccui` → TUI dashboard launches
2. TUI reads `project-tracker.json` via `Store.loadFromDisk()`
3. Tracker is validated against `TrackerStateSchema` (zod)
4. Views render project state: milestones, tasks, agents, activity
5. File watcher (`fs.watchFile`) detects external changes → auto-refresh
6. Alternatively, MCP server (`pnpm cc:mcp`) exposes tools via stdio
7. AI agents call MCP tools → read/write tracker → TUI updates automatically

## [ORPHANS & PENDING]

- No automated tests yet
- No linting/formatting configured (eslint, prettier)
- TUI is read-only (can't modify tasks from keyboard yet)
- MCP server error handling could be more granular
- No CI/CD pipeline
- docs/command-center-blueprint.md is the original design spec (differs from actual implementation)
- docs/improvement-plan.md documents the prioritized path for addressing these gaps
