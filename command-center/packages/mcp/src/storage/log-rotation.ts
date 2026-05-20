import fs from 'fs'
import path from 'path'
import { PROJECT_ROOT } from './tracker-file.js'
import type { AgentLogEntry } from 'command-center-shared'

const ARCHIVE_DIR = path.join(PROJECT_ROOT, '.cc-backups', 'agent-log-archive')
const MAX_IN_MEMORY = 500
const ARCHIVE_CHUNK_SIZE = 100

function ensureArchiveDir(): void {
  if (!fs.existsSync(ARCHIVE_DIR)) {
    fs.mkdirSync(ARCHIVE_DIR, { recursive: true })
  }
}

export function rotateAgentLog(log: AgentLogEntry[]): { active: AgentLogEntry[]; rotated: number } {
  if (log.length <= MAX_IN_MEMORY) {
    return { active: log, rotated: 0 }
  }

  ensureArchiveDir()

  const excess = log.length - MAX_IN_MEMORY
  const toArchive = log.slice(0, excess)
  const active = log.slice(excess)

  const timestamp = new Date().toISOString().replace(/[:.]/g, '-').slice(0, 19)
  const archivePath = path.join(ARCHIVE_DIR, `agent-log-${timestamp}-${toArchive.length}.json`)
  fs.writeFileSync(archivePath, JSON.stringify(toArchive, null, 2), 'utf-8')

  compactArchives()
  return { active, rotated: toArchive.length }
}

export function getArchivedLogCount(): number {
  ensureArchiveDir()
  const files = fs.readdirSync(ARCHIVE_DIR).filter(f => f.startsWith('agent-log-') && f.endsWith('.json'))
  let total = 0
  for (const f of files) {
    try {
      const entries: AgentLogEntry[] = JSON.parse(fs.readFileSync(path.join(ARCHIVE_DIR, f), 'utf-8'))
      total += entries.length
    } catch {
      /* ignore corrupt archives */
    }
  }
  return total
}

function compactArchives(): void {
  ensureArchiveDir()
  const files = fs.readdirSync(ARCHIVE_DIR)
    .filter(f => f.startsWith('agent-log-') && f.endsWith('.json'))
    .sort()

  const MAX_ARCHIVE_FILES = 10
  while (files.length > MAX_ARCHIVE_FILES) {
    const toRemove = files.shift()!
    fs.unlinkSync(path.join(ARCHIVE_DIR, toRemove))
  }
}
