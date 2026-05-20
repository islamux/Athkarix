#!/usr/bin/env node

import { readFileSync, writeFileSync, existsSync } from "fs"
import { join, dirname, resolve } from "path"
import { fileURLToPath } from "url"

function findTracker(startDir) {
  let dir = resolve(startDir)
  for (let i = 0; i < 20; i++) {
    const candidate = join(dir, "project-tracker.json")
    if (existsSync(candidate)) return candidate
    const parent = dirname(dir)
    if (parent === dir) break
    dir = parent
  }
  if (process.env.PROJECT_ROOT) {
    const candidate = join(process.env.PROJECT_ROOT, "project-tracker.json")
    if (existsSync(candidate)) return candidate
  }
  return null
}

function readTracker(path) {
  return JSON.parse(readFileSync(path, "utf-8"))
}

function writeTracker(path, state) {
  writeFileSync(path, JSON.stringify(state, null, 2) + "\n")
}

function log(state, action, description) {
  if (!state.history_log) state.history_log = []
  state.history_log.push({
    date: new Date().toISOString(),
    action,
    description,
    agent: "script",
  })
}

// --- Actions ---

function activate(trkPath, state, id) {
  const idx = state.milestones.backlog.findIndex((m) => m.id === id)
  if (idx === -1) return `Error: Backlog milestone "${id}" not found`

  const milestone = state.milestones.backlog.splice(idx, 1)[0]
  milestone.actual_start = new Date().toISOString().split("T")[0]
  state.milestones.active.push(milestone)

  if (state.dashboard) {
    state.dashboard.active_milestone = milestone.id
    state.dashboard.current_focus = milestone.title
    state.dashboard.next_priority = `Complete ${milestone.title} milestone`
  }

  log(state, "activate_milestone", `Activated milestone "${milestone.title}"`)
  writeTracker(trkPath, state)
  return `✅ Milestone "${milestone.title}" activated (backlog → active)`
}

function unactivate(trkPath, state, id) {
  const idx = state.milestones.active.findIndex((m) => m.id === id)
  if (idx === -1) return `Error: Active milestone "${id}" not found`

  const milestone = state.milestones.active.splice(idx, 1)[0]
  milestone.actual_start = null
  state.milestones.backlog.push(milestone)

  if (state.dashboard && state.dashboard.active_milestone === id) {
    state.dashboard.active_milestone = ""
    state.dashboard.current_focus = "Next milestone"
    state.dashboard.next_priority = "Define next milestone"
  }

  log(state, "unactivate_milestone", `Moved milestone "${milestone.title}" back to backlog`)
  writeTracker(trkPath, state)
  return `↩️ Milestone "${milestone.title}" unactivated (active → backlog)`
}

function complete(trkPath, state, id) {
  const idx = state.milestones.active.findIndex((m) => m.id === id)
  if (idx === -1) return `Error: Active milestone "${id}" not found`

  const milestone = state.milestones.active.splice(idx, 1)[0]
  const doneCount = milestone.subtasks.filter((s) => s.status === "done").length

  state.milestones.completed.push({
    id: milestone.id,
    title: milestone.title,
    completed_at: new Date().toISOString().split("T")[0],
    summary: `${doneCount}/${milestone.subtasks.length} tasks completed`,
    domain: milestone.domain,
    week: milestone.week,
    phase: milestone.phase,
    planned_start: milestone.planned_start,
    planned_end: milestone.planned_end,
    subtasks: milestone.subtasks,
    status: "completed",
  })

  if (state.dashboard && state.dashboard.active_milestone === id) {
    state.dashboard.active_milestone = ""
    state.dashboard.current_focus = "Next milestone"
    state.dashboard.next_priority = "Define next milestone"
  }

  log(state, "complete_milestone", `Completed milestone "${milestone.title}"`)
  writeTracker(trkPath, state)
  return `✅ Milestone "${milestone.title}" completed (active → completed)`
}

function status(trkPath, state) {
  const lines = []
  lines.push(`Project: ${state.project?.name || "untitled"}`)

  if (state.milestones.active.length > 0) {
    lines.push(`\n── Active ──`)
    for (const m of state.milestones.active) {
      const done = m.subtasks.filter((s) => s.status === "done").length
      lines.push(`  ${m.id}: ${m.title} (${done}/${m.subtasks.length} tasks)`)
    }
  } else {
    lines.push(`\n── Active: (none) ──`)
  }

  if (state.milestones.backlog.length > 0) {
    lines.push(`\n── Backlog ──`)
    for (const m of state.milestones.backlog) {
      lines.push(`  ${m.id}: ${m.title} (${m.subtasks.length} tasks)`)
    }
  } else {
    lines.push(`\n── Backlog: (none) ──`)
  }

  if (state.milestones.completed.length > 0) {
    lines.push(`\n── Completed ──`)
    for (const m of state.milestones.completed) {
      lines.push(`  ${m.id}: ${m.title} (${m.completed_at})`)
    }
  }

  return lines.join("\n")
}

// --- CLI ---

function main() {
  const args = process.argv.slice(2)
  if (args.length < 1) {
    console.log(`Usage:
  node scripts/cc-milestone.mjs <action> [milestone-id]

Actions:
  activate <id>     Move milestone from backlog → active
  unactivate <id>   Move milestone from active → backlog
  complete <id>     Move milestone from active → completed
  status            Show all milestones
`)
    process.exit(1)
  }

  const action = args[0]
  const id = args[1]

  const trkPath = findTracker(process.cwd())
  if (!trkPath) {
    console.error("Error: project-tracker.json not found in any parent directory")
    process.exit(1)
  }

  const state = readTracker(trkPath)

  let result
  switch (action) {
    case "activate":
      result = activate(trkPath, state, id)
      break
    case "unactivate":
      result = unactivate(trkPath, state, id)
      break
    case "complete":
      result = complete(trkPath, state, id)
      break
    case "status":
      result = status(trkPath, state)
      break
    default:
      console.error(`Unknown action: "${action}"`)
      process.exit(1)
  }

  console.log(result)
}

main()
