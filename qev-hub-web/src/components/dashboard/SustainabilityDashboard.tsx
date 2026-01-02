'use client'

import { useState, useEffect } from 'react'
import { motion } from 'framer-motion'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import { Progress } from '@/components/ui/progress'
import { ZapIcon, Leaf, Globe, Award, Target, TrendingUp, AlertCircle } from '@/components/icons'

interface SustainabilityDashboardProps {
  onCalculate: () => void
}

export function SustainabilityDashboard({ onCalculate }: SustainabilityDashboardProps) {
  const [co2Saved, setCo2Saved] = useState(12450)
  const [treesEquivalent, setTreesEquivalent] = useState(565)
  const [qatarVisionProgress, setQatarVisionProgress] = useState(68)

  useEffect(() => {
    const interval = setInterval(() => {
      setCo2Saved((prev) => prev + Math.random() * 5)
      setTreesEquivalent((prev) => prev + Math.random() * 0.2)
    }, 5000)

    return () => clearInterval(interval)
  }, [])

  const calculateImpact = () => {
    const kmDriven = 15000
    const evCo2PerKm = 0.05
    const iceCo2PerKm = 0.21
    const annualSavings = (iceCo2PerKm - evCo2PerKm) * kmDriven

    return {
      annualSavings,
      fiveYearSavings: annualSavings * 5,
      treesEquivalent: annualSavings / 22,
      petrolSaved: kmDriven * 8 / 100,
    }
  }

  const impact = calculateImpact()

  const formatNumber = (num: number) => {
    return new Intl.NumberFormat('en-QA').format(Math.round(num))
  }

  const QATAR_VISION_2030_GOALS = [
    {
      goal: 'Carbon Neutrality',
      progress: 68,
      icon: Leaf,
      color: 'text-green-600',
      bgColor: 'bg-green-500/10',
    },
    {
      goal: 'Renewable Energy',
      progress: 72,
      icon: ZapIcon,
      color: 'text-yellow-600',
      bgColor: 'bg-yellow-500/10',
    },
    {
      goal: 'Electric Vehicles',
      progress: 55,
      icon: Globe,
      color: 'text-blue-600',
      bgColor: 'bg-blue-500/10',
    },
  ]

  return (
    <div className="space-y-6">
      {/* Hero Section */}
      <Card className="glass-card tech-border border-primary/30 overflow-hidden">
        <div className="bg-gradient-to-r from-primary/20 via-primary/10 to-transparent p-6">
          <div className="flex items-center justify-between">
            <div>
              <CardTitle className="text-3xl mb-2">Sustainability Dashboard</CardTitle>
              <p className="text-sm text-muted-foreground">
                Track your environmental impact and contribution to Qatar Vision 2030
              </p>
            </div>
            <div className="w-16 h-16 rounded-full bg-primary/20 flex items-center justify-center">
              <Leaf className="h-8 w-8 text-primary" />
            </div>
          </div>
        </div>
      </Card>

      {/* Impact Stats */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.1 }}
        >
          <Card className="glass-card border-green-500/30 h-full">
            <CardContent className="p-6">
              <div className="flex items-center justify-between mb-4">
                <div className="w-12 h-12 rounded-lg bg-green-500/20 flex items-center justify-center">
                  <Leaf className="h-6 w-6 text-green-600" />
                </div>
                <Badge className="bg-green-500 text-white">Live</Badge>
              </div>
              <p className="text-sm text-muted-foreground mb-1">CO2 Saved</p>
              <p className="text-4xl font-black text-foreground">
                {formatNumber(co2Saved)} kg
              </p>
              <p className="text-xs text-green-600 dark:text-green-400 mt-2 flex items-center gap-1">
                <TrendingUp className="h-3 w-3" />
                +{formatNumber(co2Saved * 0.15)} kg this month
              </p>
            </CardContent>
          </Card>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.2 }}
        >
          <Card className="glass-card border-blue-500/30 h-full">
            <CardContent className="p-6">
              <div className="flex items-center justify-between mb-4">
                <div className="w-12 h-12 rounded-lg bg-blue-500/20 flex items-center justify-center">
                  <Leaf className="h-6 w-6 text-blue-600" />
                </div>
                <Badge className="bg-blue-500 text-white">Equivalent</Badge>
              </div>
              <p className="text-sm text-muted-foreground mb-1">Trees Planted</p>
              <p className="text-4xl font-black text-foreground">
                {formatNumber(treesEquivalent)}
              </p>
              <p className="text-xs text-muted-foreground mt-2">
                {formatNumber(treesEquivalent / 22)} years of carbon offset
              </p>
            </CardContent>
          </Card>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.3 }}
        >
          <Card className="glass-card border-yellow-500/30 h-full">
            <CardContent className="p-6">
              <div className="flex items-center justify-between mb-4">
                <div className="w-12 h-12 rounded-lg bg-yellow-500/20 flex items-center justify-center">
                  <ZapIcon className="h-6 w-6 text-yellow-600" />
                </div>
                <Badge className="bg-yellow-500 text-white">Fuel Saved</Badge>
              </div>
              <p className="text-sm text-muted-foreground mb-1">Petrol Avoided</p>
              <p className="text-4xl font-black text-foreground">
                {formatNumber(impact.petrolSaved)} L
              </p>
              <p className="text-xs text-muted-foreground mt-2">
                This year alone
              </p>
            </CardContent>
          </Card>
        </motion.div>
      </div>

      {/* Personal Impact Calculator */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.4 }}
      >
        <Card className="glass-card border-primary/30">
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <ZapIcon className="h-5 w-5 text-primary" />
              Your Impact Calculator
            </CardTitle>
          </CardHeader>
          <CardContent className="space-y-6">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              {/* EV Impact */}
              <div className="p-6 bg-green-500/5 rounded-xl border-2 border-green-500/30">
                <div className="flex items-center gap-3 mb-4">
                  <div className="w-10 h-10 rounded-full bg-green-500 flex items-center justify-center">
                    <ZapIcon className="h-5 w-5 text-white" />
                  </div>
                  <div>
                    <p className="font-semibold text-foreground">Your EV Impact</p>
                    <p className="text-xs text-muted-foreground">Based on annual driving</p>
                  </div>
                </div>

                <div className="space-y-4">
                  <div>
                    <div className="flex justify-between text-sm mb-2">
                      <span className="text-muted-foreground">Annual CO2 Saved</span>
                      <span className="font-semibold text-green-600">
                        {formatNumber(impact.annualSavings)} kg
                      </span>
                    </div>
                    <Progress value={75} className="h-2" />
                  </div>

                  <div>
                    <div className="flex justify-between text-sm mb-2">
                      <span className="text-muted-foreground">5-Year CO2 Saved</span>
                      <span className="font-semibold text-green-600">
                        {formatNumber(impact.fiveYearSavings)} kg
                      </span>
                    </div>
                    <Progress value={85} className="h-2" />
                  </div>

                  <div>
                    <div className="flex justify-between text-sm mb-2">
                      <span className="text-muted-foreground">Trees Equivalent</span>
                      <span className="font-semibold text-green-600">
                        {formatNumber(impact.treesEquivalent)} trees
                      </span>
                    </div>
                    <Progress value={90} className="h-2" />
                  </div>
                </div>
              </div>

              {/* Comparison */}
              <div className="space-y-4">
                <h4 className="font-semibold text-foreground flex items-center gap-2">
                  <TrendingUp className="h-5 w-5 text-primary" />
                  EV vs Petrol Comparison
                </h4>

                <div className="space-y-3">
                  <div className="p-4 bg-muted/30 rounded-lg border border-border/50">
                    <div className="flex justify-between items-center mb-2">
                      <span className="text-sm text-muted-foreground">Annual CO2 (EV)</span>
                      <span className="font-semibold text-green-600">
                        {formatNumber(750)} kg
                      </span>
                    </div>
                    <div className="flex justify-between items-center mb-2">
                      <span className="text-sm text-muted-foreground">Annual CO2 (Petrol)</span>
                      <span className="font-semibold text-red-600">
                        {formatNumber(3150)} kg
                      </span>
                    </div>
                    <div className="pt-2 border-t border-border/50">
                      <span className="text-sm font-semibold text-green-600">
                        You save {formatNumber(impact.annualSavings)} kg/year
                      </span>
                    </div>
                  </div>

                  <div className="p-4 bg-primary/5 rounded-lg border-2 border-primary/30">
                    <div className="flex items-center gap-3">
                      <Award className="h-8 w-8 text-primary" />
                      <div>
                        <p className="text-sm font-medium text-foreground">
                          By choosing EV, you've contributed to:
                        </p>
                        <p className="text-xs text-muted-foreground mt-1">
                          • Cleaner air for Qatar
                          <br />
                          • Reduced dependency on fossil fuels
                          <br />• Qatar Vision 2030 sustainability goals
                        </p>
                      </div>
                    </div>
                  </div>
                </div>

                <Button onClick={onCalculate} className="w-full">
                  Calculate Detailed Savings
                </Button>
              </div>
            </div>
          </CardContent>
        </Card>
      </motion.div>

      {/* Qatar Vision 2030 Integration */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.5 }}
      >
        <Card className="glass-card tech-border border-primary/30">
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Target className="h-5 w-5 text-primary" />
              Qatar Vision 2030 Contribution
            </CardTitle>
            <p className="text-sm text-muted-foreground">
              Your EV purchase supports Qatar's national sustainability goals
            </p>
          </CardHeader>
          <CardContent className="space-y-6">
            {/* Vision Banner */}
            <div className="p-6 bg-gradient-to-r from-primary/10 to-primary/5 rounded-xl border-2 border-primary/30">
              <div className="flex items-center gap-4">
                <div className="w-16 h-16 rounded-full bg-primary/20 flex items-center justify-center flex-shrink-0">
                  <Target className="h-8 w-8 text-primary" />
                </div>
                <div>
                  <h3 className="text-xl font-bold text-foreground mb-1">
                    Qatar Vision 2030
                  </h3>
                  <p className="text-sm text-muted-foreground">
                    Balancing economic growth with environmental sustainability and
                    reducing carbon emissions by 25%
                  </p>
                </div>
              </div>
            </div>

            {/* Goals Progress */}
            <div className="space-y-4">
              <h4 className="font-semibold text-foreground">National Goals</h4>
              {QATAR_VISION_2030_GOALS.map((goal, index) => (
                <div key={index} className="space-y-2">
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-3">
                      <div
                        className={`w-8 h-8 rounded-lg ${goal.bgColor} flex items-center justify-center`}
                      >
                        <goal.icon className={`h-4 w-4 ${goal.color}`} />
                      </div>
                      <span className="font-medium text-foreground">
                        {goal.goal}
                      </span>
                    </div>
                    <Badge
                      variant={goal.progress >= 70 ? 'default' : 'secondary'}
                      className={
                        goal.progress >= 70
                          ? 'bg-green-500 text-white'
                          : 'bg-primary/10 text-primary'
                      }
                    >
                      {goal.progress}%
                    </Badge>
                  </div>
                  <Progress value={goal.progress} className="h-2" />
                  <p className="text-xs text-muted-foreground pl-11">
                    Your contribution: {formatNumber(co2Saved * (goal.progress / 100))}{' '}
                    kg CO2 saved
                  </p>
                </div>
              ))}
            </div>

            {/* Impact Badge */}
            <div className="p-6 bg-gradient-to-r from-green-500/10 to-emerald-500/10 rounded-xl border-2 border-green-500/30">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-4">
                  <div className="w-14 h-14 rounded-full bg-green-500 flex items-center justify-center">
                    <Award className="h-7 w-7 text-white" />
                  </div>
                  <div>
                    <p className="text-sm text-green-700 dark:text-green-300 font-medium">
                      Sustainability Champion
                    </p>
                    <p className="text-xs text-muted-foreground">
                      You're in the top 15% of eco-conscious drivers in Qatar
                    </p>
                  </div>
                </div>
                <div className="text-right">
                  <p className="text-3xl font-black text-green-600 dark:text-green-400">
                    {formatNumber(co2Saved * 0.01)}
                  </p>
                  <p className="text-xs text-muted-foreground">
                    Vision points earned
                  </p>
                </div>
              </div>
            </div>

            {/* Call to Action */}
            <div className="p-4 bg-muted/30 rounded-lg border border-border/50">
              <div className="flex items-start gap-3">
                <AlertCircle className="h-5 w-5 text-primary mt-0.5 flex-shrink-0" />
                <div>
                  <p className="text-sm font-medium text-foreground mb-1">
                    Want to learn more?
                  </p>
                  <p className="text-xs text-muted-foreground">
                    Learn how Qatar is transitioning to sustainable transportation and
                    how your EV purchase contributes to a greener future.
                  </p>
                </div>
              </div>
            </div>
          </CardContent>
        </Card>
      </motion.div>
    </div>
  )
}
