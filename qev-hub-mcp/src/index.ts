#!/usr/bin/env node

import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
  Tool,
} from "@modelcontextprotocol/sdk/types.js";
import { createClient, SupabaseClient } from "@supabase/supabase-js";
import dotenv from "dotenv";

// Load environment variables
dotenv.config();

const SUPABASE_URL = process.env.SUPABASE_URL!;
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY!;

if (!SUPABASE_URL || !SUPABASE_SERVICE_ROLE_KEY) {
  console.error("Error: SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY must be set");
  process.exit(1);
}

// Initialize Supabase client with service role key
const supabase: SupabaseClient = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

// Define available tools
const TOOLS: Tool[] = [
  {
    name: "search_vehicles",
    description: "Search and filter vehicles in the QEV Hub marketplace. Returns available EVs with pricing and specifications.",
    inputSchema: {
      type: "object",
      properties: {
        manufacturer: {
          type: "string",
          description: "Filter by manufacturer name (e.g., Tesla, BYD, Nissan)",
        },
        minPrice: {
          type: "number",
          description: "Minimum price in QAR",
        },
        maxPrice: {
          type: "number",
          description: "Maximum price in QAR",
        },
        availableOnly: {
          type: "boolean",
          description: "Show only available vehicles (default: true)",
          default: true,
        },
      },
    },
  },
  {
    name: "get_vehicle",
    description: "Get detailed information about a specific vehicle by ID",
    inputSchema: {
      type: "object",
      properties: {
        vehicleId: {
          type: "string",
          description: "UUID of the vehicle",
        },
      },
      required: ["vehicleId"],
    },
  },
  {
    name: "get_orders",
    description: "Get orders from the system. Can filter by user, status, and limit results.",
    inputSchema: {
      type: "object",
      properties: {
        userId: {
          type: "string",
          description: "Filter orders by user ID (UUID)",
        },
        status: {
          type: "string",
          description: "Filter by order status",
          enum: [
            "pending",
            "confirmed",
            "shipped",
            "in_customs",
            "fahes_inspection",
            "insurance_processing",
            "out_for_delivery",
            "completed",
            "cancelled",
          ],
        },
        limit: {
          type: "number",
          description: "Maximum number of orders to return (default: 50)",
          default: 50,
        },
      },
    },
  },
  {
    name: "get_order_tracking",
    description: "Get detailed tracking information for a specific order, including status history and timeline",
    inputSchema: {
      type: "object",
      properties: {
        orderId: {
          type: "string",
          description: "Order UUID",
        },
        trackingId: {
          type: "string",
          description: "Order tracking ID (alternative to orderId)",
        },
      },
    },
  },
  {
    name: "update_order_status",
    description: "Update the status of an order (admin function). Creates a new entry in status history.",
    inputSchema: {
      type: "object",
      properties: {
        orderId: {
          type: "string",
          description: "Order UUID",
        },
        status: {
          type: "string",
          description: "New order status",
          enum: [
            "pending",
            "confirmed",
            "shipped",
            "in_customs",
            "fahes_inspection",
            "insurance_processing",
            "out_for_delivery",
            "completed",
            "cancelled",
          ],
        },
        location: {
          type: "string",
          description: "Current location of the order",
        },
        notes: {
          type: "string",
          description: "Additional notes about the status update",
        },
        documentUrl: {
          type: "string",
          description: "URL to document related to this status",
        },
      },
      required: ["orderId", "status"],
    },
  },
  {
    name: "get_user_profile",
    description: "Get user profile information by user ID",
    inputSchema: {
      type: "object",
      properties: {
        userId: {
          type: "string",
          description: "User UUID",
        },
      },
      required: ["userId"],
    },
  },
  {
    name: "get_order_analytics",
    description: "Get order statistics and analytics including total orders, revenue, and status breakdown",
    inputSchema: {
      type: "object",
      properties: {
        startDate: {
          type: "string",
          description: "Start date for analytics (ISO 8601 format)",
        },
        endDate: {
          type: "string",
          description: "End date for analytics (ISO 8601 format)",
        },
      },
    },
  },
  {
    name: "get_sustainability_metrics",
    description: "Get environmental impact and sustainability metrics for vehicles",
    inputSchema: {
      type: "object",
      properties: {
        vehicleId: {
          type: "string",
          description: "Filter by specific vehicle UUID (optional)",
        },
      },
    },
  },
];

// Create MCP server
const server = new Server(
  {
    name: "qev-hub-mcp",
    version: "1.0.0",
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

// Handle list tools request
server.setRequestHandler(ListToolsRequestSchema, async () => {
  return { tools: TOOLS };
});

// Handle tool execution
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  try {
    switch (name) {
      case "search_vehicles": {
        const params = args as any;
        let query = supabase.from("vehicles").select("*");

        if (params?.manufacturer) {
          query = query.ilike("manufacturer", `%${params.manufacturer}%`);
        }
        if (params?.minPrice) {
          query = query.gte("manufacturer_price_qar", params.minPrice);
        }
        if (params?.maxPrice) {
          query = query.lte("manufacturer_price_qar", params.maxPrice);
        }
        if (params?.availableOnly !== false) {
          query = query.eq("available", true);
        }

        const { data, error } = await query.order("manufacturer_price_qar");

        if (error) throw error;

        return {
          content: [
            {
              type: "text",
              text: JSON.stringify(
                {
                  success: true,
                  count: data.length,
                  vehicles: data,
                },
                null,
                2
              ),
            },
          ],
        };
      }

      case "get_vehicle": {
        const params = args as any;
        const { data, error } = await supabase
          .from("vehicles")
          .select("*")
          .eq("id", params?.vehicleId)
          .single();

        if (error) throw error;

        return {
          content: [
            {
              type: "text",
              text: JSON.stringify({ success: true, vehicle: data }, null, 2),
            },
          ],
        };
      }

      case "get_orders": {
        const params = args as any;
        let query = supabase
          .from("orders")
          .select("*, vehicles(manufacturer, model, year)");

        if (params?.userId) {
          query = query.eq("user_id", params.userId);
        }
        if (params?.status) {
          query = query.eq("status", params.status);
        }

        const limit = params?.limit || 50;
        query = query.limit(limit).order("created_at", { ascending: false });

        const { data, error } = await query;

        if (error) throw error;

        return {
          content: [
            {
              type: "text",
              text: JSON.stringify(
                { success: true, count: data.length, orders: data },
                null,
                2
              ),
            },
          ],
        };
      }

      case "get_order_tracking": {
        const params = args as any;
        let orderQuery;

        if (params?.orderId) {
          orderQuery = supabase
            .from("orders")
            .select("*, vehicles(manufacturer, model, year)")
            .eq("id", params.orderId)
            .single();
        } else if (params?.trackingId) {
          orderQuery = supabase
            .from("orders")
            .select("*, vehicles(manufacturer, model, year)")
            .eq("tracking_id", params.trackingId)
            .single();
        } else {
          throw new Error("Either orderId or trackingId must be provided");
        }

        const { data: order, error: orderError } = await orderQuery;
        if (orderError) throw orderError;

        // Get status history
        const { data: history, error: historyError } = await supabase
          .from("order_status_history")
          .select("*")
          .eq("order_id", order.id)
          .order("created_at", { ascending: true });

        if (historyError) throw historyError;

        return {
          content: [
            {
              type: "text",
              text: JSON.stringify(
                {
                  success: true,
                  order,
                  statusHistory: history,
                  currentStage: getOrderStage(order.status),
                },
                null,
                2
              ),
            },
          ],
        };
      }

      case "update_order_status": {
        const params = args as any;
        // Update order status
        const { error: updateError } = await supabase
          .from("orders")
          .update({ status: params?.status })
          .eq("id", params?.orderId);

        if (updateError) throw updateError;

        // Add to status history
        const { error: historyError } = await supabase
          .from("order_status_history")
          .insert({
            order_id: params?.orderId,
            status: params?.status,
            location: params?.location,
            notes: params?.notes,
            document_url: params?.documentUrl,
          });

        if (historyError) throw historyError;

        return {
          content: [
            {
              type: "text",
              text: JSON.stringify(
                {
                  success: true,
                  message: `Order ${params?.orderId} status updated to ${params?.status}`,
                },
                null,
                2
              ),
            },
          ],
        };
      }

      case "get_user_profile": {
        const params = args as any;
        const { data, error } = await supabase
          .from("profiles")
          .select("*")
          .eq("id", params?.userId)
          .single();

        if (error) throw error;

        return {
          content: [
            {
              type: "text",
              text: JSON.stringify({ success: true, profile: data }, null, 2),
            },
          ],
        };
      }

      case "get_order_analytics": {
        const params = args as any;
        let query = supabase.from("orders").select("*");

        if (params?.startDate) {
          query = query.gte("created_at", params.startDate);
        }
        if (params?.endDate) {
          query = query.lte("created_at", params.endDate);
        }

        const { data, error } = await query;

        if (error) throw error;

        // Calculate analytics
        const totalOrders = data.length;
        const totalRevenue = data.reduce(
          (sum, order) => sum + Number(order.total_price_qar),
          0
        );
        const statusBreakdown = data.reduce((acc: any, order) => {
          acc[order.status] = (acc[order.status] || 0) + 1;
          return acc;
        }, {});

        return {
          content: [
            {
              type: "text",
              text: JSON.stringify(
                {
                  success: true,
                  analytics: {
                    totalOrders,
                    totalRevenue,
                    averageOrderValue: totalOrders > 0 ? totalRevenue / totalOrders : 0,
                    statusBreakdown,
                  },
                },
                null,
                2
              ),
            },
          ],
        };
      }

      case "get_sustainability_metrics": {
        const params = args as any;
        let query = supabase
          .from("sustainability_metrics")
          .select("*, vehicles(manufacturer, model, year)");

        if (params?.vehicleId) {
          query = query.eq("vehicle_id", params.vehicleId);
        }

        const { data, error } = await query;

        if (error) throw error;

        return {
          content: [
            {
              type: "text",
              text: JSON.stringify(
                { success: true, count: data.length, metrics: data },
                null,
                2
              ),
            },
          ],
        };
      }

      default:
        throw new Error(`Unknown tool: ${name}`);
    }
  } catch (error: any) {
    return {
      content: [
        {
          type: "text",
          text: JSON.stringify(
            {
              success: false,
              error: error.message || "Unknown error occurred",
            },
            null,
            2
          ),
        },
      ],
      isError: true,
    };
  }
});

// Helper function to get order stage number
function getOrderStage(status: string): number {
  const stages: Record<string, number> = {
    pending: 1,
    confirmed: 2,
    shipped: 3,
    in_customs: 4,
    fahes_inspection: 5,
    insurance_processing: 6,
    out_for_delivery: 7,
    completed: 8,
  };
  return stages[status] || 0;
}

// Start the server
async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error("QEV Hub MCP Server running on stdio");
}

main().catch((error) => {
  console.error("Fatal error:", error);
  process.exit(1);
});
