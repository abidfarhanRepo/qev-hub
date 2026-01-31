'use client'

import { useState } from 'react'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Textarea } from '@/components/ui/textarea'
import {
  FileText,
  Download,
  Send,
  CheckCircle,
  Clock,
  AlertCircle,
  File,
  Eye,
  Printer,
} from 'lucide-react'
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select'

interface CustomsDocument {
  id: string
  type: string
  name: string
  description: string
  status: 'draft' | 'generated' | 'submitted' | 'approved' | 'rejected'
  generated_date?: string
  submitted_date?: string
  reference_number?: string
  pdf_url?: string
}

interface CustomsDeclaration {
  declaration_type: 'import' | 'export' | 're-export'
  goods_description: string
  hs_code: string
  customs_value: number
  currency: string
  gross_weight: number
  net_weight: number
  number_of_packages: number
  package_type: string
  country_of_origin: string
  port_of_loading: string
  port_of_discharge: string
  vessel_name: string
  voyage_number: string
  bill_of_lading: string
  importer_name: string
  importer_tax_id: string
  importer_address: string
  declarant_name: string
  declarant_id: string
}

// Mock customs documents data
const mockCustomsDocuments: CustomsDocument[] = [
  {
    id: 'doc-1',
    type: 'import_declaration',
    name: 'Import Declaration (Customs 100)',
    description: 'Single administrative document for import clearance',
    status: 'draft',
  },
  {
    id: 'doc-2',
    type: 'certificate_origin',
    name: 'Certificate of Origin',
    description: 'Origin certification for customs duty assessment',
    status: 'draft',
  },
  {
    id: 'doc-3',
    type: 'commercial_invoice',
    name: 'Commercial Invoice (Customs)',
    description: 'Certified commercial invoice for customs valuation',
    status: 'draft',
  },
  {
    id: 'doc-4',
    type: 'packing_list',
    name: 'Packing List',
    description: 'Detailed packing list for customs inspection',
    status: 'draft',
  },
  {
    id: 'doc-5',
    type: 'insurance_certificate',
    name: 'Insurance Certificate',
    description: 'Cargo insurance certificate for customs',
    status: 'draft',
  },
  {
    id: 'doc-6',
    type: 'excise_tax',
    name: 'Excise Tax Declaration',
    description: 'Excise tax declaration (if applicable)',
    status: 'draft',
  },
]

// GCC HS Code reference for EVs
const EV_HS_CODES = [
  { code: '8703.80.00', description: 'Electric motor vehicles - Other', duty_rate: '5%' },
  { code: '8507.60.00', description: 'Lithium-ion batteries', duty_rate: '5%' },
  { code: '8504.40.00', description: 'EV charging equipment', duty_rate: '0%' },
]

const PORTS = [
  { code: 'CNCGG', name: 'Shanghai, China' },
  { code: 'CNSZX', name: 'Shenzhen, China' },
  { code: 'CNTAO', name: 'Qingdao, China' },
  { code: 'QADOH', name: 'Doha, Qatar (Hamad Port)' },
  { code: 'QAQAH', name: 'Qatar Port (Old Doha Port)' },
]

export default function CustomsDocumentationGenerator({ orderId }: { orderId?: string }) {
  const [documents, setDocuments] = useState<CustomsDocument[]>(mockCustomsDocuments)
  const [selectedDoc, setSelectedDoc] = useState<CustomsDocument | null>(null)
  const [generating, setGenerating] = useState(false)
  const [submitting, setSubmitting] = useState(false)
  const [previewModal, setPreviewModal] = useState(false)
  const [declarationData, setDeclarationData] = useState<CustomsDeclaration>({
    declaration_type: 'import',
    goods_description: 'BYD SEAL Electric Vehicle - Premium Sedan',
    hs_code: '8703.80.00',
    customs_value: 145000,
    currency: 'QAR',
    gross_weight: 2200,
    net_weight: 1900,
    number_of_packages: 1,
    package_type: 'Vehicle (RO/RO)',
    country_of_origin: 'CN',
    port_of_loading: 'CNCGG',
    port_of_discharge: 'QADOH',
    vessel_name: 'MV Qatar Navigator',
    voyage_number: 'QN-2025-042',
    bill_of_lading: 'QEV-BL-2025-001234',
    importer_name: 'Ahmed Al-Mansouri',
    importer_tax_id: '30012345678',
    importer_address: 'Al Dafna, Doha, Qatar',
    declarant_name: 'QEV Customs Brokerage',
    declarant_id: 'BROKER-001',
  })

  // Calculate customs duties (5% for EV imports in Qatar)
  const calculateDuties = () => {
    return declarationData.customs_value * 0.05
  }

  const calculateTotal = () => {
    return declarationData.customs_value + calculateDuties()
  }

  const handleGenerateDocument = async (docId: string) => {
    setGenerating(true)
    setSelectedDoc(documents.find((d) => d.id === docId) || null)

    // Simulate document generation
    await new Promise((resolve) => setTimeout(resolve, 2000))

    setDocuments((prev) =>
      prev.map((doc) =>
        doc.id === docId
          ? {
              ...doc,
              status: 'generated',
              generated_date: new Date().toISOString(),
              reference_number: `QA-CUST-${Date.now()}`,
              pdf_url: `/customs/${doc.id}.pdf`,
            }
          : doc
      )
    )
    setGenerating(false)
  }

  const handleGenerateAll = async () => {
    setGenerating(true)
    // Generate all documents in sequence
    for (const doc of documents) {
      await new Promise((resolve) => setTimeout(resolve, 500))
      setDocuments((prev) =>
        prev.map((d) =>
          d.id === doc.id
            ? {
                ...d,
                status: 'generated',
                generated_date: new Date().toISOString(),
                reference_number: `QA-CUST-${d.id}-${Date.now()}`,
                pdf_url: `/customs/${d.id}.pdf`,
              }
            : d
        )
      )
    }
    setGenerating(false)
  }

  const handleSubmitToCustoms = async () => {
    setSubmitting(true)
    // Simulate submission
    await new Promise((resolve) => setTimeout(resolve, 3000))

    setDocuments((prev) =>
      prev.map((doc) =>
        doc.status === 'generated'
          ? {
              ...doc,
              status: 'submitted',
              submitted_date: new Date().toISOString(),
            }
          : doc
      )
    )
    setSubmitting(false)
  }

  const getStatusIcon = (status: string) => {
    switch (status) {
      case 'generated':
      case 'approved':
        return <CheckCircle className="w-5 h-5 text-green-500" />
      case 'submitted':
        return <Send className="w-5 h-5 text-blue-500" />
      case 'rejected':
        return <AlertCircle className="w-5 h-5 text-red-500" />
      default:
        return <File className="w-5 h-5 text-gray-400" />
    }
  }

  const generatedDocs = documents.filter((d) => d.status !== 'draft')
  const allGenerated = documents.every((d) => d.status !== 'draft')
  const canSubmit = generatedDocs.length > 0 && !documents.some((d) => d.status === 'submitted')

  return (
    <div className="space-y-6">
      {/* Header */}
      <Card>
        <CardHeader>
          <div className="flex items-center justify-between">
            <div>
              <CardTitle>Customs Documentation Generator</CardTitle>
              <p className="text-sm text-muted-foreground mt-1">
                Automated Qatar Customs documentation for vehicle import clearance
              </p>
            </div>
            <div className="flex gap-2">
              <Button variant="outline" onClick={handleGenerateAll} disabled={generating}>
                {generating ? 'Generating...' : 'Generate All'}
              </Button>
              <Button
                onClick={handleSubmitToCustoms}
                disabled={!canSubmit || submitting}
                className="bg-primary hover:bg-primary-dark text-foreground"
              >
                {submitting ? 'Submitting...' : 'Submit to Customs'}
              </Button>
            </div>
          </div>
        </CardHeader>
        <CardContent>
          <div className="grid grid-cols-3 gap-4 text-center">
            <div>
              <p className="text-2xl font-bold">{documents.length}</p>
              <p className="text-xs text-muted-foreground">Total Documents</p>
            </div>
            <div>
              <p className="text-2xl font-bold text-green-500">{generatedDocs.length}</p>
              <p className="text-xs text-muted-foreground">Generated</p>
            </div>
            <div>
              <p className="text-2xl font-bold text-primary">
                QAR {calculateDuties().toLocaleString()}
              </p>
              <p className="text-xs text-muted-foreground">Est. Customs Duty</p>
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Declaration Form */}
      <Card>
        <CardHeader>
          <CardTitle>Customs Declaration Details</CardTitle>
          <p className="text-sm text-muted-foreground">
            Enter the details that will be used for all customs documents
          </p>
        </CardHeader>
        <CardContent>
          <div className="grid md:grid-cols-3 gap-6">
            {/* Declaration Type */}
            <div>
              <Label>Declaration Type</Label>
              <Select
                value={declarationData.declaration_type}
                onValueChange={(value: any) =>
                  setDeclarationData({ ...declarationData, declaration_type: value })
                }
              >
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="import">Import Declaration</SelectItem>
                  <SelectItem value="export">Export Declaration</SelectItem>
                  <SelectItem value="re-export">Re-Export Declaration</SelectItem>
                </SelectContent>
              </Select>
            </div>

            {/* HS Code */}
            <div>
              <Label>HS Code</Label>
              <Select
                value={declarationData.hs_code}
                onValueChange={(value) =>
                  setDeclarationData({ ...declarationData, hs_code: value })
                }
              >
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  {EV_HS_CODES.map((code) => (
                    <SelectItem key={code.code} value={code.code}>
                      {code.code} - {code.description} ({code.duty_rate})
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>

            {/* Customs Value */}
            <div>
              <Label>Customs Value (QAR)</Label>
              <Input
                type="number"
                value={declarationData.customs_value}
                onChange={(e) =>
                  setDeclarationData({
                    ...declarationData,
                    customs_value: parseFloat(e.target.value),
                  })
                }
              />
            </div>

            {/* Goods Description */}
            <div className="md:col-span-2">
              <Label>Goods Description</Label>
              <Textarea
                value={declarationData.goods_description}
                onChange={(e) =>
                  setDeclarationData({
                    ...declarationData,
                    goods_description: e.target.value,
                  })
                }
              />
            </div>

            {/* Country of Origin */}
            <div>
              <Label>Country of Origin</Label>
              <Input value="China (CN)" disabled />
            </div>

            {/* Port of Loading */}
            <div>
              <Label>Port of Loading</Label>
              <Select
                value={declarationData.port_of_loading}
                onValueChange={(value) =>
                  setDeclarationData({ ...declarationData, port_of_loading: value })
                }
              >
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  {PORTS.filter((p) => p.code.startsWith('CN')).map((port) => (
                    <SelectItem key={port.code} value={port.code}>
                      {port.name}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>

            {/* Port of Discharge */}
            <div>
              <Label>Port of Discharge</Label>
              <Select
                value={declarationData.port_of_discharge}
                onValueChange={(value) =>
                  setDeclarationData({ ...declarationData, port_of_discharge: value })
                }
              >
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  {PORTS.filter((p) => p.code.startsWith('QA')).map((port) => (
                    <SelectItem key={port.code} value={port.code}>
                      {port.name}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>

            {/* Vessel Name */}
            <div>
              <Label>Vessel Name</Label>
              <Input
                value={declarationData.vessel_name}
                onChange={(e) =>
                  setDeclarationData({ ...declarationData, vessel_name: e.target.value })
                }
              />
            </div>

            {/* Voyage Number */}
            <div>
              <Label>Voyage Number</Label>
              <Input
                value={declarationData.voyage_number}
                onChange={(e) =>
                  setDeclarationData({ ...declarationData, voyage_number: e.target.value })
                }
              />
            </div>

            {/* Bill of Lading */}
            <div>
              <Label>Bill of Lading</Label>
              <Input
                value={declarationData.bill_of_lading}
                onChange={(e) =>
                  setDeclarationData({ ...declarationData, bill_of_lading: e.target.value })
                }
              />
            </div>

            {/* Weight Section */}
            <div>
              <Label>Gross Weight (kg)</Label>
              <Input
                type="number"
                value={declarationData.gross_weight}
                onChange={(e) =>
                  setDeclarationData({
                    ...declarationData,
                    gross_weight: parseFloat(e.target.value),
                  })
                }
              />
            </div>

            <div>
              <Label>Net Weight (kg)</Label>
              <Input
                type="number"
                value={declarationData.net_weight}
                onChange={(e) =>
                  setDeclarationData({
                    ...declarationData,
                    net_weight: parseFloat(e.target.value),
                  })
                }
              />
            </div>

            <div>
              <Label>Packages</Label>
              <Input
                type="number"
                value={declarationData.number_of_packages}
                onChange={(e) =>
                  setDeclarationData({
                    ...declarationData,
                    number_of_packages: parseInt(e.target.value),
                  })
                }
              />
            </div>

            {/* Importer Details */}
            <div className="md:col-span-3 border-t pt-4">
              <h3 className="font-semibold mb-4">Importer Information</h3>
              <div className="grid md:grid-cols-3 gap-4">
                <div>
                  <Label>Importer Name</Label>
                  <Input
                    value={declarationData.importer_name}
                    onChange={(e) =>
                      setDeclarationData({
                        ...declarationData,
                        importer_name: e.target.value,
                      })
                    }
                  />
                </div>
                <div>
                  <Label>Tax ID (Qatari ID)</Label>
                  <Input
                    value={declarationData.importer_tax_id}
                    onChange={(e) =>
                      setDeclarationData({
                        ...declarationData,
                        importer_tax_id: e.target.value,
                      })
                    }
                  />
                </div>
                <div>
                  <Label>Declarant</Label>
                  <Input
                    value={declarationData.declarant_name}
                    onChange={(e) =>
                      setDeclarationData({
                        ...declarationData,
                        declarant_name: e.target.value,
                      })
                    }
                  />
                </div>
              </div>
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Documents List */}
      <div className="space-y-3">
        {documents.map((doc) => (
          <Card key={doc.id} className="transition-all hover:shadow-md">
            <CardContent className="p-4">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-4">
                  <div
                    className={`p-2 rounded-lg ${
                      doc.status !== 'draft'
                        ? 'bg-green-100 dark:bg-green-900/30'
                        : 'bg-muted'
                    }`}
                  >
                    {getStatusIcon(doc.status)}
                  </div>
                  <div>
                    <div className="flex items-center gap-2">
                      <p className="font-medium">{doc.name}</p>
                      <Badge variant="outline">{doc.status.toUpperCase()}</Badge>
                    </div>
                    <p className="text-sm text-muted-foreground">{doc.description}</p>
                    {doc.reference_number && (
                      <p className="text-xs text-muted-foreground">
                        Ref: {doc.reference_number}
                      </p>
                    )}
                  </div>
                </div>

                <div className="flex items-center gap-2">
                  {doc.status === 'draft' && (
                    <Button
                      size="sm"
                      variant="outline"
                      onClick={() => handleGenerateDocument(doc.id)}
                      disabled={generating}
                    >
                      {generating && selectedDoc?.id === doc.id ? (
                        'Generating...'
                      ) : (
                        <>
                          <FileText className="w-4 h-4 mr-2" />
                          Generate
                        </>
                      )}
                    </Button>
                  )}

                  {doc.status === 'generated' && (
                    <>
                      <Button size="sm" variant="outline">
                        <Eye className="w-4 h-4 mr-2" />
                        Preview
                      </Button>
                      <Button size="sm" variant="outline">
                        <Download className="w-4 h-4 mr-2" />
                        PDF
                      </Button>
                      <Button size="sm" variant="outline">
                        <Printer className="w-4 h-4 mr-2" />
                        Print
                      </Button>
                    </>
                  )}

                  {doc.status === 'submitted' && (
                    <>
                      <Button size="sm" variant="outline">
                        <Download className="w-4 h-4 mr-2" />
                        Download
                      </Button>
                      <Badge variant="secondary">
                        Submitted: {new Date(doc.submitted_date!).toLocaleDateString()}
                      </Badge>
                    </>
                  )}
                </div>
              </div>
            </CardContent>
          </Card>
        ))}
      </div>

      {/* Duty Summary */}
      <Card className="bg-accent/10 border-accent/30">
        <CardHeader>
          <CardTitle>Duty Calculation Summary</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="space-y-3">
            <div className="flex justify-between">
              <span className="text-muted-foreground">Customs Value</span>
              <span className="font-medium">
                QAR {declarationData.customs_value.toLocaleString()}
              </span>
            </div>
            <div className="flex justify-between">
              <span className="text-muted-foreground">Customs Duty (5%)</span>
              <span className="font-medium">
                QAR {calculateDuties().toLocaleString()}
              </span>
            </div>
            <div className="border-t pt-3 flex justify-between text-lg">
              <span className="font-semibold">Total Payable</span>
              <span className="font-bold text-primary">
                QAR {calculateTotal().toLocaleString()}
              </span>
            </div>
          </div>
        </CardContent>
      </Card>
    </div>
  )
}
