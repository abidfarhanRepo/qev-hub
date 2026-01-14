# QEV Hub Mobile - Booking System Architecture (Phase 6)

## Overview
A real-time charging station booking system with concurrent user handling, preventing double-bookings through database constraints and proper state management.

---

## 1. Database Schema (Supabase)

### Table: `chargers`
Individual charging units at each station.

```sql
CREATE TABLE chargers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  station_id UUID NOT NULL REFERENCES charging_stations(id) ON DELETE CASCADE,
  name VARCHAR(100) NOT NULL,          -- e.g., "Charger A1", "Fast Charger 1"
  charger_type VARCHAR(50) NOT NULL,   -- 'AC', 'DC', 'DC_FAST'
  power_kw DECIMAL(10,2) NOT NULL,     -- e.g., 50.00, 150.00
  status VARCHAR(20) DEFAULT 'available', -- 'available', 'occupied', 'maintenance', 'offline'
  connector_types TEXT[],              -- ['Type2', 'CCS2', 'CHAdeMO', 'Tesla']
  is_enabled BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index for quick lookups
CREATE INDEX idx_chargers_station ON chargers(station_id);
CREATE INDEX idx_chargers_status ON chargers(status);
```

### Table: `bookings`
User bookings for charging sessions.

```sql
CREATE TABLE bookings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  charger_id UUID NOT NULL REFERENCES chargers(id) ON DELETE CASCADE,
  station_id UUID NOT NULL REFERENCES charging_stations(id) ON DELETE CASCADE,
  start_time TIMESTAMPTZ NOT NULL,
  end_time TIMESTAMPTZ NOT NULL,
  status VARCHAR(20) DEFAULT 'pending',
  -- 'pending', 'confirmed', 'in_progress', 'completed', 'cancelled', 'no_show'
  estimated_cost DECIMAL(10,2),
  actual_cost DECIMAL(10,2),
  energy_delivered DECIMAL(10,2),      -- kWh
  notes TEXT,
  cancellation_reason TEXT,
  cancelled_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  -- Prevent overlapping bookings for same charger
  EXCLUDE USING GIST (
    charger_id WITH =,
    tsrange(start_time, end_time) WITH &&
  )
);

-- Indexes
CREATE INDEX idx_bookings_user ON bookings(user_id);
CREATE INDEX idx_bookings_charger ON bookings(charger_id);
CREATE INDEX idx_bookings_station ON bookings(station_id);
CREATE INDEX idx_bookings_status ON bookings(status);
CREATE INDEX idx_bookings_start_time ON bookings(start_time);
CREATE INDEX idx_bookings_upcoming ON bookings(user_id, start_time) WHERE status IN ('pending', 'confirmed');

-- RLS Policies
ALTER TABLE bookings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own bookings"
  ON bookings FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own bookings"
  ON bookings FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own bookings"
  ON bookings FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can cancel their own bookings"
  ON bookings FOR UPDATE
  USING (auth.uid() = user_id AND status IN ('pending', 'confirmed'));
```

### Function: Check Charger Availability
```sql
CREATE OR REPLACE FUNCTION check_charger_available(
  p_charger_id UUID,
  p_start_time TIMESTAMPTZ,
  p_end_time TIMESTAMPTZ
)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN NOT EXISTS (
    SELECT 1 FROM bookings
    WHERE charger_id = p_charger_id
      AND status IN ('confirmed', 'pending', 'in_progress')
      AND tsrange(start_time, end_time) && tsrange(p_start_time, p_end_time)
  );
END;
$$ LANGUAGE plpgsql;
```

### Trigger: Update chargers status based on active bookings
```sql
CREATE OR REPLACE FUNCTION update_charger_status()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
    IF NEW.status IN ('confirmed', 'in_progress') THEN
      UPDATE chargers
      SET status = 'occupied'
      WHERE id = NEW.charger_id;
    ELSIF NEW.status IN ('completed', 'cancelled', 'no_show') THEN
      UPDATE chargers
      SET status = 'available'
      WHERE id = NEW.charger_id
        AND NOT EXISTS (
          SELECT 1 FROM bookings
          WHERE charger_id = NEW.charger_id
            AND status IN ('confirmed', 'in_progress')
            AND id != NEW.id
        );
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_charger_status
  AFTER INSERT OR UPDATE ON bookings
  FOR EACH ROW
  EXECUTE FUNCTION update_charger_status();
```

---

## 2. Concurrency Handling Strategy

### 2.1 Database-Level Protection
- **EXCLUDE constraint** on bookings table prevents overlapping bookings
- **RLS policies** ensure users can only access their own data
- **Triggers** automatically update charger status
- **SERIALIZABLE isolation** for critical transactions

### 2.2 Application-Level Handling
- **Optimistic locking** with version checking
- **Retry mechanism** for conflicts
- **Real-time subscriptions** for booking updates
- **State machine** for booking status transitions

---

## 3. State Machine

```
                    ┌─────────────┐
                    │   pending   │
                    └──────┬──────┘
                           │ (confirm)
                           ▼
                    ┌─────────────┐
          (cancel)  │  confirmed  │  (start session)
        ┌───────────┴──────┬──────┴──────────┐
        ▼                  ▼                  ▼
  ┌──────────┐      ┌──────────┐      ┌─────────────┐
  │cancelled │      │ no_show  │      │ in_progress │
  └──────────┘      └──────────┘      └──────┬──────┘
                                            │ (complete)
                                            ▼
                                     ┌─────────────┐
                                     │  completed  │
                                     └─────────────┘
```

### Valid Transitions:
- pending → confirmed (user confirms, payment verified)
- pending/confirmed → cancelled (user cancels before time)
- pending/confirmed → no_show (user didn't arrive)
- confirmed → in_progress (charging started)
- in_progress → completed (charging finished)

---

## 4. Data Models (Dart/Flutter)

### Charger Model
```dart
@freezed
class Charger with _$Charger {
  const factory Charger({
    required String id,
    required String stationId,
    required String name,
    required String chargerType,
    required double powerKw,
    required ChargerStatus status,
    required List<String> connectorTypes,
    required bool isEnabled,
  }) = _Charger;

  factory Charger.fromJson(Map<String, dynamic> json) =>
      _$ChargerFromJson(json);
}

enum ChargerStatus { available, occupied, maintenance, offline }
```

### Booking Model
```dart
@freezed
class Booking with _$Booking {
  const factory Booking({
    required String id,
    required String userId,
    required String chargerId,
    required String stationId,
    required DateTime startTime,
    required DateTime endTime,
    required BookingStatus status,
    double? estimatedCost,
    double? actualCost,
    double? energyDelivered,
    String? notes,
    String? cancellationReason,
    DateTime? cancelledAt,
    DateTime? completedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    // Relations
    Charger? charger,
    ChargingStation? station,
  }) = _Booking;

  factory Booking.fromJson(Map<String, dynamic> json) =>
      _$BookingFromJson(json);
}

enum BookingStatus {
  pending,
  confirmed,
  inProgress,
  completed,
  cancelled,
  noShow,
}
```

### Time Slot Model
```dart
@freezed
class TimeSlot with _$TimeSlot {
  const factory TimeSlot({
    required DateTime startTime,
    required DateTime endTime,
    required bool isAvailable,
    String? reason,
  }) = _TimeSlot;

  factory TimeSlot.fromJson(Map<String, dynamic> json) =>
      _$TimeSlotFromJson(json);
}
```

---

## 5. Backend Services (Supabase Edge Functions)

### 5.1 Check Availability
```typescript
// Function: check-availability
// Returns available time slots for a charger on a given date
```

### 5.2 Create Booking
```typescript
// Function: create-booking
// Validates and creates booking with conflict check
```

### 5.3 Cancel Booking
```typescript
// Function: cancel-booking
// Cancels booking and updates charger status
```

### 5.4 Start Charging Session
```typescript
// Function: start-session
// Transitions booking to in_progress
```

### 5.5 Complete Charging Session
```typescript
// Function: complete-session
// Records final metrics and completes booking
```

---

## 6. Frontend Screens

### 6.1 Station Detail Screen
- Show station info with available chargers
- List chargers with status indicators
- Select charger to book

### 6.2 Booking Flow
- **Step 1**: Select charger
- **Step 2**: Select date and time slot
- **Step 3**: Confirm booking details
- **Step 4**: Success/cancellation

### 6.3 My Bookings Screen
- List of upcoming bookings
- List of past bookings
- Cancel/modify booking options
- QR code for check-in

### 6.4 Active Session Screen
- Real-time charging progress
- Energy delivered, time remaining, cost
- Stop charging button

---

## 7. Real-time Features

### Supabase Subscriptions
```dart
// Listen for booking changes
supabase
  .channel('bookings')
  .on('postgres_changes',
    event: 'INSERT',
    schema: 'public',
    table: 'bookings',
    filter: 'user_id=eq.{userId}',
    handler: (payload) { /* handle new booking */ }
  )
  .subscribe();

// Listen for charger status changes
supabase
  .channel('chargers')
  .on('postgres_changes',
    event: 'UPDATE',
    schema: 'public',
    table: 'chargers',
    handler: (payload) { /* update charger availability */ }
  )
  .subscribe();
```

---

## 8. User Flow

```
1. User navigates to Charging Screen
   ↓
2. Taps on a station marker
   ↓
3. Station Detail Screen opens
   ↓
4. Views available chargers
   ↓
5. Taps "Book" on a charger
   ↓
6. Selects date and time slot
   ↓
7. Confirms booking
   ↓
8. Booking confirmed → Added to "My Bookings"
   ↓
9. User arrives → Shows QR code
   ↓
10. Scans QR → Session starts (in_progress)
   ↓
11. Charging completes
   ↓
12. Booking marked complete
```

---

## 9. Edge Cases & Error Handling

### 9.1 Double Booking Prevention
- Database EXCLUDE constraint
- Application-level pre-check
- User-friendly error message

### 9.2 Concurrent Bookings
- Optimistic locking
- Retry on conflict
- Real-time updates

### 9.3 Time Zone Handling
- Store all times in UTC
- Display in user's local time
- Clear timezone indication

### 9.4 Late Arrivals
- Grace period (e.g., 15 min)
- Auto-cancel → no_show
- Charger becomes available

### 9.5 Cancellation Policy
- Free cancellation up to X minutes before
- Partial refund if within Y minutes
- No refund if less than Z minutes

---

## 10. Implementation Order

1. ✅ Design architecture (this document)
2. Create database schema (Supabase migration)
3. Create Dart data models
4. Implement booking repository
5. Create booking provider (Riverpod)
6. Build station detail screen
7. Build booking confirmation screen
8. Build my bookings screen
9. Add route navigation
10. Test full flow on device
11. Fix bugs and polish UI
12. Deploy and push to GitHub

---

## 11. Testing Checklist

- [ ] User can view station details
- [ ] User can see available chargers
- [ ] User can book an available time slot
- [ ] Double booking is prevented
- [ ] User can cancel pending booking
- [ ] User can view upcoming bookings
- [ ] User can view past bookings
- [ ] Real-time updates work
- [ ] UI handles loading states
- [ ] UI handles error states
- [ ] Time zones display correctly
- [ ] Navigation works smoothly
