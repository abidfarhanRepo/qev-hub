'use client'

import { useAuth } from '@/contexts/AuthContext'
import { Button } from '@/components/ui/button'
import { UserMenu } from '@/components/UserMenu'
import { ThemeToggle } from '@/components/ThemeToggle'

export function Navbar() {
  const { user, loading } = useAuth()

  return (
    <nav className="sticky top-0 z-50 bg-background/80 backdrop-blur-md border-b border-border shadow-lg">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between h-16 items-center">
          <div className="flex items-center">
            <a href="/" className="text-2xl font-black tracking-widest text-foreground uppercase group">
              QEV<span className="text-primary group-hover:text-foreground transition-colors">-HUB</span>
            </a>
            <div className="ml-10 flex space-x-8">
              <a
                href="/marketplace"
                className="text-muted-foreground hover:text-primary transition-colors px-3 py-2 rounded-md text-sm font-bold uppercase tracking-wider"
              >
                Marketplace
              </a>
              <a
                href="/charging"
                className="text-muted-foreground hover:text-primary transition-colors px-3 py-2 rounded-md text-sm font-bold uppercase tracking-wider"
              >
                Charging Stations
              </a>
              {user && (
                <a
                  href="/orders"
                  className="text-muted-foreground hover:text-primary transition-colors px-3 py-2 rounded-md text-sm font-bold uppercase tracking-wider"
                >
                  My Orders
                </a>
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
                <a
                  href="/login"
                  className="text-foreground hover:text-primary transition-colors px-3 py-2 rounded-md text-sm font-medium"
                >
                  Login
                </a>
                <Button asChild className="gradient-primary">
                  <a href="/signup">Sign Up</a>
                </Button>
              </>
            )}
          </div>
        </div>
      </div>
    </nav>
  )
}
