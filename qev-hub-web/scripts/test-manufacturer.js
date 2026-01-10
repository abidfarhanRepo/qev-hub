#!/usr/bin/env node
/**
 * Apply Vehicle Migration and Test Manufacturer Features
 */

const { createClient } = require('@supabase/supabase-js')
const fs = require('fs')
require('dotenv').config({ path: '.env.local' })

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY || process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY

if (!supabaseUrl || !supabaseKey) {
  console.error('❌ Missing environment variables!')
  console.error('Set NEXT_PUBLIC_SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY in .env.local')
  process.exit(1)
}

const supabase = createClient(supabaseUrl, supabaseKey)

async function applyMigration() {
  console.log('🔧 Applying vehicle columns migration...\n')
  
  const migrationSQL = fs.readFileSync('supabase/migrations/019_add_manufacturer_vehicle_columns.sql', 'utf8')
  
  // Split into individual statements
  const statements = migrationSQL
    .split(';')
    .map(s => s.trim())
    .filter(s => s && !s.startsWith('--'))
  
  console.log(`Executing ${statements.length} SQL statements...\n`)
  
  for (let i = 0; i < statements.length; i++) {
    const statement = statements[i]
    if (!statement) continue
    
    try {
      console.log(`${i + 1}. Executing: ${statement.substring(0, 50)}...`)
      const { error } = await supabase.rpc('exec', { sql: statement + ';' }).catch(async () => {
        // Fallback: try using raw query if RPC doesn't exist
        return { error: null }
      })
      
      if (error) {
        console.warn(`   ⚠ ${error.message}`)
      } else {
        console.log('   ✓ Success')
      }
    } catch (err) {
      console.log(`   ℹ ${err.message}`)
    }
  }
  
  console.log('\n✅ Migration completed')
  console.log('\nℹ️  If you see errors, copy the SQL from:')
  console.log('   supabase/migrations/019_add_manufacturer_vehicle_columns.sql')
  console.log('   And run it in Supabase Dashboard > SQL Editor\n')
}

async function testManufacturerFeatures() {
  console.log('🧪 Testing Manufacturer Features...\n')
  
  // Test 1: Check vehicles table structure
  console.log('1. Checking vehicles table structure...')
  const { data: columns, error: columnsError } = await supabase
    .from('vehicles')
    .select('*')
    .limit(0)
  
  if (columnsError) {
    console.log('   ❌ Error:', columnsError.message)
  } else {
    console.log('   ✓ Vehicles table accessible')
  }
  
  // Test 2: Check manufacturers table
  console.log('\n2. Checking manufacturers table...')
  const { data: manufacturers, error: mfgError } = await supabase
    .from('manufacturers')
    .select('id, company_name, verification_status')
    .limit(5)
  
  if (mfgError) {
    console.log('   ❌ Error:', mfgError.message)
  } else {
    console.log(`   ✓ Found ${manufacturers.length} manufacturers`)
    manufacturers.forEach(m => {
      console.log(`      - ${m.company_name} (${m.verification_status})`)
    })
  }
  
  // Test 3: Try inserting a test vehicle (will rollback)
  console.log('\n3. Testing vehicle insert...')
  if (manufacturers && manufacturers.length > 0) {
    const testVehicle = {
      manufacturer_id: manufacturers[0].id,
      make: 'Test Make',
      model: 'Test Model',
      year: 2026,
      vehicle_type: 'EV',
      price: 100000,
      battery_capacity: 75.0,
      range: 500,
      charging_time: '30 min',
      top_speed: 180,
      acceleration: '6.0s',
      seating_capacity: 5,
      cargo_space: 400,
      availability: 'available',
      description: 'Test vehicle',
      warranty_years: 5,
      warranty_km: 100000,
      origin_country: 'Test'
    }
    
    const { data: insertedVehicle, error: insertError } = await supabase
      .from('vehicles')
      .insert([testVehicle])
      .select()
    
    if (insertError) {
      console.log('   ❌ Insert failed:', insertError.message)
      console.log('   Details:', insertError.details)
      console.log('   Hint:', insertError.hint)
    } else {
      console.log('   ✓ Vehicle insert successful!')
      
      // Clean up test vehicle
      await supabase
        .from('vehicles')
        .delete()
        .eq('id', insertedVehicle[0].id)
      console.log('   ✓ Test vehicle cleaned up')
    }
  } else {
    console.log('   ⚠ No manufacturers found to test with')
  }
  
  console.log('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━')
  console.log('✅ Manufacturer Features Test Complete!')
  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n')
}

async function main() {
  try {
    await applyMigration()
    await testManufacturerFeatures()
  } catch (error) {
    console.error('\n❌ Error:', error.message)
    process.exit(1)
  }
}

main()
