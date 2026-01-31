'use client'

import { useState, Suspense } from 'react'
import ComplianceDashboard from '@/components/compliance/ComplianceDashboard'
import FAHESInspectionFlow from '@/components/compliance/FAHESInspectionFlow'
import DocumentUploadSystem from '@/components/compliance/DocumentUploadSystem'
import CustomsDocumentationGenerator from '@/components/compliance/CustomsDocumentationGenerator'
import ImportPermitAutomation from '@/components/compliance/ImportPermitAutomation'
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs'
import { useSearchParams } from 'next/navigation'

function CompliancePageContent() {
  const searchParams = useSearchParams()
  const orderId = searchParams.get('order_id') || undefined
  const [activeTab, setActiveTab] = useState('dashboard')

  return (
    <div className="min-h-screen bg-background py-8">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Header */}
        <div className="mb-8">
          <h1 className="text-3xl font-black uppercase tracking-widest text-foreground mb-2">
            Regulatory <span className="text-primary">Compliance</span>
          </h1>
          <p className="text-muted-foreground">
            Module 2: Automated FAHES inspection, customs documentation, and import permit
            processing
          </p>
        </div>

        {/* Compliance Tabs */}
        <Tabs value={activeTab} onValueChange={setActiveTab} className="space-y-6">
          <TabsList className="grid w-full grid-cols-5 lg:w-auto">
            <TabsTrigger value="dashboard">Dashboard</TabsTrigger>
            <TabsTrigger value="fahes">FAHES</TabsTrigger>
            <TabsTrigger value="documents">Documents</TabsTrigger>
            <TabsTrigger value="customs">Customs</TabsTrigger>
            <TabsTrigger value="permit">Permit</TabsTrigger>
          </TabsList>

          <TabsContent value="dashboard">
            <ComplianceDashboard orderId={orderId} />
          </TabsContent>

          <TabsContent value="fahes">
            <FAHESInspectionFlow orderId={orderId} />
          </TabsContent>

          <TabsContent value="documents">
            <DocumentUploadSystem orderId={orderId} />
          </TabsContent>

          <TabsContent value="customs">
            <CustomsDocumentationGenerator orderId={orderId} />
          </TabsContent>

          <TabsContent value="permit">
            <ImportPermitAutomation orderId={orderId} />
          </TabsContent>
        </Tabs>
      </div>
    </div>
  )
}

export default function CompliancePage() {
  return (
    <Suspense
      fallback={
        <div className="min-h-screen bg-background flex items-center justify-center">
          <div className="text-center">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto mb-4" />
            <p>Loading...</p>
          </div>
        </div>
      }
    >
      <CompliancePageContent />
    </Suspense>
  )
}
