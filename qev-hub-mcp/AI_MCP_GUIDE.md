# MCP Server Guide for AI Agents

> **For**: LLMs and AI assistants (GPT-4, Claude, GLM-4, DeepSeek, Gemini, etc.)  
> **Purpose**: Understand and extend the QEV Hub MCP server

---

## What This MCP Server Does

This is a **Model Context Protocol (MCP)** server that bridges AI assistants to the QEV Hub database. It allows natural language queries to be translated into database operations.

**Example Interaction**:
```
User: "Show me all Tesla vehicles under 200,000 QAR"
AI: [Calls search_vehicles tool with filters]
Server: [Queries Supabase database]
AI: [Formats results for user]
```

---

## Architecture

```
┌─────────────────┐
│  AI Assistant   │ ← You (Claude, GPT-4, GLM-4, etc.)
│  (Any LLM)      │
└────────┬────────┘
         │ MCP Protocol (stdio)
         │
┌────────▼────────┐
│   MCP Server    │ ← This codebase (src/index.ts)
│   (Node.js)     │
└────────┬────────┘
         │ @supabase/supabase-js
         │
┌────────▼────────┐
│   Supabase      │ ← PostgreSQL + RLS + Realtime
│   (Database)    │
└─────────────────┘
```

---

## Tool Inventory

### 1. search_vehicles
**Purpose**: Search EV marketplace  
**Parameters**:
- `manufacturer` (string, optional) - Filter by brand
- `minPrice` (number, optional) - Minimum price in QAR
- `maxPrice` (number, optional) - Maximum price in QAR
- `availableOnly` (boolean, optional) - Show only available

**Example Query**:
```typescript
{
  manufacturer: "Tesla",
  maxPrice: 200000,
  availableOnly: true
}
```

**Database Query**:
```sql
SELECT * FROM vehicles 
WHERE manufacturer ILIKE '%Tesla%'
  AND manufacturer_price_qar <= 200000
  AND available = true
ORDER BY manufacturer_price_qar;
```

**Use When**: User asks about vehicles, pricing, availability

---

### 2. get_vehicle
**Purpose**: Get detailed vehicle info  
**Parameters**:
- `vehicleId` (string, required) - UUID of vehicle

**Example Query**:
```typescript
{
  vehicleId: "a1b2c3d4-e5f6-7890-abcd-ef1234567890"
}
```

**Use When**: User asks for specs, details of a specific vehicle

---

### 3. get_orders
**Purpose**: Retrieve orders  
**Parameters**:
- `userId` (string, optional) - Filter by user UUID
- `status` (string, optional) - Filter by order status
- `limit` (number, optional) - Max results (default: 50)

**Example Query**:
```typescript
{
  status: "shipped",
  limit: 10
}
```

**Database Query**:
```sql
SELECT orders.*, vehicles.manufacturer, vehicles.model, vehicles.year
FROM orders
JOIN vehicles ON orders.vehicle_id = vehicles.id
WHERE status = 'shipped'
ORDER BY created_at DESC
LIMIT 10;
```

**Use When**: User asks about orders, order history, order status

---

### 4. get_order_tracking
**Purpose**: Get order tracking details  
**Parameters**:
- `orderId` (string) - Order UUID
- `trackingId` (string) - Tracking ID (e.g., "QEV-12345")

**Note**: Provide either `orderId` OR `trackingId`

**Returns**:
- Order details
- Status history (all status changes)
- Current stage (1-8)

**Use When**: User asks "where is my order", "track order", "order status"

---

### 5. update_order_status
**Purpose**: Update order status (admin function)  
**Parameters**:
- `orderId` (string, required) - Order UUID
- `status` (string, required) - New status
- `location` (string, optional) - Current location
- `notes` (string, optional) - Update notes
- `documentUrl` (string, optional) - Document URL

**Status Values**:
- `pending`
- `confirmed`
- `shipped`
- `in_customs`
- `fahes_inspection`
- `insurance_processing`
- `out_for_delivery`
- `completed`
- `cancelled`

**Database Operations**:
1. Updates `orders.status`
2. Inserts into `order_status_history`

**Use When**: Admin requests status update

⚠️ **Security**: This is an admin-only operation in the app, but MCP uses service role key so bypasses RLS

---

### 6. get_user_profile
**Purpose**: Get user profile  
**Parameters**:
- `userId` (string, required) - User UUID

**Returns**: Full profile including role

**Use When**: User asks about profile, user info, account details

---

### 7. get_order_analytics
**Purpose**: Generate order statistics  
**Parameters**:
- `startDate` (string, optional) - ISO 8601 date
- `endDate` (string, optional) - ISO 8601 date

**Returns**:
- Total orders
- Total revenue
- Average order value
- Status breakdown

**Example Query**:
```typescript
{
  startDate: "2026-01-01T00:00:00Z",
  endDate: "2026-01-31T23:59:59Z"
}
```

**Use When**: User asks for reports, statistics, analytics

---

### 8. get_sustainability_metrics
**Purpose**: Get environmental impact data  
**Parameters**:
- `vehicleId` (string, optional) - Filter by vehicle

**Returns**: CO2 savings, energy consumption per vehicle

**Use When**: User asks about environmental impact, sustainability

---

## Implementation Pattern

All tools follow this pattern in `src/index.ts`:

```typescript
case "tool_name": {
  const params = args as any;
  
  // 1. Build query
  let query = supabase.from('table').select('*');
  
  // 2. Apply filters
  if (params?.filter) {
    query = query.eq('column', params.filter);
  }
  
  // 3. Execute query
  const { data, error } = await query;
  
  // 4. Handle error
  if (error) throw error;
  
  // 5. Return formatted response
  return {
    content: [{
      type: "text",
      text: JSON.stringify({ success: true, data }, null, 2)
    }]
  };
}
```

---

## Database Tables Reference

### vehicles
```typescript
{
  id: UUID
  manufacturer: string         // e.g., "Tesla"
  model: string               // e.g., "Model 3"
  year: number                // e.g., 2024
  range_km: number            // e.g., 500
  manufacturer_price_qar: number  // Direct price (lower)
  broker_price_qar: number       // Traditional price (higher)
  available: boolean
}
```

### orders
```typescript
{
  id: UUID
  user_id: UUID
  vehicle_id: UUID
  tracking_id: string         // e.g., "QEV-12345"
  status: OrderStatus
  total_price_qar: number
  shipping_address: string
  created_at: timestamp
}
```

### order_status_history
```typescript
{
  id: UUID
  order_id: UUID
  status: OrderStatus
  location: string            // e.g., "Doha Port"
  notes: string
  document_url: string
  created_at: timestamp
}
```

### profiles
```typescript
{
  id: UUID                    // Matches auth.users.id
  email: string
  full_name: string
  phone: string
  role: 'consumer' | 'manufacturer' | 'admin'
}
```

---

## Error Handling

All tools follow this pattern:

```typescript
try {
  // Database operation
} catch (error: any) {
  return {
    content: [{
      type: "text",
      text: JSON.stringify({
        success: false,
        error: error.message || "Unknown error"
      }, null, 2)
    }],
    isError: true
  }
}
```

**Common Errors**:
- "Invalid credentials" - Check SUPABASE_URL and key
- "Permission denied" - Check service role key (not anon key)
- "Row not found" - Invalid ID provided
- "Connection refused" - Supabase project not running

---

## Adding New Tools

To add a new tool:

1. **Add to TOOLS array**:
```typescript
{
  name: "new_tool",
  description: "What it does",
  inputSchema: {
    type: "object",
    properties: {
      param1: { type: "string", description: "..." }
    },
    required: ["param1"]
  }
}
```

2. **Add case in switch statement**:
```typescript
case "new_tool": {
  const params = args as any;
  // Implementation
  return { content: [...] }
}
```

3. **Rebuild**:
```bash
npm run build
```

4. **Test**:
```bash
npm start
# Use AI assistant to call new tool
```

---

## Environment Setup

### Required Environment Variables

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_ROLE_KEY=eyJhbGc...  # ⚠️ Service role, not anon
```

**Why Service Role Key?**
- Bypasses Row Level Security (RLS)
- Allows reading all data for AI queries
- Required for admin operations

⚠️ **Security**: Service role key grants full database access. Only use in trusted environments.

---

## Testing the Server

### Start Server
```bash
cd qev-hub-mcp
npm run build
npm start
```

**Expected Output**:
```
QEV Hub MCP Server running on stdio
```

### Test with Claude Desktop

1. Configure `claude_desktop_config.json`:
```json
{
  "mcpServers": {
    "qev-hub": {
      "command": "node",
      "args": ["/path/to/qev-hub-mcp/dist/index.js"],
      "env": {
        "SUPABASE_URL": "your-url",
        "SUPABASE_SERVICE_ROLE_KEY": "your-key"
      }
    }
  }
}
```

2. Restart Claude Desktop

3. Ask: "Search for Tesla vehicles in QEV Hub"

4. Claude will use the MCP tools automatically

---

## Debugging

### Enable Verbose Logging

Add to `src/index.ts`:
```typescript
console.error('Tool called:', name)
console.error('Arguments:', JSON.stringify(args, null, 2))
```

**Note**: Use `console.error()` not `console.log()` - stdout is used for MCP protocol

### Check Database Connection

```typescript
// Add to main() function
const { data, error } = await supabase.from('vehicles').select('count')
console.error('DB Connection:', error ? 'Failed' : 'Success')
```

### Common Issues

1. **"Cannot find module"**
   - Run `npm install`
   - Check `node_modules` exists

2. **"TypeScript errors"**
   - Run `npm run build`
   - Check `tsconfig.json`

3. **"Connection refused"**
   - Check SUPABASE_URL is correct
   - Verify Supabase project is active

4. **"Permission denied"**
   - Using service role key (not anon)?
   - Check key in environment variables

---

## Integration with Other LLMs

### GPT-4 / ChatGPT
- Not natively supported yet
- Can use via custom MCP client

### Claude Desktop
- ✅ Native MCP support
- Configure in `claude_desktop_config.json`

### VS Code Extensions
- ✅ Cline - Supports MCP
- ✅ Continue - Supports MCP
- Configure in extension settings

### OpenCode GLM-4
- Check if supports MCP protocol
- If yes: Same config as Claude
- If no: Can expose as REST API wrapper

### DeepSeek
- Check MCP support
- Alternative: Use as subprocess and parse stdout/stdin

### Custom Integration
```python
# Example Python wrapper
import subprocess
import json

def query_mcp(tool, params):
    process = subprocess.Popen(
        ['node', 'dist/index.js'],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE
    )
    
    request = {
        "jsonrpc": "2.0",
        "method": "tools/call",
        "params": {
            "name": tool,
            "arguments": params
        }
    }
    
    stdout, stderr = process.communicate(
        json.dumps(request).encode()
    )
    
    return json.loads(stdout)
```

---

## Performance Considerations

### Query Optimization
- Use filters to limit results
- Always use `limit` parameter for large tables
- Join tables in single query when possible

### Caching (Future Enhancement)
```typescript
// Could add simple cache
const cache = new Map()

case "get_vehicle": {
  const cached = cache.get(params.vehicleId)
  if (cached) return cached
  
  // ... fetch from database
  cache.set(params.vehicleId, result)
  return result
}
```

### Rate Limiting (Future Enhancement)
Consider adding rate limiting for production use.

---

## Security Best Practices

1. **Never expose service role key in client apps**
2. **Run MCP server only in trusted environments**
3. **Validate all input parameters**
4. **Sanitize data before returning**
5. **Consider adding authentication layer**

---

## Extending for Other Databases

To adapt this MCP server for other databases:

1. **Replace Supabase client**:
```typescript
// Instead of:
import { createClient } from '@supabase/supabase-js'

// Use:
import pg from 'pg'
const client = new pg.Client(connectionString)
```

2. **Adapt query syntax**:
```typescript
// Supabase style:
await supabase.from('table').select('*')

// PostgreSQL style:
await client.query('SELECT * FROM table')
```

3. **Handle authentication differently**
(Supabase RLS vs custom auth)

---

## Resources

- **MCP Specification**: https://modelcontextprotocol.io/
- **Supabase Docs**: https://supabase.com/docs
- **TypeScript Handbook**: https://www.typescriptlang.org/docs/

---

## Quick Commands

```bash
# Install dependencies
npm install

# Build TypeScript
npm run build

# Start server
npm start

# Watch mode (auto-rebuild)
npm run watch

# Check TypeScript errors
npx tsc --noEmit
```

---

**This guide should help any LLM understand and work with the MCP server.**

For broader codebase context, see:
- [../AI_CONTEXT.md](../AI_CONTEXT.md) - Full project context
- [../CODEBASE_MAP.md](../CODEBASE_MAP.md) - File navigation
- [../DOCUMENTATION.md](../DOCUMENTATION.md) - Technical docs
