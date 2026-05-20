import fs from 'fs'
import path from 'path'
import { TRACKER_PATH, PROJECT_ROOT } from './tracker-file.js'

const BACKUP_DIR = path.join(PROJECT_ROOT, '.cc-backups')
const MAX_BACKUPS = 20

export interface UndoEntry {
  timestamp: string
  operation: string
  snapshot: string
}

function ensureBackupDir(): void {
  if (!fs.existsSync(BACKUP_DIR)) {
    fs.mkdirSync(BACKUP_DIR, { recursive: true })
  }
}

export function createBackup(operation: string): void {
  ensureBackupDir()
  const timestamp = new Date().toISOString().replace(/[:.]/g, '-')
  const backupPath = path.join(BACKUP_DIR, `tracker-${timestamp}.json`)
  const current = fs.readFileSync(TRACKER_PATH, 'utf-8')
  fs.writeFileSync(backupPath, current, 'utf-8')

  const undoEntry: UndoEntry = {
    timestamp: new Date().toISOString(),
    operation,
    snapshot: current,
  }
  const undoPath = path.join(BACKUP_DIR, 'undo-log.json')
  let undoLog: UndoEntry[] = []
  try {
    undoLog = JSON.parse(fs.readFileSync(undoPath, 'utf-8'))
  } catch { /* first time */ }
  undoLog.push(undoEntry)
  if (undoLog.length > MAX_BACKUPS) {
    undoLog = undoLog.slice(-MAX_BACKUPS)
  }
  fs.writeFileSync(undoPath, JSON.stringify(undoLog, null, 2), 'utf-8')

  const backups = fs.readdirSync(BACKUP_DIR)
    .filter(f => f.startsWith('tracker-') && f.endsWith('.json'))
    .sort()
  while (backups.length > MAX_BACKUPS) {
    const toRemove = backups.shift()!
    fs.unlinkSync(path.join(BACKUP_DIR, toRemove))
  }
}

export function getLastUndo(): UndoEntry | null {
  ensureBackupDir()
  const undoPath = path.join(BACKUP_DIR, 'undo-log.json')
  try {
    const undoLog: UndoEntry[] = JSON.parse(fs.readFileSync(undoPath, 'utf-8'))
    return undoLog.length > 0 ? undoLog[undoLog.length - 1] : null
  } catch {
    return null
  }
}

export function popUndo(): UndoEntry | null {
  ensureBackupDir()
  const undoPath = path.join(BACKUP_DIR, 'undo-log.json')
  try {
    const undoLog: UndoEntry[] = JSON.parse(fs.readFileSync(undoPath, 'utf-8'))
    if (undoLog.length === 0) return null
    const entry = undoLog.pop()!
    fs.writeFileSync(undoPath, JSON.stringify(undoLog, null, 2), 'utf-8')
    return entry
  } catch {
    return null
  }
}
