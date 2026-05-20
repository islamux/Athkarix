# Command Center Improvement Plan

Generated on 2026-05-14 after reviewing the current docs, package scripts, source layout, and project map.

## Purpose

This plan turns the current repository analysis into a practical improvement path for Command Center. It focuses on making the existing MCP CLI and terminal dashboard more dependable before adding larger workflow features.

## Current State

Command Center is a pnpm workspace with three packages:

- `packages/shared`: shared TypeScript types and Zod schemas.
- `packages/mcp`: MCP server, CLI command handlers, tracker file storage, lifecycle services, backups, and log rotation.
- `packages/tui`: blessed-based terminal dashboard with Swim Lane, Task Board, Agent Hub, and Calendar views.

The project already has a clear operating model: `project-tracker.json` is the single source of truth, MCP tools mutate it, and the TUI reads it from disk. The architecture is small enough to keep improving surgically.

Command Center also has a dual-use requirement:

- It should be able to manage its own roadmap from this repository root.
- It should also be usable from other project roots, where each project owns its own `project-tracker.json`.

That makes project-root discovery and initialization especially important. The CLI currently sets `PROJECT_ROOT` to `pwd` through the root `_cc` script, while the TUI discovers the tracker by checking `PROJECT_ROOT` and then walking up from `cwd`.

## Key Gaps

1. **Verification is thin**
   - `PROJECT_MAP.md` already notes there are no automated tests.
   - Lifecycle logic changes tracker state, timestamps, drift, logs, and milestone status, but there are no regression tests around these paths.

2. **Tooling setup is incomplete**
   - There is no lint or formatting script.
   - `pnpm build` is the only repository-level quality gate.
   - In this environment, `pnpm` is not available on `PATH`, which blocks local build verification until the package manager is installed or made available through Corepack.

3. **Schema expectations are not fully aligned in docs**
   - The blueprint describes an older flat milestone array and references Electron/React concepts.
   - The actual implementation uses categorized milestones: `active`, `backlog`, and `completed`.
   - This mismatch can mislead future agents during implementation.

4. **Runtime error reporting can hide useful detail**
   - TUI store loading catches all parse/read/schema errors and returns `false` without exposing the reason.
   - MCP handlers often return a generic `Error: ...` at the tool boundary.

5. **TUI is read-only**
   - The dashboard displays state well but does not yet support common task operations from the keyboard.
   - Operators must switch to CLI commands for lifecycle changes.

6. **Tracker initialization path needs polish**
   - The README asks users to copy `project-tracker.example.json`, but the app does not appear to provide a first-run helper when the tracker is missing.
   - Missing tracker state is especially sharp for the TUI because load failures are silent.
   - Self-management and external-project management need clear setup paths so the product repository tracker is not confused with a target project's tracker.

7. **CI/CD is absent**
   - There is no automated pipeline to run install, build, tests, or package checks.

## Improvement Roadmap

### Phase 1: Stabilize Verification

Goal: make core tracker behavior safe to change.

Recommended tasks:

- Add a test runner suitable for TypeScript ESM, such as Vitest.
- Add unit tests for `computeOverallProgress`, `computeScheduleStatus`, `findTask`, and `generateTaskId`.
- Add lifecycle tests for task transitions: start, complete, approve, reject, reset, block, and unblock.
- Add lifecycle tests for milestone transitions: create, activate, and complete.
- Use temporary tracker files in tests so storage behavior can be tested without mutating a real project tracker.

Acceptance criteria:

- `pnpm test` runs at the workspace root.
- Tests cover both success and failure paths for lifecycle services.
- A failed schema parse or missing task/milestone has a regression test.

Dependencies:

- Make `pnpm` available locally, likely through Corepack or project setup docs.

### Phase 2: Add Quality Gates

Goal: create a repeatable local and CI quality check.

Recommended tasks:

- Add `lint`, `format`, and `check` scripts at the workspace root.
- Add TypeScript-aware linting for `packages/*/src`.
- Add formatting rules for TypeScript, Markdown, and JSON.
- Make `pnpm check` run build, tests, and lint.

Acceptance criteria:

- `pnpm check` is the single command humans and agents use before handoff.
- CI can call the same command without special local assumptions.
- Formatting does not churn generated or user-owned tracker files.

### Phase 3: Reconcile Documentation With Reality

Goal: make docs trustworthy for future agents.

Recommended tasks:

- Update `docs/command-center-blueprint.md` or clearly mark it as historical.
- Add a current data model section that matches `TrackerStateSchema`.
- Document categorized milestones and completed milestone shape.
- Document the difference between MCP, CLI, and TUI responsibilities.
- Add a troubleshooting section for missing `project-tracker.json`, schema errors, and unavailable `pnpm`.

Acceptance criteria:

- A new contributor can understand the actual implementation without comparing source files to the blueprint.
- Docs no longer imply that Electron, React, Zustand, Tailwind, or drag-and-drop are current runtime dependencies.

### Phase 4: Improve Error Visibility

Goal: make failures actionable without exposing noisy internals.

Recommended tasks:

- Return structured load errors from the TUI store.
- Render a clear TUI empty/error state when the tracker is missing or invalid.
- Preserve specific schema validation messages where useful.
- Normalize MCP service errors so CLI users see consistent, concise messages.

Acceptance criteria:

- Running the TUI without `project-tracker.json` explains how to create one.
- Invalid tracker JSON points to the failing field when Zod provides that path.
- MCP errors remain readable in both CLI and MCP tool responses.

### Phase 5: Add Interactive TUI Operations

Goal: let operators handle common task flows inside the dashboard.

Recommended tasks:

- Add keyboard-driven actions for selected tasks: start, complete, approve, reject, block, unblock, and reset.
- Reuse existing MCP service logic instead of duplicating lifecycle behavior in the TUI.
- Add confirmation prompts for destructive or state-reversing actions.

Acceptance criteria:

- A user can move a task from todo to done without leaving the TUI.
- TUI operations write through the same tracker services as CLI commands.
- File watching still refreshes external changes.

### Phase 6: First-Run and Project Setup

Goal: make the first user experience smoother.

Recommended tasks:

- Add an `init` CLI command that creates `project-tracker.json` from the example.
- Detect existing trackers and avoid overwriting them.
- Support both self-management from the Command Center repository and external project setup through explicit `PROJECT_ROOT` behavior.
- Optionally prompt for project name, start date, target date, and first milestone.
- Add docs for `PROJECT_ROOT` discovery and common workspace layouts.

Acceptance criteria:

- `pnpm cc:init` creates a valid tracker in the current project root.
- Re-running init is safe and explicit about existing files.
- The TUI can point users to `pnpm cc:init` when no tracker exists.
- Docs include examples for managing this repository and managing another project.

### Phase 7: CI/CD

Goal: protect the repository from regressions.

Recommended tasks:

- Add GitHub Actions or the target repository host equivalent.
- Run dependency install, build, test, lint, and type checks.
- Cache pnpm dependencies.
- Consider a release check for package entry points and CLI executability.

Acceptance criteria:

- Pull requests show automated pass/fail status.
- CI runs the same `pnpm check` command used locally.

## Suggested Priority Order

1. Stabilize verification.
2. Add quality gates.
3. Reconcile docs.
4. Improve error visibility.
5. Add TUI task operations.
6. Add first-run setup.
7. Add CI/CD.

This order keeps risk low: tests and checks come before broader behavior changes, then documentation catches up, then user-facing workflow improvements build on a safer base.

## Tracker Task Candidates

When `project-tracker.json` is available, convert this plan into tasks like:

- `quality_001`: Add TypeScript test runner and root `pnpm test`.
- `quality_002`: Cover tracker progress, schedule, and lookup helpers.
- `quality_003`: Cover task and milestone lifecycle services.
- `quality_004`: Add lint, format, and `pnpm check`.
- `docs_001`: Update blueprint status and current data model docs.
- `runtime_001`: Add visible TUI tracker load errors.
- `runtime_002`: Normalize MCP and CLI error messages.
- `tui_001`: Add task selection and lifecycle actions in the TUI.
- `setup_001`: Add `cc:init` tracker creation command.
- `ci_001`: Add CI workflow using `pnpm check`.

## Verification Notes

- Date checked with `date`: 2026-05-14 06:55:59 +03.
- Build first failed because `pnpm` was not on `PATH`.
- Build passed after running with `/home/islamux/.local/share/pnpm` prepended to `PATH`: `env PATH=/home/islamux/.local/share/pnpm:$PATH /home/islamux/.local/share/pnpm/pnpm build`.
- No `project-tracker.json` was present, so no tracker history entry could be logged.
