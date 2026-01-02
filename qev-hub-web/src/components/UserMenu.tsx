'use client'

import { useState } from 'react'
import { useAuth } from '@/contexts/AuthContext'
import { useRouter } from 'next/navigation'
import { Button } from '@/components/ui/button'
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog'
import { User as UserIcon, LogOut, Settings, ShoppingBag } from '@/components/icons'

export function UserMenu() {
  const { user, signOut } = useAuth()
  const router = useRouter()
  const [isLoading, setIsLoading] = useState(false)
  const [isOpen, setIsOpen] = useState(false)

  const handleSignOut = async () => {
    setIsLoading(true)
    try {
      await signOut()
      router.push('/')
    } catch (error) {
      console.error('Sign out error:', error)
    } finally {
      setIsLoading(false)
      setIsOpen(false)
    }
  }

  const handleNavigate = (path: string) => {
    router.push(path)
    setIsOpen(false)
  }

  if (!user) {
    return null
  }

  const userEmail = user.email
  const userInitial = userEmail ? userEmail.charAt(0).toUpperCase() : 'U'

  return (
    <>
      <Button
        variant="ghost"
        className="h-10 w-10 rounded-full bg-primary text-primary-foreground font-semibold"
        onClick={() => setIsOpen(true)}
      >
        {userInitial}
      </Button>
      <Dialog open={isOpen} onOpenChange={setIsOpen}>
        <DialogContent className="w-56">
          <DialogHeader>
            <DialogTitle>My Account</DialogTitle>
          </DialogHeader>
          <div className="space-y-1 pt-4">
            <p className="text-sm text-muted-foreground">{userEmail}</p>
            <div className="space-y-1 pt-2">
              <Button
                variant="ghost"
                className="w-full justify-start"
                onClick={() => handleNavigate('/orders')}
              >
                <ShoppingBag className="mr-2 h-4 w-4" />
                My Orders
              </Button>
              <Button
                variant="ghost"
                className="w-full justify-start"
                onClick={() => handleNavigate('/profile')}
              >
                <UserIcon className="mr-2 h-4 w-4" />
                Profile
              </Button>
              <Button
                variant="ghost"
                className="w-full justify-start"
                onClick={() => handleNavigate('/settings')}
              >
                <Settings className="mr-2 h-4 w-4" />
                Settings
              </Button>
            </div>
            <Button
              variant="destructive"
              className="w-full justify-start"
              onClick={handleSignOut}
              disabled={isLoading}
            >
              <LogOut className="mr-2 h-4 w-4" />
              {isLoading ? 'Signing out...' : 'Sign Out'}
            </Button>
          </div>
        </DialogContent>
      </Dialog>
    </>
  )
}
