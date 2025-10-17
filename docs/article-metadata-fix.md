# Article Metadata Not Saving to PostgreSQL - Debugging Guide

## Issue Description
When creating articles through the web portal, the content is being saved to Firebase but the metadata is not being saved to the PostgreSQL `articles` table.

## Root Cause Analysis
The original `addArticle` method in `ArticleService.java` was only saving to Firebase and not to the PostgreSQL database. This has been fixed.

## Solutions Applied

### 1. Fixed ArticleService.addArticle Method
**File**: `backend/src/main/java/Memora/DimensiaCareApplication/service/ArticleService.java`

**Changes Made**:
- Updated `addArticle` method to save to both Firebase AND PostgreSQL
- Added comprehensive logging for debugging
- Added proper error handling
- Ensured Firebase document ID is stored in PostgreSQL for reference

### 2. Database Table Creation
**File**: `database/create-articles-table.sql`

Created SQL script to ensure the articles table exists with correct structure:
```sql
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
```

### 3. Added Debugging Tools
**File**: `backend/src/main/java/Memora/DimensiaCareApplication/controller/DatabaseTestController.java`

Created test endpoints for debugging:
- `GET /api/test/articles` - Get all articles
- `GET /api/test/articles/count` - Count articles
- `POST /api/test/articles/test` - Create test article

## Testing Steps

### Step 1: Verify Database Table Exists
1. Connect to your PostgreSQL database
2. Run the following SQL command:
```sql
\d articles
```
3. If table doesn't exist, run:
```sql
\i database/create-articles-table.sql
```

### Step 2: Test Database Connection
1. Start your backend server
2. Test the database connection:
```bash
curl http://localhost:8080/api/test/articles/count
```
3. Should return: "Total articles in database: X"

### Step 3: Test Article Creation
1. Create a test article:
```bash
curl -X POST http://localhost:8080/api/test/articles/test
```
2. Should return: "Test article created with ID: X"

### Step 4: Test Web Portal Integration
1. Open the web portal
2. Navigate to Create Blog
3. Fill out the form and click "Publish" or "Save Draft"
4. Check backend console logs for detailed output
5. Verify article appears in database:
```sql
SELECT * FROM articles ORDER BY created_at DESC LIMIT 5;
```

## Expected Backend Console Output

When creating an article, you should see:
```
=== Starting article creation process ===
Article DTO received: Title: [title], Volunteer ID: [id], Category ID: [id], Draft: [true/false]
Step 1: Saving to Firestore...
Firestore data prepared: {title=..., volunteerId=..., categoryId=..., ...}
Firestore save initiated with document ID: [firebase-doc-id]
Step 2: Saving to PostgreSQL...
PostgreSQL entity prepared: Title: [title], Firebase Doc ID: [firebase-doc-id], ...
SUCCESS: Article saved to PostgreSQL with ID: [article-id]
SUCCESS: Firestore save completed at: [timestamp]
=== Article creation process completed successfully ===
```

## Troubleshooting

### If PostgreSQL Save Fails
1. **Check database connection**: Verify application.properties database settings
2. **Check table exists**: Run `\d articles` in PostgreSQL
3. **Check column names**: Ensure they match the Article entity
4. **Check data types**: Verify volunteer_id is INTEGER, etc.

### If Firebase Save Fails
1. **Check Firebase configuration**: Verify firebase-admin-key.json exists
2. **Check Firebase connection**: Look for Firebase initialization errors
3. **Check Firestore permissions**: Ensure service account has write access

### Common Errors
- **"Table articles doesn't exist"**: Run the create-articles-table.sql script
- **"Column unknown"**: Check if Article entity field names match database columns
- **"Firebase connection failed"**: Check firebase-admin-key.json configuration
- **"Volunteer ID null"**: Ensure user is properly authenticated

## Database Schema Verification

The articles table should have these columns:
- `article_id` (BIGSERIAL PRIMARY KEY)
- `volunteer_id` (INTEGER) - from authenticated user
- `category_id` (INTEGER) - from category selection
- `title` (VARCHAR) - article title
- `status` (VARCHAR) - 'disapproved', 'approved', etc.
- `draft` (BOOLEAN) - true for drafts, false for published
- `tagname` (VARCHAR) - tags if any
- `img` (VARCHAR) - article image URL
- `firebase_doc_id` (VARCHAR) - reference to Firebase document
- `created_at` (TIMESTAMP) - creation timestamp

## Next Steps After Fix

1. Restart your backend server to load the updated ArticleService
2. Test article creation through the web portal
3. Verify articles appear in both Firebase (content) and PostgreSQL (metadata)
4. Check that the Firebase document ID is properly stored in the `firebase_doc_id` column
5. Remove the test endpoints from DatabaseTestController once everything works

The fix ensures that:
- ✅ Article content is saved to Firebase
- ✅ Article metadata is saved to PostgreSQL
- ✅ Firebase document ID is stored for content retrieval
- ✅ Proper error handling and logging
- ✅ Both draft and published articles work correctly
