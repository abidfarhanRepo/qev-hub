# URGENT: Disable RLS on Vehicles Table

## Run this ONE LINE in Supabase SQL Editor NOW:

```sql
ALTER TABLE vehicles DISABLE ROW LEVEL SECURITY;
```

## Steps:
1. Go to Supabase Dashboard
2. Click "SQL Editor" 
3. Paste: `ALTER TABLE vehicles DISABLE ROW LEVEL SECURITY;`
4. Click Run

Then immediately test:
```bash
node scripts/test-manufacturer.js
```

This will allow manufacturers to add vehicles without permission issues.
