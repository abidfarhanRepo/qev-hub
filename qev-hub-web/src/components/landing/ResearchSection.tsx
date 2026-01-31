'use client'

import { useEffect, useRef } from 'react'
import { BookOpen, Target } from 'lucide-react'

export default function ResearchSection() {
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

  const team = [
    { name: 'Mohammed Hassan', role: 'Project Lead', initials: 'MH', gradient: 'from-primary to-blue-600' },
    { name: 'Abid Farhan', role: 'System Architecture', initials: 'AF', gradient: 'from-secondary to-orange-600' },
    { name: 'Khalid Al-Haj', role: 'Market Research', initials: 'KA', gradient: 'from-purple-500 to-pink-500' },
    { name: 'Abdul Razaq', role: 'Regulations', initials: 'AR', gradient: 'from-green-500 to-teal-500' },
    { name: 'Mohammed Rehman', role: 'GCC Logistics', initials: 'MR', gradient: 'from-red-500 to-orange-500' },
  ]

  return (
    <section id="research" className="py-24 bg-background">
      <div ref={sectionRef} className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Header */}
        <div className="text-center mb-16 reveal opacity-0 translate-y-8 transition-all duration-800">
          <h2 className="text-4xl font-bold mb-4 text-foreground">
            Academic Rigor, <span className="text-primary">Strategic Vision</span>
          </h2>
          <p className="text-muted-foreground max-w-2xl mx-auto">
            Based on comprehensive literature review and stakeholder analysis conducted by our
            research team.
          </p>
        </div>

        {/* Research Cards */}
        <div className="grid md:grid-cols-2 gap-8 mb-16">
          {/* Research Foundation */}
          <div className="bg-slate-50 dark:bg-slate-900 p-8 rounded-3xl border border-slate-200 dark:border-slate-800 reveal opacity-0 translate-y-8 transition-all duration-800">
            <BookOpen className="w-10 h-10 text-primary mb-4" />
            <h3 className="text-2xl font-bold mb-4 text-foreground">
              Research Foundation
            </h3>
            <p className="text-muted-foreground mb-4">
              Our proposal addresses gaps identified in peer-reviewed literature regarding Qatar's
              EV adoption barriers, specifically the lack of digital platforms connecting consumers
              directly with manufacturers.
            </p>
            <div className="space-y-2 text-sm text-muted-foreground">
              <p>• Al-Shaiba et al. (2023) - Infrastructure gap analysis</p>
              <p>• Al-Buenain et al. (2021) - Carbon reduction potential</p>
              <p>• Khandakar et al. (2020) - Consumer barrier identification</p>
            </div>
          </div>

          {/* Qatar Vision 2030 */}
          <div className="bg-gradient-to-br from-slate-900 to-slate-950 dark:from-slate-800 dark:to-slate-900 p-8 rounded-3xl text-white border border-slate-800 dark:border-slate-700 reveal opacity-0 translate-y-8 transition-all duration-800" style={{ transitionDelay: '0.1s' }}>
            <Target className="w-10 h-10 text-primary mb-4" />
            <h3 className="text-2xl font-bold mb-4">Qatar Vision 2030</h3>
            <p className="text-slate-300 mb-6">
              Directly supporting three pillars of the National Vision through sustainable
              transportation infrastructure and economic diversification.
            </p>
            <div className="grid grid-cols-3 gap-4 text-center">
              <div>
                <div className="text-2xl font-bold text-primary">12k+</div>
                <div className="text-xs text-slate-400">gCO₂ saved per 100km</div>
              </div>
              <div>
                <div className="text-2xl font-bold text-secondary">10%</div>
                <div className="text-xs text-slate-400">Target EV adoption</div>
              </div>
              <div>
                <div className="text-2xl font-bold text-white">15k</div>
                <div className="text-xs text-slate-400">Chargers planned</div>
              </div>
            </div>
          </div>
        </div>

        {/* Team Section */}
        <div className="text-center reveal opacity-0 translate-y-8 transition-all duration-800">
          <h3 className="text-2xl font-bold mb-8 text-foreground">Research Team</h3>
          <div className="flex flex-wrap justify-center gap-8">
            {team.map((member, index) => (
              <div key={index} className="text-center">
                <div
                  className={`w-16 h-16 rounded-full bg-gradient-to-br ${member.gradient} mx-auto mb-3 flex items-center justify-center text-white font-bold text-xl`}
                >
                  {member.initials}
                </div>
                <p className="font-semibold text-foreground">{member.name}</p>
                <p className="text-sm text-muted-foreground">{member.role}</p>
              </div>
            ))}
          </div>
        </div>
      </div>
    </section>
  )
}
