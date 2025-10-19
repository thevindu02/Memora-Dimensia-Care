-- Migration: Allow NULL passwords ONLY for PATIENT accounts
-- Date: 2025-10-18
-- Description: Make password column nullable, but enforce that only PATIENT role can have null passwords

-- Step 1: Remove the NOT NULL constraint
ALTER TABLE users 
ALTER COLUMN password DROP NOT NULL;

-- Step 2: Add a CHECK constraint to ensure only PATIENT role can have null passwords
ALTER TABLE users
ADD CONSTRAINT check_password_required_for_non_patients 
CHECK (
  (role = 'PATIENT') OR 
  (role != 'PATIENT' AND password IS NOT NULL)
);

-- Step 3: Add comment
COMMENT ON COLUMN users.password IS 'Password can be null ONLY for PATIENT role. All other roles require passwords.';

