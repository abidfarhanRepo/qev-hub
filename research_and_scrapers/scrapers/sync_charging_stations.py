#!/usr/bin/env python3
"""
Automated Charging Station Sync Job
Runs all scrapers and updates database with latest station data
Can be scheduled via cron or systemd timer
"""

import subprocess
import json
import os
from datetime import datetime
from pathlib import Path

# Log file
LOG_DIR = Path('/home/pi/Desktop/QEV/scrapers/logs')
LOG_DIR.mkdir(exist_ok=True)
LOG_FILE = LOG_DIR / f"sync_{datetime.now().strftime('%Y%m%d_%H%M%S')}.log"

def log(message: str):
    """Log message to console and file"""
    timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    log_message = f"[{timestamp}] {message}"
    print(log_message)
    with open(LOG_FILE, 'a') as f:
        f.write(log_message + '\n')

def run_scraper(scraper_name: str, script_path: str) -> dict:
    """Run a scraper script and return results"""
    log(f"Running {scraper_name}...")

    result = {
        'scraper': scraper_name,
        'started_at': datetime.now().isoformat(),
        'success': False,
        'stations_processed': 0,
        'error': None
    }

    try:
        # Set environment variable for Supabase key
        env = os.environ.copy()
        env['SUPABASE_SERVICE_KEY'] = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndtdW1wcXZ2b3lkbmdjYmZmb3p1Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NzE5Mzg4OSwiZXhwIjoyMDgyNzY5ODg5fQ.c8WcGF8BBRu1L6PjjW8rdQxmajGqg1FWzWx1jozFluc'

        # Run the scraper
        process = subprocess.run(
            ['python3', script_path],
            capture_output=True,
            text=True,
            env=env,
            timeout=300  # 5 minute timeout
        )

        result['success'] = process.returncode == 0
        result['stdout'] = process.stdout
        result['stderr'] = process.stderr

        if process.returncode != 0:
            result['error'] = process.stderr
            log(f"  ✗ Failed: {process.stderr[:200]}")
        else:
            # Try to extract station count from output
            if 'Processed' in process.stdout:
                for line in process.stdout.split('\n'):
                    if 'Processed' in line:
                        try:
                            count = int(line.split()[-1].strip('.').strip())
                            result['stations_processed'] = count
                            log(f"  ✓ Processed {count} stations")
                        except:
                            pass

    except subprocess.TimeoutExpired:
        result['error'] = 'Timeout after 300 seconds'
        log(f"  ✗ Timeout")
    except Exception as e:
        result['error'] = str(e)
        log(f"  ✗ Error: {e}")

    result['completed_at'] = datetime.now().isoformat()
    return result

def update_sync_status(results: list):
    """Update sync status in database"""
    log("Updating sync status in database...")

    # Save results to file for monitoring
    results_file = LOG_DIR / 'latest_sync_results.json'
    with open(results_file, 'w') as f:
        json.dump({
            'sync_time': datetime.now().isoformat(),
            'results': results,
            'summary': {
                'total_scrapers': len(results),
                'successful': sum(1 for r in results if r['success']),
                'failed': sum(1 for r in results if not r['success']),
                'total_stations': sum(r['stations_processed'] for r in results)
            }
        }, f, indent=2)

    log(f"  ✓ Results saved to {results_file}")

def send_alert(results: list):
    """Send alert if any scrapers failed"""
    failed = [r for r in results if not r['success']]
    if failed:
        log(f"⚠ ALERT: {len(failed)} scraper(s) failed:")
        for result in failed:
            log(f"  - {result['scraper']}: {result.get('error', 'Unknown error')}")

def main():
    """Main sync job"""
    log("=" * 60)
    log("Starting Charging Station Sync Job")
    log("=" * 60)

    # Define scrapers to run
    scrapers = [
        ('KAHRAMAA', '/home/pi/Desktop/QEV/scrapers/kahramaa_scraper.py'),
        ('WOQOD', '/home/pi/Desktop/QEV/scrapers/woqod_scraper.py'),
    ]

    results = []

    for scraper_name, script_path in scrapers:
        if os.path.exists(script_path):
            result = run_scraper(scraper_name, script_path)
            results.append(result)
        else:
            log(f"⚠ Scraper not found: {script_path}")
            results.append({
                'scraper': scraper_name,
                'success': False,
                'error': 'Script not found',
                'stations_processed': 0
            })

    # Update sync status
    update_sync_status(results)

    # Send alerts if needed
    send_alert(results)

    # Summary
    log("")
    log("=" * 60)
    log("Sync Job Summary")
    log("=" * 60)
    log(f"Total scrapers: {len(results)}")
    log(f"Successful: {sum(1 for r in results if r['success'])}")
    log(f"Failed: {sum(1 for r in results if not r['success'])}")
    log(f"Total stations processed: {sum(r['stations_processed'] for r in results)}")
    log("")
    log("Next sync in 5 minutes")
    log("=" * 60)

if __name__ == '__main__':
    main()
