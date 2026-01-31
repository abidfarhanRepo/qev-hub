'use client'

import { motion, useScroll, useTransform } from 'framer-motion'
import { useRef } from 'react'
import Link from 'next/link'
import { Button } from '@/components/ui/button'
import { ChevronRight } from 'lucide-react'
import { useAuth } from '@/contexts/AuthContext'

export default function HeroSection() {
  const { user } = useAuth()
  const ref = useRef(null)
  const { scrollYProgress } = useScroll({
    target: ref,
    offset: ["start start", "end start"]
  })

  const y = useTransform(scrollYProgress, [0, 1], ["0%", "50%"])
  const opacity = useTransform(scrollYProgress, [0, 0.5], [1, 0])

  return (
    <section ref={ref} className="relative h-screen w-full overflow-hidden bg-background flex items-center justify-center">
      {/* Background Grid */}
      <div className="absolute inset-0 bg-[linear-gradient(to_right,hsl(var(--foreground)/0.05)_1px,transparent_1px),linear-gradient(to_bottom,hsl(var(--foreground)/0.05)_1px,transparent_1px)] bg-[size:4rem_4rem] [mask-image:radial-gradient(ellipse_60%_50%_at_50%_0%,#000_70%,transparent_100%)] pointer-events-none"></div>

      {/* Floating Elements / Parallax Background */}
      <motion.div style={{ y, opacity }} className="absolute inset-0 pointer-events-none flex items-center justify-center">
         {/* Simulated 3D Car Glow */}
         <div className="w-[60vw] h-[60vh] bg-primary/20 blur-[100px] rounded-full mix-blend-screen animate-pulse-slow" />
      </motion.div>

      <div className="container relative z-10 px-4 md:px-6 flex flex-col items-center text-center">
        <motion.div
          initial={{ scale: 0.9, opacity: 0 }}
          animate={{ scale: 1, opacity: 1 }}
          transition={{ duration: 1, delay: 0.2 }}
          className="mb-4 inline-block px-4 py-1.5 border border-primary/50 rounded-full bg-primary/10 backdrop-blur-sm shadow-lg"
        >
          <span className="text-primary text-sm font-semibold tracking-widest uppercase">The Future Has Arrived</span>
        </motion.div>

        <motion.h1
          initial={{ y: 50, opacity: 0 }}
          animate={{ y: 0, opacity: 1 }}
          transition={{ duration: 0.8, delay: 0.5 }}
          className="text-5xl md:text-7xl lg:text-9xl font-black text-foreground tracking-tighter uppercase mb-6 leading-none"
        >
          QEV<span className="text-primary">HUB</span>
        </motion.h1>

        <motion.p
          initial={{ y: 30, opacity: 0 }}
          animate={{ y: 0, opacity: 1 }}
          transition={{ duration: 0.8, delay: 0.7 }}
          className="text-xl md:text-2xl text-foreground/90 max-w-2xl mb-10 font-medium tracking-wide"
        >
          Qatar&apos;s Premier Electric Vehicle Ecosystem.
          <br />
          <span className="text-primary font-bold">Sustainable. Connected. Powerful.</span>
        </motion.p>

        <motion.div
          initial={{ y: 30, opacity: 0 }}
          animate={{ y: 0, opacity: 1 }}
          transition={{ duration: 0.8, delay: 0.9 }}
          className="flex flex-col sm:flex-row gap-6"
        >
          <Link href={user ? "/dashboard" : "/marketplace"}>
            <Button size="lg" className="bg-primary text-primary-foreground hover:bg-primary/90 font-bold text-lg px-10 py-8 rounded-none skew-x-[-10deg] transition-all duration-300 group shadow-lg hover:shadow-xl">
              <span className="skew-x-[10deg] inline-flex items-center">
                {user ? "Go to Dashboard" : "Explore Marketplace"} <ChevronRight className="ml-2 h-5 w-5 group-hover:translate-x-1 transition-transform" />
              </span>
            </Button>
          </Link>
          <Link href="/charging">
            <Button size="lg" variant="outline" className="border-primary text-primary hover:bg-primary/10 font-bold text-lg px-10 py-8 rounded-none skew-x-[-10deg] transition-all duration-300 backdrop-blur-sm shadow-lg">
               <span className="skew-x-[10deg]">
                Locate Charging
              </span>
            </Button>
          </Link>
        </motion.div>

        {/* Stats */}
        <motion.div
          initial={{ y: 30, opacity: 0 }}
          animate={{ y: 0, opacity: 1 }}
          transition={{ duration: 0.8, delay: 1.1 }}
          className="grid grid-cols-2 md:grid-cols-4 gap-6 mt-12 max-w-4xl mx-auto"
        >
          {[
            { label: "Vehicles", value: "38+" },
            { label: "Manufacturers", value: "8" },
            { label: "Chargers", value: "26+" },
            { label: "Users", value: "2K+" },
          ].map((stat, index) => (
            <div key={index} className="text-center">
              <div className="text-3xl md:text-4xl font-black text-primary">{stat.value}</div>
              <div className="text-xs md:text-sm text-foreground/80 uppercase tracking-wider font-medium">{stat.label}</div>
            </div>
          ))}
        </motion.div>
      </div>

      {/* Scroll Indicator */}
      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1, y: [0, 10, 0] }}
        transition={{ delay: 1.5, duration: 2, repeat: Infinity }}
        className="absolute bottom-10 left-1/2 -translate-x-1/2 text-primary/70 flex flex-col items-center gap-2"
      >
        <span className="text-xs uppercase tracking-widest font-medium">Scroll</span>
        <div className="w-6 h-10 border-2 border-current rounded-full flex justify-center p-1">
          <div className="w-1 h-2 bg-current rounded-full" />
        </div>
      </motion.div>
    </section>
  )
}
