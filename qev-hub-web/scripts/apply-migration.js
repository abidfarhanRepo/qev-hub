/**
 * Script to apply database migration to Supabase
 * Run: node scripts/apply-migration.js
 */

const { createClient } = require('@supabase/supabase-js')
const fs = require('fs')
const path = require('path')
require('dotenv').config({ path: '.env.local' })

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL
const supabaseKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY

if (!supabaseUrl || !supabaseKey) {
  console.error('❌ Missing environment variables')
  console.log('Make sure NEXT_PUBLIC_SUPABASE_URL and NEXT_PUBLIC_SUPABASE_ANON_KEY are set in .env.local')
  process.exit(1)
}

const supabase = createClient(supabaseUrl, supabaseKey)

async function applyMigration() {
  try {
    console.log('📋 Applying charging stations migration...')

    // Read migration file
    const migrationPath = path.join(__dirname, '../supabase/migrations/011_charging_stations.sql')
    const migrationSql = fs.readFileSync(migrationPath, 'utf-8')

    console.log('📄 Migration file loaded')

    // Note: We can't execute raw SQL through the standard Supabase client
    // This script is for documentation purposes
    console.log('\n⚠️  IMPORTANT: Migration needs to be applied manually')
    console.log('─────────────────────────────────────────────────────────────')
    console.log('To apply the migration, you have two options:')
    console.log('')
    console.log('OPTION 1: Use Supabase Dashboard (Recommended)')
    console.log('  1. Go to: https://app.supabase.com/project/wmumpqvvoydngcbffozu/sql/new')
    console.log('  2. Copy the SQL from: supabase/migrations/011_charging_stations.sql')
    console.log('  3. Paste and run in the SQL editor')
    console.log('')
    console.log('OPTION 2: Use Supabase CLI')
    console.log('  1. Install: npm install -g supabase')
    console.log('  2. Link: supabase link --project-ref wmumpqvvoydngcbffozu')
    console.log('  3. Push: supabase db push')
    console.log('')
    console.log('─────────────────────────────────────────────────────────────')
    console.log('\nAfter applying migration, refresh the page to see charging stations!')

  } catch (error) {
    console.error('❌ Error:', error.message)
    process.exit(1)
  }
}

applyMigration()
