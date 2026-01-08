const { createClient } = require('@supabase/supabase-js')
require('dotenv').config({ path: '.env.local' })

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL
const supabaseKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY

if (!supabaseUrl || !supabaseKey) {
  console.error('❌ Missing Supabase credentials')
  process.exit(1)
}

const supabase = createClient(supabaseUrl, supabaseKey)

async function verifySetup() {
  console.log('🔍 Verifying QEV Hub Database Setup')
  console.log('===================================\n')

  try {
    // Check manufacturers
    const { data: manufacturers, error: mfgError } = await supabase
      .from('manufacturers')
      .select('company_name, country, verification_status')
      .eq('verification_status', 'verified')

    if (mfgError) {
      console.error('❌ Error fetching manufacturers:', mfgError.message)
    } else {
      console.log('✅ Manufacturers Table:')
      console.log(`   Found ${manufacturers.length} verified manufacturers`)
      manufacturers.forEach(m => {
        console.log(`   • ${m.company_name} (${m.country})`)
      })
      console.log('')
    }

    // Check vehicles
    const { data: vehicles, error: vehError } = await supabase
      .from('vehicles')
      .select('manufacturer, model, year, vehicle_type, price_qar, manufacturer_direct_price, broker_market_price, stock_count, status')
      .eq('status', 'available')
      .order('manufacturer', { ascending: true })

    if (vehError) {
      console.error('❌ Error fetching vehicles:', vehError.message)
    } else {
      console.log('✅ Vehicles Table:')
      console.log(`   Found ${vehicles.length} available vehicles\n`)
      
      vehicles.forEach(v => {
        const savings = v.broker_market_price && v.manufacturer_direct_price 
          ? v.broker_market_price - v.manufacturer_direct_price 
          : 0
        const savingsPercent = v.broker_market_price 
          ? Math.round((savings / v.broker_market_price) * 100) 
          : 0
        
        console.log(`   📦 ${v.manufacturer} ${v.model} (${v.year})`)
        console.log(`      Type: ${v.vehicle_type} | Stock: ${v.stock_count}`)
        if (v.manufacturer_direct_price && v.broker_market_price) {
          console.log(`      Direct: QAR ${v.manufacturer_direct_price.toLocaleString()}`)
          console.log(`      Broker: QAR ${v.broker_market_price.toLocaleString()}`)
          console.log(`      💰 Save: QAR ${savings.toLocaleString()} (${savingsPercent}%)`)
        } else {
          console.log(`      Price: QAR ${v.price_qar.toLocaleString()}`)
        }
        console.log('')
      })
    }

    // Check price transparency
    const { data: transparentVehicles, error: transError } = await supabase
      .from('vehicles')
      .select('*')
      .eq('price_transparency_enabled', true)
      .not('broker_market_price', 'is', null)

    if (!transError) {
      console.log('✅ Price Transparency:')
      console.log(`   ${transparentVehicles.length} vehicles with price comparison enabled\n`)
    }

    // Summary
    console.log('📊 Summary:')
    console.log(`   Verified Manufacturers: ${manufacturers?.length || 0}`)
    console.log(`   Available Vehicles: ${vehicles?.length || 0}`)
    console.log(`   Price Transparency: ${transparentVehicles?.length || 0}`)
    console.log('')
    console.log('🌐 View marketplace at: http://localhost:3000/marketplace')
    console.log('🏭 View manufacturers at: http://localhost:3000/marketplace/manufacturers')
    console.log('')

    // Test vehicle type breakdown
    const evCount = vehicles.filter(v => v.vehicle_type === 'EV').length
    const phevCount = vehicles.filter(v => v.vehicle_type === 'PHEV').length
    const fcevCount = vehicles.filter(v => v.vehicle_type === 'FCEV').length
    
    console.log('🔋 Vehicle Type Breakdown:')
    console.log(`   Electric (EV): ${evCount}`)
    console.log(`   Plug-in Hybrid (PHEV): ${phevCount}`)
    console.log(`   Fuel Cell (FCEV): ${fcevCount}`)
    console.log('')

    console.log('✅ Database setup is working correctly!')
    
  } catch (error) {
    console.error('\n❌ Error:', error.message)
    process.exit(1)
  }
}

verifySetup()
