-- Add sample patients for testing
-- First, add sample users (patients)
INSERT INTO users (f_name, l_name, email, password, phone_number, role, status) VALUES
('John', 'Smith', 'john.smith@email.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+94 77 123 4567', 'PATIENT', 'ACTIVE'),
('Mary', 'Johnson', 'mary.johnson@email.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+94 77 234 5678', 'PATIENT', 'ACTIVE'),
('Robert', 'Brown', 'robert.brown@email.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+94 77 345 6789', 'PATIENT', 'ACTIVE');

-- Add sample guardian
INSERT INTO users (f_name, l_name, email, password, phone_number, role, status) VALUES
('Sarah', 'Wilson', 'sarah.wilson@email.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+94 77 456 7890', 'GUARDIAN', 'ACTIVE');

-- Add sample patients (assuming patients table exists)
-- Note: You'll need to adjust the patient_id and guardian_id based on the actual IDs from the users table
INSERT INTO patients (user_id, guardian_id, dementia_stage, dementia_type, date_of_diagnosis) VALUES
((SELECT id FROM users WHERE email = 'john.smith@email.com'), (SELECT id FROM users WHERE email = 'sarah.wilson@email.com'), 'SEVERE', 'ALZHEIMERS', '2023-01-15'),
((SELECT id FROM users WHERE email = 'mary.johnson@email.com'), (SELECT id FROM users WHERE email = 'sarah.wilson@email.com'), 'MODERATE', 'VASCULAR', '2023-03-20'),
((SELECT id FROM users WHERE email = 'robert.brown@email.com'), (SELECT id FROM users WHERE email = 'sarah.wilson@email.com'), 'MILD', 'LEWY_BODY', '2023-06-10'); 