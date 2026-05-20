export type SubtaskStatus = 'todo' | 'in_progress' | 'review' | 'done' | 'blocked'
export type Priority = 'P1' | 'P2' | 'P3' | 'P4'
export type ExecutionMode = 'human' | 'agent' | 'pair'
export type AgentType = 'orchestrator' | 'sub-agent' | 'human' | 'external'
export type ScheduleStatus = 'on_track' | 'behind' | 'ahead'

export interface ProjectMeta {
  name: string
  start_date: string
  target_date: string
  current_week: number
  schedule_status: ScheduleStatus
  overall_progress: number
}

export interface Dashboard {
  current_focus: string
  active_milestone: string
  next_priority: string
  blockers: string
  health: string
}

export interface Subtask {
  id: string
  label: string
  status: SubtaskStatus
  assignee: string | null
  blocked_by: string | null
  blocked_reason: string | null
  completed_at: string | null
  completed_by: string | null
  priority: string
  notes: string | null
  prompt: string | null
  context_files: string[]
  reference_docs: string[]
  acceptance_criteria: string[]
  constraints: string[]
  agent_target: string | null
  execution_mode: ExecutionMode
  depends_on: string[]
  last_run_id: string | null
  builder_prompt: string | null
}

export interface Milestone {
  id: string
  title: string
  domain: string
  week: number | string
  phase: string
  planned_start: string | null
  planned_end: string | null
  actual_start: string | null
  actual_end: string | null
  drift_days: number
  is_key_milestone: boolean
  key_milestone_label: string | null
  subtasks: Subtask[]
  dependencies: string[]
  notes: string[]
  status?: string
  completed_at?: string
  summary?: string
}

export interface CompletedMilestone {
  id: string
  title: string
  completed_at: string
  summary: string
  domain?: string
  week?: number | string
  phase?: string
  planned_start?: string | null
  planned_end?: string | null
  subtasks?: Subtask[]
  status?: string
}

export interface CategorizedMilestones {
  active: Milestone[]
  backlog: Milestone[]
  completed: CompletedMilestone[]
}

export interface Agent {
  id: string
  name: string
  type: AgentType
  parent_id?: string
  color: string
  status: string
  permissions: string[]
  last_action_at: string | null
  session_action_count: number
}

export interface AgentLogEntry {
  id: string
  agent_id: string
  action: string
  target_type: string
  target_id: string
  description: string
  timestamp: string
  tags: string[]
}

export interface HistoryLogEntry {
  date: string
  event?: string
  action?: string
  agent?: string
}

export interface Phase {
  id: string
  title: string
  start_week: number
  end_week: number
}

export interface TrackerState {
  project: ProjectMeta
  dashboard?: Dashboard
  milestones: CategorizedMilestones
  agents?: Agent[]
  agent_log?: AgentLogEntry[]
  history_log?: HistoryLogEntry[]
  schedule?: { phases: Phase[] }
  _schema_version?: number
}

export interface ServiceResult {
  ok: boolean
  data?: string
  error?: string
}

export interface FoundTask {
  subtask: Subtask
  milestone: Milestone
}

export function allMilestones(state: TrackerState): Milestone[] {
  return [
    ...state.milestones.active,
    ...state.milestones.backlog,
  ].map(m => ({ ...m, subtasks: m.subtasks || [] }))
}
