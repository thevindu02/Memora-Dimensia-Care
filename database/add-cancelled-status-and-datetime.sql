-- Add cancelled_date_time column to guardian_patient_caregiver_connection table
-- This allows tracking when a guardian cancels a connection request

ALTER TABLE guardian_patient_caregiver_connection 
ADD COLUMN cancelled_date_time TIMESTAMP NULL;

-- Add CANCELLED status to the existing status enum (this may need to be adjusted based on your database)
-- Note: For PostgreSQL, you would use:
-- ALTER TYPE connection_status ADD VALUE 'CANCELLED';

-- Add comment to describe the purpose of this column
COMMENT ON COLUMN guardian_patient_caregiver_connection.cancelled_date_time 
IS 'Timestamp when guardian cancelled the connection request. Used when guardians cancel requests within 24 hours.';
