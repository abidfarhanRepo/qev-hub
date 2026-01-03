# 🚀 Quick Setup: Supabase CLI & Charging Stations

## ✅ Supabase CLI Installed

Supabase CLI has been installed locally in your project. You can run it with:

```bash
cd /home/pi/Desktop/QEV/qev-hub-web
npx supabase --help
```

## 📝 Apply Charging Stations Data

Due to Row Level Security (RLS) policies, the charging stations need to be added via Supabase Dashboard. Here's how:

### Option 1: Apply via Supabase Dashboard (Recommended - 1 minute)

1. **Open your Supabase Dashboard**
   ```
   https://app.supabase.com
   ```

2. **Select your QEV project**

3. **Go to SQL Editor**
   - Click "SQL Editor" in the left sidebar
   - Click "New query"

4. **Copy the migration file**
   ```bash
   cat supabase/migrations/015_charging_stations_seed_data.sql
   ```

5. **Paste and run**
   - Paste the SQL content into the editor
   - Click "Run" button
   - Wait for confirmation

6. **Verify data**
   ```sql
   SELECT COUNT(*) as total_stations FROM charging_stations;
   ```
   Should return: 15

### Option 2: Apply using Service Role Key (If available)

If you have the `SUPABASE_SERVICE_ROLE_KEY`, update `.env.local` and run:

```bash
cd qev-hub-web
node scripts/seed-charging-stations.js
```

## 🗺️ Verify Charging Stations

Once the migration is applied, start the dev server and visit:

```bash
npm run dev
# Then open: http://localhost:3000/charging
```

You should see:
- ✅ Interactive OpenStreetMap of Qatar
- ✅ 15 charging station markers
- ✅ Cyan markers = Available chargers
- ✅ Maroon markers = Full stations
- ✅ Click markers for details
- ✅ Filter options (All/Available/Nearby)

## 🎨 Marker Colors

| Color | Meaning |
|-------|---------|
| **Cyan (#00FFFF)** | Station has available chargers |
| **Maroon (#4A0D1D)** | All chargers in use |
| **Silver** | Your current location |

## 📊 What You'll See

### On the Map
- 15 markers across Qatar
- Doha area: 10 stations
- Lusail: 1 station
- The Pearl: 1 station
- Al Wakrah: 1 station
- Al Khor: 1 station
- Airport: 1 station

### Station Details Popup
- Station name & address
- Charger type (Type 2, CCS, CHAdeMO)
- Power output (kW)
- Available/total chargers
- Pricing
- Operating hours
- "Get Directions" button

### Station Cards (Below Map)
- All stations listed
- Amenities tags (WiFi, Parking, etc.)
- Click to center map on station

## 🔧 Supabase CLI Commands

Now that you have Supabase CLI, you can use:

```bash
# Check status
npx supabase status

# Run local development
npx supabase start

# Stop local development
npx supabase stop

# Link to remote project (recommended)
npx supabase link --project-ref YOUR_PROJECT_ID

# Push migrations to remote (after linking)
npx supabase db push

# Generate TypeScript types from schema
npx supabase gen types typescript > src/types/database.ts
```

## 🚀 Next Steps

### 1. Link Your Project (One-time setup)

Get your project reference ID from Supabase Dashboard URL:
```
https://app.supabase.com/project/YOUR_PROJECT_ID/...
                              ^^^^^^^^^^^^^^^
```

Then run:
```bash
npx supabase link --project-ref YOUR_PROJECT_ID
```

After linking, you can push migrations directly:
```bash
npx supabase db push
```

### 2. Apply Current Migration

For now, manually apply the migration (see Option 1 above).

### 3. Test the Feature

```bash
npm run dev
# Visit: http://localhost:3000/charging
```

## 📱 Testing Checklist

- [ ] Map loads with OpenStreetMap tiles
- [ ] All 15 markers visible
- [ ] Markers have correct colors (Cyan/Maroon)
- [ ] Clicking marker shows popup with details
- [ ] "Get Directions" opens OSM directions
- [ ] Filter buttons work (All/Available/Nearby)
- [ ] Station cards display correctly
- [ ] Clicking card centers map on station
- [ ] User location detection works (allow permission)

## ❓ Troubleshooting

### Map doesn't show markers
- Check migration was applied
- Verify `charging_stations` table has data
- Run: `SELECT COUNT(*) FROM charging_stations;` in SQL Editor

### Markers have wrong color
- Check `available_chargers` values
- Cyan = available_chargers > 0
- Maroon = available_chargers = 0

### User location not working
- Allow geolocation permission in browser
- Use HTTPS or localhost
- Check browser privacy settings

### Can't apply migration
- Ensure you have access to Supabase Dashboard
- Check you're in the correct project
- Verify SQL copied completely

## 📚 Documentation

- `CHARGING_MIGRATION_COMPLETE.md` - Migration summary
- `CHARGING_STATIONS_OSM_UPDATE.md` - Technical details
- `QUICKSTART_CHARGING.md` - Quick start guide

---

**Ready to go!** Apply the migration via Supabase Dashboard and start seeing charging stations on the map! 🗺️
