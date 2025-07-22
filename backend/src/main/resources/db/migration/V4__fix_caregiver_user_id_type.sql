-- Fix caregiver user_id data type to match users.id (BIGINT)
ALTER TABLE caregivers ALTER COLUMN user_id TYPE BIGINT;

-- Update the foreign key constraint to ensure it references the correct data type
ALTER TABLE caregivers DROP CONSTRAINT IF EXISTS fk_user;
ALTER TABLE caregivers ADD CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id); 