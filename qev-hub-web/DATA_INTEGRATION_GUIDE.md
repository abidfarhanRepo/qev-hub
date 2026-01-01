# Charging Station Data Integration Guide

## Overview

The charging station feature is designed to accept data from any source. The current implementation uses mock data, which you can replace with your actual data source.

## Data Provider Architecture

### Core File: `src/lib/charging-data-provider.ts`

This file contains:
- `ChargingStation` interface - Data structure
- `fetchChargingStations()` - Main data fetching function
- `calculateDistance()` - Utility for proximity calculations

## Integration Options

### Option 1: API Integration

Replace the `fetchChargingStations()` function with API calls:

```typescript
export async function fetchChargingStations(): Promise<ChargingStation[]> {
  try {
    const response = await axios.get('https://your-api.com/charging-stations', {
      headers: {
        'Authorization': `Bearer ${process.env.API_KEY}`,
      },
      params: {
        country: 'QA',
        // Add other parameters
      }
    })

    // Transform API response to match ChargingStation interface
    return response.data.stations.map((station: any) => ({
      name: station.name,
      address: station.location.address,
      latitude: station.location.lat,
      longitude: station.location.lng,
      provider: station.operator || 'Unknown',
      charger_type: station.connector_types.join(' / '),
      power_output_kw: Math.max(...station.connectors.map(c => c.power_kw)),
      total_chargers: station.connectors.length,
      available_chargers: station.connectors.filter(c => c.available).length,
      status: station.operational ? 'active' : 'offline',
      operating_hours: station.hours || '24/7',
      pricing_info: station.pricing || 'Contact operator',
      amenities: station.amenities || [],
    }))
  } catch (error) {
    console.error('Error fetching from API:', error)
    throw error
  }
}
```

### Option 2: Database Query

Fetch from your existing database:

```typescript
export async function fetchChargingStations(): Promise<ChargingStation[]> {
  const { data, error } = await supabase
    .from('charging_stations')
    .select('*')
    .eq('status', 'active')
    .order('name')

  if (error) throw error
  return data || []
}
```

### Option 3: OpenChargeMap API

Use the public OpenChargeMap API:

```typescript
import axios from 'axios'

export async function fetchChargingStations(): Promise<ChargingStation[]> {
  try {
    const response = await axios.get('https://api.openchargemap.io/v3/poi/', {
      params: {
        output: 'json',
        latitude: 25.3548, // Doha
        longitude: 51.1839,
        distance: 50, // km
        distanceunit: 'KM',
        maxresults: 100,
        countrycode: 'QA',
        key: process.env.OPENCHARGE_MAP_KEY // Optional, but recommended
      }
    })

    return response.data.map((station: any) => ({
      name: station.AddressInfo.Title,
      address: station.AddressInfo.AddressLine1,
      latitude: station.AddressInfo.Latitude,
      longitude: station.AddressInfo.Longitude,
      provider: station.OperatorInfo?.Title || 'Unknown',
      charger_type: station.Connections?.[0]?.ConnectionType?.Title,
      power_output_kw: station.Connections?.[0]?.PowerKW,
      total_chargers: station.NumberOfPoints || 1,
      available_chargers: station.StatusType?.IsOperational ? 1 : 0,
      status: station.StatusType?.IsOperational ? 'active' : 'offline',
      operating_hours: '24/7',
      amenities: [],
    }))
  } catch (error) {
    console.error('Error fetching from OpenChargeMap:', error)
    throw error
  }
}
```

### Option 4: Web Scraping

If data is only available via web scraping:

```typescript
import axios from 'axios'
import * as cheerio from 'cheerio'

export async function fetchChargingStations(): Promise<ChargingStation[]> {
  try {
    const response = await axios.get('https://example.com/charging-stations')
    const $ = cheerio.load(response.data)
    
    const stations: ChargingStation[] = []
    
    $('.station-item').each((i, elem) => {
      stations.push({
        name: $(elem).find('.station-name').text(),
        address: $(elem).find('.station-address').text(),
        latitude: parseFloat($(elem).data('lat')),
        longitude: parseFloat($(elem).data('lng')),
        provider: 'KAHRAMAA',
        charger_type: $(elem).find('.charger-type').text(),
        power_output_kw: parseFloat($(elem).find('.power').text()),
        total_chargers: parseInt($(elem).find('.total').text()),
        available_chargers: parseInt($(elem).find('.available').text()),
        status: 'active',
        operating_hours: '24/7',
        pricing_info: $(elem).find('.pricing').text(),
        amenities: $(elem).find('.amenities').text().split(',').map(a => a.trim()),
      })
    })
    
    return stations
  } catch (error) {
    console.error('Error scraping data:', error)
    throw error
  }
}
```

### Option 5: Manual Data Entry

Create an admin interface to manually add stations:

1. Create admin page: `src/app/(main)/admin/stations/page.tsx`
2. Add form to input station data
3. Save directly to database
4. Display stations on charging page

## Data Structure

### Required Fields

```typescript
interface ChargingStation {
  name: string              // Station name
  address: string           // Full address
  latitude: number          // GPS coordinate
  longitude: number         // GPS coordinate
  provider: string          // Operator name
}
```

### Optional Fields

```typescript
interface ChargingStation {
  // ... required fields above
  
  id?: string                    // Unique identifier
  charger_type?: string          // e.g., 'Type 2 / CCS'
  power_output_kw?: number       // e.g., 50, 150, 350
  total_chargers?: number        // Total charging points
  available_chargers?: number    // Currently available
  status?: string                // 'active', 'maintenance', 'offline'
  operating_hours?: string       // e.g., '24/7'
  pricing_info?: string          // Pricing details
  amenities?: string[]           // Nearby facilities
}
```

## Sync Service

### Automated Updates

The sync service (`src/services/charging-sync.ts`) can be scheduled to run periodically:

```bash
# Run manually
npm run sync-stations

# Or via API
POST /api/sync-stations

# Set up cron job (Linux/Mac)
0 * * * * cd /path/to/app && npm run sync-stations

# Or use Vercel Cron Jobs
# Create: vercel.json with cron schedule
```

### Real-time Updates

For real-time availability updates, consider:

1. **WebSocket connection** to data source
2. **Polling** every few minutes
3. **Webhooks** from data provider
4. **Supabase Realtime** for database changes

## Testing Your Integration

1. **Update the provider file**:
   ```bash
   nano src/lib/charging-data-provider.ts
   ```

2. **Test data fetching**:
   ```bash
   npm run sync-stations
   ```

3. **Verify database**:
   ```sql
   SELECT COUNT(*) FROM charging_stations;
   SELECT * FROM charging_stations LIMIT 5;
   ```

4. **Test web interface**:
   ```bash
   npm run dev
   # Visit: http://localhost:3000/charging
   ```

## Environment Variables

Add any required API keys to `.env.local`:

```env
# Your data source API key
CHARGING_DATA_API_KEY=your_key_here
CHARGING_DATA_API_URL=https://api.example.com

# OpenChargeMap (optional)
OPENCHARGE_MAP_KEY=your_key_here

# Other services
# ...
```

## Best Practices

1. **Error Handling**: Always wrap data fetching in try-catch
2. **Rate Limiting**: Respect API rate limits
3. **Caching**: Cache responses when appropriate
4. **Logging**: Log errors and sync results
5. **Validation**: Validate data before inserting to database
6. **Fallback**: Have mock/default data as fallback

## Example: Complete Integration

```typescript
// src/lib/charging-data-provider.ts
import axios from 'axios'

const API_BASE_URL = process.env.CHARGING_DATA_API_URL
const API_KEY = process.env.CHARGING_DATA_API_KEY

export async function fetchChargingStations(): Promise<ChargingStation[]> {
  try {
    // Try primary data source
    const response = await axios.get(`${API_BASE_URL}/stations`, {
      headers: { 'Authorization': `Bearer ${API_KEY}` },
      timeout: 5000,
    })
    
    return transformData(response.data)
  } catch (error) {
    console.error('Primary source failed, trying fallback:', error)
    
    // Fallback to secondary source
    try {
      return await fetchFromOpenChargeMap()
    } catch (fallbackError) {
      console.error('Fallback also failed:', fallbackError)
      
      // Return cached data or mock data
      return getMockData()
    }
  }
}

function transformData(rawData: any[]): ChargingStation[] {
  return rawData.map(station => ({
    name: station.name,
    address: station.address,
    latitude: station.lat,
    longitude: station.lng,
    provider: station.operator,
    charger_type: station.charger_types?.join(' / '),
    power_output_kw: station.max_power,
    total_chargers: station.total_points,
    available_chargers: station.available_points,
    status: station.is_active ? 'active' : 'offline',
    operating_hours: station.hours || '24/7',
    pricing_info: station.pricing || 'Contact operator',
    amenities: station.amenities || [],
  }))
}
```

## Support

For questions or issues with data integration:
1. Check this guide
2. Review `src/lib/charging-data-provider.ts`
3. Test with mock data first
4. Verify API responses
5. Check database structure

---

**Ready to integrate your data source!** Update `charging-data-provider.ts` with your implementation.
