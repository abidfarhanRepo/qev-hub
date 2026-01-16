#!/usr/bin/env python3
"""
Execute BYD SQL inserts in batches via subprocess calling Supabase MCP tool
"""

import subprocess
import json
import re
import time

def read_sql_file(filepath):
    """Read the SQL file and split into individual statements"""
    with open(filepath, 'r') as f:
        content = f.read()

    # Split by semicolon followed by newlines
    statements = []
    for stmt in content.split(';'):
        stmt = stmt.strip()
        if stmt and not stmt.startswith('--'):
            # Clean up extra whitespace
            stmt = re.sub(r'\n+', ' ', stmt)
            statements.append(stmt)

    return statements

def execute_via_supabase(sql):
    """Execute SQL via Supabase MCP tool using subprocess"""
    # Create a temporary Python script that will be executed
    # This script will use the MCP tool

    # Escape the SQL for shell
    escaped_sql = sql.replace("'", "'\\''")

    # We'll use mcp command if available, otherwise print the SQL
    print(f"Executing: {sql[:80]}...")

    # For now, save to a batch file that can be executed
    return None

def main():
    print("=== BYD Data Insertion ===\n")

    # Read SQL statements
    statements = read_sql_file('/home/pi/Desktop/QEV/scrapers/byd_insert.sql')

    # Filter out empty statements and scrape_jobs
    insert_statements = [s for s in statements if 'INSERT INTO vehicles' in s]
    scrape_statement = [s for s in statements if 'INSERT INTO scrape_jobs' in s]

    print(f"Found {len(insert_statements)} vehicle INSERT statements")
    print(f"Found {len(scrape_statement)} scrape job INSERT statement\n")

    # Write individual statements to batch files for execution
    batch_dir = '/home/pi/Desktop/QEV/scrapers/batches'
    os.makedirs(batch_dir, exist_ok=True)

    for i, stmt in enumerate(insert_statements, 1):
        # Write each statement to a file
        filename = f'{batch_dir}/insert_{i:03d}.sql'
        with open(filename, 'w') as f:
            f.write(stmt + ';\n')
        print(f"  Wrote: {filename}")

    # Write scrape job
    if scrape_statement:
        with open(f'{batch_dir}/scrape_job.sql', 'w') as f:
            f.write(scrape_statement[0] + ';\n')
        print(f"  Wrote: {batch_dir}/scrape_job.sql")

    print(f"\n✓ Created {len(insert_statements)} batch files in {batch_dir}")
    print("\nTo execute these, use the Supabase MCP tool or run:")
    print(f"  for f in {batch_dir}/*.sql; do cat $f; echo ''; done")

if __name__ == '__main__':
    import os
    main()
