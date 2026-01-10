-- Fix RLS policy for manufacturer signup
-- Drop and recreate the insert policy to ensure it works correctly

DROP POLICY IF EXISTS "Manufacturers can insert own profile" ON manufacturers;

-- Create a more permissive insert policy for authenticated users
CREATE POLICY "Authenticated users can create manufacturer profile"
  ON manufacturers FOR INSERT
  TO authenticated
  WITH CHECK (
    user_id = auth.uid() OR
    user_id::text = (current_setting('request.jwt.claims', true)::json->>'sub')
  );

-- Also ensure anon users can't insert
CREATE POLICY "Prevent anonymous manufacturer creation"
  ON manufacturers FOR INSERT
  TO anon
  WITH CHECK (false);
