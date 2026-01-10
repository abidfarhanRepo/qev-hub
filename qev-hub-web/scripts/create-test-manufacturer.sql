-- Create dummy manufacturer account for testing
-- Run this script to create a test manufacturer account

-- First, create a test user in Supabase Auth (you'll need to do this via Supabase Dashboard or Auth API)
-- Email: test@manufacturer.com
-- Password: TestManufacturer123!
-- User ID: You'll get this after creating the user

-- For now, let's create a manufacturer profile that can be linked to any user
-- You can update the user_id after creating the auth user

-- Insert dummy manufacturer
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
  description_ar,
  business_license,
  business_license_expiry,
  verification_status
) VALUES (
  '00000000-0000-0000-0000-000000000000', -- Replace with actual user_id after creating auth user
  'Test Motors Inc',
  'شركة تيست موتورز',
  'China',
  'Shenzhen',
  'Guangdong Province',
  'test@manufacturer.com',
  '+86-755-1234567',
  'https://testmotors.com',
  'Test manufacturer for QEV Hub development and testing. Leading provider of electric vehicles with focus on innovation and sustainability.',
  'مصنع تجريبي لمركز كيو إي في. مزود رائد للمركبات الكهربائية مع التركيز على الابتكار والاستدامة.',
  'BL-TEST-2024-001',
  '2027-12-31',
  'verified'
) ON CONFLICT (user_id) DO NOTHING;

-- Note: To complete the setup:
-- 1. Go to Supabase Dashboard > Authentication > Users
-- 2. Click "Add user" 
-- 3. Email: test@manufacturer.com
-- 4. Password: TestManufacturer123!
-- 5. Copy the generated user_id
-- 6. Run: UPDATE manufacturers SET user_id = 'your-copied-user-id' WHERE company_name = 'Test Motors Inc';
