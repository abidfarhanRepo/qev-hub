'use client'

import { Badge } from '@/components/ui/badge'
import { TrendingUp } from '@/components/icons'

interface SavingsBadgeProps {
  manufacturerPrice: number
  greyMarketPrice: number
  size?: 'sm' | 'md' | 'lg'
}

export function SavingsBadge({
  manufacturerPrice,
  greyMarketPrice,
  size = 'md'
}: SavingsBadgeProps) {
  const savings = greyMarketPrice - manufacturerPrice
  const savingsPercentage = ((savings / greyMarketPrice) * 100).toFixed(0)

  const formatPrice = (price: number) => {
    return new Intl.NumberFormat('en-QA', {
      style: 'currency',
      currency: 'QAR',
      maximumFractionDigits: 0,
      notation: 'compact'
    }).format(price)
  }

  const sizeClasses = {
    sm: 'px-2 py-1 text-xs',
    md: 'px-3 py-1.5 text-sm',
    lg: 'px-4 py-2 text-base'
  }

  return (
    <Badge
      className={`${sizeClasses[size]} bg-gradient-to-r from-green-500 to-emerald-600 hover:from-green-600 hover:to-emerald-700 text-white font-semibold border-0 shadow-lg`}
    >
      <TrendingUp className={`h-3 w-3 ${size === 'lg' ? 'h-4 w-4' : ''} mr-1`} />
      Save {savingsPercentage}% ({formatPrice(savings)})
    </Badge>
  )
}
