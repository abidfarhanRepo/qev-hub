'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { useAuth } from '@/contexts/AuthContext'
import { supabase } from '@/lib/supabase'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Badge } from '@/components/ui/badge'
import { AlertCircle, CheckCircle2, FileText, ZapIcon } from '@/components/icons'

export default function ManufacturerSignupPage() {
  const router = useRouter()
  const { user, getSupabaseClient, loading: authLoading } = useAuth()
  const [step, setStep] = useState<'details' | 'documents' | 'review'>('details')
  const [loading, setLoading] = useState(false)
  const [success, setSuccess] = useState(false)
  const [error, setError] = useState<string | null>(null)
  
  const [formData, setFormData] = useState({
    // Company Details
    companyName: '',
    companyNameAr: '',
    country: 'China',
    city: '',
    region: '',
    
    // Contact
    contactEmail: '',
    contactPhone: '',
    websiteUrl: '',
    
    // Business Info
    description: '',
    descriptionAr: '',
    businessLicense: '',
    businessLicenseExpiry: '',
    
    // Documents (will be uploaded)
    documents: [] as File[],
  })

  const [uploadedDocUrls, setUploadedDocUrls] = useState<string[]>([])
  const [uploading, setUploading] = useState(false)

  // Redirect to login if not authenticated
  if (authLoading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-background">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary" />
      </div>
    )
  }

  if (!user) {
    router.push('/login')
    return null
  }

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files) {
      const newFiles = Array.from(e.target.files)
      
      // Validate file size (10MB max per file)
      const invalidFiles = newFiles.filter(file => file.size > 10 * 1024 * 1024)
      if (invalidFiles.length > 0) {
        setError(`Some files exceed 10MB limit: ${invalidFiles.map(f => f.name).join(', ')}`)
        return
      }
      
      // Validate file types
      const allowedTypes = ['application/pdf', 'image/jpeg', 'image/jpg', 'image/png']
      const invalidTypes = newFiles.filter(file => !allowedTypes.includes(file.type))
      if (invalidTypes.length > 0) {
        setError(`Invalid file types. Only PDF and images (JPG, PNG) are allowed.`)
        return
      }
      
      setError(null)
      setFormData({
        ...formData,
        documents: [...formData.documents, ...newFiles],
      })
    }
  }

  const removeDocument = (index: number) => {
    setFormData({
      ...formData,
      documents: formData.documents.filter((_, i) => i !== index),
    })
  }

  const uploadDocuments = async (): Promise<string[]> => {
    if (formData.documents.length === 0) return []
    
    setUploading(true)
    const uploadedUrls: string[] = []
    
    try {
      const authSupabase = getSupabaseClient()
      
      for (const file of formData.documents) {
        const fileExt = file.name.split('.').pop()
        const fileName = `${user!.id}/${Date.now()}-${Math.random().toString(36).substring(7)}.${fileExt}`
        
        const { data, error } = await authSupabase.storage
          .from('manufacturer-documents')
          .upload(fileName, file, {
            cacheControl: '3600',
            upsert: false,
          })
        
        if (error) throw error
        
        // Get public URL (even though bucket is private, we store the path)
        const { data: { publicUrl } } = authSupabase.storage
          .from('manufacturer-documents')
          .getPublicUrl(data.path)
        
        uploadedUrls.push(data.path)
      }
      
      return uploadedUrls
    } catch (error: any) {
      throw new Error(`Document upload failed: ${error.message}`)
    } finally {
      setUploading(false)
    }
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setError(null)
    setLoading(true)

    try {
      if (!user) {
        throw new Error('Please log in first')
      }

      // Validate business license expiry date
      const expiryDate = new Date(formData.businessLicenseExpiry)
      const today = new Date()
      today.setHours(0, 0, 0, 0)
      
      if (expiryDate < today) {
        throw new Error('Business license has expired. Please provide a valid license.')
      }

      // Upload documents first
      let documentUrls: string[] = []
      if (formData.documents.length > 0) {
        documentUrls = await uploadDocuments()
      }

      // Use the main supabase client which has the authenticated session
      const { data: manufacturer, error: manufacturerError } = await supabase
        .from('manufacturers')
        .insert({
          user_id: user.id,
          company_name: formData.companyName,
          company_name_ar: formData.companyNameAr || null,
          country: formData.country,
          city: formData.city || null,
          region: formData.region || null,
          contact_email: formData.contactEmail,
          contact_phone: formData.contactPhone || null,
          website_url: formData.websiteUrl || null,
          description: formData.description || null,
          description_ar: formData.descriptionAr || null,
          business_license: formData.businessLicense,
          business_license_expiry: formData.businessLicenseExpiry,
          verification_status: 'pending',
          verified_documents: documentUrls,
        })
        .select()
        .single()

      if (manufacturerError) {
        console.error('Full error:', manufacturerError)
        throw new Error(manufacturerError.message || 'Failed to create manufacturer profile')
      }

      setUploadedDocUrls(documentUrls)
      setSuccess(true)

      // Redirect to admin dashboard after 3 seconds
      setTimeout(() => {
        router.push('/dashboard/admin')
      }, 3000)
    } catch (error: any) {
      setError(error.message || 'Failed to register manufacturer')
      console.error('Signup error:', error)
    } finally {
      setLoading(false)
    }
  }

  const isStepValid = () => {
    switch (step) {
      case 'details':
        return (
          formData.companyName &&
          formData.contactEmail &&
          formData.contactPhone &&
          formData.businessLicense
        )
      case 'documents':
        return formData.documents.length > 0
      case 'review':
        return true
      default:
        return false
    }
  }

  if (success) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-background py-12 px-4 relative overflow-hidden">
        <div className="absolute inset-0 bg-[linear-gradient(to_right,hsl(var(--foreground)/0.05)_1px,transparent_1px),linear-gradient(to_bottom,hsl(var(--foreground)/0.05)_1px,transparent_1px)] bg-[size:2rem_2rem] opacity-10 pointer-events-none"></div>

        <Card className="glass-card tech-border max-w-md w-full relative z-10">
          <CardContent className="p-12 text-center">
            <div className="mx-auto flex h-16 w-16 items-center justify-center rounded-full bg-green-500/20 mb-6">
              <CheckCircle2 className="h-8 w-8 text-green-600" />
            </div>
            <h2 className="text-2xl font-bold text-foreground mb-2">
              Application Submitted!
            </h2>
            <p className="text-muted-foreground mb-6">
              Your manufacturer account is under review. We'll verify your documents and contact you within 2-3 business days.
            </p>
            <div className="space-y-3 text-left mb-6">
              <div className="flex items-start gap-3 text-sm">
                <CheckCircle2 className="h-5 w-5 text-green-600 flex-shrink-0 mt-0.5" />
                <span className="text-foreground">Application received</span>
              </div>
              <div className="flex items-start gap-3 text-sm">
                <CheckCircle2 className="h-5 w-5 text-green-600 flex-shrink-0 mt-0.5" />
                <span className="text-foreground">Documents pending review</span>
              </div>
              <div className="flex items-start gap-3 text-sm">
                <AlertCircle className="h-5 w-5 text-primary flex-shrink-0 mt-0.5" />
                <span className="text-foreground">Verification in progress</span>
              </div>
            </div>
            <Badge className="bg-primary/10 text-primary border-primary/30 mb-4">
              You'll be redirected to Dashboard shortly...
            </Badge>
            <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary mx-auto" />
          </CardContent>
        </Card>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-background py-12 px-4 relative overflow-hidden">
      {/* Background Elements */}
      <div className="absolute inset-0 bg-[linear-gradient(to_right,hsl(var(--foreground)/0.05)_1px,transparent_1px),linear-gradient(to_bottom,hsl(var(--foreground)/0.05)_1px,transparent_1px)] bg-[size:2rem_2rem] opacity-10 pointer-events-none"></div>
      <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[600px] h-[600px] bg-primary/5 blur-[100px] rounded-full pointer-events-none"></div>

      <div className="max-w-4xl mx-auto relative z-10">
        {/* Header */}
        <div className="text-center mb-8">
          <h1 className="text-4xl font-black tracking-widest text-foreground uppercase mb-2">
            Manufacturer <span className="text-primary">Portal</span>
          </h1>
          <p className="text-muted-foreground">
            Register your factory to sell EVs and PHEVs directly on QEV Hub
          </p>
        </div>

        {/* Progress Steps */}
        <div className="flex items-center justify-center gap-4 mb-12">
          {['details', 'documents', 'review'].map((s, index) => (
            <div key={s} className="flex items-center gap-3">
              <div
                className={`w-10 h-10 rounded-full flex items-center justify-center font-semibold transition-all ${
                  step === s
                    ? 'bg-primary text-primary-foreground scale-110 shadow-lg shadow-primary/25'
                    : 'completed' || index < ['details', 'documents', 'review'].indexOf(step)
                    ? 'bg-green-500 text-white'
                    : 'bg-muted/20 text-muted-foreground'
                }`}
              >
                {index + 1}
              </div>
              {index < 2 && (
                <div
                  className={`flex-1 h-0.5 transition-all ${
                    index < ['details', 'documents', 'review'].indexOf(step)
                      ? 'bg-primary'
                      : 'bg-muted/30'
                  }`}
                />
              )}
            </div>
          ))}
        </div>

        {/* Error Message */}
        {error && (
          <Card className="border-red-500/50 mb-6">
            <CardContent className="p-4">
              <div className="flex items-center gap-3">
                <AlertCircle className="h-5 w-5 text-red-600 flex-shrink-0" />
                <p className="text-sm text-red-600">{error}</p>
              </div>
            </CardContent>
          </Card>
        )}

        {/* Form */}
        <Card className="glass-card tech-border">
          <CardHeader className="bg-gradient-to-r from-primary/10 to-transparent border-b border-border/50">
            <CardTitle>
              {step === 'details' && 'Company Information'}
              {step === 'documents' && 'Upload Documents'}
              {step === 'review' && 'Review & Submit'}
            </CardTitle>
          </CardHeader>
          <CardContent className="p-6">
            <form onSubmit={handleSubmit} className="space-y-6">
              {step === 'details' && (
                <div className="space-y-6">
                  {/* Company Name */}
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div>
                      <label className="block text-sm font-medium text-foreground mb-2">
                        Company Name (English) *
                      </label>
                      <Input
                        type="text"
                        value={formData.companyName}
                        onChange={(e) => setFormData({ ...formData, companyName: e.target.value })}
                        placeholder="BYD Auto Co Ltd"
                        required
                      />
                    </div>
                    <div>
                      <label className="block text-sm font-medium text-foreground mb-2">
                        Company Name (Arabic)
                      </label>
                      <Input
                        type="text"
                        value={formData.companyNameAr}
                        onChange={(e) => setFormData({ ...formData, companyNameAr: e.target.value })}
                        placeholder="شركة بي واي دي"
                      />
                    </div>
                  </div>

                  {/* Location */}
                  <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                    <div>
                      <label className="block text-sm font-medium text-foreground mb-2">
                        Country *
                      </label>
                      <select
                        value={formData.country}
                        onChange={(e) => setFormData({ ...formData, country: e.target.value })}
                        className="w-full px-3 py-2 border border-border bg-background rounded-md"
                        required
                      >
                        <option value="China">China</option>
                        <option value="Japan">Japan</option>
                        <option value="South Korea">South Korea</option>
                        <option value="Germany">Germany</option>
                      </select>
                    </div>
                    <div>
                      <label className="block text-sm font-medium text-foreground mb-2">
                        City
                      </label>
                      <Input
                        type="text"
                        value={formData.city}
                        onChange={(e) => setFormData({ ...formData, city: e.target.value })}
                        placeholder="Shenzhen"
                      />
                    </div>
                    <div>
                      <label className="block text-sm font-medium text-foreground mb-2">
                        Region/Province
                      </label>
                      <Input
                        type="text"
                        value={formData.region}
                        onChange={(e) => setFormData({ ...formData, region: e.target.value })}
                        placeholder="Guangdong Province"
                      />
                    </div>
                  </div>

                  {/* Contact Information */}
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div>
                      <label className="block text-sm font-medium text-foreground mb-2">
                        Contact Email *
                      </label>
                      <Input
                        type="email"
                        value={formData.contactEmail}
                        onChange={(e) => setFormData({ ...formData, contactEmail: e.target.value })}
                        placeholder="contact@company.com"
                        required
                      />
                    </div>
                    <div>
                      <label className="block text-sm font-medium text-foreground mb-2">
                        Contact Phone *
                      </label>
                      <Input
                        type="tel"
                        value={formData.contactPhone}
                        onChange={(e) => setFormData({ ...formData, contactPhone: e.target.value })}
                        placeholder="+86 123 4567 8901"
                        required
                      />
                    </div>
                  </div>

                  <div>
                    <label className="block text-sm font-medium text-foreground mb-2">
                      Website URL
                    </label>
                    <Input
                      type="url"
                      value={formData.websiteUrl}
                      onChange={(e) => setFormData({ ...formData, websiteUrl: e.target.value })}
                      placeholder="https://www.company.com"
                    />
                  </div>

                  {/* Description */}
                  <div>
                    <label className="block text-sm font-medium text-foreground mb-2">
                      Company Description (English)
                    </label>
                    <textarea
                      value={formData.description}
                      onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                      placeholder="Brief company description..."
                      rows={3}
                      className="w-full px-3 py-2 border border-border bg-background rounded-md"
                    />
                  </div>

                  <div>
                    <label className="block text-sm font-medium text-foreground mb-2">
                      Company Description (Arabic)
                    </label>
                    <textarea
                      value={formData.descriptionAr}
                      onChange={(e) => setFormData({ ...formData, descriptionAr: e.target.value })}
                      placeholder="وصف مختصر للشركة..."
                      rows={3}
                      className="w-full px-3 py-2 border border-border bg-background rounded-md"
                      dir="rtl"
                    />
                    </div>

                  {/* Business License */}
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div>
                      <label className="block text-sm font-medium text-foreground mb-2">
                        Business License Number *
                      </label>
                      <Input
                        type="text"
                        value={formData.businessLicense}
                        onChange={(e) => setFormData({ ...formData, businessLicense: e.target.value })}
                        placeholder="License number"
                        required
                      />
                    </div>
                    <div>
                      <label className="block text-sm font-medium text-foreground mb-2">
                        License Expiry Date *
                      </label>
                      <Input
                        type="date"
                        value={formData.businessLicenseExpiry}
                        onChange={(e) => setFormData({ ...formData, businessLicenseExpiry: e.target.value })}
                        required
                      />
                    </div>
                  </div>
                </div>
              )}

              {step === 'documents' && (
                <div className="space-y-6">
                  <div className="p-6 bg-primary/5 rounded-lg border-2 border-primary/30">
                    <div className="flex items-start gap-4">
                      <FileText className="h-8 w-8 text-primary flex-shrink-0" />
                      <div>
                        <h3 className="font-semibold text-foreground mb-2">
                          Required Documents
                        </h3>
                        <ul className="space-y-2 text-sm text-muted-foreground">
                          <li className="flex items-start gap-2">
                            <ZapIcon className="h-4 w-4 text-primary mt-0.5 flex-shrink-0" />
                            <span>Business License (PDF/IMG) - Max 10MB</span>
                          </li>
                          <li className="flex items-start gap-2">
                            <ZapIcon className="h-4 w-4 text-primary mt-0.5 flex-shrink-0" />
                            <span>Company Registration Certificate</span>
                          </li>
                          <li className="flex items-start gap-2">
                            <ZapIcon className="h-4 w-4 text-primary mt-0.5 flex-shrink-0" />
                            <span>ISO/Quality Certification (if applicable)</span>
                          </li>
                          <li className="flex items-start gap-2">
                            <ZapIcon className="h-4 w-4 text-primary mt-0.5 flex-shrink-0" />
                            <span>Tax Registration Document</span>
                          </li>
                        </ul>
                      </div>
                    </div>
                  </div>

                  <div>
                    <label className="block text-sm font-medium text-foreground mb-2">
                      Upload Documents (PDF or Images)
                    </label>
                    <input
                      type="file"
                      multiple
                      accept=".pdf,.jpg,.jpeg,.png"
                      onChange={handleFileChange}
                      className="w-full px-3 py-6 border-2 border-dashed border-border bg-background rounded-lg cursor-pointer hover:border-primary/50 transition-colors"
                    />
                    <p className="text-xs text-muted-foreground mt-2">
                      Accepted formats: PDF, JPG, PNG. Max 10MB per file.
                    </p>
                  </div>

                  {/* File List Preview */}
                  {formData.documents.length > 0 && (
                    <div className="space-y-2">
                      <p className="text-sm font-medium text-foreground">
                        Selected Files ({formData.documents.length})
                      </p>
                      <div className="space-y-2">
                        {formData.documents.map((file, index) => (
                          <div
                            key={index}
                            className="flex items-center justify-between p-3 bg-muted/30 rounded-lg border border-border/50"
                          >
                            <div className="flex items-center gap-3">
                              <FileText className="h-5 w-5 text-primary" />
                              <div>
                                <p className="text-sm font-medium text-foreground">{file.name}</p>
                                <p className="text-xs text-muted-foreground">
                                  {(file.size / 1024 / 1024).toFixed(2)} MB
                                </p>
                              </div>
                            </div>
                            <Button
                              type="button"
                              variant="ghost"
                              size="sm"
                              onClick={() => removeDocument(index)}
                              className="text-red-500 hover:text-red-600 hover:bg-red-50"
                            >
                              Remove
                            </Button>
                          </div>
                        ))}
                      </div>
                    </div>
                  )}

                  <div className="p-4 bg-muted/30 rounded-lg border border-border/50">
                    <p className="text-sm text-foreground">
                      All documents will be verified by our team within 2-3 business days. You'll receive a notification once your account is approved.
                    </p>
                  </div>
                </div>
              )}

              {step === 'review' && (
                <div className="space-y-6">
                  <div className="p-6 bg-muted/30 rounded-lg">
                    <h3 className="font-semibold text-foreground mb-4">Review Your Information</h3>
                    
                    <div className="space-y-3">
                      <div className="flex justify-between text-sm">
                        <span className="text-muted-foreground">Company Name:</span>
                        <span className="font-medium text-foreground">{formData.companyName}</span>
                      </div>
                      <div className="flex justify-between text-sm">
                        <span className="text-muted-foreground">Location:</span>
                        <span className="font-medium text-foreground">{formData.city}, {formData.country}</span>
                      </div>
                      <div className="flex justify-between text-sm">
                        <span className="text-muted-foreground">Contact Email:</span>
                        <span className="font-medium text-foreground">{formData.contactEmail}</span>
                      </div>
                      <div className="flex justify-between text-sm">
                        <span className="text-muted-foreground">Documents:</span>
                        <span className="font-medium text-foreground">{formData.documents.length} files</span>
                      </div>
                    </div>
                  </div>

                  <div className="p-4 bg-green-500/5 rounded-lg border-2 border-green-500/30">
                    <div className="flex items-start gap-3">
                      <CheckCircle2 className="h-5 w-5 text-green-600 flex-shrink-0 mt-0.5" />
                      <div>
                        <p className="text-sm text-foreground font-medium">
                          Ready to Submit
                        </p>
                        <p className="text-xs text-muted-foreground mt-1">
                          By submitting, you agree to our terms and conditions for manufacturers selling on QEV Hub.
                        </p>
                      </div>
                    </div>
                  </div>
                </div>
              )}

              {/* Navigation Buttons */}
              <div className="flex justify-between pt-4 border-t border-border/50">
                <Button
                  type="button"
                  variant="outline"
                  onClick={() => setStep('details')}
                  disabled={step === 'details' || loading}
                >
                  Back
                </Button>
                
                {step === 'documents' && (
                  <Button
                    type="button"
                    onClick={() => setStep('details')}
                    disabled={loading}
                  >
                    Previous
                  </Button>
                )}

                {step !== 'review' && (
                  <Button
                    type="button"
                    onClick={() => setStep(step === 'details' ? 'documents' : 'review')}
                    disabled={!isStepValid() || loading}
                  >
                    Next
                  </Button>
                )}

                {step === 'review' && (
                  <Button
                    type="submit"
                    disabled={loading || uploading}
                    className="bg-primary text-primary-foreground hover:bg-primary/90"
                  >
                    {loading ? (uploading ? 'Uploading Documents...' : 'Submitting...') : 'Submit Application'}
                  </Button>
                )}
              </div>
            </form>
          </CardContent>
        </Card>

        {/* Help Section */}
        <Card className="mt-6">
          <CardContent className="p-6">
            <h3 className="font-semibold text-foreground mb-3">Need Help?</h3>
            <p className="text-sm text-muted-foreground mb-4">
              Contact our manufacturer support team for assistance with your application.
            </p>
            <div className="flex items-center gap-4">
              <a
                href="mailto:manufacturers@qev-hub.qa"
                className="text-sm text-primary hover:underline"
              >
                manufacturers@qev-hub.qa
              </a>
              <Badge className="bg-primary/10 text-primary border-primary/30">
                Response within 24 hours
              </Badge>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  )
}
