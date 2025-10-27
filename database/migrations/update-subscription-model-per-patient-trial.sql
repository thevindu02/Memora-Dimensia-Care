-- Update guardian_subscriptions table for new per-patient trial + paid model
-- PostgreSQL version
-- Run this migration to support the new payment system

-- Add new columns for trial and paid periods
ALTER TABLE guardian_subscriptions 
ADD COLUMN IF NOT EXISTS trial_start_date DATE,
ADD COLUMN IF NOT EXISTS trial_end_date DATE,
ADD COLUMN IF NOT EXISTS paid_start_date DATE,
ADD COLUMN IF NOT EXISTS paid_end_date DATE;

-- Make old columns nullable (they'll be deprecated)
ALTER TABLE guardian_subscriptions 
ALTER COLUMN plan_type DROP NOT NULL,
ALTER COLUMN start_date DROP NOT NULL,
ALTER COLUMN end_date DROP NOT NULL,
ALTER COLUMN duration_months DROP NOT NULL;

-- Update subscription status to include TRIAL
-- First, alter column type if needed
ALTER TABLE guardian_subscriptions 
ALTER COLUMN status TYPE VARCHAR(50);

-- Add check constraint for valid status values
ALTER TABLE guardian_subscriptions 
DROP CONSTRAINT IF EXISTS guardian_subscriptions_status_check;

ALTER TABLE guardian_subscriptions 
ADD CONSTRAINT guardian_subscriptions_status_check 
CHECK (status IN ('PENDING', 'TRIAL', 'ACTIVE', 'EXPIRED', 'CANCELLED'));

-- Add comments for clarity
COMMENT ON COLUMN guardian_subscriptions.trial_start_date IS 'Start date of 3-month free trial (when caregiver assigned)';
COMMENT ON COLUMN guardian_subscriptions.trial_end_date IS 'End date of 3-month free trial';
COMMENT ON COLUMN guardian_subscriptions.paid_start_date IS 'Start date of paid subscription';
COMMENT ON COLUMN guardian_subscriptions.paid_end_date IS 'End date of paid subscription';
COMMENT ON COLUMN guardian_subscriptions.duration_months IS 'Duration in months (3, 6, or 12) for paid subscription';

-- Add indexes for better performance
CREATE INDEX IF NOT EXISTS idx_guardian_subscriptions_patient_id ON guardian_subscriptions(patient_id);
CREATE INDEX IF NOT EXISTS idx_guardian_subscriptions_status ON guardian_subscriptions(status);
