# AI Agent Context Guide for QEV Hub

> **Purpose**: This document provides structured context for LLMs and AI coding agents (GPT-4, Claude, GLM-4, DeepSeek, etc.) to effectively understand and work with the QEV Hub codebase.

---

## Quick Orientation

**Project**: QEV Hub - Electric Vehicle marketplace for Qatar  
**Stack**: Next.js 14, React Native, TypeScript, Supabase (PostgreSQL)  
**Purpose**: Direct consumer-to-manufacturer EV purchasing platform  
**Primary Goal**: Eliminate middlemen, reduce costs by 30-40%

---

## Critical Files & Locations

### Configuration Files
```
qev-hub-web/.env.local          → Supabase credentials (web)
qev-hub-mobile/.env             → Supabase credentials (mobile)
qev-hub-mcp/.env                → Supabase service role key (MCP)
```

### Database Migrations
```
qev-hub-web/supabase/migrations/
├── 001_initial_schema.sql      → Database schema (7 tables)
├── 008_rebuild_rls_policies.sql → RLS policies (CRITICAL)
└── 010_enable_realtime.sql     → Real-time subscriptions
```

### Core Application Files
```
qev-hub-web/src/
├── lib/supabase.ts             → Supabase client initialization
├── app/(main)/marketplace/page.tsx → Vehicle listing page
├── app/(main)/orders/[id]/page.tsx → Order tracking page
└── app/(main)/admin/page.tsx   → Admin dashboard
```

---

## Database Schema (7 Tables)

### 1. **profiles** - User information
```typescript
{
  id: UUID (references auth.users.id),
  email: TEXT,
  full_name: TEXT,
  phone: TEXT,
  role: 'consumer' | 'manufacturer' | 'admin',
  created_at: TIMESTAMPTZ
}
```
**Key Relationships**: One-to-many with orders

### 2. **vehicles** - EV inventory
```typescript
{
  id: UUID,
  manufacturer: TEXT,
  model: TEXT,
  year: INTEGER,
  range_km: INTEGER,
  battery_capacity_kwh: NUMERIC,
  manufacturer_price_qar: NUMERIC,  // Direct price (lower)
  broker_price_qar: NUMERIC,        // Traditional price (higher)
  available: BOOLEAN,
  image_url: TEXT,
  specs: JSONB
}
```
**Key Concept**: `manufacturer_price_qar` vs `broker_price_qar` shows savings

### 3. **orders** - Purchase orders
```typescript
{
  id: UUID,
  user_id: UUID (FK → profiles.id),
  vehicle_id: UUID (FK → vehicles.id),
  tracking_id: TEXT (unique, e.g., "QEV-12345"),
  status: OrderStatus,
  total_price_qar: NUMERIC,
  shipping_address: TEXT,
  notes: TEXT,
  created_at: TIMESTAMPTZ,
  completed_at: TIMESTAMPTZ
}
```
**Status Flow**: pending → confirmed → shipped → in_customs → fahes_inspection → insurance_processing → out_for_delivery → completed

### 4. **order_status_history** - Tracking timeline
```typescript
{
  id: UUID,
  order_id: UUID (FK → orders.id),
  status: OrderStatus,
  location: TEXT,
  notes: TEXT,
  document_url: TEXT,
  created_at: TIMESTAMPTZ
}
```
**Purpose**: Creates audit trail for order tracking timeline

### 5. **documents** - Shipping documents
```typescript
{
  id: UUID,
  order_id: UUID (FK → orders.id),
  type: 'customs_form' | 'fahes_certificate' | 'insurance_policy' | 'shipping_manifest' | 'delivery_receipt',
  url: TEXT,
  uploaded_by: UUID,
  created_at: TIMESTAMPTZ
}
```

### 6. **gcc_export_rules** - Compliance rules
```typescript
{
  id: UUID,
  country: TEXT,
  rule_description: TEXT,
  compliance_required: BOOLEAN
}
```

### 7. **sustainability_metrics** - Environmental data
```typescript
{
  id: UUID,
  vehicle_id: UUID (FK → vehicles.id),
  co2_savings_kg_per_year: NUMERIC,
  energy_consumption_kwh_per_100km: NUMERIC,
  estimated_lifecycle_years: INTEGER
}
```

---

## Row Level Security (RLS) Patterns

**CRITICAL**: Every table has RLS enabled. Never disable RLS!

### Pattern 1: User owns their data
```sql
CREATE POLICY "users_select_own" ON profiles
FOR SELECT USING (auth.uid() = id);
```

### Pattern 2: Admin access all
```sql
CREATE POLICY "admin_select_all" ON orders
FOR SELECT USING (
  EXISTS (
    SELECT 1 FROM profiles 
    WHERE id = auth.uid() AND role = 'admin'
  )
);
```

### Pattern 3: Public read
```sql
CREATE POLICY "public_select" ON vehicles
FOR SELECT USING (available = true);
```

**Common Issue**: Profile creation during signup. Always check `profiles_insert_own` policy allows `auth.uid() = id`.

---

## Common Patterns & Conventions

### 1. Supabase Client Usage
```typescript
import { supabase } from '@/lib/supabase'

// Always check for errors
const { data, error } = await supabase
  .from('table_name')
  .select('*')

if (error) {
  console.error('Error:', error)
  // Handle error
}
```

### 2. Authentication Flow
```typescript
// 1. Sign up user
const { data: authData, error: authError } = await supabase.auth.signUp({
  email,
  password,
})

// 2. Create profile (MUST happen immediately after)
const { error: profileError } = await supabase
  .from('profiles')
  .insert({
    id: authData.user.id,  // CRITICAL: Use auth user ID
    email,
    full_name,
    role: 'consumer'
  })
```

### 3. Real-time Subscriptions
```typescript
const subscription = supabase
  .channel('channel-name')
  .on('postgres_changes', {
    event: 'UPDATE',
    schema: 'public',
    table: 'orders',
    filter: `id=eq.${orderId}`
  }, (payload) => {
    // Handle update
    setOrder(payload.new)
  })
  .subscribe()

// Always cleanup
return () => subscription.unsubscribe()
```

### 4. Order Status Updates (Admin)
```typescript
// Always do BOTH: update order + create history entry
// 1. Update order status
await supabase
  .from('orders')
  .update({ status: newStatus })
  .eq('id', orderId)

// 2. Create history entry
await supabase
  .from('order_status_history')
  .insert({
    order_id: orderId,
    status: newStatus,
    location: location,
    notes: notes,
    document_url: documentUrl
  })
```

---

## File Organization Patterns

### Next.js App Router Structure
```
app/
├── (auth)/           → Unauthenticated routes (login, signup)
│   ├── login/
│   └── signup/
├── (main)/           → Protected routes (require auth)
│   ├── marketplace/
│   ├── orders/
│   └── admin/
└── auth/callback/    → OAuth callback handler
```

### Component Organization
```
components/
├── ui/               → shadcn/ui components (reusable primitives)
│   ├── button.tsx
│   ├── card.tsx
│   └── ...
└── auth/             → Auth-specific components
```

### Data Fetching Pattern
```typescript
// Always in useEffect for client components
useEffect(() => {
  fetchData()
}, [])

const fetchData = async () => {
  setLoading(true)
  try {
    const { data, error } = await supabase.from('table').select('*')
    if (error) throw error
    setData(data)
  } catch (err) {
    console.error('Error:', err)
  } finally {
    setLoading(false)
  }
}
```

---

## Common Tasks & How-Tos

### Task: Add a new order status
1. Update type definition in `qev-hub-shared/src/types/index.ts`
2. Update database enum (new migration file)
3. Update status flow logic in order tracking page
4. Update admin dashboard status dropdown
5. Test RLS policies still work

### Task: Add a new field to profiles
1. Create migration: `qev-hub-web/supabase/migrations/XXX_add_field.sql`
```sql
ALTER TABLE profiles ADD COLUMN new_field TEXT;
```
2. Update TypeScript type in shared package
3. Update signup form to collect new field
4. Update profile display components

### Task: Create a new page
1. Create file in `app/(main)/new-page/page.tsx`
2. Mark as `"use client"` if using hooks
3. Add authentication check in useEffect
4. Add navigation link in header/sidebar

### Task: Fix RLS policy issue
1. Check current policies: Query `pg_policies` table
2. Create new migration to drop and recreate policy
3. Test with different user roles
4. Verify using `supabase.auth.getSession()`

---

## TypeScript Types & Interfaces

### Shared Types Location
```
qev-hub-shared/src/types/index.ts
```

### Key Type Definitions
```typescript
export interface Vehicle {
  id: string
  manufacturer: string
  model: string
  year: number
  range_km: number
  battery_capacity_kwh: number
  manufacturer_price_qar: number
  broker_price_qar: number
  available: boolean
  image_url?: string
  specs?: Record<string, any>
  created_at: string
}

export type OrderStatus = 
  | 'pending'
  | 'confirmed'
  | 'shipped'
  | 'in_customs'
  | 'fahes_inspection'
  | 'insurance_processing'
  | 'out_for_delivery'
  | 'completed'
  | 'cancelled'

export type UserRole = 'consumer' | 'manufacturer' | 'admin'
```

---

## Testing & Debugging

### Test Scripts Location
```
qev-hub-web/scripts/
├── test-auth.js              → Test authentication
├── test-complete-flow.js     → Test signup + profile creation
├── check-database.js         → Verify database connection
└── create-test-account.js    → Create test users
```

### Database Status Check
```
URL: http://localhost:3000/db-status
Shows: Connection status, table counts, RLS status
```

### Common Debug Points
1. **Profile not created**: Check RLS policy `profiles_insert_own`
2. **Orders not showing**: Check `user_id` matches `auth.uid()`
3. **Real-time not working**: Verify `010_enable_realtime.sql` applied
4. **Permission denied**: Check user role and RLS policies

---

## Environment Variables Reference

### Web App (.env.local)
```env
NEXT_PUBLIC_SUPABASE_URL=https://xxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJxxx...
```

### Mobile App (.env)
```env
EXPO_PUBLIC_SUPABASE_URL=https://xxx.supabase.co
EXPO_PUBLIC_SUPABASE_ANON_KEY=eyJxxx...
```

### MCP Server (.env)
```env
SUPABASE_URL=https://xxx.supabase.co
SUPABASE_SERVICE_ROLE_KEY=eyJxxx...  # ⚠️ ADMIN KEY - bypasses RLS
```

---

## State Management Patterns

### Client-Side State
```typescript
// Use React hooks for local state
const [data, setData] = useState<DataType[]>([])
const [loading, setLoading] = useState(true)
const [error, setError] = useState<string | null>(null)
```

### Session State
```typescript
// Check authentication
const { data: { session } } = await supabase.auth.getSession()
if (!session) {
  router.push('/login')
}
```

### Real-time State Updates
```typescript
// Subscribe to changes
useEffect(() => {
  const channel = supabase
    .channel('changes')
    .on('postgres_changes', {...}, (payload) => {
      setData(prev => updateWithPayload(prev, payload))
    })
    .subscribe()
  
  return () => channel.unsubscribe()
}, [])
```

---

## Error Handling Patterns

### Standard Error Handling
```typescript
try {
  const { data, error } = await supabase.from('table').select('*')
  if (error) throw error
  return data
} catch (err) {
  console.error('Operation failed:', err)
  // Show user-friendly error
  toast({
    title: "Error",
    description: "Failed to load data. Please try again.",
    variant: "destructive"
  })
  return null
}
```

### RLS Error Detection
```typescript
// RLS errors typically have code '42501' or message contains 'policy'
if (error?.code === '42501' || error?.message?.includes('policy')) {
  console.error('Permission denied - check RLS policies')
}
```

---

## Styling Patterns

### Tailwind Classes
```typescript
// Standard patterns used throughout
className="flex items-center justify-between"  // Flexbox layout
className="grid grid-cols-1 md:grid-cols-3"   // Responsive grid
className="bg-primary text-white"              // Theme colors
className="rounded-lg shadow-md p-4"           // Card styling
```

### shadcn/ui Components
```typescript
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader } from "@/components/ui/card"

// Always import from @/components/ui/
// Never modify these files directly
```

---

## Security Considerations

### NEVER expose
- Service role key in client-side code
- User passwords in logs
- Personal data in error messages
- Internal IDs in URLs (use tracking_id instead)

### ALWAYS verify
- User authentication before data access
- User role before admin operations
- Input validation on forms
- RLS policies on new tables

### Best Practices
- Use anon key for client apps
- Use service role key only for admin operations or MCP
- Validate all user input with Zod schemas
- Sanitize data before display

---

## Performance Optimization

### Query Optimization
```typescript
// BAD: Multiple queries
const users = await supabase.from('profiles').select('*')
for (const user of users) {
  const orders = await supabase.from('orders').select('*').eq('user_id', user.id)
}

// GOOD: Single query with join
const { data } = await supabase
  .from('orders')
  .select('*, profiles(*)')
```

### Pagination
```typescript
const { data } = await supabase
  .from('orders')
  .select('*')
  .range(0, 49)  // First 50 records
  .order('created_at', { ascending: false })
```

---

## MCP Server Integration

### When to use MCP vs Direct Access
- **Direct Access**: Normal app operations, user interactions
- **MCP Server**: AI-driven queries, admin automation, analytics

### MCP Tools Available
1. `search_vehicles` - AI searches marketplace
2. `get_order_tracking` - AI tracks orders
3. `update_order_status` - AI updates orders (admin)
4. `get_order_analytics` - AI generates reports

See `qev-hub-mcp/src/index.ts` for implementation details.

---

## Quick Decision Tree

### "Should I create a new migration?"
- Adding/modifying database schema? → YES
- Changing RLS policies? → YES
- Adding seed data? → YES
- Changing client code only? → NO

### "Should I use 'use client' directive?"
- Using React hooks (useState, useEffect)? → YES
- Using browser APIs (localStorage, window)? → YES
- Using Supabase client directly? → YES
- Pure data display with no interactivity? → NO (consider Server Component)

### "Should this be an admin-only feature?"
- Modifying order status? → YES
- Viewing all orders? → YES
- Browsing marketplace? → NO
- Placing orders? → NO

---

## Troubleshooting Checklist

### Issue: "Cannot read property 'X' of undefined"
- [ ] Check if data is loaded (loading state)
- [ ] Check if query returned null/undefined
- [ ] Add optional chaining (`data?.property`)

### Issue: "Permission denied" / "Row level security"
- [ ] User authenticated? (`supabase.auth.getSession()`)
- [ ] User has correct role?
- [ ] RLS policy exists for operation?
- [ ] Policy filter matches current user?

### Issue: "Real-time updates not working"
- [ ] Realtime enabled on table? (migration 010)
- [ ] Subscription created correctly?
- [ ] Cleanup function removes subscription?
- [ ] Channel name unique?

### Issue: "Profile not created on signup"
- [ ] RLS policy allows insert with `auth.uid() = id`?
- [ ] Profile insert happens immediately after signup?
- [ ] Error handling catches profile creation failure?

---

## Code Navigation Tips

### Find where feature is implemented
```bash
# Search for text in files
grep -r "search_term" qev-hub-web/src/

# Find component usage
grep -r "ComponentName" qev-hub-web/src/

# Find database queries
grep -r "\.from\('table_name'\)" qev-hub-web/src/
```

### Key files for each feature
- **Authentication**: `app/(auth)/login/page.tsx`, `app/(auth)/signup/page.tsx`
- **Marketplace**: `app/(main)/marketplace/page.tsx`
- **Order Tracking**: `app/(main)/orders/[id]/page.tsx`
- **Admin**: `app/(main)/admin/page.tsx`
- **Database Client**: `lib/supabase.ts`

---

## Integration Points

### Web ↔ Database
```
Next.js → supabase-js client → Supabase REST API → PostgreSQL
```

### Mobile ↔ Database
```
React Native → supabase-js client → Supabase REST API → PostgreSQL
```

### MCP ↔ Database
```
AI Assistant → MCP Protocol → Node.js Server → supabase-js → PostgreSQL
```

### Real-time Flow
```
Database Change → Supabase Realtime → WebSocket → Client App → UI Update
```

---

## Project-Specific Context

### Qatar-Specific Features
- **FAHES Inspection**: Mandatory vehicle safety inspection in Qatar
- **GCC Export Rules**: Regional compliance requirements
- **QAR Currency**: Qatari Riyal pricing throughout

### Business Logic
- **Savings Calculation**: `broker_price_qar - manufacturer_price_qar`
- **Tracking ID Format**: "QEV-" + random string
- **Order Timeline**: 8 stages from placement to delivery

### User Roles
- **Consumer**: Browse, order, track own orders
- **Manufacturer**: Manage inventory (future)
- **Admin**: Full access, update order status

---

## Best Practices for AI Agents

1. **Always read before writing**: Check existing code patterns
2. **Maintain consistency**: Follow established naming conventions
3. **Test incrementally**: Make small changes, test, then continue
4. **Respect RLS**: Never suggest disabling Row Level Security
5. **Document changes**: Add comments for complex logic
6. **Handle errors**: Always check for and handle errors gracefully
7. **Type safety**: Use TypeScript types from shared package
8. **Security first**: Never expose sensitive keys or data

---

## Resources for AI Agents

- **Full Documentation**: `/DOCUMENTATION.md`
- **Database Schema**: `/qev-hub-web/supabase/migrations/001_initial_schema.sql`
- **Type Definitions**: `/qev-hub-shared/src/types/index.ts`
- **MCP Server**: `/qev-hub-mcp/src/index.ts`
- **Test Scripts**: `/qev-hub-web/scripts/`

---

**Last Updated**: January 1, 2026  
**For**: LLMs, AI Coding Agents, and Autonomous Development Tools  
**Maintained**: Keep this file updated when architecture changes
