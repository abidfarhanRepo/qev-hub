'use client'

import { useState } from 'react'
import { Button } from '@/components/ui/button'
import { motion, useScroll, useMotionValueEvent } from 'framer-motion'
import Link from 'next/link'
import { useAuth } from '@/contexts/AuthContext'
import { UserMenu } from '@/components/UserMenu'
import { ThemeToggle } from '@/components/ThemeToggle'

export default function LandingNavbar() {
  const [isScrolled, setIsScrolled] = useState(false)
  const { scrollY } = useScroll()
  const { user, loading } = useAuth()

  useMotionValueEvent(scrollY, "change", (latest) => {
    setIsScrolled(latest > 50)
  })

  return (
    <motion.nav 
      className={`fixed top-0 left-0 right-0 z-50 transition-all duration-300 ${
        isScrolled ? 'bg-background/80 backdrop-blur-md border-b border-border py-4 shadow-lg' : 'bg-transparent py-6'
      }`}
      initial={{ y: -100 }}
      animate={{ y: 0 }}
      transition={{ duration: 0.5 }}
    >
      <div className="container px-4 md:px-6 flex justify-between items-center">
        <Link href="/" className="text-2xl font-black tracking-widest text-foreground uppercase group">
          QEV<span className="text-primary group-hover:text-foreground transition-colors">-HUB</span>
        </Link>

        <div className="hidden md:flex items-center space-x-8">
          <Link href="/marketplace" className="text-sm font-bold text-muted-foreground hover:text-primary transition-colors uppercase tracking-wider">
            Marketplace
          </Link>
          <Link href="/charging" className="text-sm font-bold text-muted-foreground hover:text-primary transition-colors uppercase tracking-wider">
            Charging
          </Link>
          {user && (
            <Link href="/orders" className="text-sm font-bold text-muted-foreground hover:text-primary transition-colors uppercase tracking-wider">
              Orders
            </Link>
          )}
        </div>

        <div className="flex items-center space-x-4">
          <ThemeToggle />
          {loading ? (
            <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary" />
          ) : user ? (
            <UserMenu />
          ) : (
            <>
              <Link href="/login">
                 <Button variant="ghost" className="text-foreground hover:text-primary hover:bg-primary/5 font-medium">
                    Login
                 </Button>
              </Link>
              <Link href="/signup">
                <Button className="bg-primary text-primary-foreground hover:bg-primary/90 font-bold rounded-none skew-x-[-10deg] transition-all duration-300 shadow-lg hover:shadow-xl">
                    <span className="skew-x-[10deg]">Get Started</span>
                </Button>
              </Link>
            </>
          )}
        </div>
      </div>
    </motion.nav>
  )
}
