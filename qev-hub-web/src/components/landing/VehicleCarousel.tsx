'use client'

import { motion } from 'framer-motion'
import { useRef, useState, useEffect } from 'react'
import { Button } from '@/components/ui/button'

const vehicles = [
  {
    id: 1,
    name: "Model S Plaid",
    price: "QAR 450,000",
    image: "/placeholder-car-1.png", 
    color: "from-blue-500 to-cyan-500"
  },
  {
    id: 2,
    name: "Taycan Turbo S",
    price: "QAR 650,000",
    image: "/placeholder-car-2.png",
    color: "from-red-500 to-orange-500"
  },
  {
    id: 3,
    name: "e-tron GT",
    price: "QAR 550,000",
    image: "/placeholder-car-3.png",
    color: "from-purple-500 to-pink-500"
  },
  {
    id: 4,
    name: "Lucid Air",
    price: "QAR 500,000",
    image: "/placeholder-car-4.png",
    color: "from-emerald-500 to-teal-500"
  }
]

export default function VehicleCarousel() {
  const [width, setWidth] = useState(0)
  const carousel = useRef<HTMLDivElement>(null)

  useEffect(() => {
    if (carousel.current) {
      setWidth(carousel.current.scrollWidth - carousel.current.offsetWidth)
    }
  }, [])

  return (
    <section className="py-24 bg-background overflow-hidden relative">
       {/* Background Grid */}
       <div className="absolute inset-0 bg-[linear-gradient(to_right,hsl(var(--foreground)/0.05)_1px,transparent_1px),linear-gradient(to_bottom,hsl(var(--foreground)/0.05)_1px,transparent_1px)] bg-[size:2rem_2rem] opacity-20 pointer-events-none"></div>

      <div className="container px-4 md:px-6 mb-12 relative z-10">
        <motion.h2 
          initial={{ opacity: 0, x: -50 }}
          whileInView={{ opacity: 1, x: 0 }}
          viewport={{ once: true }}
          className="text-3xl md:text-5xl font-bold text-foreground uppercase tracking-wider"
        >
          Featured <span className="text-primary">Models</span>
        </motion.h2>
      </div>

      <motion.div ref={carousel} className="cursor-grab active:cursor-grabbing overflow-hidden px-4 md:px-6 relative z-10">
        <motion.div 
          drag="x" 
          dragConstraints={{ right: 0, left: -width }} 
          className="flex gap-8"
        >
          {vehicles.map((vehicle) => (
            <motion.div 
              key={vehicle.id} 
              className="min-w-[300px] md:min-w-[400px] h-[500px] relative rounded-2xl overflow-hidden group border border-border hover:border-primary/50 transition-colors duration-300"
            >
              <div className={`absolute inset-0 bg-gradient-to-br ${vehicle.color} opacity-10 group-hover:opacity-20 transition-opacity duration-500`} />
              <div className="absolute inset-0 bg-card/60 group-hover:bg-card/40 transition-colors duration-500" />
              
              {/* Placeholder for Car Image */}
              <div className="absolute inset-0 flex items-center justify-center">
                 <div className={`w-3/4 h-1/2 bg-gradient-to-r ${vehicle.color} rounded-lg blur-2xl opacity-30 group-hover:opacity-60 transition-opacity duration-500`} />
                 <div className="absolute text-foreground/10 text-8xl font-black uppercase rotate-[-10deg] select-none group-hover:scale-110 transition-transform duration-500">
                    QEV
                 </div>
              </div>

              <div className="absolute bottom-0 left-0 right-0 p-8 bg-gradient-to-t from-background via-background/80 to-transparent translate-y-4 group-hover:translate-y-0 transition-transform duration-300">
                <h3 className="text-3xl font-bold text-foreground mb-2">{vehicle.name}</h3>
                <p className="text-primary text-xl font-medium mb-6">{vehicle.price}</p>
                <Button className="w-full bg-primary text-primary-foreground hover:bg-primary/90 font-bold transition-colors rounded-none skew-x-[-10deg]">
                   <span className="skew-x-[10deg]">View Details</span>
                </Button>
              </div>
            </motion.div>
          ))}
        </motion.div>
      </motion.div>
    </section>
  )
}
