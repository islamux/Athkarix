import blessed from 'blessed'
import type { Widgets } from 'blessed'
import type { TrackerState, HistoryLogEntry } from '../types.js'

export function createCalendar(screen: Widgets.Screen, state: TrackerState | null): Widgets.BoxElement {
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

    const lines: string[] = []

    lines.push('{center}{bold}{#e2b714-fg}═══ CALENDAR ═══{/}{/}{/}')
    lines.push('')

    const startDate = new Date(s.project.start_date)
    const now = new Date()
    const currentWeek = Math.max(1, Math.floor((now.getTime() - startDate.getTime()) / (7 * 24 * 60 * 60 * 1000)) + 1)
    const totalWeeks = Math.ceil((new Date(s.project.target_date).getTime() - startDate.getTime()) / (7 * 24 * 60 * 60 * 1000))

    lines.push(`{bold} Project Timeline{/}  Start: ${s.project.start_date}  Target: ${s.project.target_date}  Current Week: ${currentWeek}/${totalWeeks}`)
    lines.push('')

    const timeline = '─'.repeat(60)
    lines.push(`  ${timeline}`)

    const weekMarkers: string[] = []
    const weekLine: string[] = []
    for (let w = 1; w <= Math.min(totalWeeks, 20); w++) {
      if (w === currentWeek) {
        weekLine.push('{bold}{#e2b714-fg}▼{/}{/}')
      } else if (w <= currentWeek) {
        weekLine.push('{green-fg}─{/}')
      } else {
        weekLine.push('{muted}─{/}')
      }
      weekMarkers.push(`W${w}`.padEnd(3).slice(0, 3))
    }
    lines.push(`  ${weekLine.join('')}`)
    lines.push(`  {muted}${weekMarkers.join('')}{/}`)
    lines.push('')

    const completedByDate: Record<string, string[]> = {}
    for (const cm of s.milestones.completed) {
      if (cm.completed_at) {
        const date = cm.completed_at
        if (!completedByDate[date]) completedByDate[date] = []
        completedByDate[date].push(cm.title)
      }
    }

    lines.push('{bold} Completed Milestones by Date{/}')
    lines.push('─'.repeat(60))
    const dates = Object.keys(completedByDate).sort().reverse()
    for (const d of dates) {
      lines.push(`  {green-fg}${d}{/}`)
      for (const title of completedByDate[d]) {
        lines.push(`    ✓ ${title}`)
      }
    }
    if (dates.length === 0) {
      lines.push('{muted}  No completed milestones yet{/}')
    }

    lines.push('')
    lines.push('{bold} Activity by Date{/}')
    lines.push('─'.repeat(60))
    const log = s.history_log || []
    const byDate: Record<string, string[]> = {}
    for (const entry of log) {
      if (!byDate[entry.date]) byDate[entry.date] = []
      byDate[entry.date].push(entry.event || entry.action || '')
    }
    const logDates = Object.keys(byDate).sort().reverse()
    for (const d of logDates.slice(0, 10)) {
      lines.push(`  {bold}${d}{/} (${byDate[d].length} events)`)
    }
    if (logDates.length === 0) {
      lines.push('{muted}  No history entries{/}')
    }

    box.setContent(lines.join('\n'))
  }

  render(state)
  ;(box as any)._render = render
  return box
}
