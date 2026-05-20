import blessed from 'blessed'
import type { Widgets } from 'blessed'

const TABS = ['Swim Lane', 'Task Board', 'Agent Hub', 'Calendar']

export function createTabBar(screen: Widgets.Screen, activeTab: number, onTab: (i: number) => void): Widgets.BoxElement {
  const bar = blessed.box({
    parent: screen,
    top: 0,
    left: 0,
    right: 0,
    height: 1,
    tags: true,
    style: { bg: '#0f3460', fg: '#e2b714' },
  })

  function render(idx: number) {
    const parts = TABS.map((t, i) => {
      const num = `{bold}{#e2b714-fg}${i + 1}{/}{/}`
      return i === idx
        ? ` {bold}{white-fg}${num}:${t}{/}{/} `
        : ` ${num}:${t} `
    })
    bar.setContent(parts.join('│'))
    screen.render()
  }

  render(activeTab)
  ;(bar as any)._render = render
  return bar
}
