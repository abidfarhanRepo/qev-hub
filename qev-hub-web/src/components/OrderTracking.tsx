'use client'

/**
 * OrderTracking Component
 *
 * Displays the real-time tracking status of vehicle orders with a visual timeline.
 * Shows logistics information, tracking history, and Qatar-specific customs clearance details.
 *
 * Features:
 * - Visual progress timeline with 5 stages (Order Placed → Delivered)
 * - Current location, destination, vessel, and estimated arrival info
 * - Tracking history with timestamps
 * - FAHES & Customs section (shown when "In Customs" stage or later)
 * - Test mode for automatic status progression during development
 *
 * Test Mode:
 * When `testMode=true`, the component automatically:
 * - Progresses order status every 5 seconds through all stages
 * - Updates backend via PUT to /api/logistics/[id]
 * - Auto-approves FAHES requirements every 3 seconds when "In Customs"
 * - Auto-receives paperwork documents every 3 seconds when "In Customs"
 *
 * @param logistics - Logistics object containing current order tracking data
 * @param onLogisticsUpdate - Optional callback when logistics data updates
 * @param testMode - Enable automatic status progression for testing (default: false)
 */

import { useState, useEffect, useCallback } from 'react'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Separator } from '@/components/ui/separator'
import { Progress } from '@/components/ui/progress'
import { ShipIcon, TruckIcon, MapPinIcon, PackageIcon, CheckIcon, FileText, AlertCircle } from '@/components/icons'

interface TrackingEvent {
  status: string
  location: string
  timestamp: string
}

interface Logistics {
  id?: string
  status: string
  current_location: string
  destination: string
  estimated_arrival: string | null
  vessel_name: string | null
  tracking_events: TrackingEvent[]
}

interface OrderTrackingProps {
  /** Current logistics data for the order */
  logistics: Logistics
  /** Optional callback invoked when logistics data is updated (e.g., during test mode progression) */
  onLogisticsUpdate?: (logistics: Logistics) => void
  /** Enable automatic status progression for testing purposes */
  testMode?: boolean
}

/** Order stages with labels, locations, and vessel information */
const ORDER_STAGES = [
  { key: 'Order Placed', label: 'Order Placed', location: 'Manufacturer Facility' },
  { key: 'Processing', label: 'Processing', location: 'Processing Center' },
  { key: 'In Transit', label: 'In Transit', location: 'International Waters', vessel: 'MV Qatar Express' },
  { key: 'In Customs', label: 'In Customs', location: 'Hamad Port, Qatar' },
  { key: 'Delivered', label: 'Delivered', location: 'Delivered to Customer' },
]

/** Sequence of order statuses for automatic progression in test mode */
const STATUS_PROGRESSION_SEQUENCE = ['Order Placed', 'Processing', 'In Transit', 'In Customs', 'Delivered']

/**
 * FAHES (General Authority for Standardization and Metrology) requirements
 * These are mandatory inspections and certifications for vehicle import into Qatar.
 * In test mode, these auto-approve every 3 seconds when status is "In Customs".
 */
const FAHES_REQUIREMENTS = [
  { id: '1', name: 'Vehicle Inspection', status: 'pending', description: 'Comprehensive safety and emissions inspection' },
  { id: '2', name: 'Certificate of Conformity', status: 'pending', description: 'GCC compliance certificate verification' },
  { id: '3', name: 'Insurance Registration', status: 'pending', description: 'Qatar vehicle insurance registration' },
  { id: '4', name: 'Traffic Registration', status: 'pending', description: 'Traffic department registration' },
]

/**
 * Required paperwork for customs clearance in Qatar.
 * In test mode, pending documents auto-receive every 3 seconds when status is "In Customs".
 */
const PAPERWORK_ITEMS = [
  { name: 'Bill of Lading', status: 'received', required: true },
  { name: 'Commercial Invoice', status: 'received', required: true },
  { name: 'Certificate of Origin', status: 'received', required: true },
  { name: 'Packing List', status: 'received', required: true },
  { name: 'Insurance Certificate', status: 'pending', required: true },
  { name: 'Export Declaration', status: 'pending', required: true },
]

/**
 * Customs fees and charges for vehicle import into Qatar.
 * Import duty is typically 5% of vehicle value (calculated dynamically based on order total).
 * Other fees are fixed charges.
 */
const CUSTOMS_FEES = [
  { name: 'Import Duty (5%)', amount: 0 }, // Will be calculated
  { name: 'Customs Processing Fee', amount: 350 },
  { name: 'Port Handling Charges', amount: 500 },
  { name: 'Documentation Fee', amount: 150 },
  { name: 'Storage Fees', amount: 200 },
]

export function OrderTracking({ logistics, onLogisticsUpdate, testMode = false }: OrderTrackingProps) {
  const [currentStage, setCurrentStage] = useState(0)
  const [localLogistics, setLocalLogistics] = useState<Logistics>(logistics)
  const [fahesStatus, setFahesStatus] = useState<typeof FAHES_REQUIREMENTS>(FAHES_REQUIREMENTS)
  const [paperwork, setPaperwork] = useState<typeof PAPERWORK_ITEMS>(PAPERWORK_ITEMS)

  /**
   * Initialize state from logistics prop
   * Updates current stage and local logistics whenever the prop changes
   */
  useEffect(() => {
    const stageIndex = ORDER_STAGES.findIndex(
      (stage) => stage.key === logistics.status
    )
    setCurrentStage(Math.max(0, stageIndex))
    setLocalLogistics(logistics)
  }, [logistics.status, logistics])

  /**
   * Test Mode: Auto-progression of order status
   *
   * When enabled, automatically advances the order through all stages every 5 seconds:
   * - Updates local state immediately for instant UI feedback
   * - Updates backend via PUT to /api/logistics/[id]
   * - Stops when order reaches "Delivered" status
   */
  useEffect(() => {
    if (!testMode || !logistics.id) return

    // Stop progression when delivered
    if (localLogistics.status === 'Delivered') return

    const timer = setInterval(async () => {
      const currentIndex = STATUS_PROGRESSION_SEQUENCE.indexOf(localLogistics.status)
      if (currentIndex < STATUS_PROGRESSION_SEQUENCE.length - 1) {
        const nextStatus = STATUS_PROGRESSION_SEQUENCE[currentIndex + 1]
        const stageInfo = ORDER_STAGES.find(s => s.key === nextStatus)

        const newEvent = {
          status: nextStatus,
          location: stageInfo?.location || localLogistics.current_location,
          timestamp: new Date().toISOString(),
        }

        const updatedLogistics = {
          ...localLogistics,
          status: nextStatus,
          current_location: stageInfo?.location || localLogistics.current_location,
          vessel_name: stageInfo?.vessel || localLogistics.vessel_name,
          tracking_events: [...localLogistics.tracking_events, newEvent],
          estimated_arrival: nextStatus === 'In Transit'
            ? new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString()
            : localLogistics.estimated_arrival,
        }

        // Update local state
        setLocalLogistics(updatedLogistics)
        setCurrentStage(currentIndex + 1)

        // Update backend
        try {
          const response = await fetch(`/api/logistics/${logistics.id}`, {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
              status: nextStatus,
              current_location: stageInfo?.location,
            }),
          })

          if (response.ok) {
            const data = await response.json()
            if (data.logistics && onLogisticsUpdate) {
              onLogisticsUpdate(data.logistics)
            }
          }
        } catch (error) {
          console.error('Failed to update logistics:', error)
        }
      }
    }, 5000)

    return () => clearInterval(timer)
  }, [testMode, localLogistics, logistics.id, onLogisticsUpdate])

  /**
   * Test Mode: Auto-approve FAHES requirements and paperwork
   *
   * When order is in "In Customs" stage and test mode is enabled:
   * - Approves one FAHES requirement every 3 seconds
   * - Receives one pending paperwork document every 3 seconds
   * - Stops when all items are approved/received
   */
  useEffect(() => {
    if (localLogistics.status === 'In Customs' && testMode) {
      const timer = setInterval(() => {
        setFahesStatus(prev => {
          const pendingIndex = prev.findIndex(item => item.status === 'pending')
          if (pendingIndex >= 0) {
            const updated = [...prev]
            updated[pendingIndex] = { ...updated[pendingIndex], status: 'approved' }
            return updated
          }
          return prev
        })

        setPaperwork(prev => {
          const pendingIndex = prev.findIndex(item => item.status === 'pending')
          if (pendingIndex >= 0) {
            const updated = [...prev]
            updated[pendingIndex] = { ...updated[pendingIndex], status: 'received' }
            return updated
          }
          return prev
        })
      }, 3000)

      return () => clearInterval(timer)
    }
  }, [localLogistics.status, testMode])

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

  // Use localLogistics for real-time updates during test mode
  const displayLogistics = testMode ? localLogistics : logistics

  return (
    <Card className="w-full">
      <CardHeader>
        <div className="flex items-center justify-between">
          <CardTitle>Order Tracking</CardTitle>
          <Badge
            variant={
              displayLogistics.status === 'Delivered' ? 'default' : 'secondary'
            }
          >
            {displayLogistics.status}
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
                      {displayLogistics.current_location}
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
              {displayLogistics.current_location}
            </p>
          </div>
        </div>

        {/* Destination */}
        <div className="flex items-start gap-3">
          <TruckIcon className="h-5 w-5 text-muted-foreground mt-0.5" />
          <div>
            <p className="text-sm font-medium">Destination</p>
            <p className="text-sm text-muted-foreground">
              {displayLogistics.destination}
            </p>
          </div>
        </div>

        {/* Estimated Arrival */}
        {displayLogistics.estimated_arrival && (
          <div className="flex items-start gap-3">
            <PackageIcon className="h-5 w-5 text-muted-foreground mt-0.5" />
            <div>
              <p className="text-sm font-medium">Estimated Arrival</p>
              <p className="text-sm text-muted-foreground">
                {formatDate(displayLogistics.estimated_arrival)}
              </p>
            </div>
          </div>
        )}

        {/* Vessel Information */}
        {displayLogistics.vessel_name && (
          <div className="flex items-start gap-3">
            <ShipIcon className="h-5 w-5 text-muted-foreground mt-0.5" />
            <div>
              <p className="text-sm font-medium">Vessel</p>
              <p className="text-sm text-muted-foreground">
                {displayLogistics.vessel_name}
              </p>
            </div>
          </div>
        )}

        <Separator />

        {/* Tracking Events */}
        {displayLogistics.tracking_events && displayLogistics.tracking_events.length > 0 && (
          <div>
            <h3 className="font-semibold mb-3">Tracking History</h3>
            <div className="space-y-3">
              {displayLogistics.tracking_events
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

        {/* FAHES & Customs Section - Only shown when In Customs or later */}
        {currentStage >= 3 && (
          <>
            <Separator />
            <div className="space-y-4">
              <div className="flex items-center gap-2">
                <FileText className="h-5 w-5 text-primary" />
                <h3 className="font-semibold text-lg">FAHES & Customs Clearance</h3>
              </div>

              {/* FAHES Requirements Progress */}
              <div className="bg-muted/30 rounded-lg p-4">
                <div className="flex items-center justify-between mb-3">
                  <h4 className="font-medium">FAHES Inspection Status</h4>
                  <Badge variant={fahesStatus.every(r => r.status === 'approved') ? 'default' : 'secondary'}>
                    {fahesStatus.filter(r => r.status === 'approved').length}/{fahesStatus.length} Approved
                  </Badge>
                </div>
                <div className="space-y-3">
                  {fahesStatus.map((req) => (
                    <div key={req.id} className="flex items-start gap-3">
                      <div className="mt-0.5">
                        {req.status === 'approved' ? (
                          <CheckIcon className="h-4 w-4 text-green-600" />
                        ) : (
                          <AlertCircle className="h-4 w-4 text-yellow-600" />
                        )}
                      </div>
                      <div className="flex-1">
                        <p className="text-sm font-medium">{req.name}</p>
                        <p className="text-xs text-muted-foreground">{req.description}</p>
                      </div>
                      <Badge variant={req.status === 'approved' ? 'default' : 'outline'} className="text-xs">
                        {req.status === 'approved' ? 'Approved' : 'Pending'}
                      </Badge>
                    </div>
                  ))}
                </div>
              </div>

              {/* Paperwork Checklist */}
              <div className="bg-muted/30 rounded-lg p-4">
                <div className="flex items-center justify-between mb-3">
                  <h4 className="font-medium">Required Paperwork</h4>
                  <Badge variant={paperwork.every(p => p.status === 'received') ? 'default' : 'secondary'}>
                    {paperwork.filter(p => p.status === 'received').length}/{paperwork.length} Received
                  </Badge>
                </div>
                <div className="grid grid-cols-2 gap-2">
                  {paperwork.map((doc, idx) => (
                    <div key={idx} className="flex items-center gap-2 text-sm">
                      {doc.status === 'received' ? (
                        <CheckIcon className="h-4 w-4 text-green-600 flex-shrink-0" />
                      ) : (
                        <div className="h-4 w-4 rounded-full border-2 border-muted flex-shrink-0" />
                      )}
                      <span className={doc.status === 'received' ? '' : 'text-muted-foreground'}>
                        {doc.name}
                        {doc.required && <span className="text-red-500 ml-1">*</span>}
                      </span>
                    </div>
                  ))}
                </div>
                <p className="text-xs text-muted-foreground mt-2">* Required for customs clearance</p>
              </div>

              {/* Customs Fees Breakdown */}
              <div className="bg-muted/30 rounded-lg p-4">
                <div className="flex items-center justify-between mb-3">
                  <h4 className="font-medium">Customs Fees & Charges</h4>
                  <Badge variant="outline">QAR</Badge>
                </div>
                <div className="space-y-2 text-sm">
                  {CUSTOMS_FEES.map((fee, idx) => (
                    <div key={idx} className="flex justify-between">
                      <span className="text-muted-foreground">{fee.name}</span>
                      <span className="font-medium">
                        {fee.amount > 0 ? `QAR ${fee.amount.toLocaleString()}` : '---'}
                      </span>
                    </div>
                  ))}
                  <div className="border-t pt-2 mt-2">
                    <div className="flex justify-between font-semibold">
                      <span>Total Fees</span>
                      <span>QAR {CUSTOMS_FEES.reduce((sum, f) => sum + f.amount, 0).toLocaleString()}</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </>
        )}
      </CardContent>
    </Card>
  )
}
