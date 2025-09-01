-- Fix ID type mismatches between database schema and JPA entities
-- Convert INTEGER columns to BIGINT to match Long types in Java entities

-- First, drop foreign key constraints that reference the IDs we're changing
ALTER TABLE careactivity DROP CONSTRAINT IF EXISTS careactivity_schedule_id_fkey;

-- Drop constraints on tables that reference careactivity (if they exist)
ALTER TABLE task DROP CONSTRAINT IF EXISTS fk_task_careactivity;
ALTER TABLE medicationreminder DROP CONSTRAINT IF EXISTS fk_medicationreminder_careactivity;

-- Change schedule_id in schedule table from INTEGER to BIGINT
ALTER TABLE schedule ALTER COLUMN schedule_id TYPE BIGINT;

-- Update the sequence for schedule_id to handle BIGINT values
ALTER SEQUENCE schedule_schedule_id_seq AS BIGINT;

-- Change careactivityid in careactivity table from INTEGER to BIGINT  
ALTER TABLE careactivity ALTER COLUMN careactivityid TYPE BIGINT;

-- Update the sequence for careactivityid to handle BIGINT values
ALTER SEQUENCE careactivity_careactivityid_seq AS BIGINT;

-- Update foreign key references to BIGINT as well
ALTER TABLE careactivity ALTER COLUMN schedule_id TYPE BIGINT;

-- Update other tables that might reference schedule_id
ALTER TABLE careactivity ALTER COLUMN schedule_id TYPE BIGINT;

-- Re-add the foreign key constraints
ALTER TABLE careactivity 
    ADD CONSTRAINT careactivity_schedule_id_fkey 
    FOREIGN KEY (schedule_id) REFERENCES schedule(schedule_id);

-- Add foreign key constraints for tables that reference careactivity (if columns exist)
-- Note: Only add these if the columns exist in the respective tables
DO $$ 
BEGIN
    -- Check if careactivity_id column exists in task table
    IF EXISTS (SELECT 1 FROM information_schema.columns 
               WHERE table_name = 'task' AND column_name = 'careactivity_id') THEN
        -- Update the column type to BIGINT
        ALTER TABLE task ALTER COLUMN careactivity_id TYPE BIGINT;
        -- Add foreign key constraint
        ALTER TABLE task 
            ADD CONSTRAINT fk_task_careactivity 
            FOREIGN KEY (careactivity_id) REFERENCES careactivity(careactivityid);
    END IF;

    -- Check if careactivity_id column exists in medicationreminder table  
    IF EXISTS (SELECT 1 FROM information_schema.columns 
               WHERE table_name = 'medicationreminder' AND column_name = 'careactivity_id') THEN
        -- Update the column type to BIGINT
        ALTER TABLE medicationreminder ALTER COLUMN careactivity_id TYPE BIGINT;
        -- Add foreign key constraint
        ALTER TABLE medicationreminder 
            ADD CONSTRAINT fk_medicationreminder_careactivity 
            FOREIGN KEY (careactivity_id) REFERENCES careactivity(careactivityid);
    END IF;
END $$;
