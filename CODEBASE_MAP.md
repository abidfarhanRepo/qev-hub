# Codebase Navigation Map for AI Agents

> **Purpose**: Structured map of the entire codebase for efficient navigation by LLMs and AI coding agents.

---

## Project Root Structure

```
QEV/
├── AI_CONTEXT.md                    ← YOU ARE HERE (AI agent guide)
├── DOCUMENTATION.md                 ← Complete technical documentation
├── README.md                        ← Project overview & setup
├── DATABASE_REBUILD_COMPLETE.md     ← Database migration notes
│
├── qev-hub-web/                     ← Next.js web application
├── qev-hub-mobile/                  ← React Native mobile app
├── qev-hub-shared/                  ← Shared TypeScript types
├── qev-hub-mcp/                     ← MCP server for AI integration
└── qev-shared/                      ← Legacy shared folder (minimal)
```

---

## qev-hub-web/ (Next.js Application)

### Top-Level Structure
```
qev-hub-web/
├── public/                          ← Static assets (images, fonts)
├── src/                             ← Source code (components, pages)
├── supabase/                        ← Database migrations
├── scripts/                         ← Utility scripts for testing
├── package.json                     ← Dependencies
├── next.config.mjs                  ← Next.js configuration
├── tailwind.config.ts               ← Tailwind CSS config
├── tsconfig.json                    ← TypeScript config
└── .env.local                       ← Environment variables (not in git)
```

### src/ Directory Deep Dive

```
src/
├── app/                             ← Next.js App Router (all pages)
│   ├── globals.css                  ← Global styles
│   ├── layout.tsx                   ← Root layout (wraps all pages)
│   ├── page.tsx                     ← Homepage (/)
│   │
│   ├── (auth)/                      ← Unauthenticated routes group
│   │   ├── login/
│   │   │   └── page.tsx             ← Login page (/login)
│   │   └── signup/
│   │       └── page.tsx             ← Signup page (/signup)
│   │
│   ├── (main)/                      ← Protected routes group (requires auth)
│   │   ├── marketplace/
│   │   │   ├── page.tsx             ← Vehicle listing (/marketplace)
│   │   │   └── [id]/
│   │   │       └── page.tsx         ← Vehicle details (/marketplace/:id)
│   │   │
│   │   ├── orders/
│   │   │   ├── page.tsx             ← Orders list (/orders)
│   │   │   └── [id]/
│   │   │       └── page.tsx         ← Order tracking (/orders/:id)
│   │   │
│   │   └── admin/
│   │       └── page.tsx             ← Admin dashboard (/admin)
│   │
│   ├── auth/
│   │   └── callback/
│   │       └── page.tsx             ← OAuth callback handler
│   │
│   └── db-status/
│       └── page.tsx                 ← Database status checker
│
├── components/                      ← React components
│   ├── ui/                          ← shadcn/ui components (reusable)
│   │   ├── badge.tsx
│   │   ├── button.tsx
│   │   ├── card.tsx
│   │   ├── dialog.tsx
│   │   ├── form.tsx
│   │   ├── input.tsx
│   │   ├── label.tsx
│   │   ├── progress.tsx
│   │   ├── select.tsx
│   │   ├── tabs.tsx
│   │   ├── toast.tsx
│   │   └── toaster.tsx
│   │
│   └── auth/                        ← Auth-specific components (if any)
│
├── hooks/                           ← Custom React hooks
│   └── use-toast.ts                 ← Toast notification hook
│
└── lib/                             ← Utility libraries
    ├── supabase.ts                  ← Supabase client initialization ⭐ KEY FILE
    └── utils.ts                     ← Helper functions (cn, etc.)
```

### supabase/ Directory (Database)

```
supabase/migrations/
├── 001_initial_schema.sql           ← Database schema (7 tables) ⭐ KEY FILE
├── 002_seed_data.sql                ← Sample data for testing
├── 003_fix_rls_policies.sql         ← RLS policy fixes
├── 004_fix_auth_rls.sql             ← Auth-related RLS fixes
├── 005_add_read_policy.sql          ← Read policy additions
├── 006_remove_trigger.sql           ← Trigger cleanup
├── 007_fix_profile_insert_policy.sql ← Profile creation fix
├── 008_rebuild_rls_policies.sql     ← Complete RLS rebuild ⭐ KEY FILE
├── 009_fix_insert_only.sql          ← Insert policy refinement
└── 010_enable_realtime.sql          ← Enable real-time subscriptions
```

### scripts/ Directory (Testing & Utilities)

```
scripts/
├── test-auth.js                     ← Test authentication flow
├── test-complete-flow.js            ← Test full signup → profile flow ⭐
├── test-profile-creation.js         ← Test profile creation
├── test-actual-signup.js            ← Test actual signup process
├── test-with-auth.js                ← Test with authentication
├── test-tracking.sh                 ← Test order tracking
├── check-database.js                ← Verify database connection
├── database-scan.js                 ← Scan database for issues
├── create-test-account.js           ← Create test users
├── create-test-account.ts           ← TypeScript version
├── apply-migration-007.sh           ← Apply migration 007
├── apply-migration-008.sh           ← Apply migration 008
├── enable-realtime.sh               ← Enable realtime on tables
├── show-fix.sh                      ← Show RLS fixes
└── migrate.ts                       ← Migration runner
```

---

## qev-hub-mobile/ (React Native App)

```
qev-hub-mobile/
├── android/                         ← Android native code
├── ios/                             ← iOS native code
├── src/
│   ├── App.tsx                      ← Root component ⭐
│   ├── components/                  ← React components
│   ├── navigation/                  ← Navigation configuration
│   ├── screens/
│   │   └── LoginScreen.tsx          ← Login screen
│   ├── theme/
│   │   └── colors.ts                ← Color palette
│   └── utils/                       ← Utility functions
│
├── app.json                         ← React Native config
├── babel.config.js                  ← Babel configuration
├── metro.config.js                  ← Metro bundler config
├── index.js                         ← App entry point
├── package.json                     ← Dependencies
├── tsconfig.json                    ← TypeScript config
└── .env                             ← Environment variables (not in git)
```

---

## qev-hub-shared/ (Shared Types)

```
qev-hub-shared/
├── src/
│   ├── index.ts                     ← Main export
│   └── types/
│       └── index.ts                 ← Type definitions ⭐ KEY FILE
│
├── package.json                     ← Package configuration
└── tsconfig.json                    ← TypeScript config

KEY FILE: src/types/index.ts
- Contains all shared TypeScript interfaces
- Vehicle, Order, Profile, OrderStatus types
- Used by both web and mobile apps
```

---

## qev-hub-mcp/ (MCP Server)

```
qev-hub-mcp/
├── src/
│   └── index.ts                     ← MCP server implementation ⭐ KEY FILE
│
├── dist/                            ← Compiled JavaScript (generated)
├── package.json                     ← Dependencies
├── tsconfig.json                    ← TypeScript config
├── README.md                        ← MCP documentation
├── SETUP.md                         ← Setup instructions
├── QUICKSTART.md                    ← Quick reference
├── .env.example                     ← Environment template
└── .env                             ← Environment variables (not in git)

KEY FILE: src/index.ts
- Implements 8 MCP tools
- Connects to Supabase with service role key
- Handles AI assistant requests
```

---

## Key Files by Feature

### Authentication
```
PRIMARY:
- qev-hub-web/src/app/(auth)/login/page.tsx
- qev-hub-web/src/app/(auth)/signup/page.tsx
- qev-hub-web/src/lib/supabase.ts

SUPPORTING:
- qev-hub-web/supabase/migrations/008_rebuild_rls_policies.sql (RLS)
- qev-hub-web/scripts/test-auth.js (testing)
```

### Marketplace (Vehicle Browsing)
```
PRIMARY:
- qev-hub-web/src/app/(main)/marketplace/page.tsx (list view)
- qev-hub-web/src/app/(main)/marketplace/[id]/page.tsx (detail view)

DATABASE:
- vehicles table (in 001_initial_schema.sql)
- RLS policies (in 008_rebuild_rls_policies.sql)
```

### Order Management
```
PRIMARY:
- qev-hub-web/src/app/(main)/orders/page.tsx (orders list)
- qev-hub-web/src/app/(main)/orders/[id]/page.tsx (tracking page)

DATABASE:
- orders table
- order_status_history table
- documents table
```

### Admin Dashboard
```
PRIMARY:
- qev-hub-web/src/app/(main)/admin/page.tsx

FUNCTIONALITY:
- View all orders
- Update order status
- Add tracking information
- Upload documents
```

### Real-time Updates
```
IMPLEMENTATION:
- qev-hub-web/src/app/(main)/orders/[id]/page.tsx (subscription logic)

DATABASE:
- qev-hub-web/supabase/migrations/010_enable_realtime.sql

PATTERN:
supabase.channel().on('postgres_changes', ...).subscribe()
```

### Type Definitions
```
PRIMARY:
- qev-hub-shared/src/types/index.ts

USAGE:
import { Vehicle, Order, Profile } from '@qev-hub/shared'
```

### Database Schema
```
PRIMARY:
- qev-hub-web/supabase/migrations/001_initial_schema.sql

TABLES:
1. profiles
2. vehicles
3. orders
4. order_status_history
5. documents
6. gcc_export_rules
7. sustainability_metrics
```

### Row Level Security
```
PRIMARY:
- qev-hub-web/supabase/migrations/008_rebuild_rls_policies.sql

POLICIES:
- User access policies (select_own, update_own)
- Admin access policies (admin_select_all, admin_update_all)
- Public access policies (public_select)
```

---

## File Type Reference

### `.tsx` Files (React Components)
- Located in: `src/app/`, `src/components/`
- Purpose: React components with TypeScript and JSX
- Pattern: Use `"use client"` directive if using hooks

### `.ts` Files (TypeScript)
- Located in: `src/lib/`, `src/hooks/`, `scripts/`
- Purpose: Utility functions, configurations, scripts
- Pattern: Export functions/objects for reuse

### `.sql` Files (Database)
- Located in: `supabase/migrations/`
- Purpose: Database schema and policy changes
- Pattern: Numbered sequentially (001, 002, 003...)

### `.json` Files (Configuration)
- `package.json` - Dependencies and scripts
- `tsconfig.json` - TypeScript compiler options
- `app.json` - React Native configuration
- `components.json` - shadcn/ui configuration

### `.js` Files (Scripts)
- Located in: `scripts/`
- Purpose: Testing and utility scripts
- Usage: `node scripts/script-name.js`

---

## Dependency Graph

### Web App Dependencies
```
qev-hub-web
├─→ Next.js 14 (framework)
├─→ React 18 (UI library)
├─→ @supabase/supabase-js (database client)
├─→ Tailwind CSS (styling)
├─→ shadcn/ui (component library)
├─→ @qev-hub/shared (shared types)
└─→ React Hook Form + Zod (forms & validation)
```

### Mobile App Dependencies
```
qev-hub-mobile
├─→ React Native 0.72 (framework)
├─→ React Navigation (routing)
├─→ React Native Paper (UI components)
├─→ @supabase/supabase-js (database client)
└─→ @qev-hub/shared (shared types)
```

### MCP Server Dependencies
```
qev-hub-mcp
├─→ @modelcontextprotocol/sdk (MCP protocol)
├─→ @supabase/supabase-js (database client)
└─→ TypeScript (language)
```

---

## Data Flow Diagrams

### User Signup Flow
```
User submits form
    ↓
app/(auth)/signup/page.tsx
    ↓
supabase.auth.signUp()
    ↓
Supabase Auth creates user
    ↓
supabase.from('profiles').insert()
    ↓
RLS policy: profiles_insert_own validates
    ↓
Profile created
    ↓
Redirect to /marketplace
```

### Order Tracking Flow
```
User views order
    ↓
app/(main)/orders/[id]/page.tsx
    ↓
Fetch order + history
    ↓
Subscribe to real-time changes
    ↓
Display timeline
    ↓
On update: Toast notification
    ↓
Re-render with new data
```

### Admin Update Flow
```
Admin updates status
    ↓
app/(main)/admin/page.tsx
    ↓
1. Update orders table
    ↓
2. Insert into order_status_history
    ↓
Real-time broadcasts change
    ↓
Customer sees update instantly
```

### MCP Query Flow
```
AI Assistant asks question
    ↓
MCP Protocol
    ↓
qev-hub-mcp/src/index.ts
    ↓
Call appropriate tool
    ↓
Query Supabase database
    ↓
Return structured response
    ↓
AI formats for user
```

---

## Quick File Finder

### "I need to modify authentication"
→ `qev-hub-web/src/app/(auth)/login/page.tsx`
→ `qev-hub-web/src/app/(auth)/signup/page.tsx`

### "I need to change vehicle display"
→ `qev-hub-web/src/app/(main)/marketplace/page.tsx`

### "I need to update order tracking"
→ `qev-hub-web/src/app/(main)/orders/[id]/page.tsx`

### "I need to modify database schema"
→ Create new file in `qev-hub-web/supabase/migrations/`

### "I need to fix RLS policies"
→ Check `qev-hub-web/supabase/migrations/008_rebuild_rls_policies.sql`
→ Create new migration if changes needed

### "I need to add shared types"
→ `qev-hub-shared/src/types/index.ts`

### "I need to test authentication"
→ `qev-hub-web/scripts/test-complete-flow.js`

### "I need to add MCP tool"
→ `qev-hub-mcp/src/index.ts`

### "I need to check database connection"
→ `qev-hub-web/scripts/check-database.js`
→ Or visit: `http://localhost:3000/db-status`

---

## Environment-Specific Files

### Development Files (not in git)
```
qev-hub-web/.env.local
qev-hub-mobile/.env
qev-hub-mcp/.env
node_modules/ (all projects)
dist/ (compiled output)
.next/ (Next.js build)
```

### Production Files
```
qev-hub-web/.next/ (optimized build)
qev-hub-mobile/android/app/build/ (APK)
qev-hub-mobile/ios/build/ (IPA)
```

### Configuration Files (in git)
```
package.json (dependencies)
tsconfig.json (TypeScript)
tailwind.config.ts (Tailwind)
next.config.mjs (Next.js)
.gitignore (ignored files)
```

---

## Naming Conventions

### Files
- Pages: `page.tsx`
- Layouts: `layout.tsx`
- Components: `ComponentName.tsx` (PascalCase)
- Utilities: `utility-name.ts` (kebab-case)
- Scripts: `script-name.js` (kebab-case)

### Variables
- React state: `camelCase` (e.g., `isLoading`, `userData`)
- Constants: `UPPER_SNAKE_CASE` (e.g., `SUPABASE_URL`)
- Functions: `camelCase` (e.g., `fetchData`, `handleSubmit`)

### Database
- Tables: `snake_case` (e.g., `order_status_history`)
- Columns: `snake_case` (e.g., `user_id`, `created_at`)
- Policies: `table_action_scope` (e.g., `profiles_select_own`)

### Routes
- Next.js: `/kebab-case` (e.g., `/marketplace`, `/order-tracking`)
- Dynamic: `/[id]` (e.g., `/orders/[id]`)

---

## Search Patterns for AI Agents

### Find all database queries
```bash
grep -r "supabase.from" qev-hub-web/src/
```

### Find all authentication checks
```bash
grep -r "auth.getSession" qev-hub-web/src/
```

### Find all real-time subscriptions
```bash
grep -r ".channel\(" qev-hub-web/src/
```

### Find component usage
```bash
grep -r "import.*ComponentName" qev-hub-web/src/
```

### Find type imports
```bash
grep -r "from '@qev-hub/shared'" qev-hub-web/src/
```

---

## Critical Dependencies

### Must Have for Development
- Node.js v18+
- npm or yarn
- Supabase account (for database)

### Required Environment Variables
```
NEXT_PUBLIC_SUPABASE_URL (web)
NEXT_PUBLIC_SUPABASE_ANON_KEY (web)
EXPO_PUBLIC_SUPABASE_URL (mobile)
EXPO_PUBLIC_SUPABASE_ANON_KEY (mobile)
SUPABASE_SERVICE_ROLE_KEY (MCP only)
```

---

**This map should be your first reference when navigating the codebase.**

For detailed context about patterns and conventions, see [AI_CONTEXT.md](AI_CONTEXT.md).  
For complete technical documentation, see [DOCUMENTATION.md](DOCUMENTATION.md).
