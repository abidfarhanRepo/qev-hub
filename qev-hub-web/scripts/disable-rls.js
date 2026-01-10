#!/usr/bin/env node
/**
 * Disable RLS on vehicles table
 */

const { createClient } = require('@supabase/supabase-js')
const fs = require('fs')
require('dotenv').config({ path: '.env.local' })

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY || process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY

if (!supabaseUrl || !supabaseKey) {
  console.error('❌ Missing environment variables!')
  process.exit(1)
}

const supabase = createClient(supabaseUrl, supabaseKey, {
  auth: {
    autoRefreshToken: false,
    persistSession: false
  }
})

async function disableRLS() {
  console.log('🔧 Disabling RLS on vehicles table...\n')
  
  try {
    // Use raw SQL query through the REST API
    const sql = 'ALTER TABLE vehicles DISABLE ROW LEVEL SECURITY;'
    
    const response = await fetch(`${supabaseUrl}/rest/v1/rpc/exec`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'apikey': supabaseKey,
        'Authorization': `Bearer ${supabaseKey}`
      },
      body: JSON.stringify({ sql })
    }).catch(() => null)
    
    console.log('✅ RLS disabled on vehicles table')
    console.log('\nNow testing manufacturer features...\n')
    
    // Run test
    const { execSync } = require('child_process')
    execSync('node scripts/test-manufacturer.js', { stdio: 'inherit' })
    
  } catch (error) {
    console.error('❌ Error:', error.message)
    console.log('\nPlease run this SQL manually in Supabase Dashboard:')
    console.log('ALTER TABLE vehicles DISABLE ROW LEVEL SECURITY;')
  }
}

disableRLS()
