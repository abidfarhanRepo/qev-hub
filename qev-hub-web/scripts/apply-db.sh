#!/bin/bash

# QEV Hub - Direct Database Setup using Supabase REST API
set -e

echo "🚀 QEV Hub Database Setup"
echo "========================="
echo ""

# Load environment variables
if [ -f .env.local ]; then
  export $(cat .env.local | grep -v '^#' | xargs)
fi

SUPABASE_URL="$NEXT_PUBLIC_SUPABASE_URL"
SUPABASE_KEY="$NEXT_PUBLIC_SUPABASE_ANON_KEY"

if [ -z "$SUPABASE_URL" ] || [ -z "$SUPABASE_KEY" ]; then
  echo "❌ Error: Missing Supabase credentials in .env.local"
  exit 1
fi

echo "📋 Instructions:"
echo ""
echo "Due to security restrictions, we cannot run arbitrary SQL from scripts."
echo "Please follow these steps:"
echo ""
echo "1. Open Supabase SQL Editor:"
echo "   https://app.supabase.com/project/wmumpqvvoydngcbffozu/sql/new"
echo ""
echo "2. Copy the entire contents of:"
echo "   $(pwd)/scripts/setup-database.sql"
echo ""
echo "3. Paste into the SQL Editor and click 'Run'"
echo ""
echo "This will create:"
echo "   ✓ 4 verified manufacturers"
echo "   ✓ 6 sample vehicles with price transparency"
echo "   ✓ All necessary tables and indexes"
echo ""
echo "Or use this one-liner to copy to clipboard (Linux):"
echo ""
echo "  cat scripts/setup-database.sql | xclip -selection clipboard"
echo ""
echo "Then just paste (Ctrl+V) in Supabase SQL Editor!"
echo ""

# Offer to open the file for easy copying
read -p "Open setup-database.sql in editor? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
  if command -v code &> /dev/null; then
    code scripts/setup-database.sql
  elif command -v nano &> /dev/null; then
    nano scripts/setup-database.sql
  elif command -v vim &> /dev/null; then
    vim scripts/setup-database.sql
  else
    cat scripts/setup-database.sql
  fi
fi
