# Command Center Blueprint - Athkarix Flutter Edition (ARCHIVED)

> [!NOTE]
> This is a historical blueprint/specification from the design phase of the Command Center. The actual implementation has since diverged. For the current active system, refer to [PROJECT_MAP.md](file:///media/islamux/Variety/Flutter_Projects/Athkarix/PROJECT_MAP.md) and [AGENTS.md](file:///media/islamux/Variety/Flutter_Projects/Athkarix/AGENTS.md) at the root level.

---

> A complete build specification for an AI-agent-powered project command center tailored for the Athkarix Flutter application.
> Athkarix is an Islamic athkar (remembrances) tracking and distribution app for Android.

---

## About This Document

### What This Builds

Two deliverables:

1. **MCP Server** — A globally-installed Node.js package exposing 24 tools over stdio. AI agents call these tools to read project state, manage tasks, dispatch sub-agents, and log activity. Also includes a CLI for shell access.

2. **Athkarix Command Center TUI** — A terminal user interface built with Python's Textual framework. Runs in any terminal and provides 4 views: Swim Lane (strategic timeline), Task Board (tactical Kanban), Agent Hub (real-time monitoring), and Calendar (completion history). Watches `athkarix-tracker.json` for changes and renders in real-time.

Both share `athkarix-tracker.json` as the single source of truth.

### Architecture

```
┌────────────────────────────────────────────────┐
│           Athkarix Command Center TUI           │
│         (Swim Lane, Task Board,            │
│          Agent Hub, Calendar)             │
└───────────────────┬────────────────────────┘
                    │ Watchdog fs.watch
┌───────────────────▼────────────────────────┐
│            athkarix-tracker.json          │
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

### Athkarix Project Context

```
Athkarix/
├── lib/
│   ├── main.dart
│   ├── models/          # Data models (Athkar, Category, UserProgress)
│   ├── screens/         # UI screens
│   ├── services/        # Business logic, notifications
│   └── utils/           # Helpers, constants
├── android/
├── assets/
│   └── athkar_data/     # JSON athkar content
└── tracker/            # Project tracking (gitignored)
    └── athkarix-tracker.json
```

### Stack

| Layer | Technology |
|-------|-----------|
| TUI Framework | Python 3.11+ with Textual 0.95+ |
| Rich Text | Rich library for terminal rendering |
| File Watching | Watchdog |
| Data Validation | Pydantic |
| MCP Server | Node.js + @modelcontextprotocol/sdk |
| Language | Python (TUI) + TypeScript (MCP) + Dart (Flutter) |

---

## PHASE 1: TRACKER SCHEMA

Tracker JSON file lives at `tracker/athkarix-tracker.json` (gitignored).

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
  app_version: string
  flutter_version: string
}

interface Milestone {
  id: string
  title: string
  domain: string  // e.g., 'core', 'ui', 'notifications', 'analytics', 'distribution'
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

### Athkarix Empty Tracker

```json
{
  "project": {
    "name": "Athkarix",
    "start_date": "2026-01-01",
    "target_date": "2026-12-31",
    "current_week": 1,
    "schedule_status": "on_track",
    "overall_progress": 0,
    "app_version": "1.0.0",
    "flutter_version": "3.x"
  },
  "milestones": [],
  "agents": [],
  "agent_log": [],
  "schedule": { "phases": [] }
}
```

### Athkarix Domain Areas

| Domain | Description |
|--------|-------------|
| core | Core athkar functionality, data models |
| ui | Screens, widgets, navigation |
| notifications | Reminder system, background tasks |
| analytics | Usage tracking, statistics |
| distribution | APK builds, Play Store prep |
| localization | Arabic RTL support, translations |

> **Checkpoint:** Create `tracker/athkarix-tracker.json` at project root.

---

## PHASE 2: MCP SERVER

Same as original Phase 2. 24 tools, CLI, unchanged.

### Project Structure

```
athkarix-command-center-mcp/
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
athkarix-cc get-project-status
athkarix-cc create-milestone core "Core Athkar Features"
athkarix-cc add-milestone-task core "Implement Athkar model" --priority P1
athkarix-cc start-task core_001
```

> **Checkpoint:** CLI works. Test with `athkarix-cc get-project-status`.

---

## PHASE 3: TEXTUAL SHELL

### Project Structure

```
athkarix-command-center-tui/
├── pyproject.toml
├── requirements.txt
├── athkarix_cc/
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

class AthkarixCommandCenterApp(App):
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
# athkarix_cc/__main__.py
from .app import AthkarixCommandCenterApp
from .config import get_tracker_path

def main():
    path = get_tracker_path()
    app = AthkarixCommandCenterApp(str(path))
    app.run()

if __name__ == "__main__":
    main()
```

### Run

```bash
pip install -e athkarix-command-center-tui/
athkarix-cc
# or
python -m athkarix_cc
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
    return max(1, (now - start).days // 7 + 1)Prefix

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
Core      ████████████████████████
          ●6/11────●3/8
UI        ████████████████████████
                ●4/4
Notifications █████████████████████
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

## ATHKARIX-SPECIFIC ADDITIONS

### Flutter Integration Points

| Component | Tracker Domain | Description |
|-----------|---------------|-------------|
| Athkar Model | core | Track development of Athkar data model |
| Category Screen | ui | Track UI milestone |
| Notification System | notifications | Reminder scheduling implementation |
| APK Distribution | distribution | Play Store APK builds |
| RTL Support | localization | Arabic language and layout |

### Suggested Initial Milestones

1. **foundation** - Project setup, models, basic structure
2. **core_athkar** - Athkar display, categories, favorites
3. **ui_screens** - Main screens with Material Design
4. **notifications** - Daily reminders, background tasks
5. **distribution** - APK building, signing, Play Store
6. **localization** - Arabic RTL support

---

## POST-BUILD

Tell user:

> The Athkarix Command Center skeleton is built. Provide your project manifesto and roadmap to populate it.

Then hydrate by calling MCP tools to create milestones and tasks from user's documents.

---

## IMPLEMENTATION QUICK REFERENCE

| Task | Command |
|------|---------|
| Install MCP | `npm install -g athkarix-command-center-mcp` |
| Install TUI | `pip install -e athkarix-command-center-tui/` |
| Run TUI | `athkarix-cc` |
| Get status | `athkarix-cc get-project-status` |
| Create milestone | `athkarix-cc create-milestone <id> "<title>"` |
| Add task | `athkarix-cc add-milestone-task <milestone> "<label>"` |

---

## FLUTTER PROJECT FILES TO TRACK

These paths should be referenced in task context_files:

```
lib/main.dart
lib/models/
lib/screens/
lib/services/
lib/utils/
assets/athkar_data/
android/app/build.gradle
pubspec.yaml
```
