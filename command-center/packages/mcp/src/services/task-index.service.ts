import type { TrackerState, Subtask, Milestone, FoundTask } from 'command-center-shared'

export interface TaskIndexEntry {
  milestoneId: string
  milestoneCategory: 'active' | 'backlog'
  index: number
}

export type TaskIndex = Map<string, TaskIndexEntry>

export function buildTaskIndex(state: TrackerState): TaskIndex {
  const index = new Map<string, TaskIndexEntry>()

  for (const m of state.milestones.active) {
    for (let i = 0; i < m.subtasks.length; i++) {
      index.set(m.subtasks[i].id, { milestoneId: m.id, milestoneCategory: 'active', index: i })
    }
  }

  for (const m of state.milestones.backlog) {
    for (let i = 0; i < m.subtasks.length; i++) {
      index.set(m.subtasks[i].id, { milestoneId: m.id, milestoneCategory: 'backlog', index: i })
    }
  }

  return index
}

export function findTaskFast(state: TrackerState, index: TaskIndex, taskId: string): FoundTask | null {
  const entry = index.get(taskId)
  if (!entry) return null

  const milestone = state.milestones[entry.milestoneCategory].find(m => m.id === entry.milestoneId)
  if (!milestone) return null

  const subtask = milestone.subtasks[entry.index]
  if (!subtask) return null

  return { subtask, milestone }
}

export function invalidateIndex(index: TaskIndex, taskId: string): void {
  index.delete(taskId)
}

export function addToIndex(index: TaskIndex, taskId: string, entry: TaskIndexEntry): void {
  index.set(taskId, entry)
}

export function rebuildIndexIfNeeded(state: TrackerState, index: TaskIndex): TaskIndex {
  const totalTasks = index.size
  const actualTasks = getTotalTaskCount(state)
  if (totalTasks !== actualTasks) {
    return buildTaskIndex(state)
  }
  return index
}

function getTotalTaskCount(state: TrackerState): number {
  let count = 0
  for (const m of state.milestones.active) count += m.subtasks.length
  for (const m of state.milestones.backlog) count += m.subtasks.length
  return count
}
