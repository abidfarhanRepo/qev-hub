# Quick Start: Charging Stations with OpenStreetMap

## Setup Instructions

### 1. Apply Database Migration

Run the sample data migration to add charging stations to your database:

```bash
cd qev-hub-web

# If using Supabase CLI
supabase db push

# Or apply manually:
# 1. Go to Supabase Dashboard > SQL Editor
# 2. Open file: supabase/migrations/014_charging_stations_sample_data.sql
# 3. Click "Run" to execute the migration
```

### 2. Update Environment Variables

Your `.env` file should NOT contain any Google Maps keys:

```env
# Supabase Configuration
NEXT_PUBLIC_SUPABASE_URL=your_supabase_project_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key

# Note: OpenStreetMap is used for maps - NO API KEY REQUIRED
```

**Important**: Remove any `NEXT_PUBLIC_GOOGLE_MAPS_API_KEY` from your `.env` file.

### 3. Start Development Server

```bash
npm run dev
```

### 4. Access Charging Stations

Open your browser and navigate to:
```
http://localhost:3000/charging
```

## What You'll See

✅ **Interactive Map** of Qatar with charging station markers  
✅ **15 Sample Stations** across major locations  
✅ **Filter Options** (All, Available, Nearby)  
✅ **Station Details** (type, power, pricing, amenities)  
✅ **Get Directions** feature (using OpenStreetMap)  
✅ **User Location** detection (requires permission)

## Key Features

### Map Interaction
- **Scroll to zoom** in/out
- **Click and drag** to pan
- **Click on markers** to see station popup
- **Click "Get Directions"** to navigate

### Filtering
- **All Stations**: Show every active station
- **Available Now**: Only stations with free chargers
- **Nearby (10km)**: Stations near your location

### Station Cards
Below the map, you'll see cards for each station showing:
- Station name and availability status
- Address
- Charger type and power
- Available/total chargers
- Pricing
- Amenities (WiFi, Parking, Dining, etc.)

Click on any card to center the map on that station.

## Database Structure

The `charging_stations` table contains:

```sql
id              UUID (primary key)
name            TEXT
address         TEXT
latitude        NUMERIC
longitude       NUMERIC
provider        TEXT (KAHRAMAA, Private)
charger_type    TEXT (Type 2, CCS, CHAdeMO)
power_output_kw NUMERIC
total_chargers  INTEGER
available_chargers INTEGER
status          TEXT (active, maintenance)
operating_hours TEXT
pricing_info    TEXT
amenities       TEXT[]
created_at      TIMESTAMPTZ
updated_at      TIMESTAMPTZ
```

## Adding More Stations

### Via SQL
```sql
INSERT INTO charging_stations (
  name, address, latitude, longitude, 
  provider, charger_type, power_output_kw, 
  total_chargers, available_chargers, status, 
  operating_hours, pricing_info, amenities
) VALUES (
  'Your Station Name',
  'Address, Qatar',
  25.1234,
  51.1234,
  'KAHRAMAA',
  'Type 2 / CCS',
  50.00,
  2,
  2,
  'active',
  '24/7',
  'Free',
  ARRAY['WiFi', 'Parking']
);
```

### Via API (Coming Soon)
```typescript
POST /api/charging/stations
{
  "name": "Station Name",
  "address": "Address, Qatar",
  "latitude": 25.1234,
  "longitude": 51.1234,
  ...
}
```

## Coordinates for Major Qatar Locations

Use these coordinates as reference when adding new stations:

| Location | Latitude | Longitude |
|----------|----------|-----------|
| Doha City Center | 25.2867 | 51.5335 |
| The Pearl | 25.3714 | 51.5504 |
| Lusail | 25.4192 | 51.4966 |
| Al Wakrah | 25.1725 | 51.6035 |
| Al Khor | 25.6848 | 51.4959 |
| Education City | 25.3199 | 51.4375 |
| Airport | 25.2609 | 51.6138 |

## Cost Comparison

| Feature | Google Maps | OpenStreetMap |
|---------|-------------|---------------|
| **API Key** | Required | ✅ Not required |
| **Cost** | $200/mo free, then $7/1K loads | ✅ FREE forever |
| **Billing** | Credit card required | ✅ No billing |
| **Bundle Size** | ~1MB | ✅ ~40KB |

## Troubleshooting

### Map shows blank screen
- Check browser console (F12) for errors
- Ensure `014_charging_stations_sample_data.sql` was applied
- Verify `charging_stations` table has data

### Markers not appearing
- Run `SELECT * FROM charging_stations;` in Supabase
- Check if rows have valid latitude/longitude values
- Ensure status = 'active'

### User location not working
- Allow geolocation permission when prompted
- Must be on HTTPS or localhost
- Check browser privacy settings

## Next Steps

1. **Test the feature**: Visit `/charging` and try all features
2. **Add real stations**: Update with actual charging station data
3. **Connect to APIs**: Implement real-time availability from providers
4. **Add user features**: Favorites, reviews, charging history

## Support

- See `CHARGING_STATIONS_OSM_UPDATE.md` for full documentation
- OpenStreetMap: https://www.openstreetmap.org/
- Leaflet Docs: https://leafletjs.com/
