/**
 * Script to apply charging stations migration directly to database
 * Run with: node scripts/apply-charging-migration.js
 */

const { createClient } = require('@supabase/supabase-js')
const { readFileSync } = require('fs')
const { join } = require('path')
require('dotenv').config({ path: '.env.local' })

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY

if (!supabaseUrl || !supabaseAnonKey) {
  console.error('❌ Missing Supabase credentials in .env.local')
  process.exit(1)
}

const supabase = createClient(supabaseUrl, supabaseAnonKey)

async function applyMigration() {
  console.log('🚀 Applying charging stations migration...\n')

  try {
    const migrationPath = join(__dirname, '../supabase/migrations/015_charging_stations_seed_data.sql')
    const sql = readFileSync(migrationPath, 'utf8')

    console.log('📜 Migration file:', migrationPath)
    console.log('📝 SQL statement length:', sql.length, 'characters\n')

    // Execute SQL via Supabase RPC
    const { data, error } = await supabase.rpc('exec_sql', { sql })

    if (error) {
      if (error.code === 'PGRST202') {
        console.log('⚠️  exec_sql function not found. Trying direct approach...\n')
        
        // Try executing as individual statements
        const statements = sql
          .split(';')
          .map(s => s.trim())
          .filter(s => s.length > 0 && !s.startsWith('--'))

        console.log(`📊 Found ${statements.length} SQL statements to execute\n`)

        for (let i = 0; i < Math.min(statements.length, 3); i++) {
          const statement = statements[i]
          if (statement.length > 50 && (statement.includes('INSERT') || statement.includes('CREATE'))) {
            console.log(`📝 Statement ${i + 1}:`, statement.substring(0, 100) + '...')
            
            // Since we can't execute raw SQL with anon key, let's use the seed script approach
            if (statement.includes('INSERT')) {
              console.log('⚠️  Cannot execute INSERT with anon key due to RLS.')
              console.log('❌ Please apply migration manually via Supabase Dashboard SQL Editor.')
              console.log('\n📋 Steps:')
              console.log('1. Open: https://app.supabase.com/project/your-project-id/sql/new')
              console.log('2. Copy the content of: supabase/migrations/015_charging_stations_seed_data.sql')
              console.log('3. Paste and click "Run"')
              return
            }
          }
        }
      } else {
        throw error
      }
    } else {
      console.log('✅ Migration applied successfully!')
      console.log('📊 Data:', data)
    }
  } catch (error) {
    console.error('\n❌ Migration failed:', error.message)
    console.log('\n⚠️  Due to Row Level Security policies, you may need to apply the migration manually.')
    console.log('\n📋 Manual steps:')
    console.log('1. Go to Supabase Dashboard: https://app.supabase.com')
    console.log('2. Select your project')
    console.log('3. Go to SQL Editor')
    console.log('4. Copy the content of: supabase/migrations/015_charging_stations_seed_data.sql')
    console.log('5. Paste and click "Run"')
  }
}

applyMigration()
  .then(() => {
    console.log('\n✨ Done!')
    process.exit(0)
  })
  .catch((error) => {
    console.error('\n💥 Fatal error:', error)
    process.exit(1)
  })
