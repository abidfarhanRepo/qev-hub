#!/usr/bin/env node
/**
 * Quick SQL Migration Runner
 * Runs SQL migration through Supabase API
 */

const https = require('https')
const fs = require('fs')
require('dotenv').config({ path: '.env.local' })

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY || process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY

if (!supabaseUrl || !supabaseKey) {
  console.error('❌ Missing environment variables')
  process.exit(1)
}

const sql = fs.readFileSync('supabase/migrations/019_add_manufacturer_vehicle_columns.sql', 'utf8')

const projectRef = supabaseUrl.match(/https:\/\/([^.]+)/)?.[1]

const options = {
  hostname: `${projectRef}.supabase.co`,
  port: 443,
  path: '/rest/v1/rpc/exec',
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'apikey': supabaseKey,
    'Authorization': `Bearer ${supabaseKey}`
  }
}

console.log('Attempting to run SQL migration via REST API...\n')
console.log('If this fails, please run the following SQL in Supabase Dashboard:\n')
console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━')
console.log(sql)
console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n')

const req = https.request(options, (res) => {
  let data = ''
  
  res.on('data', (chunk) => {
    data += chunk
  })
  
  res.on('end', () => {
    if (res.statusCode === 200 || res.statusCode === 201) {
      console.log('✅ Migration applied successfully!')
    } else {
      console.log(`⚠ Response status: ${res.statusCode}`)
      console.log('Response:', data)
      console.log('\n📋 Please run the SQL above manually in Supabase Dashboard > SQL Editor')
    }
  })
})

req.on('error', (error) => {
  console.error('❌ Request failed:', error.message)
  console.log('\n📋 Please run the SQL above manually in Supabase Dashboard > SQL Editor')
})

req.write(JSON.stringify({ sql_string: sql }))
req.end()
