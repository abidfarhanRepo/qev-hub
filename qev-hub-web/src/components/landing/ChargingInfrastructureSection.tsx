'use client'

import { useEffect, useRef, useState } from 'react'
import { Activity, Calendar, Navigation, Zap } from 'lucide-react'

export default function ChargingInfrastructureSection() {
  const sectionRef = useRef<HTMLDivElement>(null)
  const [progress, setProgress] = useState(15)

  useEffect(() => {
    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add('active')
            setProgress(15)
          }
        })
      },
      { threshold: 0.1 }
    )

    const revealElements = sectionRef.current?.querySelectorAll('.reveal')
    revealElements?.forEach((el) => observer.observe(el))

    return () => observer.disconnect()
  }, [])

  const features = [
    {
      icon: Activity,
      title: 'Live Availability',
      description:
        'WebSocket integration with KAHRAMAA and WOQOD networks for real-time status updates.',
      color: 'bg-green-100 dark:bg-green-950/50',
      iconColor: 'text-green-600 dark:text-green-500',
    },
    {
      icon: Calendar,
      title: 'Smart Booking',
      description:
        'Reserve chargers in advance with 30-second booking flow and automated payment processing.',
      color: 'bg-blue-100 dark:bg-blue-950/50',
      iconColor: 'text-blue-600 dark:text-blue-500',
    },
    {
      icon: Navigation,
      title: 'Route Optimization',
      description:
        'AI-powered trip planning considering charger availability, wait times, and dynamic pricing.',
      color: 'bg-purple-100 dark:bg-purple-950/50',
      iconColor: 'text-purple-600 dark:text-purple-500',
    },
  ]

  const stations = [
    { name: 'Hamad Airport', chargers: '10', power: '150kW', x: '33.33%', y: '25%', color: 'bg-primary' },
    { name: 'Lusail', chargers: '6', power: '100kW', x: '66.67%', y: '50%', color: 'bg-secondary' },
    { name: 'Pearl Qatar', chargers: '8', power: '50kW', x: '50%', y: '66.67%', color: 'bg-accent' },
  ]

  return (
    <section id="charging" className="py-24 bg-slate-50 dark:bg-slate-950 relative overflow-hidden">
      {/* Background Effects */}
      <div className="absolute inset-0 opacity-5">
        <div className="absolute top-0 left-0 w-96 h-96 bg-primary rounded-full blur-3xl"></div>
        <div className="absolute bottom-0 right-0 w-96 h-96 bg-secondary rounded-full blur-3xl"></div>
      </div>

      <div ref={sectionRef} className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        <div className="grid md:grid-cols-2 gap-16 items-center">
          {/* Left Column - Map Visualization */}
          <div className="order-2 md:order-1 reveal opacity-0 translate-y-8 transition-all duration-800">
            <div className="relative">
              {/* Glow Effect */}
              <div className="absolute inset-0 bg-gradient-to-r from-primary/30 to-secondary/30 rounded-full blur-3xl"></div>

              {/* Map Card */}
              <div className="relative bg-white dark:bg-slate-900 p-8 rounded-3xl border border-slate-200 dark:border-slate-800 shadow-xl">
                {/* Map Visualization */}
                <div className="aspect-square bg-slate-100 dark:bg-slate-950 rounded-2xl relative overflow-hidden p-4">
                  {/* Grid Pattern */}
                  <div className="absolute inset-0 opacity-20 bg-[radial-gradient(circle_at_2px_2px,currentColor_1px,transparent_0)] bg-[size:20px_20px]"></div>

                  {/* Qatar Map Silhouette (Simplified) */}
                  <svg
                    viewBox="0 0 200 150"
                    className="w-full h-full opacity-30 dark:opacity-20 text-foreground"
                  >
                    <path
                      d="M80,40 Q100,30 120,40 T140,60 T130,90 T100,110 T70,90 T60,60 Z"
                      fill="currentColor"
                    />
                  </svg>

                  {/* Charging Station Pins */}
                  {stations.map((station, index) => (
                    <div
                      key={index}
                      className="absolute transform -translate-x-1/2 -translate-y-1/2 group cursor-pointer"
                      style={{ left: station.x, top: station.y }}
                    >
                      {index === 0 && (
                        <div className="w-4 h-4 bg-primary rounded-full animate-ping absolute"></div>
                      )}
                      <div
                        className={`w-3 h-4 ${station.color} rounded-full relative z-10 flex items-center justify-center`}
                      >
                        <Zap className="w-2 h-2 text-white dark:text-black" />
                      </div>
                      {/* Tooltip */}
                      <div className="absolute bottom-full left-1/2 transform -translate-x-1/2 mb-2 w-32 bg-white dark:bg-slate-800 p-2 rounded-lg shadow-lg text-xs opacity-0 group-hover:opacity-100 transition-opacity pointer-events-none z-20 border border-slate-200 dark:border-slate-700">
                        <strong className="text-foreground">{station.name}</strong>
                        <br />
                        <span className="text-muted-foreground">{station.chargers} chargers, {station.power}</span>
                      </div>
                    </div>
                  ))}
                </div>

                {/* Progress Bar */}
                <div className="mt-6 space-y-3">
                  <div className="flex justify-between items-center text-sm">
                    <span className="text-muted-foreground">Current Stations</span>
                    <span className="font-bold text-foreground">26+ Verified</span>
                  </div>
                  <div className="w-full bg-slate-200 dark:bg-slate-700 h-2 rounded-full overflow-hidden">
                    <div
                      className="bg-primary h-full rounded-full transition-all duration-1000"
                      style={{ width: `${progress}%` }}
                    ></div>
                  </div>
                  <div className="flex justify-between items-center text-sm">
                    <span className="text-muted-foreground">Target (2026)</span>
                    <span className="font-bold text-primary">300+</span>
                  </div>
                </div>
              </div>
            </div>
          </div>

          {/* Right Column - Content */}
          <div className="order-1 md:order-2 reveal opacity-0 translate-y-8 transition-all duration-800">
            <h2 className="text-4xl md:text-5xl font-bold mb-6 text-foreground">
              Real-Time <span className="text-primary">Charging</span> Network
            </h2>
            <p className="text-lg text-muted-foreground mb-6">
              Addressing the critical infrastructure shortfall identified in our research (only
              100-250 stations vs 15,000 target by 2030), the QEV platform provides live
              availability tracking.
            </p>

            <div className="space-y-4">
              {features.map((feature, index) => {
                const Icon = feature.icon
                return (
                  <div
                    key={index}
                    className="flex items-start space-x-4 p-4 rounded-xl bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800"
                  >
                    <div
                      className={`w-10 h-10 rounded-full ${feature.color} flex items-center justify-center flex-shrink-0`}
                    >
                      <Icon className={`w-5 h-5 ${feature.iconColor}`} />
                    </div>
                    <div>
                      <h4 className="font-semibold text-foreground">{feature.title}</h4>
                      <p className="text-sm text-muted-foreground">
                        {feature.description}
                      </p>
                    </div>
                  </div>
                )
              })}
            </div>
          </div>
        </div>
      </div>
    </section>
  )
}
