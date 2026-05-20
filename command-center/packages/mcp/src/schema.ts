import { z } from 'zod'

export const SubtaskStatusSchema = z.enum(['todo', 'in_progress', 'review', 'done', 'blocked'])
export const PrioritySchema = z.string()
export const ExecutionModeSchema = z.enum(['human', 'agent', 'pair'])

export const SubtaskSchema = z.object({
  id: z.string(),
  label: z.string(),
  status: SubtaskStatusSchema.optional().default('todo'),
  done: z.boolean().optional().default(false),
  assignee: z.string().nullable().optional(),
  blocked_by: z.string().nullable().optional(),
  blocked_reason: z.string().nullable().optional(),
  completed_at: z.string().nullable().optional().default(null),
  completed_by: z.string().nullable().optional(),
  priority: PrioritySchema.optional().default('P2'),
  notes: z.string().nullable().optional(),
  prompt: z.string().nullable().optional(),
  context_files: z.array(z.string()).optional().default([]),
  reference_docs: z.array(z.string()).optional().default([]),
  acceptance_criteria: z.array(z.string()).optional().default([]),
  constraints: z.array(z.string()).optional().default([]),
  agent_target: z.string().nullable().optional(),
  execution_mode: ExecutionModeSchema.optional().default('human'),
  depends_on: z.array(z.string()).optional().default([]),
  last_run_id: z.string().nullable().optional(),
  builder_prompt: z.string().nullable().optional(),
})

export const MilestoneSchema = z.object({
  id: z.string(),
  title: z.string(),
  domain: z.string(),
  week: z.union([z.number(), z.string()]).optional().default(0),
  phase: z.string().optional().default(''),
  planned_start: z.string().nullable().optional(),
  planned_end: z.string().nullable().optional(),
  actual_start: z.string().nullable().optional(),
  actual_end: z.string().nullable().optional(),
  drift_days: z.number().optional().default(0),
  is_key_milestone: z.boolean().optional().default(false),
  key_milestone_label: z.string().nullable().optional(),
  subtasks: z.array(SubtaskSchema).optional().default([]),
  dependencies: z.array(z.string()).optional().default([]),
  notes: z.array(z.string()).optional().default([]),
  status: z.string().optional(),
  completed_at: z.string().optional(),
  summary: z.string().optional(),
})

export const CompletedMilestoneSchema = z.object({
  id: z.string(),
  title: z.string(),
  completed_at: z.string().optional().default(''),
  summary: z.string().optional().default(''),
  domain: z.string().optional(),
  week: z.union([z.number(), z.string()]).optional(),
  phase: z.string().optional(),
  planned_start: z.string().nullable().optional(),
  planned_end: z.string().nullable().optional(),
  subtasks: z.array(SubtaskSchema).optional(),
  status: z.string().optional(),
  planned_start_date: z.string().optional(),
  planned_end_date: z.string().optional(),
})

export const CategorizedMilestonesSchema = z.object({
  active: z.array(MilestoneSchema),
  backlog: z.array(MilestoneSchema),
  completed: z.array(CompletedMilestoneSchema),
})

export const DashboardSchema = z.object({
  current_focus: z.string(),
  active_milestone: z.string(),
  next_priority: z.string(),
  blockers: z.string(),
  health: z.string(),
}).optional()

export const ProjectMetaSchema = z.object({
  name: z.string(),
  start_date: z.string(),
  target_date: z.string(),
  current_week: z.number(),
  schedule_status: z.enum(['on_track', 'behind', 'ahead']),
  overall_progress: z.number(),
})

export const HistoryLogEntrySchema = z.object({
  date: z.string(),
  event: z.string().optional(),
  action: z.string().optional(),
  agent: z.string().optional(),
})

export const TrackerStateSchema = z.object({
  project: ProjectMetaSchema,
  dashboard: DashboardSchema,
  milestones: CategorizedMilestonesSchema,
  agents: z.array(z.any()).optional(),
  agent_log: z.array(z.any()).optional(),
  history_log: z.array(HistoryLogEntrySchema).optional(),
  schedule: z.object({ phases: z.array(z.any()) }).optional(),
})
