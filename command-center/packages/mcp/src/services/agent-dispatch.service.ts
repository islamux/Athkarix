import type { TrackerState, Agent, Subtask, SubtaskStatus, ServiceResult } from 'command-center-shared'
import { readTracker, writeTracker, touchAgent, pushLog, ok, fail } from './tracker.service.js'

export type AgentPermission = 'READ' | 'WRITE' | 'EXECUTE' | 'DISPATCH' | 'APPROVE' | 'ADMIN'
export type AgentStatus = 'active' | 'idle' | 'busy' | 'stalled' | 'offline'

export const AGENT_HEARTBEAT_TIMEOUT_MS = 5 * 60 * 1000
export const AGENT_MAX_CONCURRENT = 3

export interface AgentDispatchResult {
  ok: boolean
  agent_id: string | null
  task_id: string | null
  error?: string
  message?: string
}

export interface ValidationResult {
  passed: boolean
  criteria_met: number
  criteria_total: number
  failures: string[]
}

export function getAgent(state: TrackerState, agentId: string): Agent | undefined {
  return state.agents?.find(a => a.id === agentId)
}

export function getAvailableAgents(state: TrackerState): Agent[] {
  if (!state.agents) return []
  return state.agents.filter(a => a.status !== 'offline' && a.status !== 'stalled')
}

export function findBestAgent(state: TrackerState, task: Subtask): Agent | null {
  if (!state.agents) return null

  if (task.agent_target) {
    const target = state.agents.find(a => a.id === task.agent_target)
    if (target && target.status !== 'offline' && target.status !== 'stalled') {
      return target
    }
  }

  const candidates = getAvailableAgents(state)
  if (candidates.length === 0) return null

  const busyCount: Record<string, number> = {}
  for (const m of [...state.milestones.active, ...state.milestones.backlog]) {
    for (const t of m.subtasks) {
      if (t.status === 'in_progress' && t.assignee) {
        busyCount[t.assignee] = (busyCount[t.assignee] || 0) + 1
      }
    }
  }

  const available = candidates.filter(a => (busyCount[a.id] || 0) < AGENT_MAX_CONCURRENT)
  if (available.length === 0) return null

  return available.sort((a, b) => {
    const aBusy = busyCount[a.id] || 0
    const bBusy = busyCount[b.id] || 0
    return aBusy - bBusy
  })[0]
}

export function dispatchTask(state: TrackerState, taskId: string, agentId?: string): AgentDispatchResult {
  const agentIdToUse = agentId || 'orchestrator'
  const agent = getAgent(state, agentIdToUse)

  if (!agent) {
    return { ok: false, agent_id: agentIdToUse, task_id: taskId, error: `Agent not found: ${agentIdToUse}` }
  }

  if (!checkPermission(agent, 'EXECUTE')) {
    return { ok: false, agent_id: agentIdToUse, task_id: taskId, error: `Agent ${agentIdToUse} lacks EXECUTE permission` }
  }

  if (agent.status === 'offline') {
    return { ok: false, agent_id: agentIdToUse, task_id: taskId, error: `Agent ${agentIdToUse} is offline` }
  }

  const busyCount = getAgentBusyCount(state, agentIdToUse)
  if (busyCount >= AGENT_MAX_CONCURRENT) {
    return { ok: false, agent_id: agentIdToUse, task_id: taskId, error: `Agent ${agentIdToUse} is at max capacity (${AGENT_MAX_CONCURRENT})` }
  }

  return { ok: true, agent_id: agentIdToUse, task_id: taskId, message: `Task dispatched to ${agent.name} (${agentIdToUse})` }
}

export function checkPermission(agent: Agent, required: AgentPermission): boolean {
  if (agent.permissions.includes('ADMIN')) return true
  return agent.permissions.includes(required)
}

export function getAgentBusyCount(state: TrackerState, agentId: string): number {
  let count = 0
  for (const m of [...state.milestones.active, ...state.milestones.backlog]) {
    for (const t of m.subtasks) {
      if (t.status === 'in_progress' && t.assignee === agentId) {
        count++
      }
    }
  }
  return count
}

export function updateHeartbeat(state: TrackerState, agentId: string): void {
  const agent = getAgent(state, agentId)
  if (!agent) return
  agent.last_action_at = new Date().toISOString()
  agent.status = 'active'
}

export function checkAgentHeartbeats(state: TrackerState): { stalled: string[]; active: number } {
  if (!state.agents) return { stalled: [], active: 0 }
  const now = Date.now()
  const stalled: string[] = []
  let active = 0

  for (const agent of state.agents) {
    if (!agent.last_action_at) {
      continue
    }
    const lastSeen = new Date(agent.last_action_at).getTime()
    const elapsed = now - lastSeen
    if (elapsed > AGENT_HEARTBEAT_TIMEOUT_MS && agent.status === 'active') {
      agent.status = 'stalled'
      stalled.push(agent.id)
    } else if (agent.status === 'active') {
      active++
    }
  }

  return { stalled, active }
}

export function validateResult(state: TrackerState, taskId: string, summary: string): ValidationResult {
  const all = [...state.milestones.active, ...state.milestones.backlog]
  let task: Subtask | null = null
  for (const m of all) {
    const found = m.subtasks.find(s => s.id === taskId)
    if (found) { task = found; break }
  }

  if (!task) {
    return { passed: false, criteria_met: 0, criteria_total: 0, failures: [`Task not found: ${taskId}`] }
  }

  if (task.acceptance_criteria.length === 0) {
    return { passed: true, criteria_met: 0, criteria_total: 0, failures: [] }
  }

  const failures: string[] = []
  const summaryLower = summary.toLowerCase()

  for (const criterion of task.acceptance_criteria) {
    const keyTerms = extractKeyTerms(criterion)
    const met = keyTerms.some(term => summaryLower.includes(term.toLowerCase()))
    if (!met) {
      failures.push(criterion)
    }
  }

  return {
    passed: failures.length === 0,
    criteria_met: task.acceptance_criteria.length - failures.length,
    criteria_total: task.acceptance_criteria.length,
    failures,
  }
}

function extractKeyTerms(criterion: string): string[] {
  const stopwords = new Set(['the', 'a', 'an', 'is', 'are', 'was', 'were', 'be', 'been', 'being', 'have', 'has', 'had', 'do', 'does', 'did', 'will', 'would', 'could', 'should', 'may', 'might', 'shall', 'can', 'need', 'dare', 'ought', 'used', 'to', 'of', 'in', 'for', 'on', 'with', 'at', 'by', 'from', 'as', 'into', 'through', 'during', 'before', 'after', 'above', 'below', 'between', 'out', 'off', 'over', 'under', 'again', 'further', 'then', 'once', 'here', 'there', 'when', 'where', 'why', 'how', 'all', 'both', 'each', 'few', 'more', 'most', 'other', 'some', 'such', 'no', 'nor', 'not', 'only', 'own', 'same', 'so', 'than', 'too', 'very', 'just', 'because', 'but', 'and', 'or', 'if', 'while', 'that', 'this', 'these', 'those', 'it', 'its'])
  return criterion.split(/\s+/).filter(w => w.length > 2 && !stopwords.has(w.toLowerCase().replace(/[^a-z0-9]/gi, '')))
}

export function enforceAgentPermission(state: TrackerState, agentId: string, required: AgentPermission): ServiceResult | null {
  const agent = getAgent(state, agentId)
  if (!agent) {
    return fail(`Agent not found: ${agentId}`)
  }
  if (!checkPermission(agent, required)) {
    return fail(`Agent \`${agentId}\` lacks ${required} permission (has: ${agent.permissions.join(', ')})`)
  }
  return null
}
