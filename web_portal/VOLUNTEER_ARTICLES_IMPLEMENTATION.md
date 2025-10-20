# Volunteer Web Portal - Articles Implementation Guide

## Overview
This document describes the implementation of the article viewing, commenting, and like/unlike functionality for the volunteer web portal, mirroring the features available in the mobile app.

## Features Implemented

### 1. Articles List Page (`/volunteer/articles`)
- **Real-time data fetching** from backend API
- **Search functionality** - Search by title, content, author, category
- **Category filtering** - Filter articles by category
- **Responsive card layout** with article previews
- **Article metadata display**:
  - Article image (with fallback placeholder)
  - Title and summary
  - Author name and publish date
  - Category badge
  - Like count
  - Comment count

### 2. Single Article View (`/volunteer/articles/:id`)
- **Complete article display**:
  - Full article content
  - Article header image
  - Author information and profile picture
  - Category tags
  - Publication date
  
- **Like/Unlike functionality**:
  - Like button with count display
  - Unlike button
  - Optimistic UI updates
  - Backend integration
  - User authentication check
  
- **Real-time comments**:
  - Display all comments in real-time
  - Add new comments
  - Comment metadata (author, user type, timestamp)
  - Firebase Firestore integration for real-time updates
  - Mobile-optimized fixed comment input

## Technical Implementation

### File Structure
```
web_portal/src/
├── components/volunteer/
│   ├── Articles.js                 (Articles list page)
│   ├── SingleArticle.js            (Single article view)
│   └── ...
├── services/
│   ├── articleService.js           (Article API calls)
│   └── commentService.js           (Firebase comment service)
└── config/
    ├── api.js                      (API configuration)
    └── firebase.js                 (Firebase configuration)
```

### Backend API Endpoints Used

#### Articles
- `GET /api/articles/published/all` - Get all published articles
- `GET /api/articles/detail/:id` - Get single article with full details
- `POST /api/articles/:articleId/like?userId=:userId` - Like an article
- `DELETE /api/articles/:articleId/like?userId=:userId` - Unlike an article
- `GET /api/articles/:articleId/like-status?userId=:userId` - Get like status

#### Comments (Firebase Firestore)
- Collection: `articles_comments`
- Real-time subscription to comments
- Add new comments with user info

### Key Components

#### Articles.js
```javascript
// Features:
- useEffect to fetch articles on mount
- useMemo for filtering by search and category
- Navigate to single article on click
- Loading and error states
- Responsive grid layout
```

#### SingleArticle.js
```javascript
// Features:
- useParams to get article ID from URL
- useEffect to fetch article, load like status, subscribe to comments
- Optimistic UI updates for like/unlike
- Real-time comment updates via Firebase
- Comment posting with user authentication
- Mobile-optimized fixed comment input
```

#### articleService.js
```javascript
// New methods added:
- getAllPublishedArticles()
- likeArticle(articleId, userId)
- unlikeArticle(articleId, userId)
- getArticleLikeStatus(articleId, userId)
```

#### commentService.js
```javascript
// Methods:
- addComment({ articleId, userId, userName, userType, content })
- subscribeToComments(articleId, callback)
- formatTimestamp(timestamp)
```

### Color Theme
The implementation uses the existing web portal color scheme:
```javascript
const colors = {
  softLavender: "#C3B1E1",
  deepPurple: "#390797",
  lightSkyBlue: "#A0C4FD",
  calmNavy: "#2B3F99",
};
```

## Setup Instructions

### 1. Install Dependencies
```bash
cd web_portal
npm install firebase
```

### 2. Configure Firebase
Edit `src/config/firebase.js` and replace the placeholder values with your Firebase project credentials:

```javascript
const firebaseConfig = {
  apiKey: "YOUR_API_KEY",
  authDomain: "YOUR_AUTH_DOMAIN",
  projectId: "YOUR_PROJECT_ID",
  storageBucket: "YOUR_STORAGE_BUCKET",
  messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
  appId: "YOUR_APP_ID"
};
```

You can find these credentials in:
- Firebase Console → Project Settings → General
- Look for "Your apps" section
- Select your web app or create one

### 3. Verify Backend is Running
Ensure your backend server is running on `http://localhost:8080` (or update the API_BASE_URL in `src/config/api.js`)

### 4. User Authentication
The implementation expects user information in localStorage:
```javascript
// Expected user object structure:
{
  userId: number,
  name: string,
  email: string,
  role: string  // e.g., "Volunteer"
}
```

Make sure your sign-in component stores this information properly.

### 5. Start the Development Server
```bash
npm start
```

Navigate to:
- Articles list: `http://localhost:3000/volunteer/articles`
- Single article: `http://localhost:3000/volunteer/articles/:articleId`

## Testing

### Test Articles List
1. Navigate to `/volunteer/articles`
2. Verify articles are loaded from backend
3. Test search functionality
4. Test category filtering
5. Click on an article card

### Test Single Article View
1. Click on any article from the list
2. Verify article content is displayed
3. Test like button (must be signed in)
4. Test unlike button
5. Test adding a comment (must be signed in)
6. Verify comments appear in real-time

### Test Mobile Responsiveness
1. Open Chrome DevTools
2. Toggle device toolbar (Ctrl+Shift+M)
3. Test on various mobile screen sizes
4. Verify fixed comment input on mobile

## Known Limitations & Future Enhancements

### Current Limitations
1. No comment replies yet (can be added based on mobile app pattern)
2. No comment editing/deletion
3. No profile pictures for comments (uses placeholder)
4. No unlike count display (only removes like)

### Suggested Enhancements
1. Add comment replies functionality
2. Add comment editing/deletion for own comments
3. Integrate user profile pictures
4. Add article sharing functionality
5. Add article bookmarking
6. Add pagination for articles list
7. Add infinite scroll for comments
8. Add image zoom for article images
9. Add article reading time estimate
10. Add "related articles" section

## Troubleshooting

### Firebase Connection Issues
**Problem**: Comments not working, "Firebase not initialized" error
**Solution**: 
1. Check `src/config/firebase.js` has correct credentials
2. Verify Firebase project is set up
3. Check browser console for specific Firebase errors

### Articles Not Loading
**Problem**: Articles list is empty or shows error
**Solution**:
1. Check backend server is running
2. Verify API_BASE_URL in `src/config/api.js`
3. Check browser console for API errors
4. Verify articles exist in database with status="approved"

### Like/Unlike Not Working
**Problem**: Like button doesn't work or shows error
**Solution**:
1. Verify user is signed in (check localStorage)
2. Check backend API endpoints are working
3. Verify userId is being sent correctly
4. Check browser console for API errors

### Navigation Issues
**Problem**: Clicking article doesn't navigate to single article page
**Solution**:
1. Verify `SingleArticle` component is imported in App.js
2. Check route is defined: `/volunteer/articles/:id`
3. Verify article has `firebaseDocId` field

## Mobile App Comparison

### Features Parity with Mobile App
✅ View all published articles
✅ Search articles
✅ Filter by category
✅ View single article with full content
✅ Like/unlike articles
✅ View like count
✅ Add comments
✅ View comments in real-time
✅ Comment metadata (author, userType, timestamp)

### Differences from Mobile App
- Web uses Material-UI components instead of Flutter widgets
- Web uses React hooks instead of Flutter StatefulWidget
- Color scheme adapted to web portal's existing theme
- Desktop and mobile responsive layouts

## API Documentation Reference

For complete API documentation, refer to:
- `docs/ARTICLE_LIKES_IMPLEMENTATION.md`
- Backend controller: `backend/src/main/java/.../ArticleController.java`
- Backend service: `backend/src/main/java/.../ArticleService.java`

## Support

For issues or questions:
1. Check this documentation
2. Review browser console for errors
3. Check backend logs
4. Refer to mobile app implementation for comparison
5. Contact development team

---

**Last Updated**: January 2025
**Author**: Development Team
**Version**: 1.0
