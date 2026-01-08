# Quick Database Setup - Fix "No vehicles available"

## Problem
- SQL migration error at line 37
- No vehicles showing in marketplace
- Database tables missing or incomplete

## Solution

### Step 1: Run the Complete Setup Script

1. **Open Supabase SQL Editor**
   - Go to: https://app.supabase.com/project/wmumpqvvoydngcbffozu/sql/new

2. **Copy and paste the entire contents of:**
   ```
   scripts/setup-database.sql
   ```

3. **Click "Run"**

This will:
- Create all necessary tables (vehicles, manufacturers, etc.)
- Add all B2C marketplace columns
- Insert 4 verified manufacturers (BYD, GAC AION, NIO, XPeng)
- Insert 6 sample vehicles with price transparency
- Set up proper RLS policies

### Step 2: Verify Setup

After running the script, you should see:
```
verified_manufacturers: 4
available_vehicles: 6
```

### Step 3: Refresh Your Browser

Visit http://localhost:3000/marketplace and you should now see:
- 6 vehicles displayed
- Vehicle type filters (Electric, Plug-in Hybrid)
- Price transparency showing savings
- "View All Verified Manufacturers" button

## Quick Test Queries

To verify data in Supabase SQL Editor:

```sql
-- Check manufacturers
SELECT company_name, country, verification_status FROM manufacturers;

-- Check vehicles
SELECT manufacturer, model, year, vehicle_type, 
       price_qar, manufacturer_direct_price, broker_market_price, 
       stock_count, status 
FROM vehicles;

-- Check price transparency is working
SELECT manufacturer, model, 
       manufacturer_direct_price as direct_price,
       broker_market_price as broker_price,
       (broker_market_price - manufacturer_direct_price) as savings,
       ROUND(((broker_market_price - manufacturer_direct_price) / broker_market_price * 100)) as savings_percent
FROM vehicles 
WHERE price_transparency_enabled = true;
```

## Troubleshooting

### If you still see "No vehicles available":

1. **Check Supabase Connection**
   - Verify `.env.local` has correct SUPABASE_URL and ANON_KEY

2. **Check RLS Policies**
   Run in SQL Editor:
   ```sql
   -- Disable RLS temporarily for testing
   ALTER TABLE vehicles DISABLE ROW LEVEL SECURITY;
   ALTER TABLE manufacturers DISABLE ROW LEVEL SECURITY;
   ```

3. **Check Network Tab**
   - Open browser DevTools → Network
   - Refresh marketplace page
   - Look for Supabase API calls
   - Check response for errors

### If migration error persists:

The new `setup-database.sql` handles all edge cases:
- Creates tables if they don't exist
- Only adds columns that are missing
- Won't fail if data already exists
- Safe to run multiple times

## What This Fixes

✅ Creates complete vehicle table structure
✅ Adds all B2C marketplace fields
✅ Inserts real manufacturer data
✅ Inserts 6 test vehicles with images
✅ Sets up price transparency (23-30% savings shown)
✅ Enables vehicle type filtering
✅ Makes everything ready for marketplace

## Expected Result

After setup, your marketplace will show:
- **BYD Atto 3** - QAR 145,000 (Save QAR 43,500)
- **BYD Han Plus** - QAR 115,000 (Save QAR 34,500)
- **GAC AION Y Plus** - QAR 135,000 (Save QAR 40,500)
- **NIO ES8** - QAR 210,000 (Save QAR 63,000)
- **XPeng P7i** - QAR 165,000 (Save QAR 49,500)
- **XPeng G9** - QAR 195,000 (Save QAR 58,500)

All with proper filtering, price transparency, and manufacturer verification badges!
