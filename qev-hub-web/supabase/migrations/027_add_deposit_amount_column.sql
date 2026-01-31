-- Add deposit_amount column to orders table
-- This migration fixes the missing deposit_amount column that was defined in migration 012
-- but may not have been applied to the actual database

-- Add deposit_amount column if it doesn't exist
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'orders'
        AND column_name = 'deposit_amount'
    ) THEN
        ALTER TABLE orders ADD COLUMN deposit_amount DECIMAL(12, 2);
        RAISE NOTICE 'Added deposit_amount column to orders table';
    ELSE
        RAISE NOTICE 'deposit_amount column already exists in orders table';
    END IF;
END $$;

-- Add comment to the column
COMMENT ON COLUMN orders.deposit_amount IS 'Deposit amount (20% of total price) required at order time';
