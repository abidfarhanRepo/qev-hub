'use client'

import { useEffect, useState } from 'react'
import { useRouter } from 'next/navigation'
import { supabase } from '@/lib/supabase'
import Link from 'next/link'
import { Button } from '@/components/ui/button'
import { CarIcon, PackageIcon, DocumentIcon, LogOutIcon } from '@/components/icons'

export default function ManufacturerLayout({
  children,
}: {
  children: React.ReactNode
}) {
  const router = useRouter()
  const [loading, setLoading] = useState(true)
  const [user, setUser] = useState<any>(null)
  const [manufacturer, setManufacturer] = useState<any>(null)

  useEffect(() => {
    checkAuth()
  }, [])

  const checkAuth = async () => {
    try {
      const { data: { user } } = await supabase.auth.getUser()
      
      if (!user) {
        router.push('/manufacturer-login')
        return
      }

      setUser(user)

      // Check if user has a manufacturer profile
      const { data: manufacturerData, error } = await supabase
        .from('manufacturers')
        .select('*')
        .eq('user_id', user.id)
        .single()

      if (error || !manufacturerData) {
        // Redirect to manufacturer signup
        router.push('/manufacturer-signup')
        return
      }

      setManufacturer(manufacturerData)
    } catch (error) {
      console.error('Auth check failed:', error)
      router.push('/manufacturer-login')
    } finally {
      setLoading(false)
    }
  }

  const handleLogout = async () => {
    await supabase.auth.signOut()
    router.push('/manufacturer-login')
  }

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-background">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary" />
      </div>
    )
  }

  if (!user || !manufacturer) {
    return null
  }

  return (
    <div className="min-h-screen bg-background">
      {/* Manufacturer Navigation */}
      <nav className="bg-card border-b border-border sticky top-0 z-50">
        <div className="container mx-auto px-4">
          <div className="flex items-center justify-between h-16">
            <div className="flex items-center space-x-8">
              <Link href="/manufacturer/dashboard" className="text-xl font-black tracking-wider">
                QEV<span className="text-primary">-HUB</span>
                <span className="text-xs ml-2 text-muted-foreground font-normal">Manufacturer</span>
              </Link>
              
              <div className="hidden md:flex items-center space-x-4">
                <Link href="/manufacturer/dashboard">
                  <Button variant="ghost" size="sm" className="gap-2">
                    <PackageIcon className="w-4 h-4" />
                    Dashboard
                  </Button>
                </Link>
                <Link href="/manufacturer/vehicles">
                  <Button variant="ghost" size="sm" className="gap-2">
                    <CarIcon className="w-4 h-4" />
                    Vehicles
                  </Button>
                </Link>
                <Link href="/manufacturer/orders">
                  <Button variant="ghost" size="sm" className="gap-2">
                    <DocumentIcon className="w-4 h-4" />
                    Orders
                  </Button>
                </Link>
              </div>
            </div>

            <div className="flex items-center gap-4">
              <div className="text-right hidden md:block">
                <p className="text-sm font-medium">{manufacturer?.company_name}</p>
                <p className="text-xs text-muted-foreground">{user?.email}</p>
              </div>
              <Button
                variant="outline"
                size="sm"
                onClick={handleLogout}
                className="gap-2"
              >
                <LogOutIcon className="w-4 h-4" />
                Logout
              </Button>
            </div>
          </div>
        </div>
      </nav>

      {/* Main Content */}
      <main className="container mx-auto px-4 py-8">
        {children}
      </main>
    </div>
  )
}
