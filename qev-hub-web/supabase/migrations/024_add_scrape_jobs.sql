-- Scrape Jobs Table
-- Tracks web scraping jobs for grey market prices

CREATE TABLE IF NOT EXISTS scrape_jobs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  source TEXT NOT NULL, -- 'qatarsale', 'qatarliving', etc.
  status TEXT DEFAULT 'running', -- 'running', 'completed', 'failed'
  full_scrape BOOLEAN DEFAULT false,
  vehicles_processed INTEGER DEFAULT 0,
  vehicles_updated INTEGER DEFAULT 0,
  vehicles_created INTEGER DEFAULT 0,
  started_at TIMESTAMPTZ DEFAULT NOW(),
  completed_at TIMESTAMPTZ,
  result TEXT, -- Summary output
  error TEXT, -- Error message if failed
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_scrape_jobs_source ON scrape_jobs(source);
CREATE INDEX IF NOT EXISTS idx_scrape_jobs_status ON scrape_jobs(status);
CREATE INDEX IF NOT EXISTS idx_scrape_jobs_started_at ON scrape_jobs(started_at);

-- Enable RLS
ALTER TABLE scrape_jobs ENABLE ROW LEVEL SECURITY;

-- RLS Policies - only admins can view/manage scrape jobs
CREATE POLICY "Admins can view scrape jobs"
  ON scrape_jobs FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid() AND profiles.role = 'admin'
    )
  );

CREATE POLICY "Admins can insert scrape jobs"
  ON scrape_jobs FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid() AND profiles.role = 'admin'
    )
  );

CREATE POLICY "Admins can update scrape jobs"
  ON scrape_jobs FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid() AND profiles.role = 'admin'
    )
  );

-- Success message
DO $$
BEGIN
  RAISE NOTICE '✓ Scrape jobs table created successfully!';
  RAISE NOTICE '✓ Indexes created';
  RAISE NOTICE '✓ RLS policies enabled';
END
$$;
