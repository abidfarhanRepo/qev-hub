'use client'

import { useState, useEffect } from 'react'
import { useAuth } from '@/contexts/AuthContext'
import { useRouter } from 'next/navigation'
import { SmartSearchBar } from '@/components/dashboard/SmartSearchBar'
import { VehicleComparisonCard } from '@/components/dashboard/VehicleComparisonCard'
import { LogisticsTimeline } from '@/components/dashboard/LogisticsTimeline'
import { SustainabilityDashboard } from '@/components/dashboard/SustainabilityDashboard'
import { SavingsCalculator } from '@/components/dashboard/SavingsCalculator'
import { CarIcon, ShoppingBag, ShipIcon, ZapIcon, User, Settings, LogOut } from '@/components/icons'
import { Button } from '@/components/ui/button'
import { Progress } from '@/components/ui/progress'

export default function DashboardPage() {
  const { user, loading, signOut } = useAuth()
  const router = useRouter()
  const [activeTab, setActiveTab] = useState<'marketplace' | 'orders' | 'sustainability' | 'admin'>('marketplace')
  const [showCalculator, setShowCalculator] = useState(false)
  const [selectedVehicle, setSelectedVehicle] = useState<any>(null)
  const [order, setOrder] = useState<any>(null)

  useEffect(() => {
    if (!loading && !user) {
      router.push('/login')
    }
  }, [user, loading, router])

  const handleLogout = async () => {
    await signOut()
  }

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-background">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary" />
      </div>
    )
  }

  if (!user) return null

  return (
    <div className="min-h-screen bg-background overflow-hidden">
      {/* Animated Background */}
      <div className="fixed inset-0 pointer-events-none">
        <div className="absolute inset-0 bg-[linear-gradient(to_right,hsl(var(--foreground)/0.02)_1px,transparent_1px),linear-gradient(to_bottom,hsl(var(--foreground)/0.02)_1px,transparent_1px)] bg-[size:3rem_3rem] opacity-50"></div>
        <div className="absolute top-0 left-1/4 w-[500px] h-[500px] bg-primary/5 blur-[150px] rounded-full animate-pulse-slow" />
        <div className="absolute bottom-0 right-1/4 w-[600px] h-[600px] bg-primary/5 blur-[150px] rounded-full animate-pulse-slow" style={{ animationDelay: '1s' }} />
      </div>

      <div className="relative z-10 flex min-h-screen">
        {/* Sidebar */}
        <aside className="w-64 bg-card/30 backdrop-blur-xl border-r border-border/50 p-6 flex flex-col">
          {/* Logo */}
          <div className="mb-8">
            <h1 className="text-2xl font-black tracking-widest text-foreground uppercase">
              QEV<span className="text-primary">-HUB</span>
            </h1>
            <p className="text-xs text-muted-foreground mt-1">Dashboard</p>
          </div>

          {/* Navigation */}
              <nav className="flex-1 space-y-2">
                <button
                  onClick={() => setActiveTab('marketplace')}
                  className={`w-full flex items-center gap-3 px-4 py-3 rounded-lg transition-all ${
                    activeTab === 'marketplace'
                      ? 'bg-primary text-primary-foreground shadow-lg shadow-primary/25'
                      : 'text-muted-foreground hover:bg-muted/50 hover:text-foreground'
                  }`}
                >
                  <CarIcon className="h-5 w-5" />
                  <span className="font-medium">Marketplace</span>
                </button>

                <button
                  onClick={() => setActiveTab('orders')}
                  className={`w-full flex items-center gap-3 px-4 py-3 rounded-lg transition-all ${
                    activeTab === 'orders'
                      ? 'bg-primary text-primary-foreground shadow-lg shadow-primary/25'
                      : 'text-muted-foreground hover:bg-muted/50 hover:text-foreground'
                  }`}
                >
                  <ShoppingBag className="h-5 w-5" />
                  <span className="font-medium">My Orders</span>
                </button>

                <button
                  onClick={() => setActiveTab('sustainability')}
                  className={`w-full flex items-center gap-3 px-4 py-3 rounded-lg transition-all ${
                    activeTab === 'sustainability'
                      ? 'bg-primary text-primary-foreground shadow-lg shadow-primary/25'
                      : 'text-muted-foreground hover:bg-muted/50 hover:text-foreground'
                  }`}
                >
                  <ZapIcon className="h-5 w-5" />
                  <span className="font-medium">Sustainability</span>
                </button>

                <button
                  onClick={() => setActiveTab('admin')}
                  className={`w-full flex items-center gap-3 px-4 py-3 rounded-lg transition-all ${
                    activeTab === 'admin'
                      ? 'bg-primary text-primary-foreground shadow-lg shadow-primary/25'
                      : 'text-muted-foreground hover:bg-muted/50 hover:text-foreground'
                  }`}
                >
                  <Settings className="h-5 w-5" />
                  <span className="font-medium">Admin Portal</span>
                </button>
              </nav>

          {/* User Profile */}
          <div className="border-t border-border/50 pt-6 mt-6">
            <div className="flex items-center gap-3 mb-4">
              <div className="w-10 h-10 rounded-full bg-primary/20 flex items-center justify-center">
                <User className="h-5 w-5 text-primary" />
              </div>
              <div className="flex-1 min-w-0">
                <p className="text-sm font-medium text-foreground truncate">{user.email}</p>
                <p className="text-xs text-muted-foreground">Premium Member</p>
              </div>
            </div>
            <div className="flex gap-2">
              <Button
                variant="outline"
                size="sm"
                className="flex-1"
                onClick={() => setShowCalculator(true)}
              >
                <ZapIcon className="h-4 w-4 mr-1" />
                Calculator
              </Button>
              <Button
                variant="ghost"
                size="sm"
                onClick={handleLogout}
              >
                <LogOut className="h-4 w-4" />
              </Button>
            </div>
          </div>
        </aside>

        {/* Main Content */}
        <main className="flex-1 p-8 overflow-y-auto">
          {activeTab === 'marketplace' && (
            <div className="space-y-6">
              {/* Smart Search Bar */}
              <SmartSearchBar
                onVehicleSelect={setSelectedVehicle}
                selectedVehicle={selectedVehicle}
              />

              {/* Vehicle Comparison Card */}
              {selectedVehicle && (
                <VehicleComparisonCard
                  vehicle={selectedVehicle}
                  onCompare={() => setShowCalculator(true)}
                />
              )}

              {/* Quick Actions */}
            <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
              <a
                href="/marketplace"
                className="glass-card tech-border p-4 hover:border-primary transition-all hover:-translate-y-1 group"
              >
                <div className="flex items-center gap-3">
                  <div className="w-10 h-10 rounded-lg bg-primary/10 group-hover:bg-primary/20 transition-colors flex items-center justify-center">
                    <CarIcon className="h-5 w-5 text-primary" />
                  </div>
                  <div>
                    <p className="text-sm font-semibold text-foreground">Marketplace</p>
                    <p className="text-xs text-muted-foreground">Browse vehicles</p>
                  </div>
                </div>
              </a>

              <a
                href="/charging"
                className="glass-card tech-border p-4 hover:border-primary transition-all hover:-translate-y-1 group"
              >
                <div className="flex items-center gap-3">
                  <div className="w-10 h-10 rounded-lg bg-primary/10 group-hover:bg-primary/20 transition-colors flex items-center justify-center">
                    <ZapIcon className="h-5 w-5 text-primary" />
                  </div>
                  <div>
                    <p className="text-sm font-semibold text-foreground">Charging</p>
                    <p className="text-xs text-muted-foreground">Find stations</p>
                  </div>
                </div>
              </a>

              <a
                href="/orders"
                className="glass-card tech-border p-4 hover:border-primary transition-all hover:-translate-y-1 group"
              >
                <div className="flex items-center gap-3">
                  <div className="w-10 h-10 rounded-lg bg-primary/10 group-hover:bg-primary/20 transition-colors flex items-center justify-center">
                    <ShipIcon className="h-5 w-5 text-primary" />
                  </div>
                  <div>
                    <p className="text-sm font-semibold text-foreground">Orders</p>
                    <p className="text-xs text-muted-foreground">Track shipments</p>
                  </div>
                </div>
              </a>

              <a
                href="/dashboard"
                className="glass-card tech-border p-4 hover:border-primary transition-all hover:-translate-y-1 group"
              >
                <div className="flex items-center gap-3">
                  <div className="w-10 h-10 rounded-lg bg-primary/10 group-hover:bg-primary/20 transition-colors flex items-center justify-center">
                    <Settings className="h-5 w-5 text-primary" />
                  </div>
                  <div>
                    <p className="text-sm font-semibold text-foreground">Settings</p>
                    <p className="text-xs text-muted-foreground">Manage account</p>
                  </div>
                </div>
              </a>
            </div>

            {/* Quick Stats */}
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
              <div className="glass-card tech-border p-6">
                <div className="flex items-center justify-between mb-4">
                  <CarIcon className="h-8 w-8 text-primary" />
                  <span className="text-xs text-muted-foreground">Available</span>
                </div>
                <p className="text-3xl font-bold text-foreground">24</p>
                <p className="text-sm text-muted-foreground mt-1">Vehicles</p>
              </div>

              <div className="glass-card tech-border p-6">
                <div className="flex items-center justify-between mb-4">
                  <ZapIcon className="h-8 w-8 text-primary" />
                  <span className="text-xs text-muted-foreground">Avg Range</span>
                </div>
                <p className="text-3xl font-bold text-foreground">485</p>
                <p className="text-sm text-muted-foreground mt-1">km</p>
              </div>

              <div className="glass-card tech-border p-6">
                <div className="flex items-center justify-between mb-4">
                  <ShipIcon className="h-8 w-8 text-primary" />
                  <span className="text-xs text-muted-foreground">Active Orders</span>
                </div>
                <p className="text-3xl font-bold text-foreground">2</p>
                <p className="text-sm text-muted-foreground mt-1">In Transit</p>
              </div>
            </div>
            </div>
          )}

          {activeTab === 'orders' && (
            <div className="space-y-6">
              <LogisticsTimeline order={order} />
            </div>
          )}

          {activeTab === 'sustainability' && (
            <SustainabilityDashboard onCalculate={() => setShowCalculator(true)} />
          )}

          {activeTab === 'admin' && (
            <div className="space-y-6">
              <Card className="glass-card tech-border">
                <CardContent className="p-8 text-center">
                  <Settings className="h-16 w-16 text-primary mx-auto mb-4" />
                  <h3 className="text-2xl font-bold text-foreground mb-2">
                    Manufacturer Admin Portal
                  </h3>
                  <p className="text-muted-foreground mb-6">
                    Manage your vehicle inventory, track analytics, and update pricing information.
                  </p>
                  <Button
                    onClick={() => router.push('/dashboard/admin')}
                    className="bg-primary text-primary-foreground"
                  >
                    Go to Admin Dashboard
                  </Button>
                </CardContent>
              </Card>
            </div>
          )}
        </main>
      </div>

      {/* Savings Calculator Modal */}
      {showCalculator && (
        <SavingsCalculator
          onClose={() => setShowCalculator(false)}
          vehicle={selectedVehicle}
        />
      )}
    </div>
  )
}
