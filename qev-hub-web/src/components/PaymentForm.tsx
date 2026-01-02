'use client'

import { useState } from 'react'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Badge } from '@/components/ui/badge'
import { CreditCardIcon, ShieldIcon } from '@/components/icons'
import { Progress } from '@/components/ui/progress'

interface PaymentFormProps {
  orderId: string
  depositAmount: number
  onPaymentComplete: (paymentData: any) => void
  onCancel: () => void
}

export function PaymentForm({ orderId, depositAmount, onPaymentComplete, onCancel }: PaymentFormProps) {
  const [paymentMethod, setPaymentMethod] = useState<'card' | 'bank'>('card')
  const [cardNumber, setCardNumber] = useState('')
  const [cardName, setCardName] = useState('')
  const [expiryDate, setExpiryDate] = useState('')
  const [cvv, setCvv] = useState('')
  const [loading, setLoading] = useState(false)

  const formatPrice = (price: number) => {
    return new Intl.NumberFormat('en-QA', {
      style: 'currency',
      currency: 'QAR'
    }).format(price)
  }

  const handlePayment = async () => {
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
        onPaymentComplete(data)
      } else {
        alert('Payment failed. Please try again.')
      }
    } catch (error) {
      console.error('Payment error:', error)
      alert('An error occurred. Please try again.')
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
              <label className="text-sm font-medium mb-1 block">Card Number</label>
              <input
                type="text"
                value={cardNumber}
                onChange={(e) => setCardNumber(e.target.value)}
                placeholder="1234 5678 9012 3456"
                className="w-full px-3 py-2 border rounded-md"
              />
            </div>
            <div>
              <label className="text-sm font-medium mb-1 block">Cardholder Name</label>
              <input
                type="text"
                value={cardName}
                onChange={(e) => setCardName(e.target.value)}
                placeholder="John Doe"
                className="w-full px-3 py-2 border rounded-md"
              />
            </div>
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="text-sm font-medium mb-1 block">Expiry Date</label>
                <input
                  type="text"
                  value={expiryDate}
                  onChange={(e) => setExpiryDate(e.target.value)}
                  placeholder="MM/YY"
                  className="w-full px-3 py-2 border rounded-md"
                />
              </div>
              <div>
                <label className="text-sm font-medium mb-1 block">CVV</label>
                <input
                  type="text"
                  value={cvv}
                  onChange={(e) => setCvv(e.target.value)}
                  placeholder="123"
                  className="w-full px-3 py-2 border rounded-md"
                />
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
