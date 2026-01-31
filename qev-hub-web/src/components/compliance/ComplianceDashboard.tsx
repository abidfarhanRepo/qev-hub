'use client'

import { useState, useEffect } from 'react'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs'
import { Progress } from '@/components/ui/progress'
import {
  FileText,
  Upload,
  CheckCircle,
  Clock,
  AlertCircle,
  Ship,
  FileCheck,
  ClipboardCheck,
  Download,
} from 'lucide-react'

interface ComplianceStep {
  id: string
  title: string
  description: string
  status: 'pending' | 'in_progress' | 'completed' | 'failed'
  documents_required: number
  documents_uploaded: number
  estimated_days?: number
}

interface Document {
  id: string
  name: string
  type: string
  status: 'pending' | 'under_review' | 'approved' | 'rejected'
  upload_date?: string
  url?: string
}

interface OrderCompliance {
  order_id: string
  tracking_id: string
  vehicle_name: string
  manufacturer: string
  overall_progress: number
  steps: ComplianceStep[]
  documents: Document[]
  estimated_completion: string
}

// Mock data - simulating real compliance workflow
const mockComplianceData: OrderCompliance = {
  order_id: 'ord-12345',
  tracking_id: 'QEV-2025-001234',
  vehicle_name: 'BYD Seal',
  manufacturer: 'BYD',
  overall_progress: 45,
  estimated_completion: '2025-03-15',
  steps: [
    {
      id: 'fahes_inspection',
      title: 'FAHES Inspection',
      description: 'Vehicle inspection and certification from Qatar General Electricity & Water Corporation (KAHRAMAA)',
      status: 'in_progress',
      documents_required: 3,
      documents_uploaded: 2,
      estimated_days: 5,
    },
    {
      id: 'import_permit',
      title: 'Import Permit',
      description: 'Ministry of Commerce and Industry import authorization',
      status: 'pending',
      documents_required: 5,
      documents_uploaded: 0,
      estimated_days: 7,
    },
    {
      id: 'customs_clearance',
      title: 'Customs Clearance',
      description: ' Qatar Customs documentation and duty processing',
      status: 'pending',
      documents_required: 4,
      documents_uploaded: 0,
      estimated_days: 3,
    },
    {
      id: 'vehicle_registration',
      title: 'Vehicle Registration',
      description: 'Traffic Department registration and plate issuance',
      status: 'pending',
      documents_required: 3,
      documents_uploaded: 0,
      estimated_days: 2,
    },
    {
      id: 'insurance',
      title: 'Insurance Verification',
      description: 'Vehicle insurance policy validation',
      status: 'pending',
      documents_required: 1,
      documents_uploaded: 0,
      estimated_days: 1,
    },
  ],
  documents: [
    {
      id: 'doc-1',
      name: 'Commercial Invoice.pdf',
      type: 'invoice',
      status: 'approved',
      upload_date: '2025-01-25',
    },
    {
      id: 'doc-2',
      name: 'Bill of Lading.pdf',
      type: 'shipping',
      status: 'under_review',
      upload_date: '2025-01-26',
    },
    {
      id: 'doc-3',
      name: 'Certificate of Origin.pdf',
      type: 'certificate',
      status: 'pending',
    },
  ],
}

export default function ComplianceDashboard({ orderId }: { orderId?: string }) {
  const [compliance, setCompliance] = useState<OrderCompliance>(mockComplianceData)
  const [activeTab, setActiveTab] = useState('overview')
  const [uploadModal, setUploadModal] = useState(false)

  const getStatusIcon = (status: string) => {
    switch (status) {
      case 'completed':
      case 'approved':
        return <CheckCircle className="w-5 h-5 text-green-500" />
      case 'in_progress':
      case 'under_review':
        return <Clock className="w-5 h-5 text-yellow-500" />
      case 'failed':
      case 'rejected':
        return <AlertCircle className="w-5 h-5 text-red-500" />
      default:
        return <Clock className="w-5 h-5 text-gray-400" />
    }
  }

  const getStatusBadge = (status: string) => {
    const variants: Record<string, any> = {
      completed: 'default',
      approved: 'default',
      in_progress: 'secondary',
      under_review: 'secondary',
      failed: 'destructive',
      rejected: 'destructive',
      pending: 'outline',
    }
    return (
      <Badge variant={variants[status] || 'outline'}>
        {status.replace(/_/g, ' ').toUpperCase()}
      </Badge>
    )
  }

  const calculateProgress = (uploaded: number, required: number) => {
    return Math.round((uploaded / required) * 100)
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-2xl font-bold">Regulatory Compliance</h2>
          <p className="text-sm text-muted-foreground">
            Tracking ID: {compliance.tracking_id}
          </p>
        </div>
        <Button onClick={() => setUploadModal(true)}>
          <Upload className="w-4 h-4 mr-2" />
          Upload Documents
        </Button>
      </div>

      {/* Overall Progress */}
      <Card>
        <CardHeader>
          <div className="flex items-center justify-between">
            <CardTitle>Overall Progress</CardTitle>
            <span className="text-2xl font-bold text-primary">{compliance.overall_progress}%</span>
          </div>
        </CardHeader>
        <CardContent>
          <Progress value={compliance.overall_progress} className="h-3" />
          <p className="text-sm text-muted-foreground mt-2">
            Estimated completion: {new Date(compliance.estimated_completion).toLocaleDateString()}
          </p>
        </CardContent>
      </Card>

      {/* Tabs */}
      <Tabs value={activeTab} onValueChange={setActiveTab}>
        <TabsList className="grid w-full grid-cols-4">
          <TabsTrigger value="overview">Overview</TabsTrigger>
          <TabsTrigger value="documents">Documents</TabsTrigger>
          <TabsTrigger value="timeline">Timeline</TabsTrigger>
          <TabsTrigger value="shipping">Shipping</TabsTrigger>
        </TabsList>

        {/* Overview Tab */}
        <TabsContent value="overview" className="space-y-4">
          {compliance.steps.map((step) => (
            <Card key={step.id}>
              <CardContent className="p-6">
                <div className="flex items-start justify-between">
                  <div className="flex-1">
                    <div className="flex items-center gap-3 mb-2">
                      {getStatusIcon(step.status)}
                      <h3 className="font-semibold">{step.title}</h3>
                      {getStatusBadge(step.status)}
                    </div>
                    <p className="text-sm text-muted-foreground mb-3">{step.description}</p>
                    <div className="flex items-center gap-4 text-sm">
                      <span className="text-muted-foreground">
                        Documents: {step.documents_uploaded}/{step.documents_required}
                      </span>
                      {step.estimated_days && (
                        <span className="text-muted-foreground">
                          Est. {step.estimated_days} days
                        </span>
                      )}
                    </div>
                    <Progress
                      value={calculateProgress(step.documents_uploaded, step.documents_required)}
                      className="h-2 mt-3"
                    />
                  </div>
                  <Button variant="outline" size="sm">
                    <FileText className="w-4 h-4 mr-2" />
                    Details
                  </Button>
                </div>
              </CardContent>
            </Card>
          ))}
        </TabsContent>

        {/* Documents Tab */}
        <TabsContent value="documents" className="space-y-4">
          <div className="grid gap-4">
            {compliance.documents.map((doc) => (
              <Card key={doc.id}>
                <CardContent className="p-4">
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-3">
                      <FileText className="w-8 h-8 text-primary" />
                      <div>
                        <p className="font-medium">{doc.name}</p>
                        <p className="text-sm text-muted-foreground">
                          {doc.upload_date && `Uploaded: ${new Date(doc.upload_date).toLocaleDateString()}`}
                        </p>
                      </div>
                    </div>
                    <div className="flex items-center gap-2">
                      {getStatusBadge(doc.status)}
                      {doc.url && (
                        <Button variant="ghost" size="sm">
                          <Download className="w-4 h-4" />
                        </Button>
                      )}
                    </div>
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>

          {/* Upload Area */}
          <Card className="border-dashed">
            <CardContent className="p-8 text-center">
              <Upload className="w-12 h-12 mx-auto mb-4 text-muted-foreground" />
              <h3 className="font-semibold mb-2">Upload Additional Documents</h3>
              <p className="text-sm text-muted-foreground mb-4">
                Drag and drop files here or click to browse
              </p>
              <Button>Select Files</Button>
            </CardContent>
          </Card>
        </TabsContent>

        {/* Timeline Tab */}
        <TabsContent value="timeline">
          <ComplianceTimeline steps={compliance.steps} />
        </TabsContent>

        {/* Shipping Tab */}
        <TabsContent value="shipping">
          <ShippingDetails orderId={orderId || compliance.order_id} />
        </TabsContent>
      </Tabs>
    </div>
  )
}

// Compliance Timeline Component
function ComplianceTimeline({ steps }: { steps: ComplianceStep[] }) {
  const getStatusIcon = (status: string) => {
    switch (status) {
      case 'completed':
        return <CheckCircle className="w-5 h-5 text-green-500" />
      case 'in_progress':
        return <Clock className="w-5 h-5 text-yellow-500" />
      case 'failed':
        return <AlertCircle className="w-5 h-5 text-red-500" />
      default:
        return <Clock className="w-5 h-5 text-gray-400" />
    }
  }

  const getStatusBadge = (status: string) => {
    const variants: Record<string, any> = {
      completed: 'default',
      in_progress: 'secondary',
      failed: 'destructive',
      pending: 'outline',
    }
    return (
      <Badge variant={variants[status] || 'outline'}>
        {status.replace(/_/g, ' ').toUpperCase()}
      </Badge>
    )
  }

  return (
    <Card>
      <CardHeader>
        <CardTitle>Compliance Timeline</CardTitle>
      </CardHeader>
      <CardContent>
        <div className="relative">
          {steps.map((step, index) => (
            <div key={step.id} className="flex gap-4 pb-8 last:pb-0">
              {/* Timeline line */}
              {index < steps.length - 1 && (
                <div className="absolute left-[19px] top-12 w-0.5 h-full bg-border" />
              )}

              {/* Icon */}
              <div className="relative z-10 w-10 h-10 rounded-full bg-background border-2 border-border flex items-center justify-center">
                {getStatusIcon(step.status)}
              </div>

              {/* Content */}
              <div className="flex-1 pb-8">
                <div className="flex items-center justify-between mb-1">
                  <h4 className="font-semibold">{step.title}</h4>
                  {getStatusBadge(step.status)}
                </div>
                <p className="text-sm text-muted-foreground">{step.description}</p>
              </div>
            </div>
          ))}
        </div>
      </CardContent>
    </Card>
  )
}

// Shipping Details Component
function ShippingDetails({ orderId }: { orderId: string }) {
  const [shipping, setShipping] = useState({
    vessel: 'MV Qatar Navigator',
    voyage: 'QN-2025-042',
    departure_port: 'Shanghai, China',
    arrival_port: 'Hamad Port, Qatar',
    departure_date: '2025-01-20',
    estimated_arrival: '2025-02-15',
    current_location: 'Strait of Malacca',
    status: 'In Transit',
    coordinates: { lat: 1.5, lng: 104.0 },
  })

  return (
    <div className="space-y-4">
      {/* Ship Information */}
      <Card>
        <CardHeader>
          <div className="flex items-center justify-between">
            <CardTitle className="flex items-center gap-2">
              <Ship className="w-5 h-5" />
              Vessel Information
            </CardTitle>
            <Badge variant="secondary">{shipping.status}</Badge>
          </div>
        </CardHeader>
        <CardContent>
          <div className="grid md:grid-cols-2 gap-4">
            <div>
              <p className="text-sm text-muted-foreground">Vessel Name</p>
              <p className="font-semibold">{shipping.vessel}</p>
            </div>
            <div>
              <p className="text-sm text-muted-foreground">Voyage Number</p>
              <p className="font-semibold">{shipping.voyage}</p>
            </div>
            <div>
              <p className="text-sm text-muted-foreground">Departure Port</p>
              <p className="font-semibold">{shipping.departure_port}</p>
            </div>
            <div>
              <p className="text-sm text-muted-foreground">Arrival Port</p>
              <p className="font-semibold">{shipping.arrival_port}</p>
            </div>
            <div>
              <p className="text-sm text-muted-foreground">Departure Date</p>
              <p className="font-semibold">{new Date(shipping.departure_date).toLocaleDateString()}</p>
            </div>
            <div>
              <p className="text-sm text-muted-foreground">Estimated Arrival</p>
              <p className="font-semibold">{new Date(shipping.estimated_arrival).toLocaleDateString()}</p>
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Current Location */}
      <Card>
        <CardHeader>
          <CardTitle>Current Location</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="space-y-4">
            <div className="aspect-video bg-slate-100 dark:bg-slate-800 rounded-lg relative overflow-hidden">
              {/* Simplified map visualization */}
              <div className="absolute inset-0 bg-[radial-gradient(circle_at_2px_2px,currentColor_1px,transparent_0)] bg-[size:20px_20px] opacity-20" />
              <div className="absolute inset-0 flex items-center justify-center">
                <div className="text-center">
                  <Ship className="w-12 h-12 mx-auto mb-2 text-primary" />
                  <p className="text-sm font-medium">{shipping.current_location}</p>
                  <p className="text-xs text-muted-foreground">
                    {shipping.coordinates.lat}°N, {shipping.coordinates.lng}°E
                  </p>
                </div>
              </div>
            </div>
            <div className="flex items-center justify-between text-sm">
              <span className="text-muted-foreground">Last updated: 2 hours ago</span>
              <Button variant="outline" size="sm">
                <ClipboardCheck className="w-4 h-4 mr-2" />
                View Full Shipping Documents
              </Button>
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Hamad Port Integration Note */}
      <Card className="border-primary/30">
        <CardContent className="p-4">
          <div className="flex items-start gap-3">
            <AlertCircle className="w-5 h-5 text-accent mt-0.5" />
            <div>
              <p className="font-medium text-sm">Hamad Port Integration</p>
              <p className="text-xs text-muted-foreground mt-1">
                Real-time port data integration requires official API access. Current data is simulated
                for demonstration purposes.
              </p>
            </div>
          </div>
        </CardContent>
      </Card>
    </div>
  )
}

// Helper function for status icons
function getStatusIcon(status: string) {
  switch (status) {
    case 'completed':
    case 'approved':
      return <CheckCircle className="w-5 h-5 text-green-500" />
    case 'in_progress':
    case 'under_review':
      return <Clock className="w-5 h-5 text-yellow-500" />
    case 'failed':
    case 'rejected':
      return <AlertCircle className="w-5 h-5 text-red-500" />
    default:
      return <Clock className="w-5 h-5 text-gray-400" />
  }
}
