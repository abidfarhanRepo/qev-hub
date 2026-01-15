#!/bin/bash

# Script to run the enhanced charging stations migration
# Usage: ./run_enhanced_migration.sh

echo "🔧 Running Enhanced Charging Stations Migration..."

# Check if we're in the right directory
if [ ! -f "supabase/migrations/020_enhanced_charging_stations.sql" ]; then
    echo "❌ Error: Migration file not found. Please run from qev-hub-web directory."
    exit 1
fi

# Run the migration
echo "📊 Creating enhanced charging stations table with Tarsheed data..."
supabase db push

if [ $? -eq 0 ]; then
    echo "✅ Migration completed successfully!"
    
    echo "📈 Migration Summary:"
    echo "  - Enhanced charging stations table created"
    echo "  - Tarsheed data imported (59 stations)"
    echo "  - Connector types: Type 2, CCS, CHAdeMO"
    echo "  - Power levels: 22kW, 50kW, 150kW"
    echo "  - Operators: KAHRAMAA, WOQOD, ABB, Q-RAIL"
    echo "  - PostGIS spatial indexing enabled"
    echo "  - Real-time availability support"
    
    echo ""
    echo "🎯 Next Steps:"
    echo "  1. Update QEV mobile app to use EnhancedChargingScreen"
    echo "  2. Test connector icons and power indicators"
    echo "  3. Verify map markers with availability colors"
    echo "  4. Test filtering by connector types and operators"
    
else
    echo "❌ Migration failed. Please check the error above."
    exit 1
fi