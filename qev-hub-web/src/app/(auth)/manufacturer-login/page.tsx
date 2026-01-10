'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { supabase } from '@/lib/supabase'
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { AlertCircle } from '@/components/icons'
import Link from 'next/link'

export default function ManufacturerLoginPage() {
  const router = useRouter()
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault()
    setLoading(true)
    setError(null)

    try {
      const { data, error } = await supabase.auth.signInWithPassword({
        email,
        password,
      })

      if (error) throw error

      if (data.user) {
        // Check if user has a manufacturer profile
        const { data: manufacturerData, error: manufacturerError } = await supabase
          .from('manufacturers')
          .select('*')
          .eq('user_id', data.user.id)
          .single()

        if (manufacturerError || !manufacturerData) {
          // User doesn't have a manufacturer profile
          setError('No manufacturer account found. Please sign up first.')
          await supabase.auth.signOut()
          return
        }

        // Redirect to manufacturer dashboard
        router.push('/manufacturer/dashboard')
        router.refresh()
      }
    } catch (error: any) {
      console.error('Login error:', error)
      setError(error.message || 'Failed to login. Please check your credentials.')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-background via-background to-primary/5 p-4">
      <Card className="w-full max-w-md border-2">
        <CardHeader className="space-y-2">
          <div className="text-center">
            <Link href="/" className="text-2xl font-black tracking-wider inline-block mb-2">
              QEV<span className="text-primary">-HUB</span>
            </Link>
            <p className="text-xs text-muted-foreground">Manufacturer Portal</p>
          </div>
          <CardTitle className="text-2xl text-center">Manufacturer Login</CardTitle>
          <CardDescription className="text-center">
            Sign in to manage your vehicle listings and orders
          </CardDescription>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleLogin} className="space-y-4">
            {error && (
              <div className="bg-destructive/10 text-destructive px-4 py-3 rounded-lg flex items-start gap-3">
                <AlertCircle className="w-5 h-5 flex-shrink-0 mt-0.5" />
                <p className="text-sm">{error}</p>
              </div>
            )}

            <div className="space-y-2">
              <Label htmlFor="email">Email Address</Label>
              <Input
                id="email"
                type="email"
                placeholder="manufacturer@company.com"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                required
                disabled={loading}
              />
            </div>

            <div className="space-y-2">
              <Label htmlFor="password">Password</Label>
              <Input
                id="password"
                type="password"
                placeholder="Enter your password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                required
                disabled={loading}
              />
            </div>

            <Button
              type="submit"
              className="w-full"
              disabled={loading}
            >
              {loading ? 'Signing in...' : 'Sign In'}
            </Button>

            <div className="text-center space-y-2 pt-4 border-t">
              <p className="text-sm text-muted-foreground">
                Don't have a manufacturer account?
              </p>
              <Link href="/manufacturer-signup">
                <Button variant="outline" className="w-full">
                  Register as Manufacturer
                </Button>
              </Link>
              <Link href="/">
                <Button variant="ghost" size="sm" className="text-xs">
                  ← Back to Home
                </Button>
              </Link>
            </div>
          </form>
        </CardContent>
      </Card>
    </div>
  )
}
