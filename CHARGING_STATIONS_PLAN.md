# QEV Charging Stations Development Plan

## Current State

### What Exists ✓
- **Database**: `charging_stations_enhanced` table with PostGIS support
- **Data**: 26+ Qatar stations, 118+ chargers pre-populated
- **Flutter UI**: Map view, station cards, booking flow
- **Operators**: KAHRAMAA, WOQOD, ABB, QRail
- **Booking System**: Time slots, status tracking

### What's Missing ✗
- Real-time availability (no WebSockets)
- Automated data collection (no scrapers)
- Payment integration for charging
- Individual chargers table
- Live session monitoring

---

## Development Plan

### Phase 1: Data Collection & Real-Time Updates (Priority: HIGH)

#### 1.1 Scrapers for Official Sources
```
scrapers/
├── kahramaa_scraper.py    # KAHRAMAA station data & availability
├── woqod_scraper.py       # WOQOD charging network
└── station_aggregator.py  # Combine all sources
```

**Tasks:**
- [ ] Scrape KAHRAMAA website for station locations/availability
- [ ] Scrape WOQOD charging stations
- [ ] Build automated sync job (every 5 minutes)
- [ ] Handle errors gracefully with fallback data

#### 1.2 Real-Time Availability System
```sql
-- Add real-time tracking
ALTER TABLE charging_stations_enhanced
ADD COLUMN last_synced_at TIMESTAMP WITH TIME ZONE,
ADD COLUMN availability_source TEXT; -- 'scraped', 'manual', 'api'
```

**Tasks:**
- [ ] Implement Supabase Realtime subscriptions
- [ ] Add WebSocket connection in Flutter app
- [ ] Create availability update API endpoint
- [ ] Build admin dashboard for manual overrides

#### 1.3 Individual Chargers Table
```sql
CREATE TABLE chargers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    station_id UUID REFERENCES charging_stations_enhanced(id),
    charger_code TEXT UNIQUE, -- e.g., "KH-LUM-01"
    connector_types TEXT[], -- ['Type 2', 'CCS']
    power_kw NUMERIC,
    current_status TEXT, -- 'available', 'occupied', 'offline'
    last_updated TIMESTAMP WITH TIME ZONE
);
```

---

### Phase 2: Enhanced Features (Priority: MEDIUM)

#### 2.1 Payment Integration for Charging
```
api/
├── charging/
│   ├── sessions/route.ts      # Start/stop charging
│   ├── payment/route.ts        # Process charging payment
│   └── pricing/route.ts        # Calculate cost
```

**Tasks:**
- [ ] Extend payment API for charging sessions
- [ ] Implement per-kWh pricing
- [ ] Add session time tracking
- [ ] Build cost estimation

#### 2.2 User Charging Profile
```
lib/features/charging/
├── history/
├── favorites/
└── analytics/
```

**Tasks:**
- [ ] Track charging history
- [ ] Save favorite stations
- [ ] Show usage statistics
- [ ] Carbon savings calculator

#### 2.3 Queue Management
```sql
CREATE TABLE charging_queue (
    id UUID PRIMARY KEY,
    station_id UUID REFERENCES charging_stations_enhanced(id),
    user_id UUID REFERENCES auth.users(id),
    queue_position INT,
    estimated_wait_minutes INT,
    status TEXT, -- 'waiting', 'notified', 'served'
    created_at TIMESTAMP WITH TIME ZONE
);
```

---

### Phase 3: Advanced Features (Priority: LOW)

#### 3.1 Push Notifications
- Booking reminders
- Queue updates
- Session completion
- Station status changes

#### 3.2 Vehicle Integration
- Battery level tracking
- Range calculator
- Charger recommendations
- Charging schedule optimizer

#### 3.3 Analytics Dashboard
- Station utilization
- Peak hours analysis
- Revenue tracking
- User behavior insights

---

## Implementation Order

### Sprint 1: Foundation (Week 1-2)
1. Create chargers table
2. Build KAHRAMAA scraper
3. Implement basic sync job
4. Update Flutter to show charger-level availability

### Sprint 2: Real-Time (Week 3-4)
1. Add Supabase Realtime subscriptions
2. Implement WebSocket in Flutter
3. Create availability update API
4. Build admin override dashboard

### Sprint 3: Payments (Week 5-6)
1. Extend payment system for charging
2. Implement session tracking
3. Add pricing calculator
4. Build charging history UI

### Sprint 4: Polish (Week 7-8)
1. Queue management system
2. Push notifications
3. Analytics dashboard
4. Performance optimization

---

## Technical Decisions

### Data Sources
| Source | Type | Priority |
|--------|------|----------|
| KAHRAMAA | Scrape | HIGH |
| WOQOD | Scrape | HIGH |
| Google Places | API | MEDIUM |
| Manual Entry | Admin | LOW |

### Real-Time Strategy
- **Supabase Realtime** for availability updates
- **Polling fallback** every 30 seconds if WebSocket fails
- **Local caching** for offline mode

### Pricing Model
- Base rate: 0.35 QAR/kWh (AC)
- Fast charging: 0.50 QAR/kWh (DC)
- Parking fee: 5 QAR/hour (where applicable)
- Dynamic pricing: +20% during peak hours (7-9 AM, 4-6 PM)

---

## API Endpoints to Create

```
GET  /api/charging/stations          # List all stations
GET  /api/charging/stations/:id      # Station details
GET  /api/charging/stations/:id/chargers  # List chargers
POST /api/charging/sessions          # Start charging
PUT  /api/charging/sessions/:id      # Stop charging
GET  /api/charging/queue/:stationId  # Join queue
POST /api/charging/payment/:sessionId # Process payment
```

---

## Success Metrics

- [ ] All 26+ stations show real-time availability
- [ ] Data syncs every 5 minutes automatically
- [ ] Users can book chargers within 30 seconds
- [ ] Payment processes in < 5 seconds
- [ ] 99.9% uptime for charging services
- [ ] Average session starts within 2 minutes of arrival

---

## Next Steps

1. **Confirm this plan** - Review and approve priorities
2. **Set up database** - Create chargers table
3. **Build first scraper** - KAHRAMAA data collection
4. **Test sync pipeline** - Verify data flows correctly
