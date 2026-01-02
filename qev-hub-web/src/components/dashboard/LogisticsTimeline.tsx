'use client'

import { useState } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import { Dialog, DialogContent, DialogHeader, DialogTitle } from '@/components/ui/dialog'
import { Separator } from '@/components/ui/separator'
import { ShipIcon, TruckIcon, PackageIcon, CheckIcon, FileText, Download, Clock, AlertCircle, CheckCircle2 } from '@/components/icons'

interface Document {
  id: string
  name: string
  type: string
  status: 'available' | 'pending' | 'processing'
  url: string
  generatedAt?: string
}

interface Checkpoint {
  id: string
  stage: string
  title: string
  status: 'completed' | 'in-progress' | 'pending'
  location: string
  timestamp: string | null
  description: string
  requirements?: string[]
  documents?: Document[]
}

interface LogisticsTimelineProps {
  order: any
}

export function LogisticsTimeline({ order }: LogisticsTimelineProps) {
  const [selectedCheckpoint, setSelectedCheckpoint] = useState<Checkpoint | null>(null)
  const [showDocument, setShowDocument] = useState<Document | null>(null)

  const MOCK_CHECKPOINTS: Checkpoint[] = [
    {
      id: '1',
      stage: 'Order Placed',
      title: 'Order Confirmed',
      status: 'completed',
      location: 'QEV-Hub Platform',
      timestamp: '2024-01-15T10:30:00Z',
      description: 'Your order has been successfully placed and confirmed.',
      requirements: ['Payment verified', 'Vehicle availability confirmed', 'Order ID generated'],
      documents: [
        {
          id: 'd1',
          name: 'Digital Invoice',
          type: 'PDF',
          status: 'available',
          url: '#',
          generatedAt: '2024-01-15T10:35:00Z',
        },
      ],
    },
    {
      id: '2',
      stage: 'Processing',
      title: 'Vehicle Preparation',
      status: 'completed',
      location: 'Manufacturer Facility',
      timestamp: '2024-01-20T14:00:00Z',
      description: 'Vehicle is being prepared for shipment.',
      requirements: ['Quality inspection completed', 'Battery fully charged', 'Final configuration'],
      documents: [
        {
          id: 'd2',
          name: 'Vehicle Certificate',
          type: 'PDF',
          status: 'available',
          url: '#',
          generatedAt: '2024-01-20T14:30:00Z',
        },
      ],
    },
    {
      id: '3',
      stage: 'FAHES Inspection',
      title: 'FAHES Clearance',
      status: 'in-progress',
      location: 'Qatar Customs',
      timestamp: null,
      description: 'Vehicle is undergoing FAHES inspection and clearance process.',
      requirements: [
        'Safety inspection',
        'Emissions verification',
        'Vehicle identification check',
        'Documentation review',
        'Import duty assessment',
      ],
      documents: [
        {
          id: 'd3',
          name: 'FAHES Inspection Report',
          type: 'PDF',
          status: 'processing',
          url: '#',
        },
        {
          id: 'd4',
          name: 'Import Duty Certificate',
          type: 'PDF',
          status: 'pending',
          url: '#',
        },
      ],
    },
    {
      id: '4',
      stage: 'In Transit',
      title: 'Shipping to Qatar',
      status: 'pending',
      location: 'International Waters',
      timestamp: null,
      description: 'Vehicle is being shipped to Hamad Port, Qatar.',
      requirements: ['Vessel tracking active', 'ETA confirmation', 'Shipping documentation'],
      documents: [
        {
          id: 'd5',
          name: 'Bill of Lading',
          type: 'PDF',
          status: 'pending',
          url: '#',
        },
      ],
    },
    {
      id: '5',
      stage: 'In Customs',
      title: 'Customs Clearance',
      status: 'pending',
      location: 'Hamad Port, Qatar',
      timestamp: null,
      description: 'Vehicle is clearing customs at Hamad Port.',
      requirements: ['Customs declaration', 'Vehicle verification', 'Duty payment confirmation'],
      documents: [
        {
          id: 'd6',
          name: 'Customs Declaration',
          type: 'PDF',
          status: 'pending',
          url: '#',
        },
        {
          id: 'd7',
          name: 'Insurance Policy',
          type: 'PDF',
          status: 'pending',
          url: '#',
        },
      ],
    },
    {
      id: '6',
      stage: 'Delivered',
      title: 'Delivery Complete',
      status: 'pending',
      location: 'Your Address',
      timestamp: null,
      description: 'Vehicle will be delivered to your specified address.',
      requirements: ['Final inspection', 'Handover documentation', 'Registration assistance'],
      documents: [
        {
          id: 'd8',
          name: 'Vehicle Registration',
          type: 'PDF',
          status: 'pending',
          url: '#',
        },
      ],
    },
  ]

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

  const getStageIcon = (status: Checkpoint['status']) => {
    switch (status) {
      case 'completed':
        return (
          <div className="w-10 h-10 rounded-full bg-green-500 flex items-center justify-center">
            <CheckIcon className="h-5 w-5 text-white" />
          </div>
        )
      case 'in-progress':
        return (
          <div className="w-10 h-10 rounded-full bg-primary animate-pulse flex items-center justify-center">
            <Clock className="h-5 w-5 text-white" />
          </div>
        )
      default:
        return (
          <div className="w-10 h-10 rounded-full bg-muted border-2 border-border flex items-center justify-center">
            <div className="w-3 h-3 rounded-full bg-muted-foreground/50" />
          </div>
        )
    }
  }

  const getDocumentIcon = (status: Document['status']) => {
    switch (status) {
      case 'available':
        return <CheckCircle2 className="h-5 w-5 text-green-600" />
      case 'processing':
        return <Clock className="h-5 w-5 text-yellow-600 animate-pulse" />
      default:
        return <AlertCircle className="h-5 w-5 text-muted-foreground" />
    }
  }

  return (
    <div className="space-y-6">
      {/* Order Summary */}
      <Card className="glass-card tech-border">
        <CardContent className="p-6">
          <div className="flex items-center justify-between">
            <div>
              <h3 className="text-xl font-bold text-foreground">Order Tracking</h3>
              <p className="text-sm text-muted-foreground">Tracking ID: QEV-1234</p>
            </div>
            <Badge variant="default" className="bg-primary text-primary-foreground">
              In Progress
            </Badge>
          </div>
        </CardContent>
      </Card>

      {/* Interactive Timeline */}
      <Card className="glass-card border-border/50">
        <CardHeader>
          <CardTitle>Shipping Timeline</CardTitle>
          <p className="text-sm text-muted-foreground">
            Click on any checkpoint to view details and available documents
          </p>
        </CardHeader>
        <CardContent>
          <div className="space-y-0">
            {MOCK_CHECKPOINTS.map((checkpoint, index) => (
              <div key={checkpoint.id}>
                <button
                  onClick={() => setSelectedCheckpoint(checkpoint)}
                  className={`w-full flex items-start gap-6 p-6 transition-all hover:bg-primary/5 relative ${
                    selectedCheckpoint?.id === checkpoint.id ? 'bg-primary/10' : ''
                  }`}
                >
                  {/* Icon */}
                  <div className="flex-shrink-0">{getStageIcon(checkpoint.status)}</div>

                  {/* Content */}
                  <div className="flex-1 text-left">
                    <div className="flex items-center gap-3 mb-2">
                      <h4 className="text-lg font-semibold text-foreground">
                        {checkpoint.title}
                      </h4>
                      <Badge
                        variant={
                          checkpoint.status === 'completed'
                            ? 'default'
                            : checkpoint.status === 'in-progress'
                            ? 'secondary'
                            : 'outline'
                        }
                        className={`${
                          checkpoint.status === 'completed'
                            ? 'bg-green-500 text-white'
                            : checkpoint.status === 'in-progress'
                            ? 'bg-primary text-primary-foreground'
                            : 'bg-muted'
                        }`}
                      >
                        {checkpoint.status === 'completed' && 'Completed'}
                        {checkpoint.status === 'in-progress' && 'In Progress'}
                        {checkpoint.status === 'pending' && 'Pending'}
                      </Badge>
                    </div>
                    <p className="text-sm text-muted-foreground mb-2">
                      {checkpoint.description}
                    </p>
                    <div className="flex items-center gap-4 text-xs text-muted-foreground">
                      <span className="flex items-center gap-1">
                        <PackageIcon className="h-3 w-3" />
                        {checkpoint.location}
                      </span>
                      {checkpoint.timestamp && (
                        <span className="flex items-center gap-1">
                          <Clock className="h-3 w-3" />
                          {formatDate(checkpoint.timestamp)}
                        </span>
                      )}
                    </div>
                  </div>

                  {/* Documents Badge */}
                  {checkpoint.documents && checkpoint.documents.length > 0 && (
                    <div className="flex-shrink-0">
                      <Badge variant="outline" className="flex items-center gap-2">
                        <FileText className="h-3 w-3" />
                        {checkpoint.documents.length} Document
                        {checkpoint.documents.length > 1 ? 's' : ''}
                      </Badge>
                    </div>
                  )}
                </button>

                {index < MOCK_CHECKPOINTS.length - 1 && (
                  <div className="ml-5 h-8 w-0.5 bg-border relative">
                    {checkpoint.status === 'completed' && (
                      <div className="absolute top-0 left-0 w-full h-full bg-primary" />
                    )}
                  </div>
                )}
              </div>
            ))}
          </div>
        </CardContent>
      </Card>

      {/* Checkpoint Detail Modal */}
      <Dialog open={!!selectedCheckpoint} onOpenChange={() => setSelectedCheckpoint(null)}>
        <DialogContent className="max-w-2xl max-h-[80vh] overflow-y-auto">
          {selectedCheckpoint && (
            <>
              <DialogHeader>
                <DialogTitle className="text-2xl">{selectedCheckpoint.title}</DialogTitle>
              </DialogHeader>
              <div className="space-y-6">
                {/* Status & Location */}
                <div className="grid grid-cols-2 gap-4">
                  <div className="p-4 bg-muted/30 rounded-lg">
                    <p className="text-xs text-muted-foreground mb-1">Status</p>
                    <Badge
                      variant={
                        selectedCheckpoint.status === 'completed'
                          ? 'default'
                          : selectedCheckpoint.status === 'in-progress'
                          ? 'secondary'
                          : 'outline'
                      }
                      className={`${
                        selectedCheckpoint.status === 'completed'
                          ? 'bg-green-500 text-white'
                          : selectedCheckpoint.status === 'in-progress'
                          ? 'bg-primary text-primary-foreground'
                          : 'bg-muted'
                      }`}
                    >
                      {selectedCheckpoint.status}
                    </Badge>
                  </div>
                  <div className="p-4 bg-muted/30 rounded-lg">
                    <p className="text-xs text-muted-foreground mb-1">Location</p>
                    <p className="font-semibold text-foreground">
                      {selectedCheckpoint.location}
                    </p>
                  </div>
                </div>

                {/* Description */}
                <div>
                  <h4 className="font-semibold text-foreground mb-2">Description</h4>
                  <p className="text-sm text-muted-foreground">
                    {selectedCheckpoint.description}
                  </p>
                </div>

                {/* Requirements */}
                {selectedCheckpoint.requirements && (
                  <div>
                    <h4 className="font-semibold text-foreground mb-3">Requirements</h4>
                    <div className="space-y-2">
                      {selectedCheckpoint.requirements.map((req, index) => (
                        <div
                          key={index}
                          className="flex items-center gap-3 p-3 bg-muted/20 rounded-lg border border-border/50"
                        >
                          {selectedCheckpoint.status === 'completed' ||
                          selectedCheckpoint.status === 'in-progress' ? (
                            <CheckCircle2 className="h-5 w-5 text-green-600 flex-shrink-0" />
                          ) : (
                            <Clock className="h-5 w-5 text-muted-foreground flex-shrink-0" />
                          )}
                          <span className="text-sm text-foreground">{req}</span>
                        </div>
                      ))}
                    </div>
                  </div>
                )}

                <Separator />

                {/* Document Vault */}
                {selectedCheckpoint.documents && selectedCheckpoint.documents.length > 0 && (
                  <div>
                    <h4 className="font-semibold text-foreground mb-4 flex items-center gap-2">
                      <FileText className="h-5 w-5 text-primary" />
                      Document Vault
                    </h4>
                    <div className="space-y-3">
                      {selectedCheckpoint.documents.map((doc) => (
                        <div
                          key={doc.id}
                          className={`p-4 rounded-lg border-2 transition-all ${
                            doc.status === 'available'
                              ? 'bg-green-500/5 border-green-500/30 hover:border-green-500/50 cursor-pointer'
                              : doc.status === 'processing'
                              ? 'bg-yellow-500/5 border-yellow-500/30'
                              : 'bg-muted/20 border-border/50'
                          }`}
                          onClick={() =>
                            doc.status === 'available' && setShowDocument(doc)
                          }
                        >
                          <div className="flex items-center justify-between">
                            <div className="flex items-center gap-3">
                              {getDocumentIcon(doc.status)}
                              <div>
                                <p className="font-semibold text-foreground">
                                  {doc.name}
                                </p>
                                <p className="text-xs text-muted-foreground">
                                  {doc.type}
                                  {doc.generatedAt &&
                                    ` • Generated: ${formatDate(doc.generatedAt)}`}
                                </p>
                              </div>
                            </div>
                            {doc.status === 'available' && (
                              <Button
                                variant="outline"
                                size="sm"
                                className="flex items-center gap-2"
                                onClick={(e) => {
                                  e.stopPropagation()
                                  setShowDocument(doc)
                                }}
                              >
                                <Download className="h-4 w-4" />
                                Download
                              </Button>
                            )}
                          </div>
                        </div>
                      ))}
                    </div>
                  </div>
                )}

                {/* Action Button */}
                {selectedCheckpoint.status === 'pending' && (
                  <div className="p-4 bg-primary/5 rounded-lg border border-primary/30 text-center">
                    <p className="text-sm text-muted-foreground mb-3">
                      This checkpoint is pending. You'll be notified when it's ready.
                    </p>
                    <Badge className="bg-primary/10 text-primary border-primary/30">
                      <Clock className="h-3 w-3 mr-1" />
                      Est. 2-3 weeks
                    </Badge>
                  </div>
                )}
              </div>
            </>
          )}
        </DialogContent>
      </Dialog>

      {/* Document Preview Modal */}
      <Dialog open={!!showDocument} onOpenChange={() => setShowDocument(null)}>
        <DialogContent className="max-w-md">
          {showDocument && (
            <>
              <DialogHeader>
                <DialogTitle>{showDocument.name}</DialogTitle>
              </DialogHeader>
              <div className="space-y-4">
                <div className="p-6 bg-muted/30 rounded-lg border-2 border-dashed border-border text-center">
                  <FileText className="h-16 w-16 text-primary mx-auto mb-4" />
                  <p className="font-semibold text-foreground mb-2">
                    {showDocument.name}
                  </p>
                  <p className="text-sm text-muted-foreground mb-4">
                    PDF Document • {showDocument.type}
                  </p>
                  <Button
                    className="w-full bg-primary text-primary-foreground"
                    onClick={() => window.open(showDocument.url, '_blank')}
                  >
                    <Download className="h-4 w-4 mr-2" />
                    Download Document
                  </Button>
                </div>
                <div className="flex items-center gap-2 text-xs text-muted-foreground">
                  <CheckCircle2 className="h-4 w-4 text-green-600" />
                  <span>Document verified and ready for download</span>
                </div>
              </div>
            </>
          )}
        </DialogContent>
      </Dialog>
    </div>
  )
}
