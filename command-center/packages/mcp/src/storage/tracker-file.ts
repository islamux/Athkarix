import fs from 'fs'
import path from 'path'
import os from 'os'

export const PROJECT_ROOT = process.env.PROJECT_ROOT!
export const TRACKER_PATH = path.join(PROJECT_ROOT, 'project-tracker.json')

const LOCK_FILE = path.join(os.tmpdir(), `cc-${Buffer.from(PROJECT_ROOT).toString('base64url').slice(0, 32)}.lock`)

function acquireLock(timeoutMs = 5000): void {
  const start = Date.now()
  while (Date.now() - start < timeoutMs) {
    try {
      fs.writeFileSync(LOCK_FILE, String(process.pid), { flag: 'wx' })
      return
    } catch {
      const raw = fs.existsSync(LOCK_FILE) ? fs.readFileSync(LOCK_FILE, 'utf-8') : ''
      const pid = parseInt(raw, 10)
      if (pid && !isProcessAlive(pid)) {
        try { fs.unlinkSync(LOCK_FILE) } catch { /* ignore */ }
        continue
      }
      const waited = Date.now() - start
      if (waited > 100) {
        Atomics.wait(new Int32Array(new SharedArrayBuffer(4)), 0, 0, Math.min(50, timeoutMs - waited))
      }
    }
  }
  throw new Error(`Could not acquire lock on ${TRACKER_PATH} after ${timeoutMs}ms`)
}

function releaseLock(): void {
  try { fs.unlinkSync(LOCK_FILE) } catch { /* ignore */ }
}

function isProcessAlive(pid: number): boolean {
  try {
    process.kill(pid, 0)
    return true
  } catch {
    return false
  }
}

export function readRaw(): string {
  return fs.readFileSync(TRACKER_PATH, 'utf-8')
}

export function writeAtomic(data: string): void {
  const tmpPath = TRACKER_PATH + '.tmp.' + process.pid
  fs.writeFileSync(tmpPath, data, 'utf-8')
  fs.renameSync(tmpPath, TRACKER_PATH)
}

export function withLock<T>(fn: () => T): T {
  acquireLock()
  try {
    return fn()
  } finally {
    releaseLock()
  }
}
