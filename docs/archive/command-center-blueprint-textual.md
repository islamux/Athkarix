# Command Center Blueprint - Textual TUI Edition (ARCHIVED)

> [!NOTE]
> This is a historical blueprint/specification from the design phase of the Command Center. The actual implementation has since diverged. For the current active system, refer to [PROJECT_MAP.md](file:///media/islamux/Variety/Flutter_Projects/Athkarix/PROJECT_MAP.md) and [AGENTS.md](file:///media/islamux/Variety/Flutter_Projects/Athkarix/AGENTS.md) at the root level.

---

> A complete build specification for an AI-agent-powered project command center with Textual TUI.
> Feed this document to any capable coding agent (Claude Code, Codex, Cursor, etc.)
> and it will build the entire system across multiple phases.

---

## About This Document

### What This Builds

Two deliverables:

1. **MCP Server** — A globally-installed Node.js package exposing 24 tools over stdio. AI agents call these tools to read project state, manage tasks, dispatch sub-agents, and log activity. Also includes a CLI for shell access.

2. **Textual TUI App** — A terminal user interface built with Python's Textual framework. Runs in any terminal and provides 4 views: Swim Lane (strategic timeline), Task Board (tactical Kanban), Agent Hub (real-time monitoring), and Calendar (completion history). Watches `project-tracker.json` for changes and renders in real-time.

Both share `project-tracker.json` as the single source of truth.

### Architecture

```
┌────────────────────────────────────────────────┐
│           Textual TUI Terminal App            │
│         (Swim Lane, Task Board,            │
│          Agent Hub, Calendar)             │
└───────────────────┬────────────────────────┘
                    │ Watchdog fs.watch
┌───────────────────▼────────────────────────┐
│            project-tracker.json          │
│          (Single Source of Truth)         │
└───────────────────▲────────────────────────┘
                    │ MCP read/write
┌───────────────────┴────────────────────────┐
│          MCP Server (24 tools)             │
│            + CLI interface               │
└───────────────────▲────────────────────────┘
                    │ MCP protocol
        ┌───────────┴───────────┐
        │      AI Agents        │
  ┌─────▼──────┐         ┌─────▼──────┐
  │ Claude Code│         │   Codex    │
  └────────────┘         └────────────┘
```

### Stack

| Layer | Technology |
|-------|-----------|
| TUI Framework | Python 3.11+ with Textual 0.95+ |
| Rich Text | Rich library for terminal rendering |
| File Watching | Watchdog |
| Data Validation | Pydantic |
| MCP Server | Node.js + @modelcontextprotocol/sdk |
| Language | Python (TUI) + TypeScript (MCP) |

---

## PHASE 1: TRACKER SCHEMA

Same as original. The JSON file lives at project root.

### TypeScript Interfaces

```typescript
interface TrackerState {
  project: ProjectMeta
  milestones: Milestone[]
  agents: Agent[]
  agent_log: AgentLogEntry[]
  schedule: { phases: Phase[] }
}

interface ProjectMeta {
  name: string
  start_date: string  // YYYY-MM-DD
  target_date: string
  current_week: number
  schedule_status: 'on_track' | 'behind' | 'ahead'
  overall_progress: number
}

interface Milestone {
  id: string
  title: string
  domain: string
  week: number
  phase: string
  planned_start: string | null
  planned_end: string | null
  actual_start: string | null
  actual_end: string | null
  drift_days: number
  is_key_milestone: boolean
  key_milestone_label: string | null
  subtasks: Subtask[]
  dependencies: string[]
  notes: string[]
}

interface Subtask {
  id: string
  label: string
  status: 'todo' | 'in_progress' | 'review' | 'done' | 'blocked'
  done: boolean
  assignee: string | null
  blocked_by: string | null
  blocked_reason: string | null
  completed_at: string | null
  completed_by: string | null
  priority: string  // P1-P4
  notes: string | null
  prompt: string | null
  context_files: string[]
  reference_docs: string[]
  acceptance_criteria: string[]
  constraints: string[]
  agent_target: string | null
  execution_mode: 'human' | 'agent' | 'pair'
  depends_on: string[]
  last_run_id: string | null
  builder_prompt: string | null
}

interface Agent {
  id: string
  name: string
  type: 'orchestrator' | 'sub-agent' | 'human' | 'external'
  parent_id?: string
  color: string
  status: 'active' | 'idle'
  permissions: string[]
  last_action_at: string | null
  session_action_count: number
}

interface AgentLogEntry {
  id: string
  agent_id: string
  action: string
  target_type: 'subtask' | 'milestone' | 'agent'
  target_id: string
  description: string
  timestamp: string
  tags: string[]
}

interface Phase {
  id: string
  title: string
  start_week: number
  end_week: number
}
```

### Empty Tracker

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
  "schedule": { "phases": [] }
}
```

> **Checkpoint:** Create `project-tracker.json` at project root.

---

## PHASE 2: MCP SERVER

Same as original Phase 2. 24 tools, CLI, unchanged.

### Project Structure

```
command-center-mcp/
├── package.json
├── tsconfig.json
└── src/
    ├── index.ts      # MCP server entry
    ├── tools.ts      # 24 tool definitions
    ├── tracker.ts   # Types + utilities
    ├── context.ts   # Markdown builders
    └── cli.ts      # CLI interface
```

### Key Tools Summary

**Read Tools (8):** `get_task_context`, `get_task_summary`, `get_project_status`, `get_milestone_overview`, `list_tasks`, `get_task_history`, `list_agents`, `get_activity_feed`

**Write Tools (16):** Task lifecycle (`start_task`, `complete_task`, `approve_task`, `reject_task`, `reset_task`, `block_task`, `unblock_task`, `update_task`, `log_action`), enrichment (`enrich_task`), milestone management (`add_milestone_note`, `set_milestone_dates`, `update_drift`, `create_milestone`, `add_milestone_task`), agent management (`register_agent`)

### CLI Examples

```bash
command-center get-project-status
command-center create-milestone foundation "Foundation Phase"
command-center add-milestone-task foundation "Setup project structure" --priority P1
command-center start-task foundation_001
```

> **Checkpoint:** CLI works. Test with `command-center get-project-status`.

---

## PHASE 3: TEXTUAL SHELL

### Project Structure

```
command-center-tui/
├── pyproject.toml
├── requirements.txt
├── command_center/
│   ├── __init__.py
│   ├── __main__.py      # Entry point
│   ├── app.py           # Main Textual app
│   ├── store.py         # State management
│   ├── config.py        # Path resolution
│   ├── widgets/
│   │   ├── __init__.py
│   │   ├── header.py
│   │   ├── tab_bar.py
│   │   ├── status_bar.py
│   │   └── progress.py
│   ├── screens/
│   │   ├── __init__.py
│   │   ├── base.py
│   │   ├── swim_lane.py
│   │   ├── task_board.py
│   │   ├── agent_hub.py
│   │   └── calendar.py
│   └── utils/
│       ├── __init__.py
│       ├── colors.py
│       ├── selectors.py
│       └── render.py
```

### Dependencies

```
textual>=0.95.0
rich>=13.7.0
watchdog>=4.0.0
pydantic>=2.0.0
```

### Main App

```python
from textual.app import App, ComposeResult
from textual.containers import Container
from watchdog.observers import Observer

class CommandCenterApp(App):
    CSS = """
    Screen { background: $surface; }
    """
    
    def __init__(self, tracker_path: str):
        super().__init__()
        self.tracker_path = tracker_path
        self.store = Store()
    
    def on_mount(self):
        self.observer = Observer()
        self.observer.schedule(TrackerHandler(self), 
                               path=self.tracker_path)
        self.observer.start()
        self.load_tracker()
    
    def on_unmount(self):
        self.observer.stop()
    
    def compose(self) -> ComposeResult:
        yield Header()
        yield Container(TabBar(), StatusBar())
        yield Footer()
```

### Entry Point

```python
# command_center/__main__.py
from .app import CommandCenterApp
from .config import get_tracker_path

def main():
    path = get_tracker_path()
    app = CommandCenterApp(str(path))
    app.run()

if __name__ == "__main__":
    main()
```

### Run

```bash
pip install -e command-center-tui/
command-center-tui
# or
python -m command_center
```

> **Checkpoint:** App launches, shows tabs, file watcher active.

---

## PHASE 4: STORE & SCREEN SYSTEM

### Pydantic Store

```python
from pydantic import BaseModel
from typing import Optional, Callable, List
import threading

class Store:
    def __init__(self):
        self._tracker: Optional[TrackerState] = None
        self._loading = False
        self._error: Optional[str] = None
        self._subscribers: List[Callable] = []
    
    def set_tracker(self, data):
        self._tracker = TrackerState(**data)
        self._notify()
    
    def subscribe(self, callback):
        self._subscribers.append(callback)
    
    def _notify(self):
        for cb in self._subscribers:
            cb()
```

### Selectors

```python
def select_current_week(tracker):
    start = datetime.fromisoformat(tracker.project.start_date)
    now = datetime.now()
    return max(1, (now - start).days // 7 + 1)

def select_schedule_status(tracker):
    if not tracker.milestones:
        return 'on_track'
    drifts = [m.drift_days for m in tracker.milestones]
    if max(drifts) > 3: return 'behind'
    if min(drifts) < -3: return 'ahead'
    return 'on_track'
```

### Tab System

- 4 screens via Textual's `Screen` class
- Keyboard navigation (←→ switch tabs)
- StatusBar shows week, progress, schedule status

> **Checkpoint:** Tab switching works, store updates.

---

## PHASE 5-8: SCREENS

### Swim Lane View

Text-based timeline with Unicode graphics:

```
W1    W2    W3    W4    W5
01-01 01-08 01-15 01-22 01-29
──────────────────────────────────
Domain A ████████████████████████
        ●6/11────●3/8
Domain B ████████████████████████
              ●4/4
        │ NOW
```

### Task Board

5 columns: TODO, IN PROGRESS, REVIEW, DONE, BLOCKED
Keyboard: ←→ navigate milestones, Tab switch columns

### Agent Hub

- Connected agents panel
- Activity feed with filtering
- Context injection for AI agents

### Calendar

Week grid showing completed tasks by day.

---

## PHASE 9: DESIGN SYSTEM

### Terminal Colors

| Purpose | Terminal Color |
|---------|---------------|
| Accent | blue |
| Success/Done | green |
| Warning/Behind | red |
| Review | yellow |
| Muted | white |

### CSS

```python
CSS = """
Screen { background: $surface; }
TabBar { width: 50%; }
StatusBar { width: 50%; }
ListView { height: 100%; }
"""
```

---

## PHASE 10: WORKFLOW STATE MACHINE

Same as original. Task lifecycle:
- TODO → IN_PROGRESS (start_task)
- IN_PROGRESS → REVIEW (complete_task)
- REVIEW → DONE (approve_task) or IN_PROGRESS (reject_task)
- Any → BLOCKED (block_task)

Agent roles: Explorer, Researcher, Post-Build Auditor.

---

## POST-BUILD

Tell user:

> The Command Center skeleton is built. Provide your project manifesto and roadmap to populate it.

Then hydrate by calling MCP tools to create milestones and tasks from user's documents.

---

## IMPLEMENTATION QUICK REFERENCE

| Task | Command |
|------|----------|
| Install MCP | `npm install -g command-center-mcp` |
| Install TUI | `pip install -e command-center-tui/` |
| Run TUI | `command-center-tui` |
| Get status | `command-center get-project-status` |
| Create milestone | `command-center create-milestone <id> "<title>"` |
| Add task | `command-center add-milestone-task <milestone> "<label>"` |
