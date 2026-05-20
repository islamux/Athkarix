import fs from 'fs'
import { EventEmitter } from 'events'
import { getTrackerPath } from './config.js'
import { TrackerStateSchema } from 'command-center-shared'
import type { TrackerState } from 'command-center-shared'

export class Store extends EventEmitter {
  private _state: TrackerState | null = null
  private _trackerPath: string

  constructor() {
    super()
    this._trackerPath = getTrackerPath()
    this.loadFromDisk()
  }

  get state(): TrackerState | null {
    return this._state
  }

  loadFromDisk(): boolean {
    try {
      const raw = fs.readFileSync(this._trackerPath, 'utf-8')
      const parsed = JSON.parse(raw)
      this._state = TrackerStateSchema.parse(parsed) as TrackerState
      this.emit('change', this._state)
      return true
    } catch {
      return false
    }
  }

  get trackerPath(): string {
    return this._trackerPath
  }
}
