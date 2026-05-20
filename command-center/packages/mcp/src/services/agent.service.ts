import { readTracker, writeTracker, touchAgent, pushLog, ok, fail } from './tracker.service.js'
import type { ServiceResult } from 'command-center-shared'

export function registerAgent(
  agentId: string,
  name: string,
  type: string,
  permissions: string[],
  options: { color?: string; parent_id?: string } = {},
): ServiceResult {
  const state = readTracker()
  if (!state.agents) state.agents = []
  const existing = state.agents.find((a: import('../types.js').Agent) => a.id === agentId)

  if (existing) {
    existing.name = name
    existing.type = type as any
    existing.permissions = permissions
    if (options.color !== undefined) existing.color = options.color
    if (options.parent_id !== undefined) existing.parent_id = options.parent_id
  } else {
    state.agents.push({
      id: agentId,
      name,
      type: type as any,
      color: options.color || '#888888',
      status: 'active',
      permissions,
      last_action_at: null,
      session_action_count: 0,
      ...(options.parent_id !== undefined ? { parent_id: options.parent_id } : {}),
    })
  }

  touchAgent(state, agentId)
  pushLog(state, {
    agent_id: 'orchestrator',
    action: 'register_agent',
    target_type: 'agent',
    target_id: agentId,
    description: `${existing ? 'Updated' : 'Registered'} agent "${name}" (${agentId})`,
    tags: ['agent'],
  })
  writeTracker(state, 'register_agent')
  return ok(`Agent \`${agentId}\` ${existing ? 'updated' : 'registered'}: ${name}`)
}
