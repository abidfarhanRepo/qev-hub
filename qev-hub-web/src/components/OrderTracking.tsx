'use client'

import { useState, useEffect } from 'react'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Separator } from '@/components/ui/separator'
import { ShipIcon, TruckIcon, MapPinIcon, PackageIcon, CheckIcon } from '@/components/icons'

interface TrackingEvent {
  status: string
  location: string
  timestamp: string
}

interface Logistics {
  status: string
  current_location: string
  destination: string
  estimated_arrival: string | null
  vessel_name: string | null
  tracking_events: TrackingEvent[]
}

interface OrderTrackingProps {
  logistics: Logistics
}

const ORDER_STAGES = [
  { key: 'Order Placed', label: 'Order Placed' },
  { key: 'Processing', label: 'Processing' },
  { key: 'In Transit', label: 'In Transit' },
  { key: 'In Customs', label: 'In Customs' },
  { key: 'Delivered', label: 'Delivered' },
]

export function OrderTracking({ logistics }: OrderTrackingProps) {
  const [currentStage, setCurrentStage] = useState(0)

  useEffect(() => {
    const stageIndex = ORDER_STAGES.findIndex(
      (stage) => stage.key === logistics.status
    )
    setCurrentStage(Math.max(0, stageIndex))
  }, [logistics.status])

  const formatDate = (dateString: string) => {
    const date = new Date(dateString)
    return date.toLocaleDateString('en-QA', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit',
    })
  }

  const getStageIcon = (index: number) => {
    if (index < currentStage) {
      return <CheckIcon className="h-5 w-5 text-green-600" />
    } else if (index === currentStage) {
      return <ShipIcon className="h-5 w-5 text-primary" />
    } else {
      return <div className="h-5 w-5 rounded-full border-2 border-muted" />
    }
  }

  const getStageStatus = (index: number) => {
    if (index < currentStage) return 'completed'
    if (index === currentStage) return 'current'
    return 'pending'
  }

  return (
    <Card className="w-full">
      <CardHeader>
        <div className="flex items-center justify-between">
          <CardTitle>Order Tracking</CardTitle>
          <Badge
            variant={
              logistics.status === 'Delivered' ? 'default' : 'secondary'
            }
          >
            {logistics.status}
          </Badge>
        </div>
      </CardHeader>
      <CardContent className="space-y-6">
        {/* Progress Timeline */}
        <div className="relative">
          {/* Progress Line */}
          <div className="absolute left-[15px] top-0 bottom-0 w-0.5 bg-muted">
            <div
              className="w-full bg-primary transition-all duration-500"
              style={{
                height: `${(currentStage / (ORDER_STAGES.length - 1)) * 100}%`,
              }}
            />
          </div>

          {/* Stages */}
          <div className="space-y-8">
            {ORDER_STAGES.map((stage, index) => (
              <div key={stage.key} className="relative flex items-start gap-4">
                {/* Stage Icon */}
                <div
                  className={`relative z-10 flex items-center justify-center w-8 h-8 rounded-full border-2 ${
                    getStageStatus(index) === 'completed'
                      ? 'border-green-600 bg-green-600'
                      : getStageStatus(index) === 'current'
                      ? 'border-primary bg-primary'
                      : 'border-muted bg-background'
                  }`}
                >
                  {getStageIcon(index)}
                </div>

                {/* Stage Content */}
                <div className="flex-1 pb-2">
                  <div className="flex items-center gap-2 mb-1">
                    <h3 className="font-semibold">{stage.label}</h3>
                    {getStageStatus(index) === 'current' && (
                      <Badge variant="secondary" className="text-xs">
                        Current
                      </Badge>
                    )}
                  </div>
                  {getStageStatus(index) === 'current' && (
                    <p className="text-sm text-muted-foreground">
                      {logistics.current_location}
                    </p>
                  )}
                </div>
              </div>
            ))}
          </div>
        </div>

        <Separator />

        {/* Current Location */}
        <div className="flex items-start gap-3">
          <MapPinIcon className="h-5 w-5 text-muted-foreground mt-0.5" />
          <div>
            <p className="text-sm font-medium">Current Location</p>
            <p className="text-sm text-muted-foreground">
              {logistics.current_location}
            </p>
          </div>
        </div>

        {/* Destination */}
        <div className="flex items-start gap-3">
          <TruckIcon className="h-5 w-5 text-muted-foreground mt-0.5" />
          <div>
            <p className="text-sm font-medium">Destination</p>
            <p className="text-sm text-muted-foreground">
              {logistics.destination}
            </p>
          </div>
        </div>

        {/* Estimated Arrival */}
        {logistics.estimated_arrival && (
          <div className="flex items-start gap-3">
            <PackageIcon className="h-5 w-5 text-muted-foreground mt-0.5" />
            <div>
              <p className="text-sm font-medium">Estimated Arrival</p>
              <p className="text-sm text-muted-foreground">
                {formatDate(logistics.estimated_arrival)}
              </p>
            </div>
          </div>
        )}

        {/* Vessel Information */}
        {logistics.vessel_name && (
          <div className="flex items-start gap-3">
            <ShipIcon className="h-5 w-5 text-muted-foreground mt-0.5" />
            <div>
              <p className="text-sm font-medium">Vessel</p>
              <p className="text-sm text-muted-foreground">
                {logistics.vessel_name}
              </p>
            </div>
          </div>
        )}

        <Separator />

        {/* Tracking Events */}
        {logistics.tracking_events && logistics.tracking_events.length > 0 && (
          <div>
            <h3 className="font-semibold mb-3">Tracking History</h3>
            <div className="space-y-3">
              {logistics.tracking_events
                .slice()
                .reverse()
                .map((event, index) => (
                  <div key={index} className="flex items-start gap-3">
                    <div className="mt-1">
                      <div className="h-2 w-2 rounded-full bg-primary" />
                    </div>
                    <div className="flex-1">
                      <p className="text-sm font-medium">{event.status}</p>
                      <p className="text-xs text-muted-foreground">
                        {event.location}
                      </p>
                      <p className="text-xs text-muted-foreground">
                        {formatDate(event.timestamp)}
                      </p>
                    </div>
                  </div>
                ))}
            </div>
          </div>
        )}
      </CardContent>
    </Card>
  )
}
