'use client'

import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { useAuth } from '@/contexts/AuthContext'
import { Button } from '@/components/ui/button'
import { UserMenu } from '@/components/UserMenu'
import { ThemeToggle } from '@/components/ThemeToggle'

export function Navbar() {
  const { user, loading } = useAuth()
  const pathname = usePathname()

  const isActive = (path: string) => pathname === path

  return (
    <nav className="sticky top-0 z-50 bg-background/80 backdrop-blur-md border-b border-border shadow-lg">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between h-16 items-center">
          <div className="flex items-center">
            <Link href="/" className="text-2xl font-black tracking-widest text-foreground uppercase group">
              QEV<span className="text-primary group-hover:text-foreground transition-colors">-HUB</span>
            </Link>
            <div className="ml-10 flex space-x-8">
              <Link
                href="/marketplace"
                aria-current={isActive('/marketplace') ? 'page' : undefined}
                className={`transition-colors px-3 py-2 rounded-md text-sm font-bold uppercase tracking-wider ${
                  isActive('/marketplace') ? 'text-primary' : 'text-muted-foreground hover:text-primary'
                }`}
              >
                Marketplace
              </Link>
              <Link
                href="/charging"
                aria-current={isActive('/charging') ? 'page' : undefined}
                className={`transition-colors px-3 py-2 rounded-md text-sm font-bold uppercase tracking-wider ${
                  isActive('/charging') ? 'text-primary' : 'text-muted-foreground hover:text-primary'
                }`}
              >
                Charging Stations
              </Link>
              {user && (
                <>
                  <Link
                    href="/orders"
                    aria-current={isActive('/orders') ? 'page' : undefined}
                    className={`transition-colors px-3 py-2 rounded-md text-sm font-bold uppercase tracking-wider ${
                      isActive('/orders') ? 'text-primary' : 'text-muted-foreground hover:text-primary'
                    }`}
                  >
                    My Orders
                  </Link>
                  <Link
                    href="/dashboard"
                    aria-current={isActive('/dashboard') ? 'page' : undefined}
                    className={`transition-colors px-3 py-2 rounded-md text-sm font-bold uppercase tracking-wider ${
                      isActive('/dashboard') ? 'text-primary' : 'text-muted-foreground hover:text-primary'
                    }`}
                  >
                    Dashboard
                  </Link>
                </>
              )}
            </div>
          </div>
          <div className="flex items-center space-x-2">
            <ThemeToggle />
            {loading ? (
              <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary" />
            ) : user ? (
              <UserMenu />
            ) : (
              <>
                <Link
                  href="/login"
                  className="text-foreground hover:text-primary transition-colors px-3 py-2 rounded-md text-sm font-medium"
                >
                  Login
                </Link>
                <Button asChild className="gradient-primary">
                  <Link href="/signup">Sign Up</Link>
                </Button>
              </>
            )}
          </div>
        </div>
      </div>
    </nav>
  )
}
