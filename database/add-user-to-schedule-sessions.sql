-- Add user_id column to schedule_sessions table if not exists
-- This associates each session with a specific user who should receive notifications

DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'schedule_sessions' 
        AND column_name = 'user_id'
    ) THEN
        ALTER TABLE schedule_sessions ADD COLUMN user_id INTEGER;
        
        -- Add foreign key constraint if you have a users table
        -- ALTER TABLE schedule_sessions 
        -- ADD CONSTRAINT fk_schedule_sessions_user 
        -- FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
        
        -- Create index for faster queries
        CREATE INDEX idx_schedule_sessions_user_id ON schedule_sessions(user_id);
        
        COMMENT ON COLUMN schedule_sessions.user_id IS 'User who should receive notifications for this session';
    END IF;
END $$;

-- Add notification_sent flag to track if notification has been sent
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'schedule_sessions' 
        AND column_name = 'notification_sent'
    ) THEN
        ALTER TABLE schedule_sessions ADD COLUMN notification_sent BOOLEAN DEFAULT FALSE;
        
        COMMENT ON COLUMN schedule_sessions.notification_sent IS 'Flag to track if notification has been sent for this session';
    END IF;
END $$;

-- Create index for efficient notification checks
CREATE INDEX IF NOT EXISTS idx_schedule_sessions_date_time 
ON schedule_sessions(session_date, session_time) 
WHERE notification_sent = FALSE;
