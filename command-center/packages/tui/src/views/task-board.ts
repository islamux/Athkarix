import blessed from 'blessed'
import type { Widgets } from 'blessed'
import type { TrackerState, Milestone } from '../types.js'
import { statusColor, statusIcon } from '../theme.js'

const COLUMNS = [
  { id: 'todo', label: 'TODO' },
  { id: 'in_progress', label: 'IN PROGRESS' },
  { id: 'review', label: 'REVIEW' },
  { id: 'done', label: 'DONE' },
  { id: 'blocked', label: 'BLOCKED' },
]

export function createTaskBoard(screen: Widgets.Screen, state: TrackerState | null, _milestoneIdx: number): Widgets.BoxElement {
  const box = blessed.box({
    parent: screen,
    top: 1,
    left: 0,
    right: 0,
    bottom: 1,
    keys: true,
    vi: true,
    scrollable: true,
    alwaysScroll: true,
    tags: true,
    style: { bg: '#1a1a2e', fg: '#e0e0e0' },
  })

  function render(s: TrackerState | null) {
    if (!s) {
      box.setContent('{center}{red-fg}No data{/}{/}')
      return
    }

    const allMilestones = [...s.milestones.active, ...s.milestones.backlog]
    if (allMilestones.length === 0) {
      box.setContent('{center}No milestones{/}')
      return
    }

    const current = allMilestones[Math.min(_milestoneIdx, allMilestones.length - 1)]
    const subtasks = (current.subtasks || [])
    const lines: string[] = []

    lines.push('{center}{bold}{#e2b714-fg}═══ TASK BOARD ═══{/}{/}{/}')
    lines.push('')

    const indicator = allMilestones.length > 1 ? ` [${_milestoneIdx + 1}/${allMilestones.length}] ` : ' '
    const key = current.is_key_milestone ? ' ★' : ''
    lines.push(`{bold}${current.title}${key}{/}${indicator}{muted}(${current.id}) — ${current.domain} — ${current.phase}{/}`)
    lines.push('')

    const done = subtasks.filter(t => t.status === 'done').length
    const total = subtasks.length
    lines.push(`Progress: ${done}/${total} {muted}│ [ ] navigate  [s] cycle status  [Enter] details{/}`)
    lines.push('─'.repeat(80))

    if (subtasks.length === 0) {
      lines.push('{muted}  No tasks in this milestone{/}')
      box.setContent(lines.join('\n'))
      return
    }

    for (const col of COLUMNS) {
      const tasks = subtasks.filter(t => t.status === col.id)
      if (tasks.length === 0) continue

      const color = statusColor(col.id)
      lines.push(`{bold}{${color}-fg}${col.label} (${tasks.length}){/}{/}`)

      for (const t of tasks) {
        const icon = statusIcon(t.status)
        const pri = t.priority && t.priority.startsWith('P') ? ` {bold}{${color}-fg}[${t.priority}]{/}{/}` : ''
        const assignee = t.assignee ? ` {muted}→ ${t.assignee}{/}` : ''
        lines.push(`  {${color}-fg}${icon}{/} {bold}${t.id}{/}${pri} ${t.label}${assignee}`)
      }
      lines.push('')
    }

    box.setContent(lines.join('\n'))
  }

  render(state)
  ;(box as any)._render = render
  return box
}
