# Create Test Manufacturer Account - Quick Guide

## Option 1: Via Supabase Dashboard (Easiest)

### Step 1: Create Auth User
1. Go to Supabase Dashboard: https://supabase.com/dashboard
2. Select your QEV Hub project
3. Navigate to **Authentication** → **Users**
4. Click **"Add user"**
5. Fill in:
   - **Email**: `test@manufacturer.com`
   - **Password**: `TestManufacturer123!`
   - Enable **"Auto Confirm User"**
6. Click **"Create user"**
7. **Copy the User ID** from the created user

### Step 2: Create Manufacturer Profile
1. Navigate to **Table Editor** → **manufacturers**
2. Click **"Insert"** → **"Insert row"**
3. Fill in:
   - **user_id**: Paste the User ID you copied
   - **company_name**: `Test Motors Inc`
   - **company_name_ar**: `شركة تيست موتورز`
   - **country**: `China`
   - **city**: `Shenzhen`
   - **region**: `Guangdong Province`
   - **contact_email**: `test@manufacturer.com`
   - **contact_phone**: `+86-755-1234567`
   - **website_url**: `https://testmotors.com`
   - **description**: `Test manufacturer for QEV Hub development`
   - **verification_status**: `verified` (IMPORTANT!)
4. Click **"Save"**

### Step 3: Login
1. Go to: http://localhost:3000/manufacturer-login
2. Login with:
   - **Email**: `test@manufacturer.com`
   - **Password**: `TestManufacturer123!`
3. You should be redirected to the manufacturer dashboard!

---

## Option 2: Via SQL (Quick)

Run this SQL in Supabase SQL Editor:

```sql
-- First, get or create the auth user
-- You'll need to do this via Dashboard or API as SQL can't directly create auth users

-- Then insert manufacturer profile (replace USER_ID_HERE with actual UUID)
INSERT INTO manufacturers (
  user_id,
  company_name,
  company_name_ar,
  country,
  city,
  region,
  contact_email,
  contact_phone,
  website_url,
  description,
  verification_status
) VALUES (
  'USER_ID_HERE', -- Replace with the auth user ID
  'Test Motors Inc',
  'شركة تيست موتورز',
  'China',
  'Shenzhen',
  'Guangdong Province',
  'test@manufacturer.com',
  '+86-755-1234567',
  'https://testmotors.com',
  'Test manufacturer for QEV Hub development and testing',
  'verified'
);
```

---

## Test Credentials

Once created:
- **Email**: test@manufacturer.com
- **Password**: TestManufacturer123!
- **Company**: Test Motors Inc
- **Status**: verified
- **Login URL**: http://localhost:3000/manufacturer-login

---

## Add Sample Vehicles (Optional)

After logging in, you can:
1. Click **"Add New Vehicle"** on the dashboard
2. Or navigate to **Vehicles** → **New**
3. Fill in vehicle details and save

Alternatively, run this SQL (replace MANUFACTURER_ID with your manufacturer's ID):

```sql
INSERT INTO vehicles (
  manufacturer_id,
  make,
  model,
  year,
  vehicle_type,
  price,
  battery_capacity,
  range,
  charging_time,
  top_speed,
  acceleration,
  seating_capacity,
  availability,
  description,
  warranty_years,
  warranty_km,
  origin_country
) VALUES 
(
  'MANUFACTURER_ID_HERE',
  'Test Motors',
  'EV-1000',
  2026,
  'EV',
  150000,
  75.5,
  520,
  '30 min (10-80%)',
  180,
  '5.8s',
  5,
  'available',
  'Premium electric sedan with advanced features',
  5,
  100000,
  'China'
),
(
  'MANUFACTURER_ID_HERE',
  'Test Motors',
  'SUV-2000',
  2026,
  'EV',
  220000,
  95.0,
  600,
  '35 min (10-80%)',
  200,
  '4.5s',
  7,
  'available',
  'Luxury electric SUV with spacious interior',
  5,
  150000,
  'China'
);
```

---

## Troubleshooting

**Can't login?**
- Make sure the user is confirmed (Auto Confirm enabled)
- Verify verification_status is 'verified'
- Check user_id matches between auth.users and manufacturers table

**No manufacturer profile error?**
- Ensure the manufacturers table entry exists
- Verify user_id is correct
- Check RLS policies are enabled

**Dashboard not showing?**
- Hard refresh browser (Ctrl+Shift+R)
- Check browser console for errors
- Verify manufacturer's verification_status is 'verified'
