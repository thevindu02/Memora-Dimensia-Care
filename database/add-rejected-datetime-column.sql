-- Add rejected_date_time column to guardian_patient_caregiver_connection table
-- This allows tracking when a caregiver rejects a request to hide them for 2 days

ALTER TABLE guardian_patient_caregiver_connection 
ADD COLUMN rejected_date_time TIMESTAMP NULL;

-- Add comment to describe the purpose of this column
COMMENT ON COLUMN guardian_patient_caregiver_connection.rejected_date_time 
IS 'Timestamp when caregiver rejected the connection request. Used to hide caregiver from patient for 2 days after rejection.';
