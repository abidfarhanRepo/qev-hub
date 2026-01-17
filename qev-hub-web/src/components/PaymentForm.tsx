'use client'

import { useState, useEffect, useCallback } from 'react'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Badge } from '@/components/ui/badge'
import { CreditCardIcon, ShieldIcon } from '@/components/icons'
import { Progress } from '@/components/ui/progress'
import { useToast } from '@/components/ui/use-toast'

interface PaymentFormProps {
  orderId: string
  depositAmount: number
  onPaymentComplete: (paymentData: any) => void
  onCancel: () => void
}

// Luhn algorithm for card number validation
const validateCardNumber = (number: string): boolean => {
  const digits = number.replace(/\s/g, '').split('').map(Number)
  if (digits.length < 13 || digits.length > 19) return false
  let sum = 0
  let isEven = false
  for (let i = digits.length - 1; i >= 0; i--) {
    let digit = digits[i]
    if (isEven) {
      digit *= 2
      if (digit > 9) digit -= 9
    }
    sum += digit
    isEven = !isEven
  }
  return sum % 10 === 0
}

const validateExpiry = (expiry: string): boolean => {
  const match = expiry.match(/^(0[1-9]|1[0-2])\/([0-9]{2})$/)
  if (!match) return false
  const [, month, year] = match
  const expDate = new Date(2000 + parseInt(year), parseInt(month) - 1)
  return expDate > new Date()
}

export function PaymentForm({ orderId, depositAmount, onPaymentComplete, onCancel }: PaymentFormProps) {
  const { toast } = useToast()
  const [paymentMethod, setPaymentMethod] = useState<'card' | 'bank'>('card')
  const [cardNumber, setCardNumber] = useState('')
  const [cardName, setCardName] = useState('')
  const [expiryDate, setExpiryDate] = useState('')
  const [cvv, setCvv] = useState('')
  const [loading, setLoading] = useState(false)
  const [errors, setErrors] = useState<Record<string, string>>({})

  // Clear sensitive data on unmount
  useEffect(() => {
    return () => {
      setCardNumber('')
      setCardName('')
      setExpiryDate('')
      setCvv('')
    }
  }, [])

  const formatPrice = (price: number) => {
    return new Intl.NumberFormat('en-QA', {
      style: 'currency',
      currency: 'QAR'
    }).format(price)
  }

  const validateForm = useCallback((): boolean => {
    const newErrors: Record<string, string> = {}
    
    if (paymentMethod === 'card') {
      if (!cardNumber.trim()) {
        newErrors.cardNumber = 'Card number is required'
      } else if (!validateCardNumber(cardNumber)) {
        newErrors.cardNumber = 'Invalid card number'
      }
      
      if (!cardName.trim()) {
        newErrors.cardName = 'Cardholder name is required'
      } else if (cardName.trim().length < 3) {
        newErrors.cardName = 'Please enter a valid name'
      }
      
      if (!expiryDate.trim()) {
        newErrors.expiryDate = 'Expiry date is required'
      } else if (!validateExpiry(expiryDate)) {
        newErrors.expiryDate = 'Invalid or expired date (MM/YY)'
      }
      
      if (!cvv.trim()) {
        newErrors.cvv = 'CVV is required'
      } else if (!/^[0-9]{3,4}$/.test(cvv)) {
        newErrors.cvv = 'Invalid CVV'
      }
    }
    
    setErrors(newErrors)
    return Object.keys(newErrors).length === 0
  }, [paymentMethod, cardNumber, cardName, expiryDate, cvv])

  const handlePayment = async () => {
    if (!validateForm()) {
      toast({
        title: 'Validation Error',
        description: 'Please correct the errors in the form',
        variant: 'destructive'
      })
      return
    }
    
    setLoading(true)
    try {
      const response = await fetch('/api/payments', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          order_id: orderId,
          amount: depositAmount,
          payment_method: paymentMethod,
          transaction_id: `txn_${Date.now()}`,
        }),
      })

      const data = await response.json()

      if (data.success) {
        // Clear sensitive data immediately after successful payment
        setCardNumber('')
        setCardName('')
        setExpiryDate('')
        setCvv('')
        onPaymentComplete(data)
      } else {
        toast({
          title: 'Payment Failed',
          description: data.message || 'Please try again or contact support.',
          variant: 'destructive'
        })
      }
    } catch (error) {
      console.error('Payment error:', error)
      toast({
        title: 'Payment Error',
        description: 'An unexpected error occurred. Please try again.',
        variant: 'destructive'
      })
    } finally {
      setLoading(false)
    }
  }

  return (
    <Card className="w-full">
      <CardHeader>
        <CardTitle>Complete Your Purchase</CardTitle>
      </CardHeader>
      <CardContent className="space-y-6">
        {/* Order Summary */}
        <div className="bg-muted p-4 rounded-lg">
          <div className="flex justify-between items-center">
            <span className="text-muted-foreground">Deposit Amount</span>
            <span className="text-xl font-bold">{formatPrice(depositAmount)}</span>
          </div>
        </div>

        {/* Payment Methods */}
        <div>
          <h3 className="font-semibold mb-3">Select Payment Method</h3>
          <div className="grid grid-cols-2 gap-3">
            <button
              onClick={() => setPaymentMethod('card')}
              className={`p-4 border rounded-lg flex flex-col items-center gap-2 transition ${
                paymentMethod === 'card'
                  ? 'border-primary bg-primary/5'
                  : 'border-border hover:border-primary/50'
              }`}
            >
              <CreditCardIcon className="h-6 w-6" />
              <span className="text-sm font-medium">Credit Card</span>
            </button>
            <button
              onClick={() => setPaymentMethod('bank')}
              className={`p-4 border rounded-lg flex flex-col items-center gap-2 transition ${
                paymentMethod === 'bank'
                  ? 'border-primary bg-primary/5'
                  : 'border-border hover:border-primary/50'
              }`}
            >
              <ShieldIcon className="h-6 w-6" />
              <span className="text-sm font-medium">Bank Transfer</span>
            </button>
          </div>
        </div>

        {/* Card Details Form */}
        {paymentMethod === 'card' && (
          <div className="space-y-4">
            <div>
              <label htmlFor="cardNumber" className="text-sm font-medium mb-1 block">Card Number</label>
              <input
                id="cardNumber"
                type="text"
                inputMode="numeric"
                autoComplete="cc-number"
                aria-label="Card number"
                aria-invalid={!!errors.cardNumber}
                value={cardNumber}
                onChange={(e) => setCardNumber(e.target.value.replace(/[^0-9\s]/g, '').slice(0, 19))}
                placeholder="1234 5678 9012 3456"
                className={`w-full px-3 py-2 border rounded-md ${errors.cardNumber ? 'border-red-500' : ''}`}
              />
              {errors.cardNumber && <p className="text-red-500 text-xs mt-1">{errors.cardNumber}</p>}
            </div>
            <div>
              <label htmlFor="cardName" className="text-sm font-medium mb-1 block">Cardholder Name</label>
              <input
                id="cardName"
                type="text"
                autoComplete="cc-name"
                aria-label="Cardholder name"
                aria-invalid={!!errors.cardName}
                value={cardName}
                onChange={(e) => setCardName(e.target.value)}
                placeholder="John Doe"
                className={`w-full px-3 py-2 border rounded-md ${errors.cardName ? 'border-red-500' : ''}`}
              />
              {errors.cardName && <p className="text-red-500 text-xs mt-1">{errors.cardName}</p>}
            </div>
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label htmlFor="expiryDate" className="text-sm font-medium mb-1 block">Expiry Date</label>
                <input
                  id="expiryDate"
                  type="text"
                  inputMode="numeric"
                  autoComplete="cc-exp"
                  aria-label="Card expiry date"
                  aria-invalid={!!errors.expiryDate}
                  value={expiryDate}
                  onChange={(e) => setExpiryDate(e.target.value.replace(/[^0-9/]/g, '').slice(0, 5))}
                  placeholder="MM/YY"
                  className={`w-full px-3 py-2 border rounded-md ${errors.expiryDate ? 'border-red-500' : ''}`}
                />
                {errors.expiryDate && <p className="text-red-500 text-xs mt-1">{errors.expiryDate}</p>}
              </div>
              <div>
                <label htmlFor="cvv" className="text-sm font-medium mb-1 block">CVV</label>
                <input
                  id="cvv"
                  type="password"
                  inputMode="numeric"
                  autoComplete="cc-csc"
                  aria-label="Card security code"
                  aria-invalid={!!errors.cvv}
                  value={cvv}
                  onChange={(e) => setCvv(e.target.value.replace(/[^0-9]/g, '').slice(0, 4))}
                  placeholder="123"
                  className={`w-full px-3 py-2 border rounded-md ${errors.cvv ? 'border-red-500' : ''}`}
                />
                {errors.cvv && <p className="text-red-500 text-xs mt-1">{errors.cvv}</p>}
              </div>
            </div>
          </div>
        )}

        {/* Bank Transfer Instructions */}
        {paymentMethod === 'bank' && (
          <div className="bg-muted p-4 rounded-lg space-y-2">
            <p className="text-sm"><strong>Bank Name:</strong> Qatar National Bank</p>
            <p className="text-sm"><strong>Account Number:</strong> QNB-001234567890</p>
            <p className="text-sm"><strong>IBAN:</strong> QA12 QNBI 0000 0123 4567 8901 2345 6</p>
            <p className="text-sm"><strong>Reference:</strong> {orderId}</p>
          </div>
        )}

        {/* Security Notice */}
        <div className="flex items-center gap-2 text-xs text-muted-foreground">
          <ShieldIcon className="h-4 w-4" />
          <span>Your payment is secured with 256-bit SSL encryption</span>
        </div>

        {/* Actions */}
        <div className="flex gap-3">
          <Button variant="outline" onClick={onCancel} className="flex-1">
            Cancel
          </Button>
          <Button
            onClick={handlePayment}
            disabled={loading}
            className="flex-1"
          >
            {loading ? 'Processing...' : 'Pay Now'}
          </Button>
        </div>
      </CardContent>
    </Card>
  )
}
