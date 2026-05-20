import blessed from 'blessed'
import type { Widgets } from 'blessed'
import type { TrackerState } from '../types.js'

export function createAgentHub(screen: Widgets.Screen, state: TrackerState | null): Widgets.BoxElement {
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

    lines.push('{center}{bold}{#e2b714-fg}═══ AGENT HUB ═══{/}{/}{/}')
    lines.push('')

    const agents = (s as any).agents || []
    if (agents.length > 0) {
      lines.push('{bold} REGISTERED AGENTS{/}')
      lines.push('─'.repeat(60))
      for (const a of agents) {
        const status = a.status === 'active' ? '{green-fg}●{/}' : '{muted}○{/}'
        lines.push(`  ${status} {bold}${a.name}{/} {muted}(${a.id}){/}`)
        lines.push(`    Type: ${a.type}  Permissions: ${a.permissions.join(', ')}  Actions: ${a.session_action_count}`)
        lines.push('')
      }
    } else {
      lines.push('{muted}  No agents registered{/}')
      lines.push('')
    }

    const log = s.history_log || []
    lines.push('{bold} RECENT ACTIVITY{/}')
    lines.push('─'.repeat(60))

    const recent = log.slice(-25).reverse()
    let lastDate = ''
    for (const entry of recent) {
      if (entry.date !== lastDate) {
        lastDate = entry.date
        lines.push(`{bold}  ${entry.date}{/}`)
      }
      const text = entry.event || entry.action || ''
      const agent = entry.agent ? ` {muted}[${entry.agent}]{/}` : ''
      lines.push(`    ${text}${agent}`)
    }

    if (log.length === 0) {
      lines.push('{muted}  No activity logged{/}')
    }

    box.setContent(lines.join('\n'))
  }

  render(state)
  ;(box as any)._render = render
  return box
}
