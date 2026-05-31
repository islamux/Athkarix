# AGENTS.md — Athkarix

## Project Overview

**Athkarix** — Flutter Islamic athkar/dua app (Android primary). Arabic & English, dark/light theme, tasbeeh counter.
License: MIT | Author: @islamux

## Commands

```bash
flutter pub get          # install deps
flutter run              # run on connected device/emulator
flutter analyze          # lint + static analysis
flutter test             # run tests
flutter build apk        # build release APK
```

**SDK**: Dart `>=2.18.2 <3.0.0` (older SDK, do not upgrade without approval)

## Architecture

### State Management: GetX
- Controllers use `GetxController` with `update()` for reactivity
- All controllers registered in `lib/binding.dart` via `Get.put()`
- **Pattern**: Widget uses `GetView<ControllerImp>`, controller instance is `Get.put()` in the view or binding
- `GetBuilder<ControllerImp>(builder: ...)` wraps only the widget that needs updates, not full pages
- Do NOT add `GetBuilder` to floating buttons — only to text inside them

### Directory Structure
```
lib/
  main.dart              # Entry: GetMaterialApp, AppRoute.goldenTheme, MyBinding
  binding.dart           # Registers all controllers
  route.dart             # GetX route definitions
  controller/            # GetX controllers (one per feature)
  view/pages/            # Full page widgets
  view/widget/           # Reusable widgets
  function/              # Utility functions
  core/data/
    json/adkar.json      # Main athkar data (all duas)
    model/               # Data models
    model/model_list/    # Typed data lists (e.g. athkar_sabah_list_model.dart)
    static/              # Theme, colors, route constants
    utils/               # Helpers
```

### Base Controller Pattern
- `BaseAthkarController` (`lib/controller/base_athkar_controller.dart`) — abstract base for all athkar pages
- Subclasses override: `pageController`, `maxPageCounters`, `dataList`, `completionMessage`
- Each controller has hardcoded `maxPageCounters` list matching the JSON data order

### Controllers (15 total)
- `athkar_sabah_controller` — morning athkar
- `athkar_massa_controller` — evening athkar
- `athkar_after_salat_controller` — post-prayer athkar
- `athkar_before_go_to_bed_controller` — bedtime athkar
- `tasbih_controller`, `estigfar_controller`, `hamd_controller`, `salat_ala_rasoul_controller`
- `duaa_men_quran_controller`, `duaa_men_sunnah_controller`
- `assma_hussna_controller` — 99 names of Allah
- `floating_action_button_controller`, `font_controller`, `home_controller`

## Command Center (AI Agent Tooling)

Located at project root: `command-center-mcp/` and `command-center-tui/`

### CLI Commands
```bash
cc get-project-status                          # current status
cc create-milestone <id> <title> --domain core --planned_start YYYY-MM-DD
cc add-milestone-task --milestone_id <id> --label "<label>"
cc register-agent <id> "<name>" <type> --permissions read,write
```

Use **named args** (`--milestone_id`, `--label`) for `add-milestone-task`, not positional.

### Known Bug: TUI crash on milestones tab
`ccui` crashes with `TypeError: Cannot read properties of null (reading 'slice')` when pressing `3` (milestones tab). Root cause: `blessed` library receives null content when rendering milestone data with null fields (`planned_end`, `actual_start`, `phase`, etc.). Fix needed in TUI source — sanitize null values before passing to `blessed` elements.

### Tracker File
`project-tracker.json` at project root — single source of truth for milestones/tasks.

### Aliases
Aliases are in `~/dotfiles/bash/.bash_aliases` with **hardcoded paths** (not `$PROJECT_ROOT`):
- `cc` → Athkarix MCP CLI
- `ccui` → Athkarix TUI dashboard

## GitHub Flow

```bash
github_flow <commit_msg> [pr_body]
```

Stages, commits, pushes current branch, creates & merges a PR (squash), then syncs main locally. Does **not** delete the branch.

Steps:
1. `git add . && git commit -m "<msg>"` — stage all & commit
2. `git push -u origin $(git branch --show-current)` — push current branch
3. `gh pr create --title "<msg>" --body "<body>"` — open PR
4. `gh pr merge --squash` — accept & merge
5. `git checkout main && git pull origin main` — sync main

## Planning Workflow

Before implementing any feature or bugfix (when starting a plan):

1. **Create branch**: Create a branch based on the naming style (`feature/<name>` or `fix/<name>`)
2. **Create milestone**: Use `cc create-milestone` to track the work in the project tracker
3. **Deep analysis dive**: Analyze the codebase thoroughly to catch bugs, logic issues, edge cases, and potential regressions before writing any code

## Testing
- `test/` directory exists
- Run: `flutter test`

## Distribution
- See `docs/APK_DISTRIBUTION_GUIDE.md` for APK release process
- Release artifacts go in `releases/`

## Documentation

Key docs referenced during development:

| File | Purpose |
|------|---------|
| `docs/ai-rules.md` | Universal AI protocols — 5-phase workflow (Think → Analyze → Execute → Verify → Sync) |
| `docs/workflow.md` | Task lifecycle state machine and agent role definitions |
| `docs/BACKLOG.md` | Feature backlog and optimization roadmap |
| `docs/SEARCH_FUNCTIONALITY.md` | Search feature implementation details |
| `docs/APK_DISTRIBUTION_GUIDE.md` | APK build and release process |
| `docs/SETUP_COMMAND_CENTER.md` | Command center TUI/MCP setup guide |
| `docs/superpowers/plans/` | Superpowers implementation plans |
| `docs/superpowers/specs/` | Superpowers design specifications |

## Notes
- Splash screen (`flutter_native_splash`) is configured but commented out in `main.dart`
- Data loaded from `lib/core/data/json/adkar.json` and TypeScript model lists
- Uses `shared_preferences` for local persistence
- Fonts: Amiri (Arabic), Cairo (UI)
