'use client'

import { useEffect, useRef } from 'react'
import { Globe, ShieldCheck, Ship, Check } from 'lucide-react'

export default function SolutionSection() {
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

  const modules = [
    {
      icon: Globe,
      title: 'Direct Marketplace',
      description:
        'Verified portal connecting Qatari buyers directly with international EV manufacturers. Eliminate broker markups on premium Chinese brands like NIO, XPeng, and Zeekr.',
      features: ['Real-time inventory & pricing', 'Secure payment gateway', 'Shipping & tracking integration'],
      color: 'primary',
      gradient: 'from-primary/20',
      borderHover: 'hover:border-primary/50',
      shadow: 'shadow-primary/10',
      iconBg: 'bg-primary/10',
      iconColor: 'text-primary',
    },
    {
      icon: ShieldCheck,
      title: 'Compliance Engine',
      description:
        'Automated FAHES inspection scheduling, customs documentation generation, and regulatory compliance for seamless import processing.',
      features: ['FAHES pre-clearance', 'Automated customs docs', 'Warranty validation'],
      color: 'secondary',
      gradient: 'from-secondary/20',
      borderHover: 'hover:border-secondary/50',
      shadow: 'shadow-secondary/10',
      iconBg: 'bg-secondary/20',
      iconColor: 'text-secondary-foreground',
    },
    {
      icon: Ship,
      title: 'GCC Export Hub',
      description:
        'Transform Qatar into a regional distribution center with streamlined re-export capabilities to UAE, Saudi Arabia, Kuwait, Bahrain, and Oman.',
      features: ['Multi-country customs docs', 'Hamad Port integration', 'Regional logistics network'],
      color: 'accent',
      gradient: 'from-accent/20',
      borderHover: 'hover:border-accent/50',
      shadow: 'shadow-accent/10',
      iconBg: 'bg-accent/20',
      iconColor: 'text-accent-foreground',
    },
  ]

  return (
    <section id="solution" className="py-24 bg-slate-50 dark:bg-slate-950 relative">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Header */}
        <div className="text-center max-w-3xl mx-auto mb-16 reveal opacity-0 translate-y-8 transition-all duration-800">
          <h2 className="text-4xl md:text-5xl font-bold mb-6 text-foreground">
            The QEV-Hub <span className="text-primary">Ecosystem</span>
          </h2>
          <p className="text-lg text-muted-foreground">
            Three integrated modules designed to transform Qatar into the GCC's central hub for
            electric and hybrid vehicles.
          </p>
        </div>

        {/* Module Cards */}
        <div className="grid md:grid-cols-3 gap-8">
          {modules.map((module, index) => {
            const Icon = module.icon
            return (
              <div
                key={index}
                className={`group relative reveal opacity-0 translate-y-8 transition-all duration-800`}
                style={{ transitionDelay: `${(index + 1) * 0.1}s` }}
              >
                {/* Hover Glow Effect */}
                <div
                  className={`absolute inset-0 bg-gradient-to-br ${module.gradient} to-transparent rounded-3xl blur-xl opacity-0 group-hover:opacity-100 transition-opacity duration-500`}
                ></div>

                {/* Card */}
                <div
                  className={`relative h-full bg-white dark:bg-slate-900 p-8 rounded-3xl border border-slate-200 dark:border-slate-800 ${module.borderHover} transition-all duration-300 hover:shadow-xl hover:${module.shadow} transform hover:-translate-y-2`}
                >
                  {/* Icon */}
                  <div
                    className={`w-14 h-14 ${module.iconBg} rounded-2xl flex items-center justify-center mb-6 group-hover:scale-110 transition-transform`}
                  >
                    <Icon className={`w-7 h-7 ${module.iconColor}`} />
                  </div>

                  {/* Title */}
                  <h3 className="text-2xl font-bold mb-4 text-foreground">
                    {module.title}
                  </h3>

                  {/* Description */}
                  <p className="text-muted-foreground mb-6 leading-relaxed">
                    {module.description}
                  </p>

                  {/* Features List */}
                  <ul className="space-y-2 text-sm text-muted-foreground">
                    {module.features.map((feature, idx) => (
                      <li key={idx} className="flex items-center space-x-2">
                        <Check className={`w-4 h-4 ${module.iconColor}`} />
                        <span>{feature}</span>
                      </li>
                    ))}
                  </ul>
                </div>
              </div>
            )
          })}
        </div>
      </div>
    </section>
  )
}
