import blessed from 'blessed'
import type { Widgets } from 'blessed'
import type { TrackerState, Milestone } from '../types.js'
import { statusIcon } from '../theme.js'

export function createSwimLane(screen: Widgets.Screen, state: TrackerState | null, milestoneIdx: number): Widgets.BoxElement {
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

  ;(box as any)._milestoneIdx = milestoneIdx

  function render(s: TrackerState | null) {
    if (!s) {
      box.setContent('{center}{red-fg}No data{/}{/}')
      return
    }

    const all = [...s.milestones.active, ...s.milestones.backlog]
    const completed = s.milestones.completed
    const lines: string[] = []

    lines.push('{center}{bold}{#e2b714-fg}═══ SWIM LANE ═══{/}{/}{/}')
    lines.push('')

    lines.push('{bold} ACTIVE MILESTONES{/}')
    lines.push('─'.repeat(70))
    for (const m of s.milestones.active) {
      const done = (m.subtasks || []).filter(t => t.status === 'done').length
      const total = (m.subtasks || []).length
      const pct = total > 0 ? Math.round((done / total) * 100) : 0
      const bar = progressBar(pct, 20)
      const key = m.is_key_milestone ? ' ★' : ''
      lines.push(`  {bold}${m.title}{/} ${key} {muted}(${m.id}){/}`)
      lines.push(`  ${bar} ${pct}%  ${done}/${total} tasks  Phase: ${m.phase}  Domain: ${m.domain}`)
      if (m.planned_start) {
        lines.push(`  {muted}Planned: ${m.planned_start} → ${m.planned_end || '?'}{/}  ${m.actual_start ? `Actual: ${m.actual_start} → ${m.actual_end || '?'}` : ''}`)
      }
      lines.push('')
    }

    if (s.milestones.active.length === 0) {
      lines.push('  {muted}(no active milestones){/}')
      lines.push('')
    }

    lines.push('{bold} BACKLOG{/}')
    lines.push('─'.repeat(70))
    for (const m of s.milestones.backlog) {
      const done = (m.subtasks || []).filter(t => t.status === 'done').length
      const total = (m.subtasks || []).length
      const key = m.is_key_milestone ? ' ★' : ''
      lines.push(`  {muted}${m.title}${key} (${m.id}) — ${done}/${total} tasks — ${m.phase}{/}`)
    }
    if (s.milestones.backlog.length === 0) {
      lines.push('  {muted}(backlog empty){/}')
    }
    lines.push('')

    lines.push('{bold} COMPLETED{/}')
    lines.push('─'.repeat(70))
    for (const c of completed.slice(-5)) {
      lines.push(`  {green-fg}✓ ${c.title}{/} {muted}(${c.completed_at}){/}`)
    }
    if (completed.length > 5) {
      lines.push(`  {muted}... and ${completed.length - 5} more{/}`)
    }

    box.setContent(lines.join('\n'))
  }

  render(state)
  ;(box as any)._render = render
  return box
}

function progressBar(pct: number, width: number): string {
  const filled = Math.round((pct / 100) * width)
  const empty = width - filled
  return `{green-fg}${'█'.repeat(filled)}{/}{#333355-fg}${'░'.repeat(empty)}{/}`
}
