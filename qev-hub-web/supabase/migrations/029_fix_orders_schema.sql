-- Fix orders table schema - migrate from old to new structure
-- This fixes the mismatch between migration 001 and 012

-- Add missing columns if they don't exist
DO $$
BEGIN
    -- Add tracking_id if missing
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'orders' AND column_name = 'tracking_id'
    ) THEN
        ALTER TABLE orders ADD COLUMN tracking_id VARCHAR(50) UNIQUE;
        CREATE INDEX idx_orders_tracking_id ON orders(tracking_id);
    END IF;

    -- Add deposit_amount if missing
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'orders' AND column_name = 'deposit_amount'
    ) THEN
        ALTER TABLE orders ADD COLUMN deposit_amount DECIMAL(12, 2);
    END IF;

    -- Add payment_status if missing
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'orders' AND column_name = 'payment_status'
    ) THEN
        ALTER TABLE orders ADD COLUMN payment_status VARCHAR(50) DEFAULT 'Pending';
    END IF;

    -- Rename total_price_qar to total_price if old column exists
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'orders' AND column_name = 'total_price_qar'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'orders' AND column_name = 'total_price'
    ) THEN
        ALTER TABLE orders RENAME COLUMN total_price_qar TO total_price;
    END IF;

    -- Ensure total_price exists (add if neither column exists)
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'orders' AND column_name = 'total_price'
    ) THEN
        ALTER TABLE orders ADD COLUMN total_price DECIMAL(12, 2);
    END IF;

    RAISE NOTICE 'Orders table schema updated';
END $$;

-- Update existing orders to have tracking IDs
DO $$
BEGIN
    -- Generate tracking IDs for existing orders that don't have one
    UPDATE orders
    SET tracking_id = 'QEV-' || LPAD(FLOOR(RANDOM() * 9999)::TEXT, 4, '0')
    WHERE tracking_id IS NULL;
    RAISE NOTICE 'Generated tracking IDs for existing orders';
END $$;

-- Set default deposit_amount to 20% of total_price for existing orders
DO $$
BEGIN
    UPDATE orders
    SET deposit_amount = total_price * 0.2
    WHERE deposit_amount IS NULL;
    RAISE NOTICE 'Set default deposit amounts for existing orders';
END $$;

-- Create logistics table if it doesn't exist
CREATE TABLE IF NOT EXISTS logistics (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  current_location VARCHAR(255),
  destination VARCHAR(255),
  estimated_arrival TIMESTAMP WITH TIME ZONE,
  actual_arrival TIMESTAMP WITH TIME ZONE,
  status VARCHAR(50) NOT NULL DEFAULT 'Order Placed',
  vessel_name VARCHAR(255),
  tracking_events JSONB DEFAULT '[]'::jsonb,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_logistics_order_id ON logistics(order_id);
CREATE INDEX IF NOT EXISTS idx_logistics_status ON logistics(status);

-- Create payments table if it doesn't exist
CREATE TABLE IF NOT EXISTS payments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  amount DECIMAL(12, 2) NOT NULL,
  currency VARCHAR(10) DEFAULT 'QAR',
  payment_method VARCHAR(50),
  payment_gateway VARCHAR(50),
  transaction_id VARCHAR(255),
  status VARCHAR(50) DEFAULT 'Pending',
  payment_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  metadata JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_payments_order_id ON payments(order_id);

-- Create compliance_documents table if it doesn't exist
CREATE TABLE IF NOT EXISTS compliance_documents (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  document_type VARCHAR(100) NOT NULL,
  document_url VARCHAR(500),
  document_name VARCHAR(255),
  status VARCHAR(50) DEFAULT 'Pending',
  generated_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_compliance_documents_order_id ON compliance_documents(order_id);

-- Enable RLS on new tables
ALTER TABLE logistics ENABLE ROW LEVEL SECURITY;
ALTER TABLE payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE compliance_documents ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Users can view logistics for their orders" ON logistics;
DROP POLICY IF EXISTS "Users can view payments for their orders" ON payments;
DROP POLICY IF EXISTS "Users can view compliance documents for their orders" ON compliance_documents;

-- Create policies for logistics
CREATE POLICY "Users can view logistics for their orders"
  ON logistics FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM orders
      WHERE orders.id = logistics.order_id
      AND orders.user_id = auth.uid()
    )
  );

-- Create policies for payments
CREATE POLICY "Users can view payments for their orders"
  ON payments FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM orders
      WHERE orders.id = payments.order_id
      AND orders.user_id = auth.uid()
    )
  );

-- Create policies for compliance documents
CREATE POLICY "Users can view compliance documents for their orders"
  ON compliance_documents FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM orders
      WHERE orders.id = compliance_documents.order_id
      AND orders.user_id = auth.uid()
    )
  );

-- Create trigger for logistics updated_at
DROP TRIGGER IF EXISTS update_logistics_updated_at ON logistics;
CREATE TRIGGER update_logistics_updated_at BEFORE UPDATE ON logistics
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

COMMENT ON COLUMN orders.deposit_amount IS 'Deposit amount (20% of total price) required at order time';
COMMENT ON COLUMN orders.tracking_id IS 'Unique tracking ID for order tracking';
COMMENT ON COLUMN orders.payment_status IS 'Payment status: Pending, Completed, Failed, Refunded';
