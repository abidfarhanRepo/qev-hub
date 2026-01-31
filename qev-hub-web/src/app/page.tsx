'use client'

import HeroSection from '@/components/landing/HeroSection'
import FeaturesSection from '@/components/landing/FeaturesSection'
import VehicleCarousel from '@/components/landing/VehicleCarousel'
import LandingNavbar from '@/components/landing/LandingNavbar'

export default function Home() {
  return (
    <main className="min-h-screen bg-background text-foreground selection:bg-primary selection:text-primary-foreground overflow-x-hidden">
      <div>
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
                   <a href="/privacy" className="text-gray-400 hover:text-qev-accent transition-colors">Privacy Policy</a>
                   <a href="/terms" className="text-gray-400 hover:text-qev-accent transition-colors">Terms of Service</a>
                   <a href="/marketplace/manufacturers" className="text-gray-400 hover:text-qev-accent transition-colors">Contact</a>
                </div>
            </div>
            <p className="text-sm mb-6">&copy; 2026 QEV-Hub. All rights reserved. Qatar's Premier Electric Vehicle Marketplace.</p>
            
            {/* Manufacturer Portal Link */}
            <div className="pt-6 border-t border-white/5">
              <div className="flex flex-col md:flex-row items-center justify-center gap-4">
                <span className="text-sm text-gray-400">Are you an EV manufacturer?</span>
                <div className="flex gap-3">
                  <a 
                    href="/manufacturer-login" 
                    className="px-6 py-2 text-sm font-semibold text-primary border border-primary rounded-lg hover:bg-primary hover:text-primary-foreground transition-all"
                  >
                    Manufacturer Login
                  </a>
                  <a 
                    href="/manufacturer-signup" 
                    className="px-6 py-2 text-sm font-semibold bg-primary text-primary-foreground rounded-lg hover:bg-primary/90 transition-all"
                  >
                    Join as Manufacturer
                  </a>
                </div>
              </div>
            </div>
          </div>
        </footer>
      </div>
    </main>
  )
}
