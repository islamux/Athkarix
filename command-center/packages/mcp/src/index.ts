#!/usr/bin/env node

import { Server } from '@modelcontextprotocol/sdk/server/index.js'
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js'
import { ListToolsRequestSchema, CallToolRequestSchema } from '@modelcontextprotocol/sdk/types.js'
import { handleTool, getToolDefinitions } from './tools.js'

async function main() {
  const server = new Server(
    { name: 'command-center', version: '1.0.0' },
    { capabilities: { tools: {} } },
  )

  server.setRequestHandler(ListToolsRequestSchema, async () => ({
    tools: getToolDefinitions(),
  }))

  server.setRequestHandler(CallToolRequestSchema, async (request) => {
    const { name, arguments: args } = request.params
    return await handleTool(name, args ?? {})
  })

  const transport = new StdioServerTransport()
  await server.connect(transport)

  process.stderr.write('command-center MCP server running on stdio\n')
}

main().catch(err => {
  process.stderr.write(`Fatal: ${err}\n`)
  process.exit(1)
})
