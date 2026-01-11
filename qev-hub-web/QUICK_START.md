# Tarsheed Data Capture - Quick Start Guide

## Current Status

### ✅ Ready
- Machine IP: `192.168.10.234`
- mitmproxy installed: `/usr/bin/mitmproxy`
- Capture script: `scripts/tarsheed-capture.py`
- Instructions file: `REAL_DEVICE_INSTRUCTIONS.md`

### ⚠️ mitmproxy Must Run in Interactive Terminal

**Important:** You need to start mitmproxy in your own terminal (I cannot start it from non-interactive shell).

---

## 📋 3-STEP QUICK START

### Step 1: Start mitmproxy

**In YOUR terminal:**
```bash
cd /home/pi/Desktop/QEV/qev-hub-web
/usr/bin/mitmproxy --listen-host 0.0.0.0 --listen-port 8080 -s scripts/tarsheed-capture.py --set block_global=false --ssl-insecure
```

**Leave this terminal open and running!**

**You should see:**
```
Mitmproxy starting...
HTTP server listening at 0.0.0.0:8080
```

---

### Step 2: Configure Your Android Device

**On your Android device:**

#### 2.1 Install Certificate

1. Open Chrome browser
2. Navigate to: `http://192.168.10.234:8080/mitm.it`
3. Download: "Android CA certificate"
4. Go to: Settings → Security → Install from storage
5. Select: Download/mitmproxy-ca-cert.cer
6. Name it: `mitmproxy`
7. Choose: "VPN and apps"
8. Confirm installation

#### 2.2 Set WiFi Proxy

1. Go to: Settings → WiFi
2. Long-press your connected network
3. Choose: "Modify network"
4. Scroll to: "Proxy"
5. Enable proxy:
   - Proxy hostname: `192.168.10.234`
   - Proxy port: `8080`
6. Save

#### 2.3 Test Proxy

1. Open browser on Android
2. Navigate to: http://google.com
3. If it loads, proxy is working!

---

### Step 3: Navigate Tarsheed App

**On your Android device:**

1. Open Tarsheed app
2. Login with your Qatar credentials
3. Navigate to charging stations section

**Explore for 20-30 minutes:**

1. **Map View:** Zoom out, pan around Qatar to load all regions
2. **List View:** Scroll through entire list
3. **Station Details:** Tap 10-15 stations to see details
4. **Filters:** Try different filters if available
5. **Refresh:** Pull-to-refresh to reload data

**Watch mitmproxy terminal - you should see:**
```
✓ Captured [1]: GET /api/v1/charging/stations
✓ Captured [2]: GET /api/v1/charging/station/123/details
```

---

### Step 4: Stop & Import

**When done navigating Tarsheed app:**

#### 4.1 Stop mitmproxy

In your terminal (running mitmproxy): Press `Ctrl+C`

#### 4.2 Parse Data

```bash
cd /home/pi/Desktop/QEV/qev-hub-web
node scripts/parse-tarsheed-capture.js
```

#### 4.3 Create Backup (in Supabase)

Open Supabase SQL Editor and run:
```sql
CREATE TABLE charging_stations_backup AS 
SELECT * FROM charging_stations;
```

#### 4.4 Import Data

```bash
node scripts/clear-and-import-tarsheed.js
```

---

## ✅ READY

**Start mitmproxy in your terminal, then configure your Android device!**

Full documentation: `REAL_DEVICE_INSTRUCTIONS.md`
