# OpenStreetMap Charging Stations Integration

## Overview

The charging stations feature has been successfully migrated from Google Maps to **OpenStreetMap + Leaflet**, eliminating the need for API keys and billing.

## Changes Made

### 1. Replaced Google Maps with OpenStreetMap
- **Removed**: `@react-google-maps/api` and `@googlemaps/js-api-loader` packages
- **Added**: `leaflet@1.9.4` and `react-leaflet@4.2.1` (free, no API key required)
- **Benefits**:
  - Completely free - no API key needed
  - No billing or credit card required
  - Open source with active community
  - Lightweight (~40KB vs ~1MB for Google Maps)
  - Works seamlessly with your existing database structure

### 2. Updated Files

#### `/src/app/(main)/charging/page.tsx`
- Replaced Google Maps components with Leaflet + OpenStreetMap
- Added custom marker icons for charging stations
- Implemented interactive markers with popups
- Added user location detection (with consent)
- Maintained all existing functionality:
  - Filter stations (All, Available, Nearby)
  - Station cards with full details
  - Get directions feature (now uses OpenStreetMap)
  - Distance calculations

#### `/src/app/globals.css`
- Added Leaflet CSS import

#### `/supabase/migrations/014_charging_stations_sample_data.sql`
- Added 15 sample charging stations across Qatar
- Includes major locations: Doha, Lusail, The Pearl, Villaggio Mall, etc.
- Indexed coordinates for faster spatial queries

#### `/.env.example`
- Removed `NEXT_PUBLIC_GOOGLE_MAPS_API_KEY` (no longer needed)
- Added note that OpenStreetMap requires no API key

## How It Works

### Map Tiles
- Uses OpenStreetMap tile server: `https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png`
- Tiles are served for free from OpenStreetMap's infrastructure
- No rate limits or API key requirements

### Database
- Your existing `charging_stations` table remains unchanged
- Already contains all necessary fields (latitude, longitude, status, etc.)
- Sample data included in migration `014_charging_stations_sample_data.sql`

### Markers
- Custom SVG markers for charging stations
- Cyan (#00FFFF) for available stations
- Maroon (#4a0d1d) for full stations
- User location shown with silver marker

## Running the Migration

To populate your database with sample charging stations:

```bash
# If using Supabase CLI
supabase db push

# Or apply the migration manually through Supabase Dashboard:
# 1. Go to SQL Editor in Supabase
# 2. Paste the contents of 014_charging_stations_sample_data.sql
# 3. Click Run
```

## Features

### 1. Interactive Map
- Zoomable and pannable map centered on Doha, Qatar
- Click on markers to see station details
- Click on "Get Directions" to navigate using OpenStreetMap

### 2. Station Filtering
- **All Stations**: Show all active charging stations
- **Available Now**: Show only stations with available chargers
- **Nearby (10km)**: Show stations within 10km of user's location

### 3. Station Details
- Station name and address
- Charger type (Type 2, CCS, CHAdeMO, etc.)
- Power output (kW)
- Available/total chargers
- Pricing information
- Operating hours
- Amenities list

### 4. User Location
- Automatic location detection (requires user consent)
- Shows user's location on the map
- Used for "Nearby" filter and distance calculations

## API Routes

No changes needed! The existing API structure works perfectly:

- `GET /api/charging/stations` - Fetch all stations
- `GET /api/charging/stations/[id]` - Fetch single station
- `POST /api/charging/stations` - Add new station (admin)

## Cost Comparison

| Feature | Google Maps | OpenStreetMap |
|---------|-------------|---------------|
| API Key | Required | Not required |
| Cost | $200/month free tier, then $7/1000 loads | FREE |
| Billing | Credit card required | No billing |
| Rate Limits | 28,000 map loads/day | None |
| Bundle Size | ~1MB | ~40KB |

## Sample Charging Stations

The migration includes 15 charging stations across Qatar:

1. **KAHRAMAA EV Charging Station - Katara** - 4 chargers, 50kW, Free
2. **KAHRAMAA EV Charging - The Pearl** - 2 chargers, 50kW, Free
3. **KAHRAMAA Charging Hub - Lusail** - 6 chargers, 150kW, Free
4. **EV Charging Station - Villaggio Mall** - 4 chargers, 22kW, 15 QAR/hour
5. **Charging Station - City Center Mall** - 3 chargers, 50kW, 20 QAR/hour
6. **EV Charger - Doha Festival City** - 2 chargers, 11kW, 12 QAR/hour
7. **KAHRAMAA Charging - Qatar University** - 2 chargers, 50kW, Free for students
8. **EV Charging - Education City** - 4 chargers, 22kW, Free
9. **Charging Station - Airport** - 8 chargers, 150kW, 30 QAR/hour
10. **EV Charger - Msheireb Downtown** - 2 chargers, 22kW, 18 QAR/hour
11. **Charging Station - Al Wakrah** - 2 chargers, 22kW, Free
12. **EV Charging - Al Khor** - 1 charger, 22kW, Free
13. **Fast Charger - Doha Port** - 4 chargers, 150kW, 25 QAR/hour
14. **Charging Station - The Gate Mall** - 2 chargers, 22kW, 20 QAR/hour
15. **EV Charger - Landmark Mall** - 3 chargers, 50kW, 22 QAR/hour

## Future Enhancements

Consider adding these features:

1. **Real-time Availability**: Connect to charging station APIs for live availability
2. **Route Planning**: Integrate OSRM (Open Source Routing Machine) for EV-optimized routes
3. **User Reviews**: Allow users to rate and review charging stations
4. **Favorite Stations**: Let users save frequently used stations
5. **Charging Session Tracking**: Track charging history in `charging_sessions` table

## Troubleshooting

### Map not showing
- Check browser console for errors
- Ensure Leaflet CSS is loaded (added to `globals.css`)
- Verify the migration was applied to populate `charging_stations` table

### Markers not appearing
- Check that latitude/longitude are valid numbers
- Verify stations have `status = 'active'`
- Check browser console for JavaScript errors

### User location not working
- Browser must request geolocation permission
- Works on HTTPS only (or localhost)
- Some browsers require user interaction first

## References

- [Leaflet Documentation](https://leafletjs.com/reference.html)
- [React Leaflet Documentation](https://react-leaflet.js.org/)
- [OpenStreetMap](https://www.openstreetmap.org/)
- [OpenStreetMap Tile Usage Policy](https://operations.osmfoundation.org/policies/tiles/)
