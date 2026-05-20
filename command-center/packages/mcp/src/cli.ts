#!/usr/bin/env node

import { handleTool } from './tools.js'

function parseArgs(argv: string[]): { command: string; positional: string[]; flags: Record<string, any> } {
  const args = argv.slice(2)
  const command = args[0]?.replace(/-/g, '_') ?? ''
  const positional: string[] = []
  const flags: Record<string, any> = {}

  for (let i = 1; i < args.length; i++) {
    if (args[i].startsWith('--')) {
      const key = args[i].slice(2).replace(/-/g, '_')
      const val = args[i + 1]
      if (val && !val.startsWith('--')) {
        if (val.includes(',')) {
          flags[key] = val.split(',')
        } else {
          flags[key] = val
        }
        i++
      }
    } else {
      positional.push(args[i])
    }
  }

  return { command, positional, flags }
}

async function main() {
  if (!process.env.PROJECT_ROOT) {
    process.stderr.write('Error: PROJECT_ROOT environment variable is required\n')
    process.exit(1)
  }

  const { command, positional, flags } = parseArgs(process.argv)

  if (!command) {
    process.stderr.write('Usage: command-center <command> [args]\n')
    process.exit(1)
  }

  let toolName: string
  let toolArgs: Record<string, any>

  switch (command) {
    case 'get_task_context':
      toolName = 'get_task_context'
      toolArgs = { task_id: positional[0] }
      break
    case 'get_task_summary':
      toolName = 'get_task_summary'
      toolArgs = { task_id: positional[0] }
      break
    case 'get_project_status':
      toolName = 'get_project_status'
      toolArgs = {}
      break
    case 'get_milestone_overview':
      toolName = 'get_milestone_overview'
      toolArgs = { milestone_id: positional[0] }
      break
    case 'list_tasks':
      toolName = 'list_tasks'
      toolArgs = { ...flags }
      break
    case 'get_task_history':
      toolName = 'get_task_history'
      toolArgs = { task_id: positional[0] }
      break
    case 'list_agents':
      toolName = 'list_agents'
      toolArgs = {}
      break
    case 'get_activity_feed':
      toolName = 'get_activity_feed'
      toolArgs = { ...flags }
      break
    case 'start_task':
      toolName = 'start_task'
      toolArgs = { task_id: positional[0], ...flags }
      break
    case 'complete_task':
      toolName = 'complete_task'
      toolArgs = { task_id: positional[0], summary: positional[1] || '', ...flags }
      break
    case 'approve_task':
      toolName = 'approve_task'
      toolArgs = { task_id: positional[0], feedback: positional[1], ...flags }
      break
    case 'reject_task':
      toolName = 'reject_task'
      toolArgs = { task_id: positional[0], feedback: positional[1] || '', ...flags }
      break
    case 'reset_task':
      toolName = 'reset_task'
      toolArgs = { task_id: positional[0] }
      break
    case 'block_task':
      toolName = 'block_task'
      toolArgs = { task_id: positional[0], reason: positional[1] || '' }
      break
    case 'unblock_task':
      toolName = 'unblock_task'
      toolArgs = { task_id: positional[0], ...flags }
      break
    case 'update_task':
      toolName = 'update_task'
      toolArgs = { task_id: positional[0], ...flags }
      break
    case 'log_action':
      toolName = 'log_action'
      toolArgs = { task_id: positional[0], action: positional[1] || '', description: positional[2] || '', ...flags }
      break
    case 'enrich_task':
      toolName = 'enrich_task'
      toolArgs = { task_id: positional[0], ...flags }
      break
    case 'add_milestone_note':
      toolName = 'add_milestone_note'
      toolArgs = { milestone_id: positional[0], note: positional[1] || '' }
      break
    case 'set_milestone_dates':
      toolName = 'set_milestone_dates'
      toolArgs = { milestone_id: positional[0], ...flags }
      break
    case 'update_drift':
      toolName = 'update_drift'
      toolArgs = { milestone_id: positional[0], drift_days: positional[1] ? Number(positional[1]) : undefined, ...flags }
      break
    case 'activate_milestone':
      toolName = 'activate_milestone'
      toolArgs = { milestone_id: positional[0] }
      break
    case 'complete_milestone':
      toolName = 'complete_milestone'
      toolArgs = { milestone_id: positional[0] }
      break
    case 'create_milestone':
      toolName = 'create_milestone'
      toolArgs = { id: positional[0], title: positional[1] || '', ...flags }
      break
    case 'add_milestone_task':
      toolName = 'add_milestone_task'
      toolArgs = { milestone_id: positional[0], label: positional[1] || '', ...flags }
      break
    case 'register_agent':
      toolName = 'register_agent'
      toolArgs = {
        agent_id: positional[0],
        name: positional[1] || '',
        type: positional[2] || 'sub-agent',
        permissions: flags.permissions || [],
        color: flags.color,
        parent_id: flags.parent_id,
      }
      break
    default:
      process.stderr.write(`Unknown command: ${command}\n`)
      process.exit(1)
  }

  const result = await handleTool(toolName, toolArgs)

  for (const item of result.content) {
    if (item.type === 'text') {
      if (result.isError) {
        process.stderr.write(item.text + '\n')
      } else {
        process.stdout.write(item.text + '\n')
      }
    }
  }

  if (result.isError) {
    process.exit(1)
  }
}

main().catch(err => {
  process.stderr.write(`Error: ${err}\n`)
  process.exit(1)
})
