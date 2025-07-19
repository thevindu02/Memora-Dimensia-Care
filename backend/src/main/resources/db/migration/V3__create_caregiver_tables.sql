-- Create caregivers table
CREATE TABLE IF NOT EXISTS caregivers (
    caregiver_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    experience VARCHAR(50),
    qualifications TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Create skills table
CREATE TABLE IF NOT EXISTS skills (
    skill_id SERIAL PRIMARY KEY,
    skill_name VARCHAR(100) NOT NULL UNIQUE
);

-- Create caregiver_skill junction table
CREATE TABLE IF NOT EXISTS caregiver_skill (
    id SERIAL PRIMARY KEY,
    caregiver_id INTEGER NOT NULL,
    skill_id INTEGER NOT NULL,
    CONSTRAINT fk_caregiver FOREIGN KEY (caregiver_id) REFERENCES caregivers(caregiver_id) ON DELETE CASCADE,
    CONSTRAINT fk_skill FOREIGN KEY (skill_id) REFERENCES skills(skill_id) ON DELETE CASCADE
);

-- Insert sample skills
INSERT INTO skills (skill_name) VALUES
('Elder Care'),
('Dementia Care'),
('Medical Care'),
('General Care'),
('First Aid'),
('Medication Management'),
('Personal Care'),
('Companionship'),
('Housekeeping'),
('Cooking'),
('Transportation'),
('Child Care'),
('Disability Care');

-- Insert sample caregivers (users first, then caregivers)
INSERT INTO users (f_name, l_name, email, password, phone_number, role, status, city, state, street) VALUES
('Sarah', 'Johnson', 'sarah.johnson@email.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+94 77 111 1111', 'CAREGIVER', 'ACTIVE', 'Colombo', 'Western Province', '45 Galle Road'),
('Michael', 'Chen', 'michael.chen@email.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+94 77 222 2222', 'CAREGIVER', 'ACTIVE', 'Kandy', 'Central Province', '78 Kandy Road'),
('Emily', 'Rodriguez', 'emily.rodriguez@email.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+94 77 333 3333', 'CAREGIVER', 'ACTIVE', 'Galle', 'Southern Province', '156 High Level Road'),
('David', 'Thompson', 'david.thompson@email.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+94 77 444 4444', 'CAREGIVER', 'ACTIVE', 'Colombo', 'Western Province', '89 Malabe Road'),
('Lisa', 'Wang', 'lisa.wang@email.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+94 77 555 5555', 'CAREGIVER', 'ACTIVE', 'Jaffna', 'Northern Province', '234 Gampaha Road'),
('Robert', 'Kim', 'robert.kim@email.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '+94 77 666 6666', 'CAREGIVER', 'ACTIVE', 'Negombo', 'Western Province', '67 Moratuwa Road');

-- Insert caregiver records
INSERT INTO caregivers (user_id, experience, qualifications) VALUES
((SELECT id FROM users WHERE email = 'sarah.johnson@email.com'), '5 years', 'Certificate in Elderly Care, First Aid Certified'),
((SELECT id FROM users WHERE email = 'michael.chen@email.com'), '3 years', 'Diploma in Care Giving, CPR Certified'),
((SELECT id FROM users WHERE email = 'emily.rodriguez@email.com'), '4 years', 'Certificate in Dementia Care, Basic Medical Training'),
((SELECT id FROM users WHERE email = 'david.thompson@email.com'), '6 years', 'Advanced Care Certificate, Mental Health Support Training'),
((SELECT id FROM users WHERE email = 'lisa.wang@email.com'), '2 years', 'Certificate in Elder Care, Basic Health Monitoring'),
((SELECT id FROM users WHERE email = 'robert.kim@email.com'), '7 years', 'Personal Care Assistant Training, First Aid Certified');

-- Insert caregiver skills
INSERT INTO caregiver_skill (caregiver_id, skill_id) VALUES
((SELECT caregiver_id FROM caregivers WHERE user_id = (SELECT id FROM users WHERE email = 'sarah.johnson@email.com')), (SELECT skill_id FROM skills WHERE skill_name = 'Elder Care')),
((SELECT caregiver_id FROM caregivers WHERE user_id = (SELECT id FROM users WHERE email = 'sarah.johnson@email.com')), (SELECT skill_id FROM skills WHERE skill_name = 'First Aid')),
((SELECT caregiver_id FROM caregivers WHERE user_id = (SELECT id FROM users WHERE email = 'michael.chen@email.com')), (SELECT skill_id FROM skills WHERE skill_name = 'Dementia Care')),
((SELECT caregiver_id FROM caregivers WHERE user_id = (SELECT id FROM users WHERE email = 'michael.chen@email.com')), (SELECT skill_id FROM skills WHERE skill_name = 'Medical Care')),
((SELECT caregiver_id FROM caregivers WHERE user_id = (SELECT id FROM users WHERE email = 'emily.rodriguez@email.com')), (SELECT skill_id FROM skills WHERE skill_name = 'General Care')),
((SELECT caregiver_id FROM caregivers WHERE user_id = (SELECT id FROM users WHERE email = 'emily.rodriguez@email.com')), (SELECT skill_id FROM skills WHERE skill_name = 'Personal Care')),
((SELECT caregiver_id FROM caregivers WHERE user_id = (SELECT id FROM users WHERE email = 'david.thompson@email.com')), (SELECT skill_id FROM skills WHERE skill_name = 'Medical Care')),
((SELECT caregiver_id FROM caregivers WHERE user_id = (SELECT id FROM users WHERE email = 'david.thompson@email.com')), (SELECT skill_id FROM skills WHERE skill_name = 'Medication Management')),
((SELECT caregiver_id FROM caregivers WHERE user_id = (SELECT id FROM users WHERE email = 'lisa.wang@email.com')), (SELECT skill_id FROM skills WHERE skill_name = 'Elder Care')),
((SELECT caregiver_id FROM caregivers WHERE user_id = (SELECT id FROM users WHERE email = 'lisa.wang@email.com')), (SELECT skill_id FROM skills WHERE skill_name = 'Companionship')),
((SELECT caregiver_id FROM caregivers WHERE user_id = (SELECT id FROM users WHERE email = 'robert.kim@email.com')), (SELECT skill_id FROM skills WHERE skill_name = 'Dementia Care')),
((SELECT caregiver_id FROM caregivers WHERE user_id = (SELECT id FROM users WHERE email = 'robert.kim@email.com')), (SELECT skill_id FROM skills WHERE skill_name = 'First Aid'));

-- Create indexes for better performance
CREATE INDEX idx_caregivers_user_id ON caregivers(user_id);
CREATE INDEX idx_caregiver_skill_caregiver_id ON caregiver_skill(caregiver_id);
CREATE INDEX idx_caregiver_skill_skill_id ON caregiver_skill(skill_id);
CREATE INDEX idx_users_city ON users(city);
CREATE INDEX idx_users_role ON users(role); 