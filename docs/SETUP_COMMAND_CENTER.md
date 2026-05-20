# Setup Command Center in a New Project

## Prerequisites

- Node.js 18+, pnpm, Git
- A project directory to set up

---

## Step 1: Copy Command Center Directories

```bash
# From the salam project (source)
SOURCE=/media/islamux/Variety/Flutter_Projects/salam
TARGET=/path/to/new-project

cp -r $SOURCE/command-center-mcp $TARGET/
cp -r $SOURCE/command-center-tui $TARGET/
cp $SOURCE/docs/workflow.md $TARGET/docs/

# Remove old builds (will rebuild in step 3)
rm -rf $TARGET/command-center-mcp/node_modules $TARGET/command-center-mcp/dist $TARGET/command-center-mcp/pnpm-lock.yaml
rm -rf $TARGET/command-center-tui/node_modules $TARGET/command-center-tui/dist $TARGET/command-center-tui/pnpm-lock.yaml
```

## Step 2: Create project-tracker.json

Create `$TARGET/project-tracker.json`:

```json
{
  "schemaVersion": 1,
  "project": {
    "name": "Your Project Name",
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

## Step 3: Build MCP Server + TUI

```bash
cd $TARGET/command-center-mcp && pnpm install && pnpm build
cd $TARGET/command-center-tui && pnpm install && pnpm build
```

## Step 4: Create .mcp.json

Create `$TARGET/.mcp.json`:

```json
{
  "command-center": {
    "command": "node",
    "args": ["/absolute/path/to/new-project/command-center-mcp/dist/index.js"],
    "env": {
      "PROJECT_ROOT": "/absolute/path/to/new-project"
    }
  }
}
```

## Step 5: Add CLI Alias

Add to `.bashrc` or run per session:

```bash
export PROJECT_ROOT=/path/to/new-project
alias cc="node $PROJECT_ROOT/command-center-mcp/dist/cli.js"
```

## Step 6: Verify

```bash
cc get-project-status
```

## Step 7: Register Agents

```bash
cc register-agent opencode "OpenCode" orchestrator --permissions read,write
cc register-agent gemini-cli "Gemini CLI" orchestrator --permissions read,write
```

## Step 8: Start Using

```bash
cc create-milestone m1 "First Milestone" --domain core --planned_start 2026-01-06
cc add-milestone-task m1 "Set up project structure"
cc start-task m1_001
```

## TUI Dashboard

```bash
cd $TARGET/command-center-tui && PROJECT_ROOT=$TARGET pnpm dev
```

Keys: `1-4` tabs | `q` quit | `r` refresh | `t` theme | `[` `]` milestones
