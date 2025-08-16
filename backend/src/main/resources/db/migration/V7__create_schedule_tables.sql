-- Migration to create Schedule, CareActivity, DailyTask, Game, Task, and GameScore tables

-- Create Game table
CREATE TABLE IF NOT EXISTS game (
    gameid SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT
);

-- Create Schedule table
CREATE TABLE IF NOT EXISTS schedule (
    schedule_id SERIAL PRIMARY KEY,
    patient_id BIGINT NOT NULL,
    guardian_id BIGINT NOT NULL,
    caregiver_id INTEGER NOT NULL,
    date DATE NOT NULL,
    iscompleted BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (guardian_id) REFERENCES guardians(guardian_id),
    FOREIGN KEY (caregiver_id) REFERENCES caregivers(caregiver_id)
);

-- Create CareActivity table
CREATE TABLE IF NOT EXISTS careactivity (
    careactivityid SERIAL PRIMARY KEY,
    schedule_id BIGINT NOT NULL,
    time TIME NOT NULL,
    skipreason TEXT,
    status VARCHAR(50),
    FOREIGN KEY (schedule_id) REFERENCES schedule(schedule_id)
);

-- Create DailyTask table
CREATE TABLE IF NOT EXISTS dailytask (
    dailytaskid SERIAL PRIMARY KEY,
    careactivityid BIGINT NOT NULL,
    dailytaskname VARCHAR(100) NOT NULL,
    description TEXT,
    FOREIGN KEY (careactivityid) REFERENCES careactivity(careactivityid)
);

-- Create Task table (links CareActivity with Game)
CREATE TABLE IF NOT EXISTS task (
    taskid SERIAL PRIMARY KEY,
    careactivityid BIGINT NOT NULL,
    gameid BIGINT NOT NULL,
    FOREIGN KEY (careactivityid) REFERENCES careactivity(careactivityid),
    FOREIGN KEY (gameid) REFERENCES game(gameid)
);

-- Create GameScores table
CREATE TABLE IF NOT EXISTS gamescores (
    gamescoreid SERIAL PRIMARY KEY,
    gameid BIGINT NOT NULL,
    patient_id BIGINT NOT NULL,
    score INTEGER NOT NULL,
    FOREIGN KEY (gameid) REFERENCES game(gameid),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

-- Insert some sample games
INSERT INTO game (name, description) VALUES
('Memory Match', 'A card matching game to improve memory'),
('Word Recognition', 'Identify and recall words to enhance vocabulary'),
('Pattern Recognition', 'Recognize and complete patterns for cognitive training'),
('Simple Math', 'Basic arithmetic exercises for mental stimulation')
ON CONFLICT DO NOTHING;
