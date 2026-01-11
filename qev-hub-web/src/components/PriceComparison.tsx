'use client'

import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Separator } from '@/components/ui/separator'
import { ShieldIcon, TrendingUp, AlertCircle, CheckIcon } from '@/components/icons'

interface PriceComparisonProps {
  manufacturerDirectPrice: number
  greyMarketPrice: number
  currency?: string
  showDetails?: boolean
}

export function PriceComparison({
  manufacturerDirectPrice,
  greyMarketPrice,
  currency = 'QAR',
  showDetails = true
}: PriceComparisonProps) {
  const savings = greyMarketPrice - manufacturerDirectPrice
  const savingsPercentage = ((savings / greyMarketPrice) * 100).toFixed(1)
  const isGoodSavings = parseFloat(savingsPercentage) >= 20

  const formatPrice = (price: number) => {
    return new Intl.NumberFormat('en-QA', {
      style: 'currency',
      currency: currency,
      maximumFractionDigits: 0
    }).format(price)
  }

  return (
    <Card className="border-primary/30 overflow-hidden">
      <CardHeader className="bg-gradient-to-r from-primary/10 to-primary/5 pb-4">
        <div className="flex items-center justify-between">
          <CardTitle className="flex items-center gap-2">
            <ShieldIcon className="h-5 w-5 text-primary" />
            Price Comparison
          </CardTitle>
          {isGoodSavings && (
            <Badge className="bg-green-600 hover:bg-green-700">
              {savingsPercentage}% Savings
            </Badge>
          )}
        </div>
      </CardHeader>

      <CardContent className="pt-6 space-y-6">
        {showDetails && (
          <div className="space-y-4">
            <div className="flex items-center justify-between p-4 bg-muted/30 rounded-lg border border-border/50">
              <div className="flex items-center gap-3">
                <div className="h-10 w-10 rounded-full bg-green-100 flex items-center justify-center">
                  <CheckIcon className="h-5 w-5 text-green-600" />
                </div>
                <div>
                  <p className="font-medium text-foreground">Factory Direct Price</p>
                  <p className="text-xs text-muted-foreground">From verified manufacturer</p>
                </div>
              </div>
              <p className="text-2xl font-bold text-green-600">
                {formatPrice(manufacturerDirectPrice)}
              </p>
            </div>

            <div className="flex items-center justify-between p-4 bg-muted/30 rounded-lg border border-border/50">
              <div className="flex items-center gap-3">
                <div className="h-10 w-10 rounded-full bg-orange-100 flex items-center justify-center">
                  <AlertCircle className="h-5 w-5 text-orange-600" />
                </div>
                <div>
                  <p className="font-medium text-foreground">Local Grey Market Price</p>
                  <p className="text-xs text-muted-foreground">Average Qatar market price</p>
                </div>
              </div>
              <div className="text-right">
                <p className="text-2xl font-bold text-muted-foreground line-through">
                  {formatPrice(greyMarketPrice)}
                </p>
              </div>
            </div>

            <Separator />

            <div className="p-6 bg-gradient-to-r from-green-50 to-emerald-50 dark:from-green-950/30 dark:to-emerald-950/30 rounded-xl border-2 border-green-500/30">
              <div className="flex items-center justify-between mb-3">
                <div className="flex items-center gap-3">
                  <div className="h-12 w-12 rounded-full bg-green-600 flex items-center justify-center">
                    <TrendingUp className="h-6 w-6 text-white" />
                  </div>
                  <div>
                    <p className="text-sm text-green-700 dark:text-green-300 font-medium">
                      Total Savings
                    </p>
                    <p className="text-xs text-muted-foreground">
                      When you buy factory direct
                    </p>
                  </div>
                </div>
                <div className="text-right">
                  <p className="text-3xl font-black text-green-600 dark:text-green-400">
                    {formatPrice(savings)}
                  </p>
                  <Badge className="bg-green-600 text-white mt-1">
                    {savingsPercentage}% OFF
                  </Badge>
                </div>
              </div>

              <div className="mt-4 pt-4 border-t border-green-500/20">
                <div className="flex items-start gap-2">
                  <ShieldIcon className="h-4 w-4 text-green-600 mt-0.5 flex-shrink-0" />
                  <div className="space-y-1 text-sm text-muted-foreground">
                    <p>• No broker fees or middlemen markups</p>
                    <p>• Factory warranty included</p>
                    <p>• Direct from verified manufacturer</p>
                    <p>• Customs clearance handled by QEV Hub</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        )}

        <div className="flex items-start gap-2 p-3 bg-primary/5 rounded-lg border border-primary/20">
          <AlertCircle className="h-4 w-4 text-primary mt-0.5 flex-shrink-0" />
          <p className="text-xs text-muted-foreground">
            Grey market prices are collected from multiple sources in Qatar and may vary. 
            Your actual savings depend on current market conditions. Prices updated weekly.
          </p>
        </div>
      </CardContent>
    </Card>
  )
}
