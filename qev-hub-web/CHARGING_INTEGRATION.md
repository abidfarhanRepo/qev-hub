# QEV Hub - Charging Stations Integration

This implementation includes:

## 1. Database Schema (`supabase/migrations/011_charging_stations.sql`)
- **charging_stations** table: Stores charging station data from Tarsheed
- **charging_sessions** table: Tracks user charging history
- RLS policies for security
- Indexes for geolocation queries

## 2. Tarsheed Data Scraper (`src/lib/tarsheed-scraper.ts`)
**Current Implementation:**
- Mock data structure with sample KAHRAMAA stations
- Distance calculation utilities
- Ready for real Tarsheed API integration

**To Implement Real Scraping:**

### Option A: Reverse Engineer Tarsheed Mobile App
1. Install Tarsheed app on Android device
2. Use tools like mitmproxy or Charles Proxy to intercept API calls
3. Identify API endpoints and authentication
4. Implement in `scrapeTarsheedData()` function

### Option B: Use OpenChargeMap API
```typescript
// Alternative public API
const response = await axios.get('https://api.openchargemap.io/v3/poi/', {
  params: {
    latitude: 25.3548,
    longitude: 51.1839,
    distance: 50,
    countrycode: 'QA',
    key: 'YOUR_API_KEY'
  }
})
```

### Option C: KAHRAMAA Official Data
- Check KAHRAMAA website for official charging station data
- May have public datasets or APIs

## 3. Charging Stations Page (`src/app/(main)/charging/page.tsx`)
Features:
- **Google Maps Integration**: Interactive map with station markers
- **Real-time Location**: Shows user's current location
- **Filters**: All stations, available now, nearby (10km radius)
- **Station Cards**: Detailed information for each station
- **Navigation**: Direct Google Maps navigation links
- **Availability Status**: Green (available) / Red (full) indicators

## 4. Sync Service (`src/services/charging-sync.ts`)
- Periodic sync function to update database
- Can be run via cron job or scheduled task
- API endpoint `/api/sync-stations` for manual triggers

## 5. Environment Variables
Add to `.env.local`:
```env
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_anon_key
NEXT_PUBLIC_GOOGLE_MAPS_API_KEY=your_google_maps_key
```

## Setup Instructions

### 1. Get Google Maps API Key
1. Go to https://console.cloud.google.com/
2. Create a new project or select existing
3. Enable Maps JavaScript API
4. Create credentials (API key)
5. Add to `.env.local`

### 2. Run Database Migration
```bash
# Apply the migration to create charging tables
psql $DATABASE_URL -f supabase/migrations/011_charging_stations.sql
```

Or use Supabase CLI:
```bash
supabase db push
```

### 3. Initial Data Sync
Run the sync service to populate initial data:
```bash
npm run sync-stations
```

Or call the API endpoint:
```bash
curl -X POST http://localhost:3000/api/sync-stations
```

### 4. Set Up Periodic Sync (Optional)
Add to package.json:
```json
{
  "scripts": {
    "sync-stations": "tsx src/services/charging-sync.ts"
  }
}
```

Set up cron job (Linux/Mac):
```bash
# Run sync every hour
0 * * * * cd /path/to/qev-hub-web && npm run sync-stations
```

## Next Steps for Production

### 1. Implement Real Tarsheed Integration
- Reverse engineer Tarsheed app API
- Handle authentication if required
- Implement rate limiting
- Add error handling and retries

### 2. Real-time Availability Updates
- Poll Tarsheed API more frequently for availability
- Use WebSocket if Tarsheed provides real-time data
- Update database with current charger availability

### 3. Enhanced Features
- **Route Planning**: Calculate best charging stops for long trips
- **Reservations**: Allow users to reserve charging slots
- **Payment Integration**: Process charging payments
- **Notifications**: Alert users when charging completes
- **Reviews**: User ratings and reviews for stations
- **Favorites**: Save frequently used stations

### 4. Mobile App Integration
- Sync charging data with React Native mobile app
- Push notifications for charging status
- Offline map caching

### 5. Analytics
- Track popular charging stations
- Monitor usage patterns
- Generate insights for infrastructure planning

## API Endpoints

### GET /api/sync-stations
Check last sync time

### POST /api/sync-stations
Manually trigger station sync (admin only)

## Database Queries

### Find nearby stations:
```sql
SELECT *, 
  earth_distance(
    ll_to_earth(latitude, longitude),
    ll_to_earth(25.3548, 51.1839)
  ) / 1000 as distance_km
FROM charging_stations
WHERE status = 'active'
ORDER BY distance_km
LIMIT 10;
```

### Get user charging history:
```sql
SELECT cs.*, st.name as station_name, v.model as vehicle_model
FROM charging_sessions cs
LEFT JOIN charging_stations st ON cs.station_id = st.id
LEFT JOIN vehicles v ON cs.vehicle_id = v.id
WHERE cs.user_id = $1
ORDER BY cs.start_time DESC;
```

## Notes
- Scraping should respect Tarsheed's terms of service
- Consider reaching out to KAHRAMAA for official data partnership
- Implement caching to reduce API calls
- Monitor scraping frequency to avoid IP bans
- Consider legal implications of web scraping
