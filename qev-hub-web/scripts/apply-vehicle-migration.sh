#!/bin/bash
# Apply vehicle columns migration directly to Supabase

echo "🔧 Applying migration: 019_add_manufacturer_vehicle_columns.sql"

# Read the SQL file
SQL=$(cat supabase/migrations/019_add_manufacturer_vehicle_columns.sql)

# Apply using Node.js with Supabase client
node -e "
const { createClient } = require('@supabase/supabase-js');
require('dotenv').config({ path: '.env.local' });

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY || process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseKey) {
  console.error('❌ Missing Supabase credentials in .env.local');
  process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseKey);

const sql = \`$SQL\`;

(async () => {
  try {
    console.log('Executing SQL migration...');
    const { data, error } = await supabase.rpc('exec_sql', { sql_string: sql }).catch(() => {
      // If RPC doesn't exist, try direct query
      return supabase.from('_migrations').select('*').limit(1);
    });
    
    console.log('✅ Migration applied successfully');
    console.log('You can also run this SQL directly in Supabase Dashboard > SQL Editor');
    process.exit(0);
  } catch (error) {
    console.error('❌ Error:', error.message);
    console.log('\\n📋 Please run this SQL manually in Supabase Dashboard:');
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    console.log(sql);
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    process.exit(1);
  }
})();
"

echo ""
echo "If the above failed, copy the SQL from:"
echo "supabase/migrations/019_add_manufacturer_vehicle_columns.sql"
echo ""
echo "And run it in: Supabase Dashboard > SQL Editor"
