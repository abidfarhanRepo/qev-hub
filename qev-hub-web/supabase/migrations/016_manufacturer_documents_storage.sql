-- Migration: Create storage bucket for manufacturer documents
-- This allows manufacturers to upload business licenses and verification documents

-- Create storage bucket for manufacturer documents
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'manufacturer-documents',
  'manufacturer-documents',
  false,
  10485760, -- 10MB limit per file
  ARRAY['application/pdf', 'image/jpeg', 'image/jpg', 'image/png']
) ON CONFLICT (id) DO NOTHING;

-- RLS Policies for manufacturer documents bucket

-- Allow authenticated users to upload documents
CREATE POLICY "Authenticated users can upload manufacturer documents"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'manufacturer-documents' AND
  (storage.foldername(name))[1] = auth.uid()::text
);

-- Allow users to view their own documents
CREATE POLICY "Users can view own manufacturer documents"
ON storage.objects FOR SELECT
TO authenticated
USING (
  bucket_id = 'manufacturer-documents' AND
  (storage.foldername(name))[1] = auth.uid()::text
);

-- Allow users to delete their own documents
CREATE POLICY "Users can delete own manufacturer documents"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'manufacturer-documents' AND
  (storage.foldername(name))[1] = auth.uid()::text
);

-- Allow admins to view all manufacturer documents
CREATE POLICY "Admins can view all manufacturer documents"
ON storage.objects FOR SELECT
TO authenticated
USING (
  bucket_id = 'manufacturer-documents' AND
  EXISTS (
    SELECT 1 FROM auth.users
    WHERE id = auth.uid()
    AND raw_user_meta_data->>'role' = 'admin'
  )
);
