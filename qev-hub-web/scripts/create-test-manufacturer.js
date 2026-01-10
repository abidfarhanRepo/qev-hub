#!/usr/bin/env node

/**
 * Create Test Manufacturer Account
 * 
 * This script creates a complete test manufacturer account including:
 * - Supabase Auth user
 * - Manufacturer profile
 * - Sample vehicles
 */

const { createClient } = require('@supabase/supabase-js')
require('dotenv').config({ path: '.env.local' })

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY

if (!supabaseUrl || !supabaseServiceKey) {
  console.error('❌ Missing environment variables!')
  console.error('Make sure NEXT_PUBLIC_SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY are set in .env.local')
  process.exit(1)
}

const supabase = createClient(supabaseUrl, supabaseServiceKey, {
  auth: {
    autoRefreshToken: false,
    persistSession: false
  }
})

const TEST_MANUFACTURER = {
  email: 'test@manufacturer.com',
  password: 'TestManufacturer123!',
  company_name: 'Test Motors Inc',
  company_name_ar: 'شركة تيست موتورز',
  country: 'China',
  city: 'Shenzhen',
  region: 'Guangdong Province',
  contact_email: 'test@manufacturer.com',
  contact_phone: '+86-755-1234567',
  website_url: 'https://testmotors.com',
  description: 'Test manufacturer for QEV Hub development and testing. Leading provider of electric vehicles with focus on innovation and sustainability.',
  description_ar: 'مصنع تجريبي لمركز كيو إي في. مزود رائد للمركبات الكهربائية مع التركيز على الابتكار والاستدامة.',
  business_license: 'BL-TEST-2024-001',
  business_license_expiry: '2027-12-31',
  verification_status: 'verified'
}

async function createTestManufacturer() {
  console.log('🚀 Creating test manufacturer account...\n')

  try {
    // Check if user already exists
    const { data: existingUsers } = await supabase.auth.admin.listUsers()
    const existingUser = existingUsers?.users?.find(u => u.email === TEST_MANUFACTURER.email)

    let userId

    if (existingUser) {
      console.log('✓ User already exists:', existingUser.email)
      userId = existingUser.id
    } else {
      // Create auth user
      console.log('Creating auth user...')
      const { data: authData, error: authError } = await supabase.auth.admin.createUser({
        email: TEST_MANUFACTURER.email,
        password: TEST_MANUFACTURER.password,
        email_confirm: true,
        user_metadata: {
          role: 'manufacturer'
        }
      })

      if (authError) {
        throw new Error(`Failed to create auth user: ${authError.message}`)
      }

      userId = authData.user.id
      console.log('✓ Auth user created:', TEST_MANUFACTURER.email)
    }

    // Check if manufacturer profile exists
    const { data: existingManufacturer } = await supabase
      .from('manufacturers')
      .select('*')
      .eq('user_id', userId)
      .single()

    if (existingManufacturer) {
      console.log('✓ Manufacturer profile already exists')
      console.log('\n✅ Test manufacturer account ready!')
      printCredentials()
      return
    }

    // Create manufacturer profile
    console.log('Creating manufacturer profile...')
    const { data: manufacturerData, error: manufacturerError } = await supabase
      .from('manufacturers')
      .insert([{
        user_id: userId,
        company_name: TEST_MANUFACTURER.company_name,
        company_name_ar: TEST_MANUFACTURER.company_name_ar,
        country: TEST_MANUFACTURER.country,
        city: TEST_MANUFACTURER.city,
        region: TEST_MANUFACTURER.region,
        contact_email: TEST_MANUFACTURER.contact_email,
        contact_phone: TEST_MANUFACTURER.contact_phone,
        website_url: TEST_MANUFACTURER.website_url,
        description: TEST_MANUFACTURER.description,
        description_ar: TEST_MANUFACTURER.description_ar,
        business_license: TEST_MANUFACTURER.business_license,
        business_license_expiry: TEST_MANUFACTURER.business_license_expiry,
        verification_status: TEST_MANUFACTURER.verification_status
      }])
      .select()
      .single()

    if (manufacturerError) {
      throw new Error(`Failed to create manufacturer profile: ${manufacturerError.message}`)
    }

    console.log('✓ Manufacturer profile created')

    // Create sample vehicles
    console.log('Creating sample vehicles...')
    const { error: vehiclesError } = await supabase
      .from('vehicles')
      .insert([
        {
          manufacturer_id: manufacturerData.id,
          make: 'Test Motors',
          model: 'EV-1000',
          year: 2026,
          vehicle_type: 'EV',
          price: 150000,
          battery_capacity: 75.5,
          range: 520,
          charging_time: '30 min (10-80%)',
          top_speed: 180,
          acceleration: '5.8s',
          seating_capacity: 5,
          cargo_space: 450,
          availability: 'available',
          description: 'Premium electric sedan with advanced autonomous driving capabilities.',
          warranty_years: 5,
          warranty_km: 100000,
          origin_country: 'China',
          manufacturer_direct_price: 150000
        },
        {
          manufacturer_id: manufacturerData.id,
          make: 'Test Motors',
          model: 'SUV-2000',
          year: 2026,
          vehicle_type: 'EV',
          price: 220000,
          battery_capacity: 95.0,
          range: 600,
          charging_time: '35 min (10-80%)',
          top_speed: 200,
          acceleration: '4.5s',
          seating_capacity: 7,
          cargo_space: 750,
          availability: 'available',
          description: 'Luxury electric SUV with spacious interior and cutting-edge technology.',
          warranty_years: 5,
          warranty_km: 150000,
          origin_country: 'China',
          manufacturer_direct_price: 220000
        }
      ])

    if (vehiclesError) {
      console.warn('⚠ Warning: Could not create sample vehicles:', vehiclesError.message)
    } else {
      console.log('✓ Sample vehicles created')
    }

    console.log('\n✅ Test manufacturer account created successfully!')
    printCredentials()

  } catch (error) {
    console.error('\n❌ Error:', error.message)
    process.exit(1)
  }
}

function printCredentials() {
  console.log('\n📋 Test Manufacturer Credentials:')
  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━')
  console.log(`Email:    ${TEST_MANUFACTURER.email}`)
  console.log(`Password: ${TEST_MANUFACTURER.password}`)
  console.log(`Company:  ${TEST_MANUFACTURER.company_name}`)
  console.log(`Status:   ${TEST_MANUFACTURER.verification_status}`)
  console.log('\n🔗 Login at: http://localhost:3000/manufacturer-login')
  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n')
}

// Run the script
createTestManufacturer()
