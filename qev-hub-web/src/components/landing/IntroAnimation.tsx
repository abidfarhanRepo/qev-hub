'use client'

import { motion, AnimatePresence } from 'framer-motion'
import { useState, useEffect } from 'react'

export default function IntroAnimation({ onComplete }: { onComplete: () => void }) {
  const [isVisible, setIsVisible] = useState(true)

  useEffect(() => {
    const timer = setTimeout(() => {
      setIsVisible(false)
      setTimeout(onComplete, 1000) // Wait for exit animation
    }, 2500)
    return () => clearTimeout(timer)
  }, [onComplete])

  return (
    <AnimatePresence>
      {isVisible && (
        <motion.div
          className="fixed inset-0 z-[100] flex items-center justify-center bg-background"
          initial={{ opacity: 1 }}
          exit={{ opacity: 0, transition: { duration: 0.8, ease: "easeInOut" } }}
        >
          <div className="relative flex flex-col items-center">
             {/* Glitch/Neon Logo Effect */}
            <motion.div
              initial={{ scale: 0.8, opacity: 0, filter: "blur(10px)" }}
              animate={{ scale: 1, opacity: 1, filter: "blur(0px)" }}
              transition={{ duration: 0.8, ease: "easeOut" }}
              className="text-6xl md:text-8xl font-black text-foreground tracking-widest uppercase relative z-10"
              style={{ textShadow: "0 0 20px hsl(var(--primary) / 0.5)" }}
            >
              QEV<span className="text-primary drop-shadow-[0_0_10px_hsl(var(--primary)/0.8)]">-HUB</span>
            </motion.div>
            
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.5, duration: 0.5 }}
              className="mt-4 text-primary/80 tracking-[0.5em] text-sm uppercase"
            >
              System Initializing...
            </motion.div>

            {/* Particle/Wireframe effect simulation */}
            <motion.div
              className="absolute -inset-12 border-2 border-primary/30 rounded-full"
              initial={{ opacity: 0, scale: 0.8 }}
              animate={{ opacity: [0, 1, 0], scale: 1.2, rotate: 90 }}
              transition={{ duration: 2, ease: "easeInOut", repeat: Infinity }}
            />
             <motion.div
              className="absolute -inset-20 border border-primary/10 rounded-full"
              initial={{ opacity: 0, scale: 1.2 }}
              animate={{ opacity: [0, 1, 0], scale: 0.8, rotate: -90 }}
              transition={{ duration: 2.5, ease: "easeInOut", repeat: Infinity }}
            />
          </div>
        </motion.div>
      )}
    </AnimatePresence>
  )
}
