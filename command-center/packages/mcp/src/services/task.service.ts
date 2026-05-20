import {
  readTracker, writeTracker, findTask, touchAgent, pushLog,
  autoUnblockDependents, countRevisions, ok, fail,
} from './tracker.service.js'
import type { ServiceResult } from 'command-center-shared'

export function startTask(taskId: string, agentId = 'orchestrator'): ServiceResult {
  const state = readTracker()
  const found = findTask(state, taskId)
  if (!found) return fail(`Task not found: ${taskId}`)

  const { subtask, milestone } = found

  subtask.status = 'in_progress'
  subtask.assignee = agentId

  if (!milestone.actual_start) {
    milestone.actual_start = new Date().toISOString().split('T')[0]
  }

  touchAgent(state, agentId)
  pushLog(state, {
    agent_id: agentId,
    action: 'start_task',
    target_type: 'task',
    target_id: subtask.id,
    description: `Started task "${subtask.label}"`,
    tags: ['lifecycle'],
  })
  writeTracker(state, 'start_task')
  return ok(`Task \`${subtask.id}\` started. Assigned to ${agentId}.`)
}

export function completeTask(taskId: string, summary: string, agentId?: string): ServiceResult {
  const state = readTracker()
  const found = findTask(state, taskId)
  if (!found) return fail(`Task not found: ${taskId}`)

  const { subtask } = found
  const aid = agentId || subtask.assignee || 'orchestrator'

  subtask.status = 'review'

  touchAgent(state, aid)
  pushLog(state, {
    agent_id: aid,
    action: 'complete_task',
    target_type: 'task',
    target_id: subtask.id,
    description: `Completed task "${subtask.label}": ${summary}`,
    tags: ['lifecycle'],
  })
  writeTracker(state, 'complete_task')
  return ok(`Task \`${subtask.id}\` moved to review.`)
}

export function approveTask(taskId: string, feedback?: string): ServiceResult {
  const state = readTracker()
  const found = findTask(state, taskId)
  if (!found) return fail(`Task not found: ${taskId}`)

  const { subtask, milestone } = found
  if (subtask.status !== 'review') {
    return fail(`Task \`${subtask.id}\` is not in review (current: ${subtask.status})`)
  }

  const agentId = 'orchestrator'
  const now = new Date().toISOString()

  subtask.status = 'done'
  subtask.completed_at = now
  subtask.completed_by = agentId

  const allDone = milestone.subtasks.every((t: import('../types.js').Subtask) => t.status === 'done')
  if (allDone && !milestone.actual_end) {
    milestone.actual_end = now.split('T')[0]
  }

  const unblocked = autoUnblockDependents(state, subtask.id, milestone.id)

  const fb = feedback ? ` Feedback: ${feedback}.` : ''
  const unblockMsg = unblocked.length > 0
    ? ` Unblocked tasks: ${unblocked.join(', ')}.`
    : ''

  touchAgent(state, agentId)
  pushLog(state, {
    agent_id: agentId,
    action: 'approve_task',
    target_type: 'task',
    target_id: subtask.id,
    description: `Approved task "${subtask.label}".${fb}${unblockMsg}`,
    tags: ['lifecycle'],
  })
  writeTracker(state, 'approve_task')
  return ok(`Task \`${subtask.id}\` approved and marked done.${unblockMsg}`)
}

export function rejectTask(taskId: string, feedback: string): ServiceResult {
  const state = readTracker()
  const found = findTask(state, taskId)
  if (!found) return fail(`Task not found: ${taskId}`)

  const { subtask } = found
  if (subtask.status !== 'review') {
    return fail(`Task \`${subtask.id}\` is not in review (current: ${subtask.status})`)
  }

  const agentId = 'orchestrator'
  subtask.status = 'in_progress'

  const revision = countRevisions(state, subtask.id) + 1

  touchAgent(state, agentId)
  pushLog(state, {
    agent_id: agentId,
    action: 'reject_task',
    target_type: 'task',
    target_id: subtask.id,
    description: `Rejected task "${subtask.label}" (revision #${revision}): ${feedback}`,
    tags: ['lifecycle', 'revision'],
  })
  writeTracker(state, 'reject_task')
  return ok(`Task \`${subtask.id}\` rejected (revision #${revision}). Back to in_progress.`)
}

export function resetTask(taskId: string): ServiceResult {
  const state = readTracker()
  const found = findTask(state, taskId)
  if (!found) return fail(`Task not found: ${taskId}`)

  const { subtask } = found
  const agentId = 'orchestrator'

  subtask.status = 'todo'
  subtask.assignee = null
  subtask.completed_at = null
  subtask.completed_by = null
  subtask.blocked_by = null
  subtask.blocked_reason = null
  subtask.last_run_id = null

  touchAgent(state, agentId)
  pushLog(state, {
    agent_id: agentId,
    action: 'reset_task',
    target_type: 'task',
    target_id: subtask.id,
    description: `Reset task "${subtask.label}" to todo.`,
    tags: ['lifecycle'],
  })
  writeTracker(state, 'reset_task')
  return ok(`Task \`${subtask.id}\` reset to todo.`)
}

export function blockTask(taskId: string, reason: string): ServiceResult {
  const state = readTracker()
  const found = findTask(state, taskId)
  if (!found) return fail(`Task not found: ${taskId}`)

  const { subtask } = found
  const agentId = 'orchestrator'

  subtask.status = 'blocked'
  subtask.blocked_reason = reason

  touchAgent(state, agentId)
  pushLog(state, {
    agent_id: agentId,
    action: 'block_task',
    target_type: 'task',
    target_id: subtask.id,
    description: `Blocked task "${subtask.label}": ${reason}`,
    tags: ['lifecycle', 'blocked'],
  })
  writeTracker(state, 'block_task')
  return ok(`Task \`${subtask.id}\` blocked: ${reason}`)
}

export function unblockTask(taskId: string, resolution?: string): ServiceResult {
  const state = readTracker()
  const found = findTask(state, taskId)
  if (!found) return fail(`Task not found: ${taskId}`)

  const { subtask } = found
  if (subtask.status !== 'blocked') {
    return fail(`Task \`${subtask.id}\` is not blocked (current: ${subtask.status})`)
  }

  const agentId = 'orchestrator'
  subtask.status = subtask.assignee ? 'in_progress' : 'todo'
  subtask.blocked_by = null
  subtask.blocked_reason = null

  const res = resolution ? `: ${resolution}` : ''
  touchAgent(state, agentId)
  pushLog(state, {
    agent_id: agentId,
    action: 'unblock_task',
    target_type: 'task',
    target_id: subtask.id,
    description: `Unblocked task "${subtask.label}"${res}`,
    tags: ['lifecycle'],
  })
  writeTracker(state, 'unblock_task')
  return ok(`Task \`${subtask.id}\` unblocked → ${subtask.status}.`)
}

export function updateTask(taskId: string, updates: Record<string, any>): ServiceResult {
  const state = readTracker()
  const found = findTask(state, taskId)
  if (!found) return fail(`Task not found: ${taskId}`)

  const { subtask } = found
  const agentId = 'orchestrator'
  const changes: string[] = []

  if (updates.priority !== undefined) { subtask.priority = updates.priority; changes.push(`priority=${updates.priority}`) }
  if (updates.assignee !== undefined) { subtask.assignee = updates.assignee; changes.push(`assignee=${updates.assignee}`) }
  if (updates.execution_mode !== undefined) { subtask.execution_mode = updates.execution_mode; changes.push(`execution_mode=${updates.execution_mode}`) }
  if (updates.notes !== undefined) { subtask.notes = updates.notes; changes.push('notes updated') }

  touchAgent(state, agentId)
  pushLog(state, {
    agent_id: agentId,
    action: 'update_task',
    target_type: 'task',
    target_id: subtask.id,
    description: `Updated task "${subtask.label}": ${changes.join(', ')}`,
    tags: ['update'],
  })
  writeTracker(state, 'update_task')
  return ok(`Task \`${subtask.id}\` updated: ${changes.join(', ')}`)
}

export function logAction(taskId: string, action: string, description: string, agentId = 'orchestrator', tags: string[] = []): ServiceResult {
  const state = readTracker()

  touchAgent(state, agentId)
  pushLog(state, {
    agent_id: agentId,
    action,
    target_type: 'task',
    target_id: taskId,
    description,
    tags,
  })
  writeTracker(state, 'log_action')
  return ok(`Action logged: ${action} on ${taskId}`)
}

export function enrichTask(taskId: string, updates: Record<string, any>): ServiceResult {
  const state = readTracker()
  const found = findTask(state, taskId)
  if (!found) return fail(`Task not found: ${taskId}`)

  const { subtask } = found
  const agentId = 'orchestrator'
  const changes: string[] = []

  if (updates.prompt !== undefined) { subtask.prompt = updates.prompt; changes.push('prompt') }
  if (updates.builder_prompt !== undefined) { subtask.builder_prompt = updates.builder_prompt; changes.push('builder_prompt') }
  if (updates.acceptance_criteria !== undefined) { subtask.acceptance_criteria = updates.acceptance_criteria; changes.push('acceptance_criteria') }
  if (updates.constraints !== undefined) { subtask.constraints = updates.constraints; changes.push('constraints') }
  if (updates.context_files !== undefined) { subtask.context_files = updates.context_files; changes.push('context_files') }
  if (updates.reference_docs !== undefined) { subtask.reference_docs = updates.reference_docs; changes.push('reference_docs') }

  touchAgent(state, agentId)
  pushLog(state, {
    agent_id: agentId,
    action: 'enrich_task',
    target_type: 'task',
    target_id: subtask.id,
    description: `Enriched task "${subtask.label}": ${changes.join(', ')}`,
    tags: ['enrichment'],
  })
  writeTracker(state, 'enrich_task')
  return ok(`Task \`${subtask.id}\` enriched: ${changes.join(', ')}`)
}
