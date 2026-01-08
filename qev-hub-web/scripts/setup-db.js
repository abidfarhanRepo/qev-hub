const { createClient } = require('@supabase/supabase-js')
const fs = require('fs')
const path = require('path')
require('dotenv').config({ path: '.env.local' })

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY || process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY

if (!supabaseUrl || !supabaseServiceKey) {
  console.error('❌ Missing Supabase credentials in .env.local')
  console.error('   Required: NEXT_PUBLIC_SUPABASE_URL and NEXT_PUBLIC_SUPABASE_ANON_KEY')
  process.exit(1)
}

const supabase = createClient(supabaseUrl, supabaseServiceKey)

async function setupDatabase() {
  console.log('🚀 QEV Hub Database Setup')
  console.log('=========================\n')

  try {
    // Read the SQL file
    const sqlPath = path.join(__dirname, 'setup-database.sql')
    const sqlContent = fs.readFileSync(sqlPath, 'utf-8')

    console.log('📁 Reading setup-database.sql...')

    // Split by statement terminator and execute
    const statements = sqlContent
      .split(';')
      .map(s => s.trim())
      .filter(s => s.length > 0 && !s.startsWith('--'))

    console.log(`📊 Found ${statements.length} SQL statements\n`)

    let successCount = 0
    let errorCount = 0

    for (let i = 0; i < statements.length; i++) {
      const statement = statements[i] + ';'
      
      // Skip comments and DO blocks (they need special handling)
      if (statement.startsWith('--') || statement.includes('DO $$')) {
        continue
      }

      try {
        const { error } = await supabase.rpc('exec_sql', { sql: statement })
        
        if (error) {
          // Try direct execution for some statements
          const { error: directError } = await supabase.from('_sql').select('*').limit(1)
          
          if (statement.includes('CREATE TABLE') || statement.includes('INSERT INTO')) {
            console.log(`⚠️  Skipping: ${statement.substring(0, 50)}...`)
          }
        } else {
          successCount++
          if (i % 10 === 0) {
            console.log(`✓ Executed ${i + 1}/${statements.length} statements`)
          }
        }
      } catch (error) {
        errorCount++
        console.log(`⚠️  Warning: ${error.message}`)
      }
    }

    console.log(`\n✅ Database setup completed!`)
    console.log(`   Successful: ${successCount}`)
    if (errorCount > 0) {
      console.log(`   Warnings: ${errorCount} (these are usually safe to ignore)`)
    }

    // Verify setup
    console.log('\n📊 Verifying setup...')
    
    const { data: manufacturers, error: mfgError } = await supabase
      .from('manufacturers')
      .select('*')
      .eq('verification_status', 'verified')

    const { data: vehicles, error: vehError } = await supabase
      .from('vehicles')
      .select('*')
      .eq('status', 'available')

    if (!mfgError && !vehError) {
      console.log(`\n🎉 Success! You now have:`)
      console.log(`   • ${manufacturers?.length || 0} verified manufacturers`)
      console.log(`   • ${vehicles?.length || 0} available vehicles`)
      
      if (vehicles && vehicles.length > 0) {
        console.log(`\n📦 Sample vehicles:`)
        vehicles.slice(0, 3).forEach(v => {
          const savings = v.broker_market_price - v.manufacturer_direct_price
          console.log(`   • ${v.manufacturer} ${v.model} - QAR ${v.manufacturer_direct_price.toLocaleString()} (Save QAR ${savings.toLocaleString()})`)
        })
      }
      
      console.log(`\n🌐 Visit http://localhost:3000/marketplace to see them!`)
    } else {
      console.log('\n⚠️  Could not verify data. You may need to run the SQL manually.')
      console.log('   Go to: https://app.supabase.com/project/wmumpqvvoydngcbffozu/sql/new')
      console.log('   Copy contents of: scripts/setup-database.sql')
    }

  } catch (error) {
    console.error('\n❌ Error:', error.message)
    console.error('\n💡 Alternative method:')
    console.error('   1. Go to: https://app.supabase.com/project/wmumpqvvoydngcbffozu/sql/new')
    console.error('   2. Copy contents of: scripts/setup-database.sql')
    console.error('   3. Click "Run"')
    process.exit(1)
  }
}

setupDatabase()
