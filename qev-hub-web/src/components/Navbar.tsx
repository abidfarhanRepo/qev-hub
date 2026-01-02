'use client'

import { useAuth } from '@/contexts/AuthContext'
import { Button } from '@/components/ui/button'
import { UserMenu } from '@/components/UserMenu'

export function Navbar() {
  const { user, loading } = useAuth()

  return (
    <nav className="bg-white shadow-sm border-b">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between h-16 items-center">
          <div className="flex items-center">
            <a href="/" className="text-2xl font-bold text-primary">
              QEV Hub
            </a>
            <div className="ml-10 flex space-x-8">
              <a
                href="/marketplace"
                className="text-gray-700 hover:text-primary px-3 py-2 rounded-md text-sm font-medium"
              >
                Marketplace
              </a>
              <a
                href="/charging"
                className="text-gray-700 hover:text-primary px-3 py-2 rounded-md text-sm font-medium"
              >
                Charging Stations
              </a>
              {user && (
                <a
                  href="/orders"
                  className="text-gray-700 hover:text-primary px-3 py-2 rounded-md text-sm font-medium"
                >
                  My Orders
                </a>
              )}
            </div>
          </div>
          <div className="flex items-center space-x-4">
            {loading ? (
              <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary" />
            ) : user ? (
              <UserMenu />
            ) : (
              <>
                <a
                  href="/login"
                  className="text-gray-700 hover:text-primary px-3 py-2 rounded-md text-sm font-medium"
                >
                  Login
                </a>
                <Button asChild>
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
