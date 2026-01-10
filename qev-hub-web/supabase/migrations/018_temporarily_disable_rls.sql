-- TEMPORARY: Disable RLS on manufacturers table for testing
-- This allows any authenticated user to insert into manufacturers table
-- Re-enable RLS after confirming signup works

ALTER TABLE manufacturers DISABLE ROW LEVEL SECURITY;
