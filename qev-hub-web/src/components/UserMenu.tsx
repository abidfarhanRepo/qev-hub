'use client'

import { useState } from 'react'
import { useAuth } from '@/contexts/AuthContext'
import { useRouter } from 'next/navigation'
import { Button } from '@/components/ui/button'
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu'
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
    <DropdownMenu open={isOpen} onOpenChange={setIsOpen}>
      <DropdownMenuTrigger asChild>
        <Button
          variant="ghost"
          className="h-10 w-10 rounded-full bg-primary text-primary-foreground font-semibold"
        >
          {userInitial}
        </Button>
      </DropdownMenuTrigger>
      <DropdownMenuContent className="w-56" align="end">
        <DropdownMenuLabel className="font-normal">
          <div className="flex flex-col space-y-1">
            <p className="text-sm font-medium leading-none">My Account</p>
            <p className="text-xs leading-none text-muted-foreground">{userEmail}</p>
          </div>
        </DropdownMenuLabel>
        <DropdownMenuSeparator />
              <DropdownMenuItem onClick={() => handleNavigate('/orders')}>
                <ShoppingBag className="mr-2 h-4 w-4" />
                My Orders
              </DropdownMenuItem>
              <DropdownMenuItem onClick={() => handleNavigate('/settings')}>
                <UserIcon className="mr-2 h-4 w-4" />
                Account Settings
              </DropdownMenuItem>
        <DropdownMenuSeparator />
        <DropdownMenuItem onClick={handleSignOut} disabled={isLoading} className="text-destructive focus:text-destructive">
          <LogOut className="mr-2 h-4 w-4" />
          {isLoading ? 'Signing out...' : 'Sign Out'}
        </DropdownMenuItem>
      </DropdownMenuContent>
    </DropdownMenu>
  )
}
