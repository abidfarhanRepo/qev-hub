# QEV Hub MCP Server Setup Guide

## Step 1: Get Your Supabase Credentials

1. Go to your Supabase project dashboard: https://supabase.com/dashboard
2. Click on your **QEV Hub** project
3. Navigate to **Settings** → **API**
4. Copy the following:
   - **Project URL**: `https://your-project.supabase.co`
   - **service_role key** (⚠️ Secret key - keep secure!)

## Step 2: Create Environment File

```bash
cd /home/pi/Desktop/QEV/qev-hub-mcp
cp .env.example .env
```

Edit `.env` and add your credentials:
```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key-here
```

## Step 3: Test the MCP Server

```bash
cd /home/pi/Desktop/QEV/qev-hub-mcp
npm start
```

The server should start and display: `QEV Hub MCP Server running on stdio`

Press `Ctrl+C` to stop.

## Step 4: Configure in Your AI Assistant

### For Claude Desktop (macOS)

Edit: `~/Library/Application Support/Claude/claude_desktop_config.json`

```json
{
  "mcpServers": {
    "qev-hub": {
      "command": "node",
      "args": ["/home/pi/Desktop/QEV/qev-hub-mcp/dist/index.js"],
      "env": {
        "SUPABASE_URL": "https://your-project.supabase.co",
        "SUPABASE_SERVICE_ROLE_KEY": "your-service-role-key"
      }
    }
  }
}
```

### For Claude Desktop (Linux)

Edit: `~/.config/Claude/claude_desktop_config.json`

```json
{
  "mcpServers": {
    "qev-hub": {
      "command": "node",
      "args": ["/home/pi/Desktop/QEV/qev-hub-mcp/dist/index.js"],
      "env": {
        "SUPABASE_URL": "https://your-project.supabase.co",
        "SUPABASE_SERVICE_ROLE_KEY": "your-service-role-key"
      }
    }
  }
}
```

### For VS Code (Cline Extension)

Open Cline settings and add MCP server:

```json
{
  "mcpServers": {
    "qev-hub": {
      "command": "node",
      "args": ["/home/pi/Desktop/QEV/qev-hub-mcp/dist/index.js"],
      "env": {
        "SUPABASE_URL": "https://your-project.supabase.co",
        "SUPABASE_SERVICE_ROLE_KEY": "your-service-role-key"
      }
    }
  }
}
```

## Step 5: Restart Your AI Assistant

- **Claude Desktop**: Quit and reopen the application
- **VS Code**: Reload window (Cmd/Ctrl + Shift + P → "Developer: Reload Window")

## Step 6: Test the MCP Tools

Ask your AI assistant:

```
"Search for Tesla vehicles in the QEV Hub marketplace"
```

or

```
"Show me all pending orders in the QEV Hub system"
```

## Available Commands

Once configured, you can ask your AI assistant to:

✅ **Search vehicles**: "Find EVs under 200,000 QAR"
✅ **Get vehicle details**: "Show me details for vehicle ID xyz"
✅ **View orders**: "List all orders with status 'shipped'"
✅ **Track orders**: "Get tracking info for order xyz"
✅ **Update status** (admin): "Update order xyz to 'in_customs'"
✅ **View profiles**: "Get profile for user xyz"
✅ **Get analytics**: "Show order statistics for last month"
✅ **Sustainability**: "Get CO2 savings for all vehicles"

## Troubleshooting

### Server won't start
- Check that Node.js is installed: `node --version`
- Verify dependencies are installed: `npm install`
- Check that build succeeded: `npm run build`

### "Connection refused" errors
- Verify Supabase URL and key are correct
- Check Supabase project is running
- Test connection: `node scripts/test-connection.js` (if available)

### Tools not showing up
- Restart your AI assistant completely
- Check config file path is correct
- Verify JSON syntax in config file
- Check server logs for errors

### Permission denied
- Make sure the dist/index.js file exists
- Check file permissions: `ls -la dist/index.js`
- Ensure Node.js path is correct: `which node`

## Security Notes

⚠️ **Important**:
- Never commit your `.env` file
- Never share your service role key
- Service role key bypasses Row Level Security
- Only run MCP server in trusted environments
- Consider using read-only credentials if possible

## Next Steps

Once the MCP server is working, you can:

1. **Query your database** through natural language
2. **Automate order updates** through AI conversations
3. **Generate reports** by asking for analytics
4. **Monitor system** through AI-powered insights

Need help? Check the [main documentation](../DOCUMENTATION.md) or the [README](README.md).
