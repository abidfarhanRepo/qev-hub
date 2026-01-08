# Database Setup Commands

## Quick Setup (Recommended)

### Option 1: Using Supabase Web UI (Easiest - 2 minutes)

1. **Open SQL Editor:**
   ```
   https://app.supabase.com/project/wmumpqvvoydngcbffozu/sql/new
   ```

2. **Copy SQL file contents:**
   ```bash
   cat scripts/setup-database.sql
   ```
   Or open it in your editor and copy all.

3. **Paste in SQL Editor and click "Run"**

### Option 2: Auto-copy to Clipboard (Linux)

```bash
# Install xclip first (if not installed)
sudo apt install xclip

# Copy SQL to clipboard
cat scripts/setup-database.sql | xclip -selection clipboard

# Then paste (Ctrl+V) in Supabase SQL Editor
```

### Option 3: Using Helper Scripts

We've created scripts to make this easier:

```bash
# Interactive guide
npm run setup-db

# Or shell script with instructions
./scripts/apply-db.sh
```

### Option 4: Using psql (If you have database password)

```bash
# Run the shell script (will prompt for password)
./scripts/setup-db.sh

# Or manually with psql
psql "postgresql://postgres:YOUR_PASSWORD@db.wmumpqvvoydngcbffozu.supabase.co:5432/postgres" -f scripts/setup-database.sql
```

## What Gets Created

After running the setup, you'll have:

✅ **Tables:**
- `manufacturers` - Verified EV manufacturers
- `vehicles` - Vehicle inventory with price transparency
- `manufacturer_stats` - Analytics data
- `vehicle_inquiries` - Customer inquiries

✅ **Sample Data:**
- 4 verified manufacturers (BYD, GAC AION, NIO, XPeng)
- 6 vehicles with real pricing:
  - BYD Atto 3 - Save QAR 43,500 (23%)
  - BYD Han Plus - Save QAR 34,500 (23%)
  - GAC AION Y Plus - Save QAR 40,500 (23%)
  - NIO ES8 - Save QAR 63,000 (23%)
  - XPeng P7i - Save QAR 49,500 (23%)
  - XPeng G9 - Save QAR 58,500 (23%)

✅ **Features Enabled:**
- Price transparency mode
- Vehicle type filtering (EV/PHEV/FCEV)
- Manufacturer verification badges
- Real-time inventory tracking

## Verify Setup

After running the setup, check:

```bash
# Visit marketplace
open http://localhost:3000/marketplace

# Or verify in Supabase SQL Editor:
SELECT company_name, verification_status FROM manufacturers;
SELECT manufacturer, model, stock_count, status FROM vehicles;
```

You should see:
- 4 manufacturers listed
- 6 vehicles displayed
- Price transparency showing savings

## Troubleshooting

### No vehicles showing?

1. **Check RLS policies** - Run in SQL Editor:
   ```sql
   SELECT schemaname, tablename, policyname 
   FROM pg_policies 
   WHERE tablename IN ('vehicles', 'manufacturers');
   ```

2. **Verify data exists:**
   ```sql
   SELECT COUNT(*) FROM vehicles;
   SELECT COUNT(*) FROM manufacturers WHERE verification_status = 'verified';
   ```

3. **Check browser console** for any API errors

### Migration error?

The `setup-database.sql` script is idempotent and handles:
- Tables that already exist
- Columns that already exist
- Duplicate data (uses `ON CONFLICT DO NOTHING`)

Safe to run multiple times!

## Available NPM Scripts

```bash
npm run dev              # Start development server
npm run setup-db         # Run database setup helper
npm run setup-db-shell   # Run shell-based setup
```

## Database Password

To get your Supabase database password:
1. Go to: https://app.supabase.com/project/wmumpqvvoydngcbffozu/settings/database
2. Look for "Database Password" section
3. Click "Reset Database Password" if needed

## Quick Reference

**Supabase Project ID:** `wmumpqvvoydngcbffozu`
**SQL Editor:** https://app.supabase.com/project/wmumpqvvoydngcbffozu/sql/new
**Setup File:** `scripts/setup-database.sql`
