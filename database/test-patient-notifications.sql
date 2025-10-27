-- Test SQL Script for Patient Notifications
-- Run this in your PostgreSQL database to create test notifications

-- First, find your patient ID
SELECT patient_id, user_id FROM patients;

-- Replace {PATIENT_ID} with actual patient_id from above query
-- Replace {CAREGIVER_ID} with an actual caregiver_id from your database

-- Create test notifications for patient
INSERT INTO notifications (
    caregiver_id, 
    patient_id, 
    patient_name, 
    title, 
    message, 
    notification_type, 
    task_id, 
    task_name, 
    is_read, 
    created_at
) VALUES 
-- Unread notifications
(
    1,  -- caregiver_id
    1,  -- patient_id (CHANGE THIS)
    'Test Patient',
    'Medication Reminder',
    'Time to take your morning medication',
    'MEDICATION_REMINDER',
    NULL,
    'Morning Medication',
    false,
    NOW() - INTERVAL '2 minutes'
),
(
    1,
    1,  -- patient_id (CHANGE THIS)
    'Test Patient',
    'Appointment Reminder',
    'Doctor appointment scheduled for tomorrow at 10 AM',
    'APPOINTMENT_REMINDER',
    NULL,
    'Doctor Visit',
    false,
    NOW() - INTERVAL '30 minutes'
),
(
    1,
    1,  -- patient_id (CHANGE THIS)
    'Test Patient',
    'Task Reminder',
    'Exercise session starting in 4 minutes',
    'TASK_REMINDER',
    5,
    'Morning Walk',
    false,
    NOW() - INTERVAL '1 hour'
),

-- Read notifications
(
    1,
    1,  -- patient_id (CHANGE THIS)
    'Test Patient',
    'Medication Taken',
    'Evening medication taken successfully',
    'MEDICATION_REMINDER',
    NULL,
    'Evening Pills',
    true,
    NOW() - INTERVAL '1 day'
),
(
    1,
    1,  -- patient_id (CHANGE THIS)
    'Test Patient',
    'Activity Completed',
    'Daily exercise completed successfully',
    'TASK_REMINDER',
    3,
    'Afternoon Exercise',
    true,
    NOW() - INTERVAL '2 days'
);

-- Verify the notifications were created
SELECT 
    notification_id,
    title,
    message,
    notification_type,
    is_read,
    created_at
FROM notifications
WHERE patient_id = 1  -- CHANGE THIS to your patient_id
ORDER BY created_at DESC;

-- Count unread notifications
SELECT COUNT(*) as unread_count
FROM notifications
WHERE patient_id = 1  -- CHANGE THIS
AND is_read = false;

-- Count read notifications
SELECT COUNT(*) as read_count
FROM notifications
WHERE patient_id = 1  -- CHANGE THIS
AND is_read = true;