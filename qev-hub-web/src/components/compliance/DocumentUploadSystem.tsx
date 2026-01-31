'use client'

import { useState, useCallback } from 'react'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import { Progress } from '@/components/ui/progress'
import { Input } from '@/components/ui/input'
import {
  FileText,
  Upload,
  X,
  CheckCircle,
  AlertCircle,
  FileImage,
  File,
  Trash2,
  Download,
  Eye,
} from 'lucide-react'
import { useDropzone } from 'react-dropzone'

interface UploadedFile {
  id: string
  name: string
  size: number
  type: string
  status: 'uploading' | 'uploaded' | 'error' | 'processing'
  progress: number
  url?: string
  error?: string
}

interface DocumentCategory {
  id: string
  name: string
  description: string
  required: boolean
  accepted_types: string[]
  max_size: number
  documents: UploadedFile[]
}

const DOCUMENT_CATEGORIES: DocumentCategory[] = [
  {
    id: 'commercial_invoice',
    name: 'Commercial Invoice',
    description: 'Original invoice from manufacturer showing vehicle details, value, and buyer information',
    required: true,
    accepted_types: ['.pdf', '.jpg', '.jpeg', '.png'],
    max_size: 10 * 1024 * 1024, // 10MB
    documents: [],
  },
  {
    id: 'bill_of_lading',
    name: 'Bill of Lading',
    description: 'Shipping document issued by the carrier to the shipper',
    required: true,
    accepted_types: ['.pdf'],
    max_size: 10 * 1024 * 1024,
    documents: [],
  },
  {
    id: 'certificate_origin',
    name: 'Certificate of Origin',
    description: 'Document certifying that the goods were manufactured in the stated country',
    required: true,
    accepted_types: ['.pdf'],
    max_size: 5 * 1024 * 1024,
    documents: [],
  },
  {
    id: 'certificate_conformity',
    name: 'Certificate of Conformity',
    description: 'CoC from manufacturer confirming compliance with Qatar/GCC standards',
    required: true,
    accepted_types: ['.pdf'],
    max_size: 5 * 1024 * 1024,
    documents: [],
  },
  {
    id: 'insurance_policy',
    name: 'Insurance Certificate',
    description: 'Valid vehicle insurance policy for Qatar',
    required: true,
    accepted_types: ['.pdf'],
    max_size: 5 * 1024 * 1024,
    documents: [],
  },
  {
    id: 'purchase_contract',
    name: 'Purchase Contract',
    description: 'Signed agreement between buyer and manufacturer/dealer',
    required: false,
    accepted_types: ['.pdf'],
    max_size: 10 * 1024 * 1024,
    documents: [],
  },
  {
    id: 'technical_specs',
    name: 'Technical Specifications',
    description: 'Detailed technical specifications including battery and safety systems',
    required: false,
    accepted_types: ['.pdf', '.jpg', '.jpeg', '.png'],
    max_size: 10 * 1024 * 1024,
    documents: [],
  },
  {
    id: 'export_declaration',
    name: 'Export Declaration',
    description: 'Customs export declaration from country of origin',
    required: true,
    accepted_types: ['.pdf'],
    max_size: 5 * 1024 * 1024,
    documents: [],
  },
]

export default function DocumentUploadSystem({ orderId }: { orderId?: string }) {
  const [categories, setCategories] = useState<DocumentCategory[]>(DOCUMENT_CATEGORIES)
  const [uploading, setUploading] = useState(false)
  const [selectedFile, setSelectedFile] = useState<UploadedFile | null>(null)
  const [previewModal, setPreviewModal] = useState(false)

  // File type icon helper
  const getFileIcon = (type: string) => {
    if (type.includes('image')) return FileImage
    if (type.includes('pdf')) return FileText
    return File
  }

  // Format file size
  const formatFileSize = (bytes: number) => {
    if (bytes === 0) return '0 Bytes'
    const k = 1024
    const sizes = ['Bytes', 'KB', 'MB', 'GB']
    const i = Math.floor(Math.log(bytes) / Math.log(k))
    return Math.round(bytes / Math.pow(k, i) * 100) / 100 + ' ' + sizes[i]
  }

  // Simulate file upload
  const uploadFile = async (
    file: File,
    categoryId: string
  ): Promise<UploadedFile> => {
    const uploadedFile: UploadedFile = {
      id: `${categoryId}-${Date.now()}`,
      name: file.name,
      size: file.size,
      type: file.type,
      status: 'uploading' as const,
      progress: 0,
    }

    return new Promise((resolve, reject) => {
      setCategories((prev) =>
        prev.map((cat) =>
          cat.id === categoryId
            ? { ...cat, documents: [...cat.documents, uploadedFile] }
            : cat
        )
      )

      // Simulate upload progress
      let progress = 0
      const interval = setInterval(() => {
        progress += Math.random() * 30
        if (progress >= 100) {
          clearInterval(interval)
          const completedFile: UploadedFile = {
            ...uploadedFile,
            status: 'uploaded' as const,
            progress: 100,
            url: `/documents/${uploadedFile.id}.pdf`,
          }
          setCategories((prev) =>
            prev.map((cat) =>
              cat.id === categoryId
                ? {
                    ...cat,
                    documents: cat.documents.map((doc) =>
                      doc.id === uploadedFile.id ? completedFile : doc
                    ),
                  }
                : cat
            )
          )
          resolve(completedFile)
        } else {
          setCategories((prev) =>
            prev.map((cat) =>
              cat.id === categoryId
                ? {
                    ...cat,
                    documents: cat.documents.map((doc) =>
                      doc.id === uploadedFile.id
                        ? { ...doc, progress: Math.min(progress, 99) }
                        : doc
                    ),
                  }
                : cat
            )
          )
        }
      }, 300)
    })
  }

  // Handle file drop
  const onDrop = useCallback(
    (acceptedFiles: File[], categoryId: string) => {
      acceptedFiles.forEach((file) => {
        uploadFile(file, categoryId)
      })
    },
    []
  )

  // Remove file
  const removeFile = (categoryId: string, fileId: string) => {
    setCategories((prev) =>
      prev.map((cat) =>
        cat.id === categoryId
          ? {
              ...cat,
              documents: cat.documents.filter((doc) => doc.id !== fileId),
            }
          : cat
      )
    )
  }

  // Calculate overall progress
  const totalRequired = categories.filter((c) => c.required).length
  const completedRequired = categories.filter(
    (c) => !c.required || c.documents.length > 0
  ).length
  const overallProgress = (completedRequired / totalRequired) * 100

  return (
    <div className="space-y-6">
      {/* Header */}
      <Card>
        <CardHeader>
          <div className="flex items-center justify-between">
            <div>
              <CardTitle>Document Management</CardTitle>
              <p className="text-sm text-muted-foreground mt-1">
                Upload and manage all required compliance documents
              </p>
            </div>
            <div className="text-right">
              <p className="text-sm text-muted-foreground">Overall Progress</p>
              <p className="text-2xl font-bold text-primary">
                {completedRequired}/{totalRequired}
              </p>
            </div>
          </div>
        </CardHeader>
        <CardContent>
          <Progress value={overallProgress} className="h-3" />
          <p className="text-xs text-muted-foreground mt-2">
            {completedRequired} of {totalRequired} required documents uploaded
          </p>
        </CardContent>
      </Card>

      {/* Document Categories */}
      <div className="space-y-4">
        {categories.map((category) => {
          const FileIcon = category.documents.length > 0 ? FileText : Upload
          const hasError = category.documents.some((d) => d.status === 'error')
          const isUploading = category.documents.some((d) => d.status === 'uploading')

          return (
            <Card
              key={category.id}
              className={`transition-all ${
                hasError ? 'border-red-300 dark:border-red-800' : ''
              }`}
            >
              <CardHeader>
                <div className="flex items-start justify-between">
                  <div className="flex items-start gap-3">
                    <div
                      className={`p-2 rounded-lg ${
                        category.documents.length > 0
                          ? 'bg-green-100 dark:bg-green-900/30'
                          : 'bg-muted'
                      }`}
                    >
                      <FileIcon
                        className={`w-5 h-5 ${
                          category.documents.length > 0
                            ? 'text-green-500'
                            : 'text-muted-foreground'
                        }`}
                      />
                    </div>
                    <div>
                      <div className="flex items-center gap-2">
                        <CardTitle className="text-lg">{category.name}</CardTitle>
                        {category.required && (
                          <Badge variant="destructive" className="text-xs">
                            Required
                          </Badge>
                        )}
                        {category.documents.length > 0 && (
                          <Badge variant="default" className="text-xs">
                            {category.documents.length} uploaded
                          </Badge>
                        )}
                      </div>
                      <p className="text-sm text-muted-foreground mt-1">
                        {category.description}
                      </p>
                      <p className="text-xs text-muted-foreground mt-1">
                        Accepted: {category.accepted_types.join(', ')} • Max:{' '}
                        {formatFileSize(category.max_size)}
                      </p>
                    </div>
                  </div>
                </div>
              </CardHeader>

              <CardContent>
                {/* Upload Area */}
                <DropzoneCategory
                  category={category}
                  onDrop={onDrop}
                  isUploading={isUploading}
                />

                {/* Uploaded Files List */}
                {category.documents.length > 0 && (
                  <div className="mt-4 space-y-2">
                    {category.documents.map((file) => {
                      const Icon = getFileIcon(file.type)
                      return (
                        <div
                          key={file.id}
                          className="flex items-center justify-between p-3 bg-muted/50 rounded-lg group"
                        >
                          <div className="flex items-center gap-3 flex-1 min-w-0">
                            <Icon className="w-5 h-5 text-muted-foreground flex-shrink-0" />
                            <div className="min-w-0 flex-1">
                              <p className="font-medium truncate">{file.name}</p>
                              <div className="flex items-center gap-2 text-xs text-muted-foreground">
                                <span>{formatFileSize(file.size)}</span>
                                {file.status === 'uploading' && (
                                  <span>• {file.progress}%</span>
                                )}
                              </div>
                              {file.status === 'uploading' && (
                                <Progress value={file.progress} className="h-1 mt-1" />
                              )}
                              {file.status === 'error' && (
                                <p className="text-xs text-red-500">{file.error}</p>
                              )}
                            </div>
                          </div>

                          {/* Actions */}
                          <div className="flex items-center gap-1 opacity-0 group-hover:opacity-100 transition-opacity">
                            {file.status === 'uploaded' && (
                              <>
                                <Button
                                  variant="ghost"
                                  size="sm"
                                  onClick={() => {
                                    setSelectedFile(file)
                                    setPreviewModal(true)
                                  }}
                                >
                                  <Eye className="w-4 h-4" />
                                </Button>
                                <Button variant="ghost" size="sm">
                                  <Download className="w-4 h-4" />
                                </Button>
                              </>
                            )}
                            <Button
                              variant="ghost"
                              size="sm"
                              onClick={() => removeFile(category.id, file.id)}
                              disabled={file.status === 'uploading'}
                            >
                              <Trash2 className="w-4 h-4 text-red-500" />
                            </Button>
                          </div>

                          {/* Status Indicator */}
                          <div className="ml-2">
                            {file.status === 'uploaded' && (
                              <CheckCircle className="w-5 h-5 text-green-500" />
                            )}
                            {file.status === 'uploading' && (
                              <div className="w-5 h-5 border-2 border-primary border-t-transparent rounded-full animate-spin" />
                            )}
                            {file.status === 'error' && (
                              <AlertCircle className="w-5 h-5 text-red-500" />
                            )}
                          </div>
                        </div>
                      )
                    })}
                  </div>
                )}
              </CardContent>
            </Card>
          )
        })}
      </div>

      {/* Submit Button */}
      <Card>
        <CardContent className="p-6">
          <div className="flex items-center justify-between">
            <div>
              <p className="font-medium">Ready to submit documents?</p>
              <p className="text-sm text-muted-foreground">
                {completedRequired}/{totalRequired} required documents uploaded
              </p>
            </div>
            <Button
              disabled={completedRequired < totalRequired}
              size="lg"
              className="min-w-[200px]"
            >
              Submit Documents
            </Button>
          </div>
        </CardContent>
      </Card>
    </div>
  )
}

// Dropzone Category Component
function DropzoneCategory({
  category,
  onDrop,
  isUploading,
}: {
  category: DocumentCategory
  onDrop: (files: File[], categoryId: string) => void
  isUploading: boolean
}) {
  const { getRootProps, getInputProps, isDragActive } = useDropzone({
    accept: {
      'application/pdf': ['.pdf'],
      'image/jpeg': ['.jpg', '.jpeg'],
      'image/png': ['.png'],
    },
    maxFiles: 5,
    maxSize: category.max_size,
    disabled: isUploading,
    onDrop: (acceptedFiles) => onDrop(acceptedFiles, category.id),
  })

  return (
    <div
      {...getRootProps()}
      className={`border-2 border-dashed rounded-lg p-8 text-center transition-all cursor-pointer ${
        isDragActive
          ? 'border-primary bg-primary/10'
          : 'border-border hover:border-primary/50'
      } ${isUploading ? 'opacity-50 cursor-not-allowed' : ''}`}
    >
      <input {...getInputProps()} />
      <Upload className="w-8 h-8 mx-auto mb-3 text-muted-foreground" />
      {isDragActive ? (
        <p className="text-sm font-medium">Drop files here...</p>
      ) : (
        <>
          <p className="text-sm font-medium">
            Drag & drop files here, or click to browse
          </p>
          <p className="text-xs text-muted-foreground mt-1">
            {category.accepted_types.join(', ')} • Max {category.max_size / (1024 * 1024)}MB
          </p>
        </>
      )}
    </div>
  )
}
