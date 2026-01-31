'use client'

import { useState } from 'react'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Textarea } from '@/components/ui/textarea'
import { Progress } from '@/components/ui/progress'
import {
  FileText,
  Upload,
  CheckCircle,
  Clock,
  AlertCircle,
  Send,
  Download,
  File,
  Eye,
  Globe,
} from 'lucide-react'
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select'

type PermitStatus = 'draft' | 'pending_review' | 'under_review' | 'approved' | 'rejected' | 'issued'

interface ImportPermit {
  id: string
  permit_type: string
  permit_number?: string
  status: PermitStatus
  application_date?: string
  issue_date?: string
  expiry_date?: string
  documents: PermitDocument[]
  applicant: ApplicantDetails
  vehicle: VehicleDetails
  comments?: string[]
}

interface PermitDocument {
  id: string
  name: string
  type: string
  status: 'pending' | 'submitted' | 'approved' | 'rejected'
  url?: string
}

interface ApplicantDetails {
  name: string
  company_name?: string
  nationality: string
  qatar_id: string
  phone: string
  email: string
  address: string
  type: 'individual' | 'company'
}

interface VehicleDetails {
  manufacturer: string
  model: string
  year: number
  chassis_number: string
  engine_number: string
  color: string
  value: number
  currency: string
  country_of_origin: string
  country_of_purchase: string
  vehicle_type: 'ev' | 'phev' | 'hybrid'
  battery_capacity: number
  range_km: number
}

// Mock import permit data
const mockImportPermit: ImportPermit = {
  id: 'permit-001',
  permit_type: 'vehicle_import',
  status: 'draft',
  documents: [],
  applicant: {
    name: 'Ahmed Al-Mansouri',
    company_name: '',
    nationality: 'Qatari',
    qatar_id: '30012345678',
    phone: '+974 5555 1234',
    email: 'ahmed.almansouri@email.com',
    address: 'Al Dafna, Tower 1, Apartment 502, Doha, Qatar',
    type: 'individual',
  },
  vehicle: {
    manufacturer: 'BYD',
    model: 'Seal',
    year: 2025,
    chassis_number: 'LGXEE4A55LA001234',
    engine_number: 'BYD2025SEAL001',
    color: 'Pearl White',
    value: 145000,
    currency: 'QAR',
    country_of_origin: 'China',
    country_of_purchase: 'China',
    vehicle_type: 'ev',
    battery_capacity: 82.5,
    range_km: 570,
  },
}

// Required documents for import permit
const REQUIRED_PERMIT_DOCUMENTS = [
  {
    id: 'doc-1',
    name: 'Import Permit Application Form',
    type: 'application_form',
    description: 'Duly signed application form',
    required: true,
  },
  {
    id: 'doc-2',
    name: 'Copy of Qatar ID',
    type: 'id_copy',
    description: 'Valid Qatari ID for individuals / CR for companies',
    required: true,
  },
  {
    id: 'doc-3',
    name: 'Commercial Invoice',
    type: 'invoice',
    description: 'Original commercial invoice from manufacturer',
    required: true,
  },
  {
    id: 'doc-4',
    name: 'Certificate of Origin',
    type: 'certificate',
    description: 'Certificate of origin from exporting country',
    required: true,
  },
  {
    id: 'doc-5',
    name: 'Proforma Invoice',
    type: 'proforma',
    description: 'Proforma invoice showing vehicle details and value',
    required: true,
  },
  {
    id: 'doc-6',
    name: 'Certificate of Conformity',
    type: 'coc',
    description: 'Gulf Standard Conformity Certificate',
    required: true,
  },
  {
    id: 'doc-7',
    name: 'Insurance Certificate',
    type: 'insurance',
    description: 'Valid vehicle insurance certificate',
    required: false,
  },
]

const PERMIT_TYPES = [
  { value: 'personal_import', label: 'Personal Import Permit' },
  { value: 'commercial_import', label: 'Commercial Import Permit' },
  { value: 'temporary_import', label: 'Temporary Import Permit' },
  { value: 'diplomatic_import', label: 'Diplomatic Import Permit' },
]

export default function ImportPermitAutomation({ orderId }: { orderId?: string }) {
  const [permit, setPermit] = useState<ImportPermit>(mockImportPermit)
  const [currentStep, setCurrentStep] = useState<'applicant' | 'vehicle' | 'documents' | 'review' | 'submit'>('applicant')
  const [selectedDocType, setSelectedDocType] = useState<string | null>(null)
  const [uploading, setUploading] = useState(false)
  const [submitting, setSubmitting] = useState(false)

  const uploadedDocs = permit.documents.filter((d) => d.status === 'submitted' || d.status === 'approved').length
  const totalRequiredDocs = REQUIRED_PERMIT_DOCUMENTS.filter((d) => d.required).length
  const uploadProgress = (uploadedDocs / totalRequiredDocs) * 100

  const handleDocumentUpload = async (docId: string) => {
    setUploading(true)
    setSelectedDocType(docId)

    // Simulate upload
    await new Promise((resolve) => setTimeout(resolve, 2000))

    const doc = REQUIRED_PERMIT_DOCUMENTS.find((d) => d.id === docId)
    if (doc) {
      setPermit({
        ...permit,
        documents: [
          ...permit.documents,
          {
            id: `uploaded-${Date.now()}`,
            name: doc.name,
            type: doc.type,
            status: 'submitted',
            url: `/permits/${docId}.pdf`,
          },
        ],
      })
    }

    setUploading(false)
    setSelectedDocType(null)
  }

  const handleRemoveDocument = (docId: string) => {
    setPermit({
      ...permit,
      documents: permit.documents.filter((d) => d.id !== docId),
    })
  }

  const handleSubmitApplication = async () => {
    setSubmitting(true)
    // Simulate submission
    await new Promise((resolve) => setTimeout(resolve, 3000))

    setPermit({
      ...permit,
      status: 'pending_review',
      application_date: new Date().toISOString(),
      permit_number: `QEV-IMP-${Date.now()}`,
    })
    setSubmitting(false)
    setCurrentStep('submit')
  }

  const getStatusBadge = (status: PermitStatus) => {
    const variants: Record<PermitStatus, any> = {
      draft: 'outline',
      pending_review: 'secondary',
      under_review: 'secondary',
      approved: 'default',
      rejected: 'destructive',
      issued: 'default',
    }
    return <Badge variant={variants[status]}>{status.replace(/_/g, ' ').toUpperCase()}</Badge>
  }

  const getStatusIcon = (status: PermitStatus) => {
    switch (status) {
      case 'approved':
      case 'issued':
        return <CheckCircle className="w-5 h-5 text-green-500" />
      case 'rejected':
        return <AlertCircle className="w-5 h-5 text-red-500" />
      case 'pending_review':
      case 'under_review':
        return <Clock className="w-5 h-5 text-yellow-500" />
      default:
        return <File className="w-5 h-5 text-gray-400" />
    }
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <Card>
        <CardHeader>
          <div className="flex items-center justify-between">
            <div>
              <CardTitle>Import Permit Application</CardTitle>
              <p className="text-sm text-muted-foreground mt-1">
                Ministry of Commerce & Industry - Vehicle Import Authorization
              </p>
            </div>
            <div className="flex items-center gap-2">
              {getStatusIcon(permit.status)}
              {getStatusBadge(permit.status)}
            </div>
          </div>
        </CardHeader>
        {permit.permit_number && (
          <CardContent>
            <div className="bg-blue-50 dark:bg-blue-900/20 border border-blue-200 dark:border-blue-800 rounded-lg p-4">
              <p className="text-sm font-medium">Application Reference</p>
              <p className="text-lg font-bold text-blue-600 dark:text-blue-400">
                {permit.permit_number}
              </p>
            </div>
          </CardContent>
        )}
      </Card>

      {/* Progress Steps */}
      <Card>
        <CardContent className="p-6">
          <div className="flex items-center justify-between">
            {[
              { key: 'applicant', label: 'Applicant', icon: '👤' },
              { key: 'vehicle', label: 'Vehicle', icon: '🚗' },
              { key: 'documents', label: 'Documents', icon: '📄' },
              { key: 'review', label: 'Review', icon: '✅' },
              { key: 'submit', label: 'Submit', icon: '📤' },
            ].map((step, index) => {
              const steps = ['applicant', 'vehicle', 'documents', 'review', 'submit']
              const currentIndex = steps.indexOf(currentStep)
              const isActive = currentStep === step.key
              const isCompleted = index < currentIndex

              return (
                <div key={step.key} className="flex items-center flex-1">
                  <button
                    onClick={() => index <= currentIndex && setCurrentStep(step.key as any)}
                    className={`flex flex-col items-center gap-2 transition-all ${
                      isActive ? 'scale-110' : ''
                    } ${isCompleted || isActive ? 'cursor-pointer' : 'cursor-not-allowed opacity-50'}`}
                    disabled={index > currentIndex}
                  >
                    <div
                      className={`w-12 h-12 rounded-full flex items-center justify-center border-2 transition-all ${
                        isCompleted
                          ? 'bg-green-500 border-green-500 text-white'
                          : isActive
                            ? 'bg-primary border-primary text-white'
                            : 'bg-muted border-muted text-muted-foreground'
                      }`}
                    >
                      <span className="text-lg">{step.icon}</span>
                    </div>
                    <span className="text-xs font-medium">{step.label}</span>
                  </button>
                  {index < 4 && (
                    <div className="flex-1 h-0.5 bg-border mx-2 relative">
                      {isCompleted && (
                        <div className="h-full bg-green-500 absolute left-0 top-0 transition-all" />
                      )}
                    </div>
                  )}
                </div>
              )
            })}
          </div>
        </CardContent>
      </Card>

      {/* Step Content */}
      {currentStep === 'applicant' && (
        <ApplicantDetailsStep
          applicant={permit.applicant}
          onUpdate={(applicant) => setPermit({ ...permit, applicant })}
          onNext={() => setCurrentStep('vehicle')}
        />
      )}

      {currentStep === 'vehicle' && (
        <VehicleDetailsStep
          vehicle={permit.vehicle}
          onUpdate={(vehicle) => setPermit({ ...permit, vehicle })}
          onNext={() => setCurrentStep('documents')}
          onBack={() => setCurrentStep('applicant')}
        />
      )}

      {currentStep === 'documents' && (
        <DocumentsStep
          documents={permit.documents}
          requiredDocs={REQUIRED_PERMIT_DOCUMENTS}
          uploading={uploading}
          selectedDocType={selectedDocType}
          onUpload={handleDocumentUpload}
          onRemove={handleRemoveDocument}
          onNext={() => setCurrentStep('review')}
          onBack={() => setCurrentStep('vehicle')}
        />
      )}

      {currentStep === 'review' && (
        <ReviewStep
          permit={permit}
          onSubmit={handleSubmitApplication}
          onBack={() => setCurrentStep('documents')}
          submitting={submitting}
        />
      )}

      {currentStep === 'submit' && (
        <SubmittedStep permit={permit} onUpdate={() => setCurrentStep('applicant')} />
      )}
    </div>
  )
}

// Applicant Details Step
function ApplicantDetailsStep({
  applicant,
  onUpdate,
  onNext,
}: {
  applicant: ApplicantDetails
  onUpdate: (applicant: ApplicantDetails) => void
  onNext: () => void
}) {
  const [localData, setLocalData] = useState(applicant)

  return (
    <Card>
      <CardHeader>
        <CardTitle>Applicant Information</CardTitle>
        <p className="text-sm text-muted-foreground">
          Provide details about the person or company importing the vehicle
        </p>
      </CardHeader>
      <CardContent>
        <div className="space-y-4">
          <div className="grid md:grid-cols-2 gap-4">
            <div>
              <Label>Applicant Type</Label>
              <Select
                value={localData.type}
                onValueChange={(value: any) => setLocalData({ ...localData, type: value })}
              >
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="individual">Individual</SelectItem>
                  <SelectItem value="company">Company</SelectItem>
                </SelectContent>
              </Select>
            </div>
            <div>
              <Label>Nationality</Label>
              <Input
                value={localData.nationality}
                onChange={(e) => setLocalData({ ...localData, nationality: e.target.value })}
              />
            </div>
          </div>

          <div>
            <Label>Full Name</Label>
            <Input
              value={localData.name}
              onChange={(e) => setLocalData({ ...localData, name: e.target.value })}
            />
          </div>

          {localData.type === 'company' && (
            <div>
              <Label>Company Name</Label>
              <Input
                value={localData.company_name}
                onChange={(e) => setLocalData({ ...localData, company_name: e.target.value })}
              />
            </div>
          )}

          <div className="grid md:grid-cols-2 gap-4">
            <div>
              <Label>Qatar ID / CR Number</Label>
              <Input
                value={localData.qatar_id}
                onChange={(e) => setLocalData({ ...localData, qatar_id: e.target.value })}
              />
            </div>
            <div>
              <Label>Phone Number</Label>
              <Input
                value={localData.phone}
                onChange={(e) => setLocalData({ ...localData, phone: e.target.value })}
              />
            </div>
          </div>

          <div>
            <Label>Email Address</Label>
            <Input
              type="email"
              value={localData.email}
              onChange={(e) => setLocalData({ ...localData, email: e.target.value })}
            />
          </div>

          <div>
            <Label>Address</Label>
            <Textarea
              value={localData.address}
              onChange={(e) => setLocalData({ ...localData, address: e.target.value })}
            />
          </div>
        </div>

        <div className="flex justify-end mt-6">
          <Button onClick={() => { onUpdate(localData); onNext() }}>Continue</Button>
        </div>
      </CardContent>
    </Card>
  )
}

// Vehicle Details Step
function VehicleDetailsStep({
  vehicle,
  onUpdate,
  onNext,
  onBack,
}: {
  vehicle: VehicleDetails
  onUpdate: (vehicle: VehicleDetails) => void
  onNext: () => void
  onBack: () => void
}) {
  const [localData, setLocalData] = useState(vehicle)

  return (
    <Card>
      <CardHeader>
        <CardTitle>Vehicle Information</CardTitle>
        <p className="text-sm text-muted-foreground">
          Provide details about the vehicle being imported
        </p>
      </CardHeader>
      <CardContent>
        <div className="grid md:grid-cols-3 gap-4">
          <div>
            <Label>Manufacturer</Label>
            <Input
              value={localData.manufacturer}
              onChange={(e) => setLocalData({ ...localData, manufacturer: e.target.value })}
            />
          </div>
          <div>
            <Label>Model</Label>
            <Input
              value={localData.model}
              onChange={(e) => setLocalData({ ...localData, model: e.target.value })}
            />
          </div>
          <div>
            <Label>Year</Label>
            <Input
              type="number"
              value={localData.year}
              onChange={(e) => setLocalData({ ...localData, year: parseInt(e.target.value) })}
            />
          </div>

          <div className="md:col-span-2">
            <Label>Chassis Number (VIN)</Label>
            <Input
              value={localData.chassis_number}
              onChange={(e) => setLocalData({ ...localData, chassis_number: e.target.value })}
              className="font-mono"
            />
          </div>
          <div>
            <Label>Engine Number</Label>
            <Input
              value={localData.engine_number}
              onChange={(e) => setLocalData({ ...localData, engine_number: e.target.value })}
              className="font-mono"
            />
          </div>

          <div>
            <Label>Color</Label>
            <Input
              value={localData.color}
              onChange={(e) => setLocalData({ ...localData, color: e.target.value })}
            />
          </div>
          <div>
            <Label>Vehicle Type</Label>
            <Select
              value={localData.vehicle_type}
              onValueChange={(value: any) => setLocalData({ ...localData, vehicle_type: value })}
            >
              <SelectTrigger>
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="ev">Electric Vehicle (EV)</SelectItem>
                <SelectItem value="phev">Plug-in Hybrid (PHEV)</SelectItem>
                <SelectItem value="hybrid">Hybrid</SelectItem>
              </SelectContent>
            </Select>
          </div>
          <div>
            <Label>Value (QAR)</Label>
            <Input
              type="number"
              value={localData.value}
              onChange={(e) => setLocalData({ ...localData, value: parseFloat(e.target.value) })}
            />
          </div>

          <div className="md:col-span-2">
            <Label>Country of Origin</Label>
            <Input
              value={localData.country_of_origin}
              onChange={(e) => setLocalData({ ...localData, country_of_origin: e.target.value })}
              disabled
            />
          </div>
          <div>
            <Label>Country of Purchase</Label>
            <Input
              value={localData.country_of_purchase}
              onChange={(e) => setLocalData({ ...localData, country_of_purchase: e.target.value })}
            />
          </div>

          <div>
            <Label>Battery Capacity (kWh)</Label>
            <Input
              type="number"
              step="0.1"
              value={localData.battery_capacity}
              onChange={(e) => setLocalData({ ...localData, battery_capacity: parseFloat(e.target.value) })}
            />
          </div>
          <div>
            <Label>Range (km)</Label>
            <Input
              type="number"
              value={localData.range_km}
              onChange={(e) => setLocalData({ ...localData, range_km: parseInt(e.target.value) })}
            />
          </div>
        </div>

        <div className="flex justify-between mt-6">
          <Button variant="outline" onClick={onBack}>
            Back
          </Button>
          <Button onClick={() => { onUpdate(localData); onNext() }}>Continue</Button>
        </div>
      </CardContent>
    </Card>
  )
}

// Documents Step
function DocumentsStep({
  documents,
  requiredDocs,
  uploading,
  selectedDocType,
  onUpload,
  onRemove,
  onNext,
  onBack,
}: {
  documents: PermitDocument[]
  requiredDocs: any[]
  uploading: boolean
  selectedDocType: string | null
  onUpload: (docId: string) => void
  onRemove: (docId: string) => void
  onNext: () => void
  onBack: () => void
}) {
  const uploadedDocs = documents.filter((d) => d.status === 'submitted' || d.status === 'approved').length
  const totalRequiredDocs = requiredDocs.filter((d) => d.required).length
  const uploadProgress = (uploadedDocs / totalRequiredDocs) * 100
  const canContinue = uploadedDocs >= totalRequiredDocs

  return (
    <Card>
      <CardHeader>
        <CardTitle>Required Documents</CardTitle>
        <p className="text-sm text-muted-foreground">
          Upload all required documents to complete your application
        </p>
      </CardHeader>
      <CardContent>
        <div className="mb-6">
          <div className="flex justify-between text-sm mb-2">
            <span>Upload Progress</span>
            <span className="font-medium">{uploadedDocs}/{totalRequiredDocs} documents</span>
          </div>
          <Progress value={uploadProgress} className="h-2" />
        </div>

        <div className="space-y-3">
          {requiredDocs.map((doc) => {
            const uploadedDoc = documents.find((d) => d.type === doc.type)
            const isUploaded = !!uploadedDoc

            return (
              <div key={doc.id} className="flex items-center justify-between p-4 border rounded-lg">
                <div className="flex items-center gap-3">
                  <div
                    className={`w-10 h-10 rounded-lg flex items-center justify-center ${
                      isUploaded ? 'bg-green-100 dark:bg-green-900/30' : 'bg-muted'
                    }`}
                  >
                    {isUploaded ? (
                      <CheckCircle className="w-5 h-5 text-green-500" />
                    ) : (
                      <FileText className="w-5 h-5 text-muted-foreground" />
                    )}
                  </div>
                  <div>
                    <div className="flex items-center gap-2">
                      <p className="font-medium">{doc.name}</p>
                      {doc.required && <Badge variant="destructive" className="text-xs">Required</Badge>}
                      {isUploaded && <Badge variant="default">Uploaded</Badge>}
                    </div>
                    <p className="text-xs text-muted-foreground">{doc.description}</p>
                  </div>
                </div>

                <div className="flex items-center gap-2">
                  {isUploaded ? (
                    <>
                      <Button size="sm" variant="outline">
                        <Eye className="w-4 h-4 mr-2" />
                        View
                      </Button>
                      <Button
                        size="sm"
                        variant="ghost"
                        onClick={() => onRemove(uploadedDoc!.id)}
                      >
                        Remove
                      </Button>
                    </>
                  ) : (
                    <Button
                      size="sm"
                      onClick={() => onUpload(doc.id)}
                      disabled={uploading && selectedDocType === doc.id}
                    >
                      {uploading && selectedDocType === doc.id ? (
                        'Uploading...'
                      ) : (
                        <>
                          <Upload className="w-4 h-4 mr-2" />
                          Upload
                        </>
                      )}
                    </Button>
                  )}
                </div>
              </div>
            )
          })}
        </div>

        <div className="flex justify-between mt-6">
          <Button variant="outline" onClick={onBack}>
            Back
          </Button>
          <Button disabled={!canContinue} onClick={onNext}>
            Review Application
          </Button>
        </div>
      </CardContent>
    </Card>
  )
}

// Review Step
function ReviewStep({
  permit,
  onSubmit,
  onBack,
  submitting,
}: {
  permit: ImportPermit
  onSubmit: () => void
  onBack: () => void
  submitting: boolean
}) {
  return (
    <div className="space-y-4">
      <Card>
        <CardHeader>
          <CardTitle>Review Application</CardTitle>
          <p className="text-sm text-muted-foreground">
            Review all information before submitting your application
          </p>
        </CardHeader>
        <CardContent>
          <div className="space-y-6">
            {/* Applicant Summary */}
            <div>
              <h3 className="font-semibold mb-2">Applicant</h3>
              <div className="bg-muted/50 p-4 rounded-lg space-y-1">
                <p className="text-sm"><span className="text-muted-foreground">Name:</span> {permit.applicant.name}</p>
                <p className="text-sm"><span className="text-muted-foreground">Type:</span> {permit.applicant.type}</p>
                <p className="text-sm"><span className="text-muted-foreground">Qatar ID:</span> {permit.applicant.qatar_id}</p>
                <p className="text-sm"><span className="text-muted-foreground">Email:</span> {permit.applicant.email}</p>
              </div>
            </div>

            {/* Vehicle Summary */}
            <div>
              <h3 className="font-semibold mb-2">Vehicle</h3>
              <div className="bg-muted/50 p-4 rounded-lg space-y-1">
                <p className="text-sm"><span className="text-muted-foreground">Vehicle:</span> {permit.vehicle.manufacturer} {permit.vehicle.model} ({permit.vehicle.year})</p>
                <p className="text-sm"><span className="text-muted-foreground">Type:</span> {permit.vehicle.vehicle_type.toUpperCase()}</p>
                <p className="text-sm"><span className="text-muted-foreground">VIN:</span> {permit.vehicle.chassis_number}</p>
                <p className="text-sm"><span className="text-muted-foreground">Value:</span> QAR {permit.vehicle.value.toLocaleString()}</p>
              </div>
            </div>

            {/* Documents Summary */}
            <div>
              <h3 className="font-semibold mb-2">Documents</h3>
              <div className="bg-muted/50 p-4 rounded-lg">
                <p className="text-sm">{permit.documents.length} documents uploaded</p>
              </div>
            </div>
          </div>

          <div className="p-4 bg-yellow-50 dark:bg-yellow-900/20 border border-yellow-200 dark:border-yellow-800 rounded-lg">
            <div className="flex items-start gap-3">
              <AlertCircle className="w-5 h-5 text-yellow-600 dark:text-yellow-400 mt-0.5" />
              <div>
                <p className="font-medium text-sm">Important Notes</p>
                <ul className="text-xs text-muted-foreground mt-2 space-y-1">
                  <li>• Processing typically takes 5-7 working days</li>
                  <li>• You will receive email notifications for status updates</li>
                  <li>• Keep all original documents for physical verification</li>
                </ul>
              </div>
            </div>
          </div>
        </CardContent>
      </Card>

      <div className="flex justify-between">
        <Button variant="outline" onClick={onBack}>
          Back to Documents
        </Button>
        <Button onClick={onSubmit} disabled={submitting} className="min-w-[200px]">
          {submitting ? (
            'Submitting...'
          ) : (
            <>
              <Send className="w-4 h-4 mr-2" />
              Submit Application
            </>
          )}
        </Button>
      </div>
    </div>
  )
}

// Submitted Step
function SubmittedStep({
  permit,
  onUpdate,
}: {
  permit: ImportPermit
  onUpdate: () => void
}) {
  return (
    <Card>
      <CardContent className="py-12 text-center">
        <div className="w-20 h-20 bg-green-100 dark:bg-green-900/30 rounded-full flex items-center justify-center mx-auto mb-6">
          <CheckCircle className="w-10 h-10 text-green-500" />
        </div>
        <h2 className="text-2xl font-bold mb-2">Application Submitted</h2>
        <p className="text-muted-foreground mb-4">
          Your import permit application has been submitted successfully
        </p>

        <div className="bg-muted/50 p-4 rounded-lg max-w-md mx-auto mb-6">
          <p className="text-sm text-muted-foreground">Application Reference</p>
          <p className="text-xl font-bold text-primary">{permit.permit_number}</p>
          <p className="text-xs text-muted-foreground mt-2">
            Submitted: {new Date(permit.application_date!).toLocaleString()}
          </p>
        </div>

        <div className="bg-blue-50 dark:bg-blue-900/20 border border-blue-200 dark:border-blue-800 rounded-lg p-4 max-w-md mx-auto mb-6">
          <div className="flex items-start gap-3">
            <Clock className="w-5 h-5 text-blue-500 mt-0.5" />
            <div className="text-left">
              <p className="font-medium text-sm">What happens next?</p>
              <ul className="text-xs text-muted-foreground mt-2 space-y-1">
                <li>• Your application will be reviewed by MOCI officials</li>
                <li>• You'll receive email updates at each stage</li>
                <li>• Once approved, you can download the permit from this portal</li>
              </ul>
            </div>
          </div>
        </div>

        <div className="flex justify-center gap-4">
          <Button variant="outline" onClick={onUpdate}>
            Start New Application
          </Button>
          <Button>
            <Download className="w-4 h-4 mr-2" />
            Download Receipt
          </Button>
        </div>
      </CardContent>
    </Card>
  )
}
