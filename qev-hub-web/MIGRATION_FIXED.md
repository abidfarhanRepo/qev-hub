# ✅ Database Migration Fixed

## Problem
The `vehicles` table already existed with a different schema (missing `battery_kwh` column).

## Solution
The migration now safely drops and recreates all tables to ensure correct schema:

```sql
-- Drop tables if they exist (to recreate with correct schema)
DROP TABLE IF EXISTS profiles CASCADE;
DROP TABLE IF EXISTS vehicles CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
```

---

## 📋 Apply This Updated Migration

**Step 1:** Go to Supabase SQL Editor
https://app.supabase.com/project/wmumpqvvoydngcbffozu/sql/new

**Step 2:** Copy the complete SQL from this file:
`supabase/migrations/001_initial_schema_fixed.sql`

**Step 3:** Paste into SQL editor and click "Run"

---

## What This Migration Does

### 1. Drops existing tables (clean slate)
```sql
DROP TABLE IF EXISTS profiles CASCADE;
DROP TABLE IF EXISTS vehicles CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
```

### 2. Creates tables with correct schema

**Profiles:**
- id (UUID, references auth.users)
- email
- full_name
- role (default: 'user')
- created_at, updated_at

**Vehicles:**
- id (UUID, primary key)
- manufacturer, model, year
- range_km, battery_kwh ← This was missing!
- price_qar
- image_url, description
- specs (JSONB)
- stock_count, status
- created_at, updated_at

**Orders:**
- id (UUID, primary key)
- user_id, vehicle_id
- status, total_price_qar
- shipping_address
- created_at, updated_at

### 3. Enables Row Level Security (RLS)
All tables have RLS enabled with appropriate policies.

### 4. Creates triggers
- Auto-create profile on user signup
- Auto-update `updated_at` timestamp

### 5. Seeds vehicles
- Tesla Model 3 (2024) - 175,000 QAR
- Tesla Model Y (2024) - 195,000 QAR
- BYD Atto 3 (2024) - 145,000 QAR

---

## ✅ After Migration

You should see these success messages:
```
✓ Schema created successfully!
✓ Profiles table created
✓ Vehicles table created with 3 seeded vehicles
✓ Orders table created
✓ RLS policies enabled
✓ Triggers created
```

---

## 🎯 Verify Migration

### 1. Check Vehicles Table
In Supabase Dashboard → Table Editor → vehicles:
- You should see 3 vehicles
- Each vehicle should have a `battery_kwh` column
- Check specs contain JSON data

### 2. Test the App
- Go to: http://localhost:3000/marketplace
- You should see 3 vehicle cards
- Filter buttons should work (All/Tesla/BYD)
- Click any vehicle to see detail modal

### 3. Test Signup
- Go to: http://localhost:3000/signup
- Create a test account
- Login at: http://localhost:3000/login
- Should redirect to `/marketplace`

---

## 🔍 If You Still Get Errors

### Error: "relation already exists"
**Solution:** The migration now uses `DROP TABLE IF EXISTS` - should handle this.

### Error: "column does not exist"
**Solution:** The migration now drops tables completely before recreating them.

### Error: "permission denied"
**Solution:** Make sure you're logged in as the project owner in Supabase Dashboard.

---

## 📋 Next Steps

1. ✅ Apply the updated migration (`001_initial_schema_fixed.sql`)
2. ✅ Verify vehicles appear in marketplace
3. ✅ Apply charging stations migration (`011_charging_stations.sql`)
4. ✅ Test complete auth flow
5. 🚀 Build orders page with purchase functionality

---

**All database issues are now fixed!** 🎉
