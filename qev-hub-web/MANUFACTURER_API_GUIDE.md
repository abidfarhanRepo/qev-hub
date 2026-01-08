# Manufacturer API Integration Guide

## Overview
QEV Hub provides REST API endpoints for verified manufacturers to sync their inventory, update pricing, and manage vehicle availability in real-time.

## Base URL
```
Production: https://qev-hub.com/api
Development: http://localhost:3000/api
```

## Authentication
All API requests require a manufacturer authentication token. Contact QEV Hub admin to obtain your API credentials after verification.

Include the token in the `Authorization` header:
```
Authorization: Bearer YOUR_MANUFACTURER_TOKEN
```

---

## Endpoints

### 1. Get Current Inventory
Retrieve all vehicles currently listed for your manufacturer account.

**Endpoint:** `GET /manufacturers/{manufacturer_id}/inventory`

**Response:**
```json
{
  "success": true,
  "inventory": [
    {
      "id": "uuid",
      "model": "ES8",
      "year": 2024,
      "vehicle_type": "EV",
      "stock_count": 8,
      "price_qar": 210000,
      "manufacturer_direct_price": 210000,
      "broker_market_price": 273000,
      "status": "available"
    }
  ],
  "total_vehicles": 10,
  "in_stock": 8
}
```

---

### 2. Update Specific Vehicles
Update stock levels, pricing, or status for specific vehicles.

**Endpoint:** `PUT /manufacturers/{manufacturer_id}/inventory`

**Request Body:**
```json
{
  "vehicles": [
    {
      "id": "vehicle-uuid-1",
      "stock_count": 5,
      "price_qar": 215000,
      "manufacturer_direct_price": 215000,
      "status": "available"
    },
    {
      "id": "vehicle-uuid-2",
      "stock_count": 0,
      "status": "out_of_stock"
    }
  ]
}
```

**Response:**
```json
{
  "success": true,
  "updated": 2,
  "errors": null,
  "vehicles": [...]
}
```

---

### 3. Bulk Inventory Sync
Synchronize your entire inventory catalog. This will create new vehicles or update existing ones based on model + year matching.

**Endpoint:** `POST /manufacturers/{manufacturer_id}/inventory`

**Request Body:**
```json
{
  "sync_timestamp": "2026-01-08T10:30:00Z",
  "vehicles": [
    {
      "external_id": "YOUR_INTERNAL_ID",
      "model": "ES8",
      "year": 2024,
      "vehicle_type": "EV",
      "range_km": 500,
      "battery_kwh": 75.0,
      "price_qar": 210000,
      "manufacturer_direct_price": 210000,
      "broker_market_price": 273000,
      "stock_count": 8,
      "image_url": "https://cdn.example.com/es8.jpg",
      "description": "Premium electric SUV with 500km range",
      "specs": {
        "0-100kmh": "4.1s",
        "top_speed": "200km/h",
        "seats": 7,
        "autonomous_level": "Level 2+"
      }
    }
  ]
}
```

**Response:**
```json
{
  "success": true,
  "manufacturer": "NIO",
  "sync_timestamp": "2026-01-08T10:30:00Z",
  "results": {
    "created": 3,
    "updated": 7,
    "errors": []
  }
}
```

---

## Vehicle Data Fields

### Required Fields
- `model` (string): Vehicle model name
- `year` (integer): Model year

### Optional but Recommended
- `external_id` (string): Your internal inventory ID
- `vehicle_type` (string): "EV", "PHEV", or "FCEV" (default: "EV")
- `range_km` (number): Electric range in kilometers
- `battery_kwh` (number): Battery capacity in kWh
- `price_qar` (number): Base price in Qatari Riyals
- `manufacturer_direct_price` (number): Your direct-to-consumer price
- `broker_market_price` (number): Typical broker/dealer price (for savings display)
- `stock_count` (integer): Current available units
- `image_url` (string): Primary product image URL
- `description` (string): Vehicle description
- `specs` (object): Key-value pairs of specifications

### Price Transparency Mode
To enable the price transparency feature that shows customer savings:
1. Set both `manufacturer_direct_price` and `broker_market_price`
2. The platform will automatically calculate and display:
   - Savings amount: `broker_market_price - manufacturer_direct_price`
   - Savings percentage: `((savings / broker_market_price) × 100)`

**Example:**
```json
{
  "manufacturer_direct_price": 145000,
  "broker_market_price": 188500
}
```
**Displays:** "Save QAR 43,500 (23%)"

---

## Vehicle Status Values
- `available`: In stock and available for purchase
- `out_of_stock`: Temporarily unavailable
- `pre_order`: Available for pre-order
- `discontinued`: No longer manufactured

---

## Best Practices

### Real-time Updates
- Update stock counts immediately when inventory changes
- Use PUT endpoint for quick updates to specific vehicles
- Recommended: webhook or scheduled sync every 15-30 minutes

### Bulk Sync
- Use POST endpoint for full catalog synchronization
- Recommended frequency: Daily or weekly
- Include `sync_timestamp` to track sync history

### Error Handling
- API returns HTTP 200 with partial success for bulk operations
- Check `results.errors` array for failed updates
- Retry failed operations with corrected data

### Rate Limiting
- Maximum 100 requests per minute
- Bulk sync: Maximum 500 vehicles per request
- For larger catalogs, split into multiple requests

---

## Example Integration (Node.js)

```javascript
const axios = require('axios');

const QEV_API = 'https://qev-hub.com/api';
const MANUFACTURER_ID = 'your-manufacturer-id';
const AUTH_TOKEN = 'your-auth-token';

// Update stock for a vehicle
async function updateVehicleStock(vehicleId, newStockCount) {
  try {
    const response = await axios.put(
      `${QEV_API}/manufacturers/${MANUFACTURER_ID}/inventory`,
      {
        vehicles: [
          {
            id: vehicleId,
            stock_count: newStockCount,
            status: newStockCount > 0 ? 'available' : 'out_of_stock'
          }
        ]
      },
      {
        headers: {
          'Authorization': `Bearer ${AUTH_TOKEN}`,
          'Content-Type': 'application/json'
        }
      }
    );
    
    console.log('Stock updated:', response.data);
    return response.data;
  } catch (error) {
    console.error('Update failed:', error.response?.data || error.message);
    throw error;
  }
}

// Full inventory sync
async function syncFullInventory(vehicles) {
  try {
    const response = await axios.post(
      `${QEV_API}/manufacturers/${MANUFACTURER_ID}/inventory`,
      {
        sync_timestamp: new Date().toISOString(),
        vehicles
      },
      {
        headers: {
          'Authorization': `Bearer ${AUTH_TOKEN}`,
          'Content-Type': 'application/json'
        }
      }
    );
    
    console.log('Sync completed:', response.data);
    return response.data;
  } catch (error) {
    console.error('Sync failed:', error.response?.data || error.message);
    throw error;
  }
}
```

---

## Support
For API access, technical support, or questions:
- Email: api@qev-hub.com
- Developer Portal: https://qev-hub.com/developers
- Status Page: https://status.qev-hub.com

---

## Changelog

### v1.0.0 (2026-01-08)
- Initial API release
- Inventory management endpoints
- Price transparency support
- Bulk sync capabilities
