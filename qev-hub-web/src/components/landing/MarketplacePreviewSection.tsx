'use client'

import { useEffect, useRef, useState } from 'react'
import { ArrowRight, Car, Zap, Cpu, Info } from 'lucide-react'
import Link from 'next/link'

export default function MarketplacePreviewSection() {
  const sectionRef = useRef<HTMLDivElement>(null)
  const [selectedBrand, setSelectedBrand] = useState('All')

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

  const brands = ['All Brands', 'BYD (Official)', 'NIO', 'XPeng', 'Zeekr']

  const vehicles = [
    {
      name: 'BYD',
      models: 'Seal & Atto 3',
      description: 'Official Mannai distributor with full Qatar warranty and service network.',
      price: 'QAR 53,000',
      extra: '6-8yr Warranty',
      badge: 'OFFICIAL',
      badgeColor: 'green',
      gradient: 'from-slate-100 to-slate-200 dark:from-slate-800 dark:to-slate-700',
      icon: Car,
      textColor: 'text-slate-900 dark:text-slate-100',
    },
    {
      name: 'NIO',
      models: 'ET5 & ES8',
      description: 'Battery swap technology. No local service centers. Premium positioning.',
      price: 'QAR 180,000',
      extra: '650hp+',
      badge: 'GREY IMPORT',
      badgeColor: 'yellow',
      gradient: 'from-blue-100 to-blue-200 dark:from-blue-900/40 dark:to-blue-800/30',
      icon: Zap,
      textColor: 'text-blue-900 dark:text-blue-100',
    },
    {
      name: 'XPeng',
      models: 'G6 & G9',
      description: '800V architecture, XNGP autonomous driving. 480kW fast charging capable.',
      price: 'QAR 165,000',
      extra: '755km Range',
      badge: 'GREY IMPORT',
      badgeColor: 'yellow',
      gradient: 'from-purple-100 to-purple-200 dark:from-purple-900/40 dark:to-purple-800/30',
      icon: Cpu,
      textColor: 'text-purple-900 dark:text-purple-100',
    },
  ]

  const badgeColors = {
    green: 'bg-green-500/20 text-green-700 dark:text-green-400 border-green-500/50',
    yellow: 'bg-yellow-500/20 text-yellow-700 dark:text-yellow-400 border-yellow-500/50',
  }

  return (
    <section id="marketplace" className="py-24 bg-background">
      <div ref={sectionRef} className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Header */}
        <div className="flex flex-col md:flex-row justify-between items-end mb-12 reveal opacity-0 translate-y-8 transition-all duration-800">
          <div>
            <h2 className="text-4xl font-bold mb-4 text-foreground">
              Available <span className="text-primary">Inventory</span>
            </h2>
            <p className="text-muted-foreground max-w-2xl">
              Comprehensive database of 38 premium EV models across 58 configurations, from
              official distributors and verified grey-market specialists.
            </p>
          </div>
          <Link
            href="/marketplace"
            className="mt-4 md:mt-0 text-primary font-semibold flex items-center space-x-2 hover:space-x-3 transition-all"
          >
            <span>View Full Catalog</span>
            <ArrowRight className="w-5 h-5" />
          </Link>
        </div>

        {/* Brand Tabs */}
        <div className="flex space-x-4 mb-8 overflow-x-auto pb-2 reveal opacity-0 translate-y-8 transition-all duration-800">
          {brands.map((brand) => (
            <button
              key={brand}
              onClick={() => setSelectedBrand(brand)}
              className={`px-6 py-2 rounded-full whitespace-nowrap transition-colors ${
                selectedBrand === brand
                  ? 'bg-primary text-primary-foreground font-semibold'
                  : 'bg-slate-100 dark:bg-slate-800 text-muted-foreground hover:bg-slate-200 dark:hover:bg-slate-700'
              }`}
            >
              {brand}
            </button>
          ))}
        </div>

        {/* Vehicle Cards */}
        <div className="grid md:grid-cols-3 gap-6">
          {vehicles.map((vehicle, index) => {
            const Icon = vehicle.icon
            return (
              <div
                key={index}
                className={`group relative bg-slate-50 dark:bg-slate-900 rounded-3xl overflow-hidden border border-slate-200 dark:border-slate-800 reveal opacity-0 translate-y-8 transition-all duration-800`}
                style={{ transitionDelay: `${index * 0.1}s` }}
              >
                {/* Badge */}
                <div className="absolute top-4 right-4 z-10">
                  <span
                    className={`px-3 py-1 text-xs font-bold rounded-full border ${badgeColors[vehicle.badgeColor as keyof typeof badgeColors]}`}
                  >
                    {vehicle.badge}
                  </span>
                </div>

                {/* Image Area */}
                <div
                  className={`h-48 bg-gradient-to-br ${vehicle.gradient} relative overflow-hidden`}
                >
                  <div className="absolute inset-0 flex items-center justify-center">
                    <Icon className={`w-24 h-24 opacity-20 ${vehicle.textColor}`} />
                  </div>
                  <div className="absolute bottom-4 left-4">
                    <span className={`text-2xl font-bold ${vehicle.textColor}`}>{vehicle.name}</span>
                  </div>
                </div>

                {/* Content */}
                <div className="p-6">
                  <h3 className="text-xl font-bold mb-2 text-foreground">
                    {vehicle.models}
                  </h3>
                  <p className="text-sm text-muted-foreground mb-4">
                    {vehicle.description}
                  </p>
                  <div className="flex justify-between items-center text-sm">
                    <span className="text-primary font-semibold">From {vehicle.price}</span>
                    <span className="text-muted-foreground">{vehicle.extra}</span>
                  </div>
                </div>
              </div>
            )
          })}
        </div>

        {/* Research Note */}
        <div className="mt-8 p-4 bg-blue-50 dark:bg-blue-950/30 border border-blue-200 dark:border-blue-900 rounded-2xl flex items-start space-x-3 reveal opacity-0 translate-y-8 transition-all duration-800">
          <Info className="w-5 h-5 text-blue-600 dark:text-blue-400 flex-shrink-0 mt-0.5" />
          <p className="text-sm text-blue-900 dark:text-blue-200">
            <strong>Research Note:</strong> As of 2025, only BYD has official distributor presence
            in Qatar (Mannai). NIO, XPeng, and Zeekr are available via grey market import only, with
            limited warranty support. Official GCC launches expected 2026-2027.{' '}
            <a href="#research" className="underline hover:text-primary">
              View full research
            </a>
            .
          </p>
        </div>
      </div>
    </section>
  )
}
