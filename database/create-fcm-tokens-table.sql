-- Create table for storing user FCM tokens
CREATE TABLE IF NOT EXISTS user_fcm_tokens (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    fcm_token VARCHAR(500) NOT NULL UNIQUE,
    device_type VARCHAR(50) DEFAULT 'android',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create index on user_id for faster queries
CREATE INDEX idx_user_fcm_tokens_user_id ON user_fcm_tokens(user_id);

-- Create index on fcm_token for faster lookups
CREATE INDEX idx_user_fcm_tokens_token ON user_fcm_tokens(fcm_token);

-- Create index on active tokens
CREATE INDEX idx_user_fcm_tokens_active ON user_fcm_tokens(user_id, is_active) WHERE is_active = TRUE;

-- Add comment to table
COMMENT ON TABLE user_fcm_tokens IS 'Stores Firebase Cloud Messaging tokens for push notifications';

-- Optional: Add foreign key constraint if you have a users table
-- ALTER TABLE user_fcm_tokens 
-- ADD CONSTRAINT fk_user_fcm_tokens_user 
-- FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
