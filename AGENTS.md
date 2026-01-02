# AGENTS.md - QEV Hub Development Guide

This file contains project-specific instructions for AI/LLM assistants working on the QEV Hub project.

## Project Overview

QEV Hub is a direct-to-consumer electric vehicle marketplace for Qatar. The platform allows users to purchase EVs directly from manufacturers, track shipments, access charging stations, and manage their electric vehicle experience.

### Key Technologies
- **Framework**: Next.js 14.2.0 (App Router)
- **UI Library**: shadcn/ui (Radix UI primitives)
- **Styling**: Tailwind CSS with custom theme
- **Database**: Supabase (PostgreSQL)
- **Authentication**: Supabase Auth
- **Language**: TypeScript (strict mode)
- **State Management**: React hooks (useState, useEffect)

### Primary Color Palette
- **Primary**: #8A1538 (Deep Red)
- **Secondary**: #00FFFF (Cyan)
- **Theme**: Neutral (gray-based) with CSS variables

## Architecture

### Project Structure
```
qev-hub-web/
├── src/
│   ├── app/
│   │   ├── (auth)/           # Authentication routes
│   │   ├── (main)/           # Main application routes
│   │   │   ├── marketplace/   # EV marketplace
│   │   │   ├── orders/        # Order tracking & purchase flow
│   │   │   └── charging/     # Charging station map
│   │   └── api/              # API routes (RESTful)
│   ├── components/
│   │   ├── ui/               # shadcn/ui components (DO NOT modify directly)
│   │   └── *.tsx             # Custom business components
│   ├── lib/
│   │   ├── supabase.ts       # Supabase client
│   │   └── utils.ts          # Utility functions (cn helper)
│   └── services/             # External service integrations
├── supabase/migrations/      # Database migrations
└── components.json           # shadcn/ui configuration
```

### Route Groups
- `(auth)`: Login, signup - no shared layout with main app
- `(main)`: Marketplace, orders, charging - shared navigation

## Development Rules

### Component Guidelines

#### 1. Use shadcn/ui Components Only
All UI components MUST use shadcn/ui primitives from `@/components/ui`:
- Button (never native `<button>`)
- Card for content containers
- Dialog for modals
- Badge for status indicators
- Progress for loading states
- Toast for notifications (via `useToast` hook)

#### 2. SVG Icons Only - NO EMOJIS
ALL emojis have been replaced with professional SVG icons. Use icons from `@/components/icons.tsx`:
- CarIcon, ShipIcon, TruckIcon, PackageIcon
- DocumentIcon, CreditCardIcon, BatteryIcon
- MapPinIcon, CheckIcon, ClockIcon, ShieldIcon

**DO NOT USE EMOJIS** - They are not professional and will break the design system.

#### 3. Styling Rules
- Use Tailwind utility classes
- Leverage CSS variables for colors: `bg-primary`, `text-primary-foreground`, `bg-muted`, `text-muted-foreground`
- Use `cn()` utility from `@/lib/utils` for conditional class merging
- Avoid inline styles - use Tailwind classes instead
- Use semantic color names (primary, secondary, muted) NOT hardcoded hex values

#### 4. Component Patterns
```typescript
// Good: Client component with hooks
'use client'

import { useState } from 'react'
import { Button } from '@/components/ui/button'

export function MyComponent() {
  const [value, setValue] = useState('')
  return <Button onClick={() => setValue('')}>Click me</Button>
}

// Bad: Server component using client-only hooks
export function MyComponent() {
  const [value, useState('') // Error!
  return <div>{value}</div>
}
```

#### 5. TypeScript Rules
- Always define interfaces for props
- Use `interface` for object shapes, `type` for unions/aliases
- Export reusable types in dedicated files
- Use `any` only as last resort - prefer `unknown` or specific types
- Strict mode is enabled - no implicit `any`

### API Development

#### Route Naming
- Use kebab-case for files: `route.ts`
- Follow RESTful conventions:
  - `GET /api/resource` - List or retrieve
  - `POST /api/resource` - Create
  - `PUT /api/resource/[id]` - Update
  - `DELETE /api/resource/[id]` - Delete

#### Error Handling
```typescript
export async function GET(request: NextRequest) {
  try {
    const data = await fetchData()
    return NextResponse.json({ data })
  } catch (error) {
    console.error('API Error:', error)
    return NextResponse.json(
      { error: 'Failed to fetch data' },
      { status: 500 }
    )
  }
}
```

#### Response Format
- Always return consistent JSON structure
- Success: `{ success: true, data: ... }`
- Error: `{ error: "Description" }` with appropriate HTTP status

### Database (Supabase)

#### Migrations
- Use snake_case for table and column names
- Create migrations in `supabase/migrations/` with descriptive names: `012_orders_logistics.sql`
- Include indexes on foreign keys and frequently queried columns
- Always enable Row-Level Security (RLS)

#### RLS Policies
```sql
CREATE POLICY "Users can view their own data"
  ON orders FOR SELECT
  USING (auth.uid() = user_id);
```

#### Database Functions
- Use PostgreSQL functions for complex logic
- Create helper functions for computed values (e.g., `generate_tracking_id()`)

### Data Flow Patterns

#### EV Purchase Flow (Core Feature)
1. **Vehicle Selection**: User clicks "Purchase" on marketplace
2. **Order Creation**: POST `/api/orders` creates order & logistics entry
3. **Payment**: User pays deposit via PaymentForm → POST `/api/payments`
4. **Compliance**: Payment triggers compliance doc generation → POST `/api/compliance`
5. **Notification**: Toast displays: "Order Confirmed. Tracking ID: QEV-XXXX"
6. **Tracking**: Logistics updates via PUT `/api/logistics/[id]` reflect in OrderTracking

#### State Management
- Use React hooks for local component state
- For complex state, consider creating custom hooks
- No global state management library yet (add Context/Redux if needed)

## File Naming Conventions

- **Components**: PascalCase (e.g., `OrderDetails.tsx`)
- **Utilities**: camelCase (e.g., `cn`, `formatPrice`)
- **Types/Interfaces**: PascalCase (e.g., `Vehicle`, `Order`)
- **API Routes**: kebab-case directories with `route.ts` file
- **Migrations**: Numbered prefix + description: `012_orders_logistics.sql`

## Code Style

### Imports
```typescript
// 1. React imports first
import { useState, useEffect } from 'react'

// 2. Third-party imports
import { NextRequest } from 'next/server'

// 3. Local imports (grouped by type)
import { Button } from '@/components/ui/button'
import { supabase } from '@/lib/supabase'
import type { Vehicle } from '@/types'
```

### Formatting
- Use 2 spaces for indentation
- No trailing whitespace
- Maximum line length: 100 characters
- Use single quotes for strings

### Comments
- NO inline comments (JSDoc style preferred for exports)
- Comment complex business logic only
- Never comment obvious code (e.g., `// increment counter`)

## Testing

### Unit Tests
- Use Jest + React Testing Library
- Test component behavior, not implementation
- Mock external dependencies (Supabase, API calls)

### E2E Tests
- Use Playwright or Cypress
- Test critical user journeys:
  - EV purchase flow
  - Order tracking
  - Payment processing

## Security Best Practices

1. **Never expose secrets** in client code
2. **Validate all inputs** on the server
3. **Use RLS policies** for all database access
4. **Sanitize user data** before display
5. **Use prepared statements** (Supabase handles this)
6. **Implement rate limiting** on public APIs

## Performance Optimization

1. **Code splitting**: Next.js handles this automatically
2. **Image optimization**: Use `next/image` component
3. **Lazy loading**: Use React.lazy for heavy components
4. **Database queries**: Use indexed columns in WHERE clauses
5. **API caching**: Consider implementing caching for frequently accessed data

## Deployment

### Environment Variables (Required)
- `NEXT_PUBLIC_SUPABASE_URL` - Supabase project URL
- `NEXT_PUBLIC_SUPABASE_ANON_KEY` - Supabase anon key
- `SUPABASE_SERVICE_ROLE_KEY` - Service role key (server-only)

### Build Commands
- `npm run dev` - Start development server
- `npm run build` - Production build
- `npm start` - Start production server
- `npm run lint` - Run ESLint (when configured)

## Known Issues & Limitations

1. **Authentication**: Demo user ID hardcoded as 'demo-user-id' - needs Supabase Auth integration
2. **Payments**: Payment processing is simulated - needs real gateway (Stripe/QPay)
3. **Documents**: PDF URLs are mocked - needs cloud storage integration
4. **Real-time Updates**: Tracking updates are manual - needs webhooks or Supabase Realtime

## Before Making Changes

1. **Check existing components** - Don't reinvent the wheel
2. **Review component library** - shadcn/ui has many pre-built components
3. **Follow the data flow** - Understand how systems connect
4. **Write tests** - If adding critical functionality
5. **Update documentation** - Keep this file current

## Common Tasks

### Adding a New Page
1. Create route in `src/app/` (e.g., `src/app/my-page/page.tsx`)
2. Add client directive if using hooks: `'use client'`
3. Import and use shadcn/ui components
4. Use SVG icons from `@/components/icons.tsx`
5. Update navigation in `src/app/layout.tsx` if needed

### Creating a Custom Component
1. Create file in `src/components/` (e.g., `MyComponent.tsx`)
2. Define TypeScript interface for props
3. Use shadcn/ui primitives
4. Add SVG icons instead of emojis
5. Export default with PascalCase name

### Adding API Route
1. Create directory: `src/app/api/my-endpoint/route.ts`
2. Export GET/POST/PUT/DELETE handlers
3. Use NextRequest and NextResponse types
4. Implement error handling with try/catch
5. Return consistent JSON responses

### Database Changes
1. Create migration: `supabase/migrations/013_description.sql`
2. Write table creation/alteration SQL
3. Add indexes on foreign keys
4. Enable RLS and create policies
5. Test migration locally: `supabase migration up`

## Project-Specific Patterns

### Order Tracking Timeline
The OrderTracking component uses a 5-stage visual timeline:
1. Order Placed
2. Processing
3. In Transit
4. In Customs
5. Delivered

Always maintain this order when updating logistics status.

### Toast Notifications
Use the `useToast` hook from `@/components/ui/use-toast`:
```typescript
const { toast } = useToast()
toast({
  title: 'Success',
  description: 'Operation completed',
})
```

### Format Helpers
For currency formatting, use:
```typescript
const formatPrice = (price: number) =>
  new Intl.NumberFormat('en-QA', {
    style: 'currency',
    currency: 'QAR'
  }).format(price)
```

## Communication Style

- Be concise and direct
- Focus on the task at hand
- Use technical language accurately
- Provide context when necessary
- Ask clarifying questions if requirements are unclear

## Related Files

- `EV_PURCHASE_FLOW_IMPLEMENTATION.md` - Detailed implementation documentation
- `ARCHITECTURE.md` - High-level system architecture
- `START_HERE.md` - Project onboarding guide
- `README.md` - Project overview
