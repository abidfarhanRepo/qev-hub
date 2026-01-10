-- Fix manufacturer column constraint
-- The old 'manufacturer' column conflicts with the new 'make' column

-- Make manufacturer column nullable (it's legacy)
ALTER TABLE vehicles ALTER COLUMN manufacturer DROP NOT NULL;

-- Update existing records to have manufacturer = make where null
UPDATE vehicles SET manufacturer = make WHERE manufacturer IS NULL;
