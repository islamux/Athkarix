# Athkarix Workspace — Universal AI Rules

> **Applies to ALL agents and all modes.** Follow these 5 phases in sequence for every task. These rules replace scattered per-mode instructions with one universal workflow.

---

## Phase 1: Think & Plan

Before writing any code, stop and think.

### 1.1 Define Assumptions
- State all assumptions about requirements clearly.
- If anything is ambiguous — **stop and ask**. Never silently choose a direction.
- Propose the **simplest viable solution**; reject unnecessary complexity.

### 1.2 Time & Dependency Check
- Detect current date/time via shell command.
- Research latest stable versions (pub.dev, npm, GitHub, etc.). Avoid deprecated packages.
- Document selected versions.

### 1.3 Scope Discipline
- Strictly adhere to requested scope — **no feature creep**.
- Define the user journey or data flow as **verifiable goals** (e.g., "User can press button X and see counter increase").
- No extra features, no speculative flexibility.

### 1.4 Surgical Architecture
- **Simplicity First:** minimum code to solve the problem.
- Create shared/core layers only for genuinely reusable logic.
- Keep related code together — **no micro-files**.

### 1.5 Safe Logging Design
- Lightweight, asynchronous, non-blocking logging.
- Only essential log levels. No performance impact.

**Output:** Brief plan + verifiable success criteria. Wait for approval before Phase 2.

---

## Phase 2: Analyze Impact

Before touching any file, understand the full picture.

### 2.1 Read PROJECT_MAP.md
- Read `PROJECT_MAP.md` in full at the root of the project to understand the system map.
- Identify all files that need to change and their dependencies.
- Check system flows and architecture diagrams for integration points.

### 2.2 Determine the Approach
- **Surgical edit** (modify existing feature):
  - Touch only what must be touched.
  - Match existing code style strictly (even if you consider it imperfect).
- **New implementation** (build from scratch):
  - Follow the plan from Phase 1.
  - Use existing patterns and utilities.

### 2.3 Research
- Look up library/framework docs if needed (e.g., Flutter/Dart docs).
- Identify gotchas and edge cases before writing code.

**Output:** Impact map of files to touch + confirmed assumptions.

---

## Phase 3: Execute

Write the code.

### 3.1 Quality Standards
- **No placeholders, no `// TODO`, no stubs.** All code must be complete.
- Proper error handling on every operation.
- Match existing codebase style.

### 3.2 Simplicity in Execution
- If it can be implemented in 50 lines instead of 200 — **do it**.
- No speculative engineering. Build only what's needed.

### 3.3 DRY & Abstraction
- Reuse existing shared/core layers when appropriate.
- Do not abstract code used only once.

### 3.4 Flow Adherence
- Continuously reference the system flow.
- Every line of code must serve the intended user journey — nothing beyond it.

### 3.5 Clean Your Debris
- If your change leaves a function, variable, or import orphaned — **remove it**.
- Do not touch unrelated legacy dead code.

**Output:** Working, complete code with no regressions.

---

## Phase 4: Verify

Prove it works.

### 4.1 Goal-Driven Verification
- Confirm the **success criteria** from Phase 1 are met.
- Do not move to the next feature until criteria are verified.

### 4.2 Self-Verification (Loop Until Verified)
- **For edits:** Prefer TDD/unit testing or manual device verification when automated tests aren't sufficient.
- **For new implementations:** Simulate the execution flow or write automated tests for every component.
- Verify **no regressions** were introduced.

### 4.3 Build & Lint
- Run the project's build/lint commands (`flutter analyze`, `flutter test`).
- Fix all errors and warnings introduced by your changes.

### 4.4 Code Review
- Check for security vulnerabilities and unsanitized inputs.
- Verify adherence to project conventions.
- Fix minor issues directly.

**Output:** All tests green. Build clean. No regressions.

---

## Phase 5: Sync

Update the documentation to reflect reality.

### 5.1 Update PROJECT_MAP.md
- **Add** unfinished or partially connected features to pending sections.
- **Remove** items from pending sections that are now fully completed.
- Update architecture drawings if files were added, removed, or moved.
- Update tech stack definitions if dependencies changed.

### 5.2 Update project-tracker.json
- Log the action in the history log via Command Center CLI or MCP tools.
- Mark task with appropriate status changes.
- Update agent touch timestamp.

**Output:** Synchronized state — docs and tracker reflect reality.

---

## TUI Environment Requirement

> [!IMPORTANT]
> When running the Command Center TUI (`ccui` or `pnpm ccui`), you **must** set the `PROJECT_ROOT` environment variable to the absolute path of the project directory. If `PROJECT_ROOT` is not set, the TUI will fail to find `project-tracker.json` and display an empty screen or no data.
>
> Run the TUI using:
> ```bash
> PROJECT_ROOT=$(pwd) pnpm --prefix command-center ccui
> ```

---

## Quick Reference

| Phase | Name | Key Question | Duration |
|-------|------|-------------|----------|
| 1 | Think & Plan | "What are we building and why?" | Until approved |
| 2 | Analyze Impact | "What needs to change?" | Brief |
| 3 | Execute | "Write the code" | Bulk of time |
| 4 | Verify | "Does it work?" | Until green |
| 5 | Sync | "Is the map updated?" | Immediate |

---

## Appendix: File Responsibilities

| File | Purpose | Maintained By |
|------|---------|---------------|
| `PROJECT_MAP.md` | System map detailing stack, architecture, and flows | AI / Human |
| `project-tracker.json` | Data store for milestones, tasks, and agent logs | CLI / MCP tools |
| `AGENTS.md` | Consolidated runbook defining agent personas and SOP | Human |
| `docs/ai-rules.md` | Universal AI protocols (this file) | Human |
