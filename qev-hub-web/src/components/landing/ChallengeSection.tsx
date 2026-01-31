'use client'

import { useEffect, useRef } from 'react'
import { XCircle, AlertTriangle } from 'lucide-react'

export default function ChallengeSection() {
  const sectionRef = useRef<HTMLDivElement>(null)

  useEffect(() => {
    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add('active')
          }
        })
      },
      { threshold: 0.1 }
    )

    const revealElements = sectionRef.current?.querySelectorAll('.reveal')
    revealElements?.forEach((el) => observer.observe(el))

    return () => observer.disconnect()
  }, [])

  const challenges = [
    {
      icon: XCircle,
      text: 'No direct manufacturer access - all imports through brokers',
    },
    {
      icon: XCircle,
      text: 'Complex FAHES inspection and customs navigation',
    },
    {
      icon: XCircle,
      text: 'Limited real-time charging infrastructure data',
    },
    {
      icon: XCircle,
      text: 'Only 31% of residents considering EV purchase',
    },
  ]

  const alerts = [
    {
      title: 'Broker Markup Detection',
      message: '+22% price inflation on NIO ET5 import',
      color: 'red',
    },
    {
      title: 'Documentation Delay',
      message: 'FAHES inspection scheduling: 14 days average',
      color: 'orange',
    },
    {
      title: 'Data Unavailable',
      message: 'Charging station real-time status: Offline',
      color: 'yellow',
    },
  ]

  const colorClasses = {
    red: {
      bg: 'bg-red-50 dark:bg-red-950/50',
      border: 'border-red-500 dark:border-red-700',
      title: 'text-red-900 dark:text-red-200',
      message: 'text-red-700 dark:text-red-300',
    },
    orange: {
      bg: 'bg-orange-50 dark:bg-orange-950/50',
      border: 'border-orange-500 dark:border-orange-700',
      title: 'text-orange-900 dark:text-orange-200',
      message: 'text-orange-700 dark:text-orange-300',
    },
    yellow: {
      bg: 'bg-yellow-50 dark:bg-yellow-950/50',
      border: 'border-yellow-600 dark:border-yellow-700',
      title: 'text-yellow-900 dark:text-yellow-200',
      message: 'text-yellow-800 dark:text-yellow-300',
    },
  }

  return (
    <section
      id="challenge"
      className="py-24 bg-background relative overflow-hidden"
    >
      <div className="absolute top-0 left-0 w-full h-px bg-gradient-to-r from-transparent via-primary/50 to-transparent"></div>

      <div ref={sectionRef} className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid md:grid-cols-2 gap-16 items-center">
          {/* Left Column */}
          <div className="reveal opacity-0 translate-y-8 transition-all duration-800">
            <h2 className="text-4xl md:text-5xl font-bold mb-6 text-foreground">
              Fragmented Ecosystem, <br />
              <span className="text-primary">Inflated Costs</span>
            </h2>
            <p className="text-lg text-muted-foreground mb-6 leading-relaxed">
              Despite Qatar's ambitious National Vision 2030, the current EV ecosystem relies on
              third-party brokers who inflate vehicle costs by 15-25%. Consumers face a fragmented
              system with no direct access to international manufacturers.
            </p>
            <ul className="space-y-4">
              {challenges.map((challenge, index) => (
                <li key={index} className="flex items-start space-x-3">
                  <challenge.icon className="w-6 h-6 text-destructive flex-shrink-0 mt-0.5" />
                  <span className="text-muted-foreground">{challenge.text}</span>
                </li>
              ))}
            </ul>
          </div>

          {/* Right Column - Alerts Card */}
          <div className="reveal opacity-0 translate-y-8 transition-all duration-800" style={{ transitionDelay: '0.2s' }}>
            <div className="relative">
              {/* Background Glow */}
              <div className="absolute inset-0 bg-gradient-to-r from-primary/20 to-transparent rounded-3xl blur-3xl"></div>

              {/* Card */}
              <div className="relative bg-slate-50 dark:bg-slate-900 p-8 rounded-3xl border border-slate-200 dark:border-slate-800 shadow-xl">
                {/* Header */}
                <div className="flex justify-between items-center mb-6">
                  <div className="flex space-x-2">
                    <div className="w-3 h-3 rounded-full bg-red-400"></div>
                    <div className="w-3 h-3 rounded-full bg-yellow-400"></div>
                    <div className="w-3 h-3 rounded-full bg-green-400"></div>
                  </div>
                  <AlertTriangle className="w-5 h-5 text-yellow-600 dark:text-yellow-500" />
                </div>

                {/* Alert Items */}
                <div className="space-y-4">
                  {alerts.map((alert, index) => {
                    const Icon = XCircle
                    const colors = colorClasses[alert.color as keyof typeof colorClasses]
                    return (
                      <div
                        key={index}
                        className={`p-4 ${colors.bg} border-l-4 ${colors.border} rounded`}
                      >
                        <p className={`text-sm font-semibold ${colors.title}`}>{alert.title}</p>
                        <p className={`text-xs ${colors.message} mt-1`}>{alert.message}</p>
                      </div>
                    )
                  })}
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  )
}
