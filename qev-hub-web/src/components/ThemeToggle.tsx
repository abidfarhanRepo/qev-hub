'use client'

import { useTheme } from 'next-themes'
import { MoonIcon, SunIcon } from '@/components/icons'
import { Button } from '@/components/ui/button'
import { useEffect, useState } from 'react'

export function ThemeToggle() {
  const { theme, setTheme } = useTheme()
  const [mounted, setMounted] = useState(false)

  useEffect(() => {
    setMounted(true)
  }, [])

  if (!mounted) {
    return (
      <Button variant="ghost" size="icon" className="rounded-full opacity-0">
        <span className="sr-only">Toggle theme</span>
      </Button>
    )
  }

  return (
    <Button
      variant="ghost"
      size="icon"
      onClick={() => setTheme(theme === 'dark' ? 'light' : 'dark')}
      className="rounded-full hover:bg-qev-accent/10"
    >
      {theme === 'dark' ? (
        <SunIcon className="h-5 w-5 text-qev-accent" />
      ) : (
        <MoonIcon className="h-5 w-5 text-qev-maroon" />
      )}
      <span className="sr-only">Toggle theme</span>
    </Button>
  )
}
