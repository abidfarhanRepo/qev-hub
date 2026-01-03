/**
 * Script to populate charging stations with sample data
 * Run with: node scripts/seed-charging-stations.js
 */

const { createClient } = require('@supabase/supabase-js')
require('dotenv').config({ path: '.env.local' })

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL
const supabaseKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY

if (!supabaseUrl || !supabaseKey) {
  console.error('❌ Missing Supabase credentials in .env.local')
  process.exit(1)
}

const supabase = createClient(supabaseUrl, supabaseKey)

const chargingStations = [
  {
    name: 'KAHRAMAA EV Charging Station - Katara',
    address: 'Katara Cultural Village, Doha, Qatar',
    latitude: 25.3548,
    longitude: 51.5326,
    provider: 'KAHRAMAA',
    charger_type: 'Type 2 / CCS',
    power_output_kw: 50.00,
    total_chargers: 4,
    available_chargers: 2,
    status: 'active',
    operating_hours: '24/7',
    pricing_info: 'Free (KAHRAMAA initiative)',
    amenities: ['Restaurant', 'WiFi', 'Restroom', 'Parking']
  },
  {
    name: 'KAHRAMAA EV Charging - The Pearl',
    address: 'Porto Arabia, The Pearl, Doha, Qatar',
    latitude: 25.3714,
    longitude: 51.5504,
    provider: 'KAHRAMAA',
    charger_type: 'Type 2 / CHAdeMO',
    power_output_kw: 50.00,
    total_chargers: 2,
    available_chargers: 1,
    status: 'active',
    operating_hours: '24/7',
    pricing_info: 'Free (KAHRAMAA initiative)',
    amenities: ['Shopping', 'Dining', 'Parking', 'WiFi']
  },
  {
    name: 'KAHRAMAA Charging Hub - Lusail',
    address: 'Lusail Boulevard, Lusail City, Qatar',
    latitude: 25.4192,
    longitude: 51.4966,
    provider: 'KAHRAMAA',
    charger_type: 'Type 2 / CCS / CHAdeMO',
    power_output_kw: 150.00,
    total_chargers: 6,
    available_chargers: 4,
    status: 'active',
    operating_hours: '24/7',
    pricing_info: 'Free (KAHRAMAA initiative)',
    amenities: ['Mall', 'Entertainment', 'Parking', 'WiFi', 'Cafe']
  },
  {
    name: 'EV Charging Station - Villaggio Mall',
    address: 'Villaggio Mall, Al Waab Street, Doha, Qatar',
    latitude: 25.2854,
    longitude: 51.4421,
    provider: 'Private',
    charger_type: 'Type 2',
    power_output_kw: 22.00,
    total_chargers: 4,
    available_chargers: 3,
    status: 'active',
    operating_hours: '10:00 - 23:00',
    pricing_info: '15 QAR/hour',
    amenities: ['Shopping', 'Dining', 'Restroom', 'Parking']
  },
  {
    name: 'Charging Station - City Center Mall',
    address: 'City Center Doha, West Bay, Qatar',
    latitude: 25.2867,
    longitude: 51.5335,
    provider: 'Private',
    charger_type: 'Type 2 / CCS',
    power_output_kw: 50.00,
    total_chargers: 3,
    available_chargers: 2,
    status: 'active',
    operating_hours: '09:00 - 00:00',
    pricing_info: '20 QAR/hour',
    amenities: ['Shopping', 'Dining', 'Restroom', 'Parking', 'Cinema']
  },
  {
    name: 'EV Charger - Doha Festival City',
    address: 'Doha Festival City, Al Rayyan, Qatar',
    latitude: 25.2585,
    longitude: 51.5405,
    provider: 'Private',
    charger_type: 'Type 2',
    power_output_kw: 11.00,
    total_chargers: 2,
    available_chargers: 1,
    status: 'active',
    operating_hours: '10:00 - 23:00',
    pricing_info: '12 QAR/hour',
    amenities: ['Shopping', 'Entertainment', 'Restroom', 'Parking']
  },
  {
    name: 'KAHRAMAA Charging - Qatar University',
    address: 'Qatar University, Al Tarafa, Doha, Qatar',
    latitude: 25.3775,
    longitude: 51.4978,
    provider: 'KAHRAMAA',
    charger_type: 'Type 2 / CHAdeMO',
    power_output_kw: 50.00,
    total_chargers: 2,
    available_chargers: 2,
    status: 'active',
    operating_hours: '07:00 - 22:00',
    pricing_info: 'Free for students',
    amenities: ['Cafe', 'WiFi', 'Restroom', 'Library']
  },
  {
    name: 'EV Charging - Education City',
    address: 'Education City, Al Rayyan, Qatar',
    latitude: 25.3199,
    longitude: 51.4375,
    provider: 'KAHRAMAA',
    charger_type: 'Type 2 / CCS',
    power_output_kw: 22.00,
    total_chargers: 4,
    available_chargers: 0,
    status: 'active',
    operating_hours: '07:00 - 23:00',
    pricing_info: 'Free (QF initiative)',
    amenities: ['Library', 'Cafe', 'WiFi', 'Restroom', 'Parking']
  },
  {
    name: 'Charging Station - Airport',
    address: 'Hamad International Airport, Doha, Qatar',
    latitude: 25.2609,
    longitude: 51.6138,
    provider: 'KAHRAMAA',
    charger_type: 'Type 2 / CCS / CHAdeMO',
    power_output_kw: 150.00,
    total_chargers: 8,
    available_chargers: 5,
    status: 'active',
    operating_hours: '24/7',
    pricing_info: '30 QAR/hour',
    amenities: ['Restroom', 'Dining', 'Shopping', 'WiFi', 'Parking']
  },
  {
    name: 'EV Charger - Msheireb Downtown',
    address: 'Msheireb Downtown Doha, Qatar',
    latitude: 25.2889,
    longitude: 51.5318,
    provider: 'Private',
    charger_type: 'Type 2',
    power_output_kw: 22.00,
    total_chargers: 2,
    available_chargers: 1,
    status: 'active',
    operating_hours: '08:00 - 22:00',
    pricing_info: '18 QAR/hour',
    amenities: ['Dining', 'Shopping', 'Restroom', 'Parking']
  },
  {
    name: 'Charging Station - Al Wakrah',
    address: 'Al Wakrah Mall, Al Wakrah, Qatar',
    latitude: 25.1725,
    longitude: 51.6035,
    provider: 'KAHRAMAA',
    charger_type: 'Type 2',
    power_output_kw: 22.00,
    total_chargers: 2,
    available_chargers: 2,
    status: 'active',
    operating_hours: '10:00 - 23:00',
    pricing_info: 'Free (KAHRAMAA initiative)',
    amenities: ['Shopping', 'Dining', 'Restroom', 'Parking']
  },
  {
    name: 'EV Charging - Al Khor',
    address: 'Al Khor Mall, Al Khor, Qatar',
    latitude: 25.6848,
    longitude: 51.4959,
    provider: 'KAHRAMAA',
    charger_type: 'Type 2',
    power_output_kw: 22.00,
    total_chargers: 1,
    available_chargers: 1,
    status: 'active',
    operating_hours: '10:00 - 22:00',
    pricing_info: 'Free (KAHRAMAA initiative)',
    amenities: ['Shopping', 'Dining', 'Restroom', 'Parking']
  },
  {
    name: 'Fast Charger - Doha Port',
    address: 'Doha Port, Old Doha Port, Qatar',
    latitude: 25.2855,
    longitude: 51.5350,
    provider: 'KAHRAMAA',
    charger_type: 'CCS / CHAdeMO',
    power_output_kw: 150.00,
    total_chargers: 4,
    available_chargers: 3,
    status: 'active',
    operating_hours: '24/7',
    pricing_info: '25 QAR/hour',
    amenities: ['Dining', 'Restroom', 'Parking', 'WiFi']
  },
  {
    name: 'Charging Station - The Gate Mall',
    address: 'The Gate Mall, West Bay, Doha, Qatar',
    latitude: 25.2899,
    longitude: 51.5353,
    provider: 'Private',
    charger_type: 'Type 2',
    power_output_kw: 22.00,
    total_chargers: 2,
    available_chargers: 2,
    status: 'active',
    operating_hours: '09:00 - 23:00',
    pricing_info: '20 QAR/hour',
    amenities: ['Shopping', 'Dining', 'Restroom', 'Parking']
  },
  {
    name: 'EV Charger - Landmark Mall',
    address: 'Landmark Mall, Al Markhiya, Doha, Qatar',
    latitude: 25.3265,
    longitude: 51.4642,
    provider: 'Private',
    charger_type: 'Type 2 / CCS',
    power_output_kw: 50.00,
    total_chargers: 3,
    available_chargers: 1,
    status: 'active',
    operating_hours: '10:00 - 23:00',
    pricing_info: '22 QAR/hour',
    amenities: ['Shopping', 'Dining', 'Restroom', 'Parking']
  }
]

async function seedChargingStations() {
  console.log('🚀 Starting charging stations seed...')
  console.log(`📍 Adding ${chargingStations.length} charging stations...\n`)

  let successCount = 0
  let errorCount = 0

  for (const station of chargingStations) {
    try {
      // First check if station already exists
      const { data: existing } = await supabase
        .from('charging_stations')
        .select('id')
        .eq('name', station.name)
        .eq('latitude', station.latitude)
        .eq('longitude', station.longitude)
        .single()

      let error
      if (existing) {
        // Update existing station
        const result = await supabase
          .from('charging_stations')
          .update(station)
          .eq('id', existing.id)
        error = result.error
        console.log(`🔄 Updated: ${station.name}`)
      } else {
        // Insert new station
        const result = await supabase
          .from('charging_stations')
          .insert(station)
        error = result.error
        console.log(`✅ Added: ${station.name}`)
      }

      if (error) throw error

      successCount++
    } catch (error) {
      errorCount++
      console.error(`❌ Failed to add ${station.name}:`, error.message)
    }
  }

  console.log(`\n📊 Summary:`)
  console.log(`   ✅ Successfully added: ${successCount}`)
  console.log(`   ❌ Failed: ${errorCount}`)

  if (successCount === chargingStations.length) {
    console.log(`\n🎉 All charging stations added successfully!`)
    console.log(`\n🗺️ Visit http://localhost:3000/charging to see the map with markers!`)
  } else {
    console.log(`\n⚠️  Some stations failed to add. Check the errors above.`)
  }
}

seedChargingStations()
  .then(() => {
    console.log('\n✨ Done!')
    process.exit(0)
  })
  .catch((error) => {
    console.error('\n💥 Fatal error:', error)
    process.exit(1)
  })
