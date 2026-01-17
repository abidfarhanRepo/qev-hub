import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY

if (!supabaseUrl || !supabaseServiceKey) {
  console.warn('API Auth: Service role key not configured, using anon key')
}

// Admin client with service role for server-side operations
const adminSupabase = supabaseUrl && supabaseServiceKey
  ? createClient(supabaseUrl, supabaseServiceKey)
  : null

export interface AuthenticatedUser {
  id: string
  email: string
  role?: string
}

export interface AuthResult {
  user: AuthenticatedUser | null
  error: string | null
}

/**
 * Authenticate a request using the Authorization header Bearer token
 * Returns the authenticated user or an error
 */
export async function authenticateRequest(request: NextRequest): Promise<AuthResult> {
  const authHeader = request.headers.get('Authorization')
  
  if (!authHeader?.startsWith('Bearer ')) {
    return { user: null, error: 'Missing or invalid Authorization header' }
  }

  const token = authHeader.replace('Bearer ', '')
  
  if (!token) {
    return { user: null, error: 'No token provided' }
  }

  try {
    // Create a client with the user's token to verify it
    const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!
    const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
    
    const userClient = createClient(supabaseUrl, supabaseAnonKey, {
      global: {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      },
      auth: {
        persistSession: false,
      },
    })

    const { data: { user }, error } = await userClient.auth.getUser()
    
    if (error || !user) {
      return { user: null, error: 'Invalid or expired token' }
    }

    // Optionally fetch user profile for role information
    const { data: profile } = await userClient
      .from('profiles')
      .select('role')
      .eq('id', user.id)
      .single()

    return {
      user: {
        id: user.id,
        email: user.email!,
        role: profile?.role || 'user',
      },
      error: null,
    }
  } catch (error) {
    console.error('Authentication error:', error)
    return { user: null, error: 'Authentication failed' }
  }
}

/**
 * Middleware helper to require authentication
 * Returns a NextResponse error if authentication fails, null otherwise
 */
export async function requireAuth(request: NextRequest): Promise<{
  response: NextResponse | null
  user: AuthenticatedUser | null
}> {
  const { user, error } = await authenticateRequest(request)
  
  if (error || !user) {
    return {
      response: NextResponse.json(
        { error: error || 'Unauthorized' },
        { status: 401 }
      ),
      user: null,
    }
  }

  return { response: null, user }
}

/**
 * Require admin role for the request
 */
export async function requireAdmin(request: NextRequest): Promise<{
  response: NextResponse | null
  user: AuthenticatedUser | null
}> {
  const { response, user } = await requireAuth(request)
  
  if (response) {
    return { response, user: null }
  }

  if (user?.role !== 'admin' && user?.role !== 'manufacturer') {
    return {
      response: NextResponse.json(
        { error: 'Insufficient permissions' },
        { status: 403 }
      ),
      user: null,
    }
  }

  return { response: null, user }
}

/**
 * Get admin Supabase client for server-side operations
 * This bypasses RLS for administrative tasks
 */
export function getAdminClient() {
  if (!adminSupabase) {
    throw new Error('Admin client not configured. Set SUPABASE_SERVICE_ROLE_KEY environment variable.')
  }
  return adminSupabase
}
