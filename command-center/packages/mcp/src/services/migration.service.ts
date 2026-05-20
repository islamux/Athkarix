import type { TrackerState } from 'command-center-shared'

export const CURRENT_SCHEMA_VERSION = 1

export interface Migration {
  version: number
  name: string
  run: (state: TrackerState) => void
}

const migrations: Migration[] = [
  {
    version: 1,
    name: 'remove_done_field',
    run: (state: TrackerState) => {
      for (const m of [...state.milestones.active, ...state.milestones.backlog]) {
        for (const t of m.subtasks) {
          if ('done' in t) {
            delete (t as any).done
          }
        }
      }
    },
  },
]

export function runMigrations(state: TrackerState): TrackerState {
  const currentVersion = (state as any)._schema_version ?? 0

  if (currentVersion >= CURRENT_SCHEMA_VERSION) {
    return state
  }

  for (const migration of migrations) {
    if (migration.version > currentVersion) {
      migration.run(state)
    }
  }

  ;(state as any)._schema_version = CURRENT_SCHEMA_VERSION
  return state
}

export function getPendingMigrations(state: TrackerState): Migration[] {
  const currentVersion = (state as any)._schema_version ?? 0
  return migrations.filter(m => m.version > currentVersion)
}

export function getSchemaVersion(state: TrackerState): number {
  return (state as any)._schema_version ?? 0
}
