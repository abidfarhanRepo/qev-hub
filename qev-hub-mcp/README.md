# QEV Hub MCP Server

Model Context Protocol server for QEV Hub - Enables AI assistants to interact with the EV marketplace and order tracking system.

## Features

This MCP server provides tools to:
- **Search Vehicles**: Browse and filter electric vehicles in the marketplace
- **Get Vehicle Details**: View detailed specifications and pricing
- **Get Orders**: Retrieve order information and history
- **Track Orders**: Get real-time order status and tracking information
- **Update Order Status**: Admin function to update order progress
- **Get User Profile**: Retrieve user information
- **Get Analytics**: Access order statistics and metrics
- **Get Sustainability Metrics**: View environmental impact data

## Installation

```bash
# Install dependencies
npm install

# Build the project
npm run build
```

## Configuration

1. Copy `.env.example` to `.env`:
```bash
cp .env.example .env
```

2. Fill in your Supabase credentials:
```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
```

**Important**: Use the **service role key** (not anon key) for the MCP server to have admin-level access.

## Usage

### Running Locally

```bash
# Development mode (auto-rebuild on changes)
npm run watch

# In another terminal, start the server
npm start
```

### Configure in Claude Desktop

Add to your Claude Desktop config (`~/Library/Application Support/Claude/claude_desktop_config.json` on macOS):

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

### Configure in VS Code (Cline/Continue)

Add to your MCP settings:

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

## Available Tools

### `search_vehicles`
Search and filter vehicles in the marketplace.

**Parameters**:
- `manufacturer` (optional): Filter by manufacturer
- `minPrice` (optional): Minimum price in QAR
- `maxPrice` (optional): Maximum price in QAR
- `availableOnly` (optional): Show only available vehicles (default: true)

**Example**:
```typescript
{
  "manufacturer": "Tesla",
  "maxPrice": 200000,
  "availableOnly": true
}
```

### `get_vehicle`
Get detailed information about a specific vehicle.

**Parameters**:
- `vehicleId`: UUID of the vehicle

### `get_orders`
Get orders (all orders for admin, user's orders for consumers).

**Parameters**:
- `userId` (optional): Filter by user ID
- `status` (optional): Filter by order status
- `limit` (optional): Maximum number of results (default: 50)

### `get_order_tracking`
Get detailed tracking information for an order.

**Parameters**:
- `orderId` or `trackingId`: Order identifier

### `update_order_status`
Update the status of an order (admin only).

**Parameters**:
- `orderId`: Order UUID
- `status`: New status
- `location` (optional): Current location
- `notes` (optional): Status update notes
- `documentUrl` (optional): Document URL for this stage

### `get_user_profile`
Get user profile information.

**Parameters**:
- `userId`: User UUID

### `get_order_analytics`
Get order statistics and analytics.

**Parameters**:
- `startDate` (optional): Start date for analytics
- `endDate` (optional): End date for analytics

### `get_sustainability_metrics`
Get environmental impact metrics for vehicles.

**Parameters**:
- `vehicleId` (optional): Filter by specific vehicle

## Development

```bash
# Watch mode (rebuilds on file changes)
npm run watch

# Build once
npm run build

# Run the server
npm start
```

## Security Notes

- The MCP server uses the **service role key** which bypasses Row Level Security
- Keep your `.env` file secure and never commit it to version control
- The server should only be run in trusted environments
- Consider implementing additional authentication if exposing over network

## License

Proprietary - All rights reserved
