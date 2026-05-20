export const themes = {
  dark: {
    bg: '#1a1a2e',
    fg: '#e0e0e0',
    accent: '#e2b714',
    success: '#4ec9b0',
    warning: '#ce9178',
    error: '#f44747',
    review: '#dcdcaa',
    muted: '#6a6a6a',
    border: '#333355',
    barBg: '#16213e',
    selectedBg: '#0f3460',
    selectedFg: '#ffffff',
    headerBg: '#0f3460',
    headerFg: '#e2b714',
  },
  light: {
    bg: '#fafafa',
    fg: '#1a1a2e',
    accent: '#b8860b',
    success: '#2e7d32',
    warning: '#e65100',
    error: '#c62828',
    review: '#f9a825',
    muted: '#9e9e9e',
    border: '#cccccc',
    barBg: '#e8e8e8',
    selectedBg: '#bbdefb',
    selectedFg: '#1a1a2e',
    headerBg: '#e2b714',
    headerFg: '#1a1a2e',
  },
}

export type ThemeName = 'dark' | 'light'

export function statusColor(status: string): string {
  const t = themes.dark
  switch (status) {
    case 'done': return t.success
    case 'in_progress': return t.accent
    case 'review': return t.review
    case 'blocked': return t.error
    case 'todo': return t.muted
    default: return t.fg
  }
}

export function statusIcon(status: string): string {
  switch (status) {
    case 'done': return '✓'
    case 'in_progress': return '◐'
    case 'review': return '◇'
    case 'blocked': return '✗'
    default: return '○'
  }
}

export function priorityBadge(priority: string): string {
  switch (priority) {
    case 'P0': return '{red-fg}[P0]{/}'
    case 'P1': return '{red-fg}[P1]{/}'
    case 'P2': return '{yellow-fg}[P2]{/}'
    case 'P3': return '{cyan-fg}[P3]{/}'
    default: return ''
  }
}
