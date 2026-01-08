#!/bin/bash

# QEV Hub - Database Setup Script
# This script applies the complete database setup using psql

set -e

echo "🚀 QEV Hub Database Setup"
echo "========================="

# Load environment variables
if [ -f .env.local ]; then
  export $(cat .env.local | grep -v '^#' | xargs)
fi

# Extract project ID from Supabase URL
PROJECT_ID=$(echo $NEXT_PUBLIC_SUPABASE_URL | sed -E 's|https://([^.]+)\.supabase\.co|\1|')

echo "📊 Project ID: $PROJECT_ID"

# Prompt for database password
echo ""
echo "⚠️  You'll need your Supabase database password."
echo "   Find it at: https://app.supabase.com/project/$PROJECT_ID/settings/database"
echo ""
read -sp "Enter your Supabase database password: " DB_PASSWORD
echo ""

# Construct connection string
CONNECTION_STRING="postgresql://postgres:${DB_PASSWORD}@db.${PROJECT_ID}.supabase.co:5432/postgres"

echo ""
echo "📁 Applying database setup script..."

# Apply the setup script
psql "$CONNECTION_STRING" -f scripts/setup-database.sql

echo ""
echo "✅ Database setup complete!"
echo ""
echo "🎉 You should now have:"
echo "   • 4 verified manufacturers (BYD, GAC AION, NIO, XPeng)"
echo "   • 6 sample vehicles with price transparency"
echo "   • All B2C marketplace features enabled"
echo ""
echo "🌐 Visit http://localhost:3000/marketplace to see your vehicles!"
echo ""
