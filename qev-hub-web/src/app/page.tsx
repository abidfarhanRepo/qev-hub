'use client'

import { useState } from 'react'
import IntroAnimation from '@/components/landing/IntroAnimation'
import HeroSection from '@/components/landing/HeroSection'
import FeaturesSection from '@/components/landing/FeaturesSection'
import VehicleCarousel from '@/components/landing/VehicleCarousel'
import LandingNavbar from '@/components/landing/LandingNavbar'

export default function Home() {
  const [showIntro, setShowIntro] = useState(true)

  return (
    <main className="min-h-screen bg-background text-foreground selection:bg-primary selection:text-primary-foreground overflow-x-hidden">
      {showIntro && <IntroAnimation onComplete={() => setShowIntro(false)} />}
      
      <div className={`transition-opacity duration-1000 ${showIntro ? 'opacity-0' : 'opacity-100'}`}>
        <LandingNavbar />
        <HeroSection />
        <FeaturesSection />
        <VehicleCarousel />
        
        {/* Footer */}
        <footer className="py-12 bg-black border-t border-white/10 text-center text-gray-500 relative z-10">
          <div className="container px-4 mx-auto">
            <div className="flex flex-col md:flex-row justify-between items-center mb-8">
               <div className="text-2xl font-black tracking-widest text-white uppercase mb-4 md:mb-0">
                  QEV<span className="text-qev-accent">-HUB</span>
               </div>
               <div className="flex space-x-6">
                  <a href="#" className="text-gray-400 hover:text-qev-accent transition-colors">Privacy Policy</a>
                  <a href="#" className="text-gray-400 hover:text-qev-accent transition-colors">Terms of Service</a>
                  <a href="#" className="text-gray-400 hover:text-qev-accent transition-colors">Contact</a>
               </div>
            </div>
            <p className="text-sm">&copy; 2026 QEV-Hub. All rights reserved. Qatar's Premier Electric Vehicle Marketplace.</p>
          </div>
        </footer>
      </div>
    </main>
  )
}
