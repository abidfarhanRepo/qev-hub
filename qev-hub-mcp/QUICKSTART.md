# QEV Hub MCP Server - Quick Reference

## What is it?

The QEV Hub MCP (Model Context Protocol) server enables AI assistants like Claude to interact with your QEV Hub database through natural language conversations.

## What can it do?

### 🔍 Search & Browse
- Search vehicles by manufacturer, price, availability
- Get detailed vehicle specifications
- View sustainability metrics

### 📦 Order Management
- View all orders or filter by user/status
- Track order progress through 8 stages
- Update order status (admin only)
- Add notes and documents to orders

### 👤 User Management
- Get user profile information
- View user roles and details

### 📊 Analytics
- Get order statistics and revenue
- View order status breakdown
- Calculate average order values
- Filter analytics by date range

## Example Conversations

### Search Vehicles
```
You: "Show me all Tesla vehicles available"
AI: [Queries database and shows results]

You: "Which EVs are under 150,000 QAR?"
AI: [Filters by price and displays matches]
```

### Track Orders
```
You: "What's the status of order ABC-123?"
AI: [Shows current status and full timeline]

You: "List all orders in customs"
AI: [Filters orders by status]
```

### Update Orders (Admin)
```
You: "Update order XYZ to 'shipped' status"
AI: [Updates database and creates status history entry]

You: "Add note to order ABC: 'Vehicle cleared FAHES inspection'"
AI: [Adds note to order history]
```

### Analytics
```
You: "How many orders were completed last month?"
AI: [Queries analytics and provides report]

You: "What's our total revenue?"
AI: [Calculates sum from all orders]
```

## Setup in 3 Steps

### 1. Build the Server
```bash
cd /home/pi/Desktop/QEV/qev-hub-mcp
npm install
npm run build
```

### 2. Configure Environment
```bash
cp .env.example .env
# Edit .env with your Supabase credentials
```

### 3. Connect to AI Assistant

**Claude Desktop** (macOS: `~/Library/Application Support/Claude/claude_desktop_config.json`)
```json
{
  "mcpServers": {
    "qev-hub": {
      "command": "node",
      "args": ["/home/pi/Desktop/QEV/qev-hub-mcp/dist/index.js"],
      "env": {
        "SUPABASE_URL": "your-url",
        "SUPABASE_SERVICE_ROLE_KEY": "your-key"
      }
    }
  }
}
```

**VS Code Cline**: Add similar config in extension settings

## Available Tools

| Tool | Description | Admin Only |
|------|-------------|------------|
| `search_vehicles` | Search marketplace | No |
| `get_vehicle` | Get vehicle details | No |
| `get_orders` | View orders | No* |
| `get_order_tracking` | Track order status | No |
| `update_order_status` | Change order status | **Yes** |
| `get_user_profile` | View user info | No |
| `get_order_analytics` | View statistics | No |
| `get_sustainability_metrics` | Environmental data | No |

*Users see only their orders; admins see all

## Security

⚠️ **Important**:
- Uses **service role key** (bypasses RLS)
- Keep `.env` file secure
- Never commit credentials
- Only run in trusted environments

## Testing

Test the server:
```bash
cd /home/pi/Desktop/QEV/qev-hub-mcp
npm start
```

Should display: `QEV Hub MCP Server running on stdio`

## Need Help?

- **Full Documentation**: [DOCUMENTATION.md](../DOCUMENTATION.md)
- **Setup Guide**: [SETUP.md](SETUP.md)
- **MCP Server README**: [README.md](README.md)
- **GitHub**: https://github.com/abidfarhanRepo/qev-hub

## Architecture

```
┌─────────────┐
│ AI Assistant│
│  (Claude)   │
└──────┬──────┘
       │ MCP Protocol
       │
┌──────▼──────┐
│  MCP Server │
│  (Node.js)  │
└──────┬──────┘
       │ Supabase Client
       │
┌──────▼──────┐
│  Supabase   │
│  Database   │
└─────────────┘
```

The MCP server acts as a bridge between your AI assistant and the Supabase database, translating natural language into database queries.

## Status

✅ **Complete and Working**
- All 8 tools implemented
- TypeScript compilation successful
- Ready to use with Claude Desktop or VS Code
- Pushed to GitHub repository

## Next Steps

1. Get your Supabase credentials
2. Configure the MCP server
3. Connect to Claude Desktop or VS Code
4. Start querying your database through conversation!

---

**Last Updated**: January 1, 2026
**Version**: 1.0.0
**Repository**: https://github.com/abidfarhanRepo/qev-hub
