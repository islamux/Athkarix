# Command Center

A standalone, AI-powered project management toolkit. Track milestones, manage tasks, and orchestrate AI agents — all from your terminal.

## What's Inside

| Package | Description |
|---------|-------------|
| `packages/shared` | TypeScript types + Zod schemas for the tracker |
| `packages/mcp` | MCP server + CLI — read/write tracker, manage tasks |
| `packages/tui` | Terminal UI dashboard (Swim Lane, Task Board, Agent Hub, Calendar) |

## Quick Start

```bash
# Install
pnpm install

# Build
pnpm build

# Initialize your project
cp project-tracker.example.json project-tracker.json   # Copy the template
nano project-tracker.json                              # Edit with your project name + milestones

# Launch TUI dashboard
pnpm ccui

# Check project status
pnpm cc:status
```

## CLI Commands

See [docs/cc-commands.md](docs/cc-commands.md) for the full reference.

## AI Integration

This package includes a universal AI ruleset in [docs/ai-rules.md](docs/ai-rules.md) — a 5-phase protocol (Think & Plan → Analyze → Execute → Verify → Sync) that any AI model can follow.

To use with AI agents:
1. Add `AGENTS.md` and `docs/ai-rules.md` to your project root.
2. Wire the MCP server into your AI tool (Claude Desktop, OpenCode, etc.).

## Project Structure

```
├── AGENTS.md                    ← Agent runbook
├── project-tracker.example.json ← Template data store
├── project-tracker.json         ← Your project data (gitignored)
├── package.json                 ← Workspace root + CLI scripts
├── pnpm-workspace.yaml
├── docs/
│   ├── ai-rules.md          ← Universal AI protocols
│   └── cc-commands.md       ← CLI reference
├── scripts/
│   └── cc-dash.py           ← Python dashboard
└── packages/
    ├── shared/              ← Types + schemas
    ├── mcp/                 ← MCP server + CLI
    └── tui/                 ← Terminal UI
```

## Requirements

- Node.js 20+
- pnpm 9+
- Python 3.8+ (optional — for `cc-dash.py`)
