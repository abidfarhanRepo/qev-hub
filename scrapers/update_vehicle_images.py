#!/usr/bin/env python3
"""
Update vehicle records with Supabase Storage image URLs
"""

import json
import os

def load_upload_results():
    """Load upload results from image uploader"""
    with open('/home/pi/Desktop/QEV/scrapers/upload_results.json', 'r') as f:
        return json.load(f)

def generate_update_sql(results):
    """Generate SQL UPDATE statements for vehicle images"""
    sql_statements = []

    for result in results:
        model = result['model']
        trim = result.get('trim', '')
        img_type = result['type']
        public_url = result['public_url']

        # Build WHERE clause
        where_conditions = [f"make = 'BYD'", f"model = '{model}'"]
        if trim:
            where_conditions.append(f"trim_level = '{trim}'")

        where_clause = " AND ".join(where_conditions)

        # Generate UPDATE SQL
        # We need to update the images JSONB column
        sql = f"""-- Update {model} {trim} - {img_type}
UPDATE vehicles
SET images = COALESCE(images, '[]'::jsonb) || jsonb_build_array(
    jsonb_build_object(
        'url', '{public_url}',
        'type', '{img_type}',
        'is_primary', {(img_type == 'exterior_front' or img_type == 'exterior')}
    )
)
WHERE {where_clause};
"""
        sql_statements.append(sql)

    return sql_statements

def main():
    print("=== Updating Vehicle Records with Supabase Storage URLs ===\n")

    results = load_upload_results()
    print(f"Loaded {len(results)} upload results\n")

    sql_statements = generate_update_sql(results)

    # Save to file
    output_file = '/home/pi/Desktop/QEV/scrapers/update_images.sql'
    with open(output_file, 'w') as f:
        f.write("-- Update BYD vehicle images with Supabase Storage URLs\n\n")
        for sql in sql_statements:
            f.write(sql + "\n")

    print(f"✓ Generated {len(sql_statements)} UPDATE statements")
    print(f"✓ Saved to: {output_file}")
    print(f"\nTo execute via Supabase MCP tool, run:")
    print(f"  cat {output_file}")

if __name__ == '__main__':
    main()
