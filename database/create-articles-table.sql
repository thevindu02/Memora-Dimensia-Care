-- Create articles table if it doesn't exist
-- This script ensures the articles table has the correct structure for the web portal integration

CREATE TABLE IF NOT EXISTS articles (
    article_id BIGSERIAL PRIMARY KEY,
    volunteer_id INTEGER,
    category_id INTEGER,
    title VARCHAR(255),
    status VARCHAR(50) DEFAULT 'disapproved',
    draft BOOLEAN DEFAULT FALSE,
    tagname VARCHAR(255),
    img VARCHAR(500),
    firebase_doc_id VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create index on volunteer_id for faster queries
CREATE INDEX IF NOT EXISTS idx_articles_volunteer_id ON articles(volunteer_id);

-- Create index on firebase_doc_id for faster lookups
CREATE INDEX IF NOT EXISTS idx_articles_firebase_doc_id ON articles(firebase_doc_id);

-- Create index on status for filtering
CREATE INDEX IF NOT EXISTS idx_articles_status ON articles(status);

-- Create index on draft for filtering
CREATE INDEX IF NOT EXISTS idx_articles_draft ON articles(draft);

-- Show the table structure
\d articles;
