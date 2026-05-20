export {
  readTracker, writeTracker,
  computeScheduleStatus, computeOverallProgress,
  findTask, getMilestoneById,
  touchAgent, pushLog,
  autoUnblockDependents, countRevisions,
  generateTaskId,
} from './services/tracker.service.js'

export type {
  ProjectMeta, Subtask, Milestone, Agent, AgentLogEntry,
  Phase, TrackerState, SubtaskStatus, Priority, ExecutionMode,
  AgentType, ScheduleStatus, ServiceResult, FoundTask,
} from './types.js'

export { PROJECT_ROOT, TRACKER_PATH } from './storage/tracker-file.js'
