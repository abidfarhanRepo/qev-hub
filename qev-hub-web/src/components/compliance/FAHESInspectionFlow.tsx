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
  CheckCircle,
  Clock,
  AlertCircle,
  Calendar,
  FileText,
  Upload,
  Car,
  Zap,
} from 'lucide-react'

type InspectionStatus = 'scheduled' | 'pending_documents' | 'in_review' | 'approved' | 'rejected'

interface InspectionSlot {
  id: string
  date: string
  time: string
  location: string
  available: boolean
}

interface FAHESInspectionData {
  status: InspectionStatus
  inspection_id?: string
  scheduled_date?: string
  scheduled_time?: string
  center_location?: string
  documents_required: DocumentRequirement[]
  inspection_checklist: InspectionChecklist[]
}

interface DocumentRequirement {
  id: string
  name: string
  description: string
  uploaded: boolean
  file_url?: string
}

interface InspectionChecklist {
  id: string
  category: string
  items: ChecklistItem[]
}

interface ChecklistItem {
  id: string
  description: string
  requirement: string
  status: 'pending' | 'pass' | 'fail' | 'na'
}

// Mock data - simulating FAHES inspection workflow
const mockInspectionData: FAHESInspectionData = {
  status: 'pending_documents',
  documents_required: [
    {
      id: 'doc-1',
      name: 'Vehicle Purchase Invoice',
      description: 'Original invoice from manufacturer showing vehicle details and value',
      uploaded: true,
      file_url: '/documents/invoice.pdf',
    },
    {
      id: 'doc-2',
      name: 'Certificate of Conformity',
      description: 'CoC from manufacturer confirming compliance with Qatar standards',
      uploaded: false,
    },
    {
      id: 'doc-3',
      name: 'Technical Specifications',
      description: 'Detailed technical specifications including battery and safety systems',
      uploaded: false,
    },
    {
      id: 'doc-4',
      name: 'Insurance Certificate',
      description: 'Valid vehicle insurance policy',
      uploaded: false,
    },
  ],
  inspection_checklist: [
    {
      id: 'cat-1',
      category: 'Vehicle Identification',
      items: [
        { id: 'item-1', description: 'VIN verification', requirement: 'Must match manufacturer documents', status: 'pending' },
        { id: 'item-2', description: 'Engine/Electric Motor number', requirement: 'Valid motor identification', status: 'pending' },
        { id: 'item-3', description: 'Vehicle registration eligibility', requirement: 'Not previously registered in another country', status: 'pending' },
      ],
    },
    {
      id: 'cat-2',
      category: 'Safety Systems',
      items: [
        { id: 'item-4', description: 'Braking system', requirement: 'Functional brakes meeting Qatar standards', status: 'pending' },
        { id: 'item-5', description: 'Lighting and signals', requirement: 'All lights operational', status: 'pending' },
        { id: 'item-6', description: 'Seat belts and airbags', requirement: 'Properly installed and functional', status: 'pending' },
        { id: 'item-7', description: 'Tires', requirement: 'Adequate tread depth and proper size', status: 'pending' },
      ],
    },
    {
      id: 'cat-3',
      category: 'EV-Specific Requirements',
      items: [
        { id: 'item-8', description: 'Battery certification', requirement: 'UN 38.3 safety certification', status: 'pending' },
        { id: 'item-9', description: 'Charging system', requirement: 'Compatible with Qatar charging infrastructure', status: 'pending' },
        { id: 'item-10', description: 'High voltage safety', requirement: 'Proper insulation and safety markings', status: 'pending' },
        { id: 'item-11', description: 'Emergency disconnect', requirement: 'Accessible emergency shut-off mechanism', status: 'pending' },
      ],
    },
    {
      id: 'cat-4',
      category: 'Emissions & Compliance',
      items: [
        { id: 'item-12', description: 'Zero emissions certification', requirement: 'EV produces no direct emissions', status: 'pass' },
        { id: 'item-13', description: 'Sound generator', requirement: 'AVAS (Acoustic Vehicle Alerting System) for pedestrian safety', status: 'pending' },
      ],
    },
  ],
}

// Available inspection slots (simulated)
const availableSlots: InspectionSlot[] = [
  { id: 'slot-1', date: '2025-02-10', time: '08:00 - 10:00', location: 'Industrial Area', available: true },
  { id: 'slot-2', date: '2025-02-10', time: '10:00 - 12:00', location: 'Industrial Area', available: true },
  { id: 'slot-3', date: '2025-02-10', time: '14:00 - 16:00', location: 'Industrial Area', available: false },
  { id: 'slot-4', date: '2025-02-11', time: '08:00 - 10:00', location: 'Dukhan', available: true },
  { id: 'slot-5', date: '2025-02-11', time: '10:00 - 12:00', location: 'Dukhan', available: true },
  { id: 'slot-6', date: '2025-02-12', time: '08:00 - 10:00', location: 'Industrial Area', available: true },
]

const FAHES_CENTERS = [
  { id: 'center-1', name: 'Industrial Area Inspection Center', address: 'Industrial Area, Street 23, Doha', capacity: 40 },
  { id: 'center-2', name: 'Dukhan Inspection Center', address: 'Dukhan Highway, Al Rayyan', capacity: 25 },
  { id: 'center-3', name: 'Al Khor Inspection Center', address: 'Al Khor Coastal Road', capacity: 20 },
  { id: 'center-4', name: 'Wakra Inspection Center', address: 'Wakra Old Town', capacity: 15 },
]

export default function FAHESInspectionFlow({ orderId }: { orderId?: string }) {
  const [inspectionData, setInspectionData] = useState<FAHESInspectionData>(mockInspectionData)
  const [selectedStep, setSelectedStep] = useState<'documents' | 'schedule' | 'checklist' | 'results'>('documents')
  const [selectedSlot, setSelectedSlot] = useState<InspectionSlot | null>(null)
  const [selectedCenter, setSelectedCenter] = useState(FAHES_CENTERS[0])
  const [uploadingDoc, setUploadingDoc] = useState<string | null>(null)

  // Calculate document upload progress
  const uploadedDocs = inspectionData.documents_required.filter((d) => d.uploaded).length
  const totalDocs = inspectionData.documents_required.length
  const docProgress = (uploadedDocs / totalDocs) * 100

  // Status helper
  const getStatusInfo = (status: InspectionStatus) => {
    switch (status) {
      case 'scheduled':
        return { icon: Calendar, color: 'text-blue-500', label: 'Inspection Scheduled' }
      case 'pending_documents':
        return { icon: FileText, color: 'text-yellow-500', label: 'Pending Documents' }
      case 'in_review':
        return { icon: Clock, color: 'text-yellow-500', label: 'Under Review' }
      case 'approved':
        return { icon: CheckCircle, color: 'text-green-500', label: 'Approved' }
      case 'rejected':
        return { icon: AlertCircle, color: 'text-red-500', label: 'Rejected' }
    }
  }

  const StatusIcon = getStatusInfo(inspectionData.status).icon

  const handleFileUpload = async (docId: string) => {
    setUploadingDoc(docId)
    // Simulate upload delay
    await new Promise((resolve) => setTimeout(resolve, 2000))
    setInspectionData((prev) => ({
      ...prev,
      documents_required: prev.documents_required.map((doc) =>
        doc.id === docId ? { ...doc, uploaded: true, file_url: `/documents/${doc.id}.pdf` } : doc
      ),
    }))
    setUploadingDoc(null)
  }

  const handleScheduleInspection = () => {
    if (selectedSlot) {
      setInspectionData((prev) => ({
        ...prev,
        status: 'scheduled',
        scheduled_date: selectedSlot.date,
        scheduled_time: selectedSlot.time,
        center_location: selectedCenter.name,
      }))
      setSelectedStep('checklist')
    }
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <Card>
        <CardHeader>
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              <div className="p-2 bg-primary/10 rounded-lg">
                <Car className="w-6 h-6 text-primary" />
              </div>
              <div>
                <CardTitle>FAHES Vehicle Inspection</CardTitle>
                <p className="text-sm text-muted-foreground">
                  Qatar General Electricity & Water Corporation Certification
                </p>
              </div>
            </div>
            <div className="flex items-center gap-2">
              <StatusIcon className={`w-5 h-5 ${getStatusInfo(inspectionData.status).color}`} />
              <Badge variant="secondary">{getStatusInfo(inspectionData.status).label}</Badge>
            </div>
          </div>
        </CardHeader>
        {inspectionData.status === 'scheduled' && (
          <CardContent>
            <div className="bg-blue-50 dark:bg-blue-900/20 border border-blue-200 dark:border-blue-800 rounded-lg p-4">
              <div className="flex items-start gap-3">
                <Calendar className="w-5 h-5 text-blue-500 mt-0.5" />
                <div>
                  <p className="font-medium">Inspection Scheduled</p>
                  <p className="text-sm text-muted-foreground mt-1">
                    {inspectionData.scheduled_date} at {inspectionData.scheduled_time}
                  </p>
                  <p className="text-sm text-muted-foreground">
                    Location: {inspectionData.center_location}
                  </p>
                </div>
              </div>
            </div>
          </CardContent>
        )}
      </Card>

      {/* Progress Steps */}
      <Card>
        <CardContent className="p-6">
          <div className="flex items-center justify-between">
            {[
              { key: 'documents', label: 'Documents', icon: FileText },
              { key: 'schedule', label: 'Schedule', icon: Calendar },
              { key: 'checklist', label: 'Checklist', icon: CheckCircle },
              { key: 'results', label: 'Results', icon: Zap },
            ].map((step, index) => {
              const Icon = step.icon
              const isActive = selectedStep === step.key
              const isCompleted = index < ['documents', 'schedule', 'checklist', 'results'].indexOf(selectedStep)

              return (
                <div key={step.key} className="flex items-center flex-1">
                  <button
                    onClick={() => setSelectedStep(step.key as any)}
                    className={`flex flex-col items-center gap-2 transition-all ${
                      isActive ? 'scale-110' : ''
                    } ${isCompleted ? 'cursor-pointer' : isActive ? 'cursor-pointer' : 'cursor-not-allowed opacity-50'}`}
                    disabled={!isCompleted && !isActive}
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
                      {isCompleted ? <CheckCircle className="w-6 h-6" /> : <Icon className="w-6 h-6" />}
                    </div>
                    <span className="text-xs font-medium">{step.label}</span>
                  </button>
                  {index < 3 && (
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

      {/* Documents Step */}
      {selectedStep === 'documents' && (
        <Card>
          <CardHeader>
            <CardTitle>Required Documents</CardTitle>
            <p className="text-sm text-muted-foreground">
              Upload all required documents before scheduling inspection
            </p>
          </CardHeader>
          <CardContent className="space-y-6">
            {/* Progress */}
            <div>
              <div className="flex justify-between text-sm mb-2">
                <span>Upload Progress</span>
                <span className="font-medium">
                  {uploadedDocs}/{totalDocs} documents
                </span>
              </div>
              <Progress value={docProgress} className="h-2" />
            </div>

            {/* Document List */}
            <div className="space-y-3">
              {inspectionData.documents_required.map((doc) => (
                <div
                  key={doc.id}
                  className="flex items-center justify-between p-4 border rounded-lg hover:border-primary/50 transition-colors"
                >
                  <div className="flex items-center gap-3">
                    <div
                      className={`w-10 h-10 rounded-lg flex items-center justify-center ${
                        doc.uploaded ? 'bg-green-100 dark:bg-green-900/30' : 'bg-muted'
                      }`}
                    >
                      {doc.uploaded ? (
                        <CheckCircle className="w-5 h-5 text-green-500" />
                      ) : (
                        <FileText className="w-5 h-5 text-muted-foreground" />
                      )}
                    </div>
                    <div>
                      <p className="font-medium">{doc.name}</p>
                      <p className="text-xs text-muted-foreground">{doc.description}</p>
                    </div>
                  </div>
                  <div className="flex items-center gap-2">
                    {doc.uploaded ? (
                      <Badge variant="default">Uploaded</Badge>
                    ) : (
                      <Button
                        size="sm"
                        onClick={() => handleFileUpload(doc.id)}
                        disabled={uploadingDoc === doc.id}
                      >
                        {uploadingDoc === doc.id ? (
                          <>Uploading...</>
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
              ))}
            </div>

            {/* Continue Button */}
            <div className="flex justify-end">
              <Button
                disabled={uploadedDocs < totalDocs}
                onClick={() => setSelectedStep('schedule')}
                className="min-w-[150px]"
              >
                Continue to Scheduling
              </Button>
            </div>
          </CardContent>
        </Card>
      )}

      {/* Schedule Step */}
      {selectedStep === 'schedule' && (
        <Card>
          <CardHeader>
            <CardTitle>Schedule Inspection</CardTitle>
            <p className="text-sm text-muted-foreground">
              Select an available slot at your preferred FAHES inspection center
            </p>
          </CardHeader>
          <CardContent className="space-y-6">
            {/* Center Selection */}
            <div>
              <Label>Inspection Center</Label>
              <div className="grid md:grid-cols-2 gap-3 mt-2">
                {FAHES_CENTERS.map((center) => (
                  <button
                    key={center.id}
                    onClick={() => setSelectedCenter(center)}
                    className={`p-4 border rounded-lg text-left transition-all ${
                      selectedCenter.id === center.id
                        ? 'border-primary bg-primary/5'
                        : 'hover:border-primary/50'
                    }`}
                  >
                    <p className="font-medium">{center.name}</p>
                    <p className="text-xs text-muted-foreground mt-1">{center.address}</p>
                    <p className="text-xs text-muted-foreground">
                      Daily capacity: {center.capacity} inspections
                    </p>
                  </button>
                ))}
              </div>
            </div>

            {/* Available Slots */}
            <div>
              <Label>Available Time Slots</Label>
              <div className="grid md:grid-cols-3 gap-3 mt-2">
                {availableSlots.map((slot) => (
                  <button
                    key={slot.id}
                    onClick={() => slot.available && setSelectedSlot(slot)}
                    disabled={!slot.available}
                    className={`p-4 border rounded-lg text-left transition-all ${
                      !slot.available
                        ? 'opacity-50 cursor-not-allowed'
                        : selectedSlot?.id === slot.id
                          ? 'border-primary bg-primary/5'
                          : 'hover:border-primary/50'
                    }`}
                  >
                    <div className="flex items-center justify-between mb-2">
                      <p className="font-medium">{slot.time}</p>
                      {!slot.available && <Badge variant="secondary">Full</Badge>}
                    </div>
                    <p className="text-xs text-muted-foreground">{slot.date}</p>
                    <p className="text-xs text-muted-foreground">{slot.location}</p>
                  </button>
                ))}
              </div>
            </div>

            {/* Confirm */}
            <div className="flex justify-end">
              <Button
                disabled={!selectedSlot}
                onClick={handleScheduleInspection}
                className="min-w-[150px]"
              >
                Confirm Schedule
              </Button>
            </div>
          </CardContent>
        </Card>
      )}

      {/* Checklist Step */}
      {selectedStep === 'checklist' && (
        <Card>
          <CardHeader>
            <CardTitle>Inspection Checklist</CardTitle>
            <p className="text-sm text-muted-foreground">
              Review the items that will be checked during your FAHES inspection
            </p>
          </CardHeader>
          <CardContent>
            <div className="space-y-6">
              {inspectionData.inspection_checklist.map((category) => (
                <div key={category.id}>
                  <h3 className="font-semibold text-lg mb-3">{category.category}</h3>
                  <div className="space-y-2">
                    {category.items.map((item) => {
                      const statusConfig = {
                        pending: { icon: Clock, color: 'text-yellow-500', bg: 'bg-yellow-50 dark:bg-yellow-900/20' },
                        pass: { icon: CheckCircle, color: 'text-green-500', bg: 'bg-green-50 dark:bg-green-900/20' },
                        fail: { icon: AlertCircle, color: 'text-red-500', bg: 'bg-red-50 dark:bg-red-900/20' },
                        na: { icon: AlertCircle, color: 'text-gray-500', bg: 'bg-gray-50 dark:bg-gray-900/20' },
                      }
                      const StatusIcon = statusConfig[item.status].icon

                      return (
                        <div
                          key={item.id}
                          className={`p-4 border rounded-lg ${statusConfig[item.status].bg}`}
                        >
                          <div className="flex items-start justify-between">
                            <div className="flex-1">
                              <div className="flex items-center gap-2 mb-1">
                                <StatusIcon className={`w-4 h-4 ${statusConfig[item.status].color}`} />
                                <p className="font-medium">{item.description}</p>
                              </div>
                              <p className="text-sm text-muted-foreground">{item.requirement}</p>
                            </div>
                            <Badge variant="outline">{item.status.toUpperCase()}</Badge>
                          </div>
                        </div>
                      )
                    })}
                  </div>
                </div>
              ))}
            </div>

            <div className="mt-6 p-4 bg-blue-50 dark:bg-blue-900/20 border border-blue-200 dark:border-blue-800 rounded-lg">
              <div className="flex items-start gap-3">
                <AlertCircle className="w-5 h-5 text-blue-500 mt-0.5" />
                <div>
                  <p className="font-medium">Inspection Day Tips</p>
                  <ul className="text-sm text-muted-foreground mt-2 space-y-1">
                    <li>• Arrive 15 minutes before your scheduled time</li>
                    <li>• Bring all original documents</li>
                    <li>• Ensure vehicle is clean and accessible</li>
                    <li>• Battery should be at least 50% charged</li>
                  </ul>
                </div>
              </div>
            </div>
          </CardContent>
        </Card>
      )}

      {/* Results Step */}
      {selectedStep === 'results' && (
        <Card>
          <CardHeader>
            <CardTitle>Inspection Results</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="text-center py-12">
              <div className="w-20 h-20 bg-yellow-100 dark:bg-yellow-900/30 rounded-full flex items-center justify-center mx-auto mb-4">
                <Clock className="w-10 h-10 text-yellow-500" />
              </div>
              <h3 className="text-xl font-semibold mb-2">Awaiting Inspection</h3>
              <p className="text-muted-foreground">
                Results will be available after your scheduled inspection date
              </p>
            </div>
          </CardContent>
        </Card>
      )}
    </div>
  )
}
