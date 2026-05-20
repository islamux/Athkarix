import blessed from 'blessed'
import type { Widgets } from 'blessed'
import type { TrackerState } from '../types.js'

export function createStatusBar(screen: Widgets.Screen, state: TrackerState | null): Widgets.BoxElement {
  const bar = blessed.box({
    parent: screen,
    bottom: 0,
    left: 0,
    right: 0,
    height: 1,
    tags: true,
    style: { bg: '#16213e', fg: '#e0e0e0' },
  })

  function render(s: TrackerState | null) {
    if (!s) {
      bar.setContent(' {red-fg}No tracker data{/}')
      return
    }
    const p = s.project
    const week = p.current_week
    const status = p.schedule_status === 'on_track' ? '{green-fg}ON TRACK{/}' : p.schedule_status === 'behind' ? '{red-fg}BEHIND{/}' : '{cyan-fg}AHEAD{/}'
    const progress = `${p.overall_progress}%`
    const active = s.milestones.active.length
    const backlog = s.milestones.backlog.length
    const completed = s.milestones.completed.length
    const focus = s.dashboard?.current_focus || ''
    bar.setContent(` Week ${week} │ ${status} │ ${progress} │ Active:${active} Backlog:${backlog} Done:${completed} │ ${focus} │ {muted}r:refresh t:theme q:quit{/}`)
  }

  render(state)
  ;(bar as any)._render = render
  return bar
}
