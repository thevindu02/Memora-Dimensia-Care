# Create Blog Backend Integration

## Overview
The create blog functionality has been successfully integrated with the backend API. This implementation allows volunteers to create blog articles through the web portal using the existing mobile app backend endpoints with Firebase integration for content storage.

## Files Created/Modified

### 1. Article Service (`/src/services/articleService.js`)
- **Purpose**: Handles all API communication for article operations
- **Key Features**:
  - Create new articles (both drafts and published)
  - Get articles by ID
  - Get draft articles for a volunteer
  - Get all article categories
  - Client-side validation
  - Error handling
  - Content cleaning and summary generation utilities

### 2. Updated Create Blog Component (`/src/components/volunteer/CreateBlog.js`)
- **Purpose**: React component for the blog creation interface
- **Key Features**:
  - Backend API integration for articles and categories
  - Real-time category loading from database
  - Form validation with real-time error clearing
  - Loading states for both save draft and publish actions
  - Success/error messaging
  - Disabled form during submission
  - Complete form reset on successful submission
  - Summary auto-generation if not provided

### 3. Updated API Config (`/src/config/api.js`)
- Added `ARTICLES: '/articles'` endpoint
- Added `CATEGORIES: '/categories'` endpoint

### 4. Updated Backend Controllers
- **ArticleController**: Added `@CrossOrigin(origins = "*")` annotation
- **ArticleCategoryController**: Added `@CrossOrigin(origins = "*")` annotation

## Backend Integration Architecture

### Data Flow
1. **Frontend** → Article Service → **Backend API** → **Firebase** (content storage) + **PostgreSQL** (metadata)
2. Articles content is stored in Firebase Firestore
3. Article metadata is stored in PostgreSQL database
4. Categories are stored in PostgreSQL and loaded dynamically

### Firebase Integration
- Articles content is stored in Firebase Firestore collection: `articles`
- Each article gets a unique Firebase document ID
- The document ID is stored in PostgreSQL for reference
- Content includes: title, content, volunteerId, categoryId, created_at

### PostgreSQL Storage
- Article metadata in `articles` table
- Categories in `article_category` table
- Firebase document ID reference for content retrieval

## Backend Endpoints Used

### Create Article
- **Endpoint**: `POST /api/articles`
- **Purpose**: Create a new article (blog post)
- **Request Body**:
```json
{
  "title": "Article Title",
  "summary": "Brief summary",
  "content": "Full article content",
  "categoryId": 1,
  "volunteerId": 123,
  "draft": false,
  "status": "disapproved",
  "articleImg": "image_url"
}
```

### Get Article by ID
- **Endpoint**: `GET /api/articles/{id}`
- **Purpose**: Retrieve a specific article from Firebase

### Get Draft Articles
- **Endpoint**: `GET /api/articles/drafts?volunteerId={id}`
- **Purpose**: Get all draft articles for a specific volunteer

### Get Categories
- **Endpoint**: `GET /api/categories`
- **Purpose**: Retrieve all available article categories
- **Response**:
```json
[
  {
    "categoryId": 1,
    "categoryName": "General"
  },
  {
    "categoryId": 2,
    "categoryName": "Caregiving"
  }
]
```

## Form Features

### Validation (Client-Side)
- **Title**: Required, 5-200 characters
- **Content**: Required for publishing (50+ characters), optional for drafts
- **Category**: Required selection
- **Summary**: Optional, max 500 characters (auto-generated if empty)

### Backend Validation
- Firebase connectivity validation
- Volunteer ID validation
- Category ID validation
- Content storage verification

### User Experience Features
- **Real-time Validation**: Errors clear as user types
- **Loading States**: Buttons show spinner during submission
- **Auto-summary**: Generated from content if not provided
- **Category Loading**: Categories loaded from database on component mount
- **Form Reset**: Complete reset after successful submission
- **Error Handling**: Comprehensive error messaging for all failure scenarios

## Error Handling

### Network Errors
- Connection timeouts
- Server unavailable
- Firebase connection issues

### Validation Errors
- Invalid data format
- Missing required fields
- Category not found

### Authentication Errors
- User not logged in
- Invalid volunteer ID
- Permission issues

### User Feedback
- Real-time error messages
- Success confirmation
- Loading indicators
- Form field highlighting

## Usage Example

```javascript
import articleService from './services/articleService';

// Create a new article
const articleData = {
  title: 'Understanding Dementia Care',
  summary: 'A comprehensive guide to dementia care',
  content: 'Full article content here...',
  categoryId: 2, // Caregiving category
  volunteerId: 123,
  draft: false,
  articleImg: 'https://example.com/image.jpg'
};

const result = await articleService.createArticle(articleData);
if (result.success) {
  console.log('Article created:', result.data);
} else {
  console.error('Error:', result.message);
}
```

## Testing the Integration

1. **Start the backend server** (should be running on localhost:8080)
2. **Ensure Firebase is configured** (firebase-admin-key.json in backend)
3. **Start the web portal** (npm start)
4. **Navigate to Create Blog page**
5. **Fill out the form**:
   - Select a category (loaded from database)
   - Enter title (required)
   - Add summary (optional)
   - Write content (required for publishing)
   - Add tags (optional)
6. **Save Draft or Publish** - the article will be created in Firebase + PostgreSQL

## Success Indicators

✅ **Category Loading**: Categories loaded from PostgreSQL database
✅ **Form Validation**: All fields properly validated
✅ **API Integration**: Backend endpoints properly called
✅ **Firebase Storage**: Article content stored in Firestore
✅ **PostgreSQL Metadata**: Article metadata saved to database
✅ **Error Handling**: Comprehensive error management
✅ **User Experience**: Loading states and feedback
✅ **Data Persistence**: Articles saved with proper references
✅ **CORS Support**: Backend configured with @CrossOrigin

## Firebase Data Structure

Articles are stored in Firebase with this structure:
```json
{
  "title": "Article Title",
  "volunteerId": 123,
  "categoryId": 1,
  "content": "Full article content...",
  "created_at": 1629123456789
}
```

## Next Steps

The create blog functionality is now fully integrated with the backend using Firebase for content storage. Volunteers can:
- Create and publish blog articles
- Save articles as drafts
- Select from dynamic categories
- Get comprehensive validation feedback
- Experience smooth loading states

The implementation follows the same patterns used for other backend integrations, ensuring consistency across the application while leveraging Firebase for scalable content storage.
