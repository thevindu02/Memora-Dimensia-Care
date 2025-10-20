# Article Likes Feature Implementation

## Overview
This document describes the implementation of the like/unlike feature for articles in the Memora Dementia Care Platform mobile app.

## Implementation Date
October 19, 2025

## Feature Description
Users can now like and unlike articles with the following characteristics:
- **One like per user per article** - Users can only like an article once
- **Toggle behavior** - Clicking the like button when already liked will unlike the article
- **Real-time updates** - Like counts update immediately with optimistic UI updates
- **Persistent storage** - Likes are stored in Firebase Firestore
- **Cross-platform** - Works for Volunteers, Guardians, and Caregivers

## Architecture

### Backend (Java Spring Boot)

#### 1. Database Structure (Firebase Firestore)

**Collection: `article_likes`**
```json
{
  "likeId": "auto-generated-id",
  "articleId": "article-firebase-doc-id",
  "userId": 123,
  "createdAt": "timestamp"
}
```

**Collection: `articles`** (updated fields)
```json
{
  "likes": 0,  // Counter field
  "updated_at": "timestamp"
}
```

#### 2. Service Layer (`ArticleService.java`)

**New Methods:**
- `likeArticle(String articleId, Long userId)` - Like an article
- `unlikeArticle(String articleId, Long userId)` - Unlike an article
- `hasLikedArticle(String articleId, Long userId)` - Check if user has liked
- `getArticleLikeCount(String articleId)` - Get total like count

**Implementation Details:**
- Uses Firestore transactions to ensure atomic counter updates
- Prevents duplicate likes by checking existing records
- Automatically increments/decrements like count on articles

#### 3. Controller Layer (`ArticleController.java`)

**New Endpoints:**

1. **Like an Article**
   - **Method:** `POST`
   - **URL:** `/api/articles/{articleId}/like`
   - **Parameters:** `userId` (query param)
   - **Response:** `{"message": "Article liked successfully"}`

2. **Unlike an Article**
   - **Method:** `DELETE`
   - **URL:** `/api/articles/{articleId}/like`
   - **Parameters:** `userId` (query param)
   - **Response:** `{"message": "Article unliked successfully"}`

3. **Get Like Status**
   - **Method:** `GET`
   - **URL:** `/api/articles/{articleId}/like-status`
   - **Parameters:** `userId` (optional query param)
   - **Response:** 
   ```json
   {
     "likeCount": 42,
     "hasLiked": true
   }
   ```

### Frontend (Flutter)

#### 1. Service Layer (`article_service.dart`)

**New Methods:**
```dart
static Future<Map<String, dynamic>> likeArticle({
  required String articleId,
  required int userId,
})

static Future<Map<String, dynamic>> unlikeArticle({
  required String articleId,
  required int userId,
})

static Future<Map<String, dynamic>?> getArticleLikeStatus({
  required String articleId,
  int? userId,
})
```

#### 2. UI Components (Article Screens)

**Updated Screens:**
1. `volunteer_single_article_screen.dart`
2. `guardian_single_article_screen.dart`
3. `caregiver/view_article_screen.dart`
4. `volunteer/view_article_screen.dart`

**Key Features:**
- Load like status on screen initialization
- Optimistic UI updates (immediate feedback)
- Error handling with rollback on failure
- Visual feedback with heart icon (filled/outlined)
- Like count display

## User Flow

1. **Initial Load:**
   - Screen loads article details
   - Fetches like status from backend
   - Displays current like count and user's like state

2. **Like Action:**
   - User taps heart icon
   - UI updates immediately (optimistic update)
   - API call sent to backend
   - On success: keep UI changes
   - On failure: revert UI and show error message

3. **Unlike Action:**
   - User taps filled heart icon
   - UI updates immediately (optimistic update)
   - API call sent to backend
   - On success: keep UI changes
   - On failure: revert UI and show error message

## Code Examples

### Backend - Like Article
```java
@PostMapping("/{articleId}/like")
public ResponseEntity<?> likeArticle(
        @PathVariable String articleId,
        @RequestParam Long userId) {
    try {
        boolean success = articleService.likeArticle(articleId, userId);
        if (success) {
            return ResponseEntity.ok(Map.of("message", "Article liked successfully"));
        } else {
            return ResponseEntity.ok(Map.of("message", "Already liked"));
        }
    } catch (Exception e) {
        return ResponseEntity.status(500).body(Map.of("error", e.getMessage()));
    }
}
```

### Frontend - Toggle Like
```dart
Future<void> _toggleLike() async {
  if (currentUserId == null) {
    // Show sign-in message
    return;
  }

  // Optimistic update
  final previousState = _isLiked;
  final previousCount = _likeCount;
  
  setState(() {
    _isLiked = !_isLiked;
    _likeCount += _isLiked ? 1 : -1;
  });

  try {
    final result = _isLiked
        ? await ArticleService.likeArticle(articleId: widget.articleId, userId: currentUserId!)
        : await ArticleService.unlikeArticle(articleId: widget.articleId, userId: currentUserId!);

    if (!result['success']) {
      // Revert on failure
      setState(() {
        _isLiked = previousState;
        _likeCount = previousCount;
      });
    }
  } catch (e) {
    // Revert on error
    setState(() {
      _isLiked = previousState;
      _likeCount = previousCount;
    });
  }
}
```

## Testing Checklist

- [ ] Backend endpoints return correct responses
- [ ] Like count increments correctly
- [ ] Like count decrements correctly
- [ ] Users cannot like the same article twice
- [ ] Unlike only works if user has previously liked
- [ ] Optimistic UI updates work correctly
- [ ] Error handling and rollback work properly
- [ ] Like status persists across app restarts
- [ ] Multiple users can like the same article
- [ ] Like counts are accurate across all user types

## Security Considerations

1. **User Authentication:** All like/unlike operations require a valid userId
2. **Duplicate Prevention:** Backend checks for existing likes before creating new ones
3. **Atomic Operations:** Firestore transactions ensure data consistency
4. **Error Handling:** Proper error messages and rollback mechanisms

## Future Enhancements

1. Add unlike notifications to article authors
2. Show list of users who liked an article
3. Add analytics for popular articles
4. Implement like animations
5. Add "Most Liked" articles section

## Files Modified

### Backend
- `backend/src/main/java/Memora/DimensiaCareApplication/service/ArticleService.java`
- `backend/src/main/java/Memora/DimensiaCareApplication/controller/ArticleController.java`

### Frontend (Mobile App)
- `mobile_app/lib/services/article_service.dart`
- **`mobile_app/lib/screens/volunteer/volunteer_single_article_screen.dart`** ← **SHARED BY ALL USER TYPES**

### User Flow - Community Section (Shared)
All user types (Volunteers, Guardians, Caregivers) access the same community section:
1. Click "Community" in bottom navigation bar
2. View `VolunteerCommunityScreen` (shared component)
3. Switch to "Articles" tab (`VolunteerArticlesTabBody`)
4. Click on any article
5. Opens `VolunteerSingleArticleScreen` (shared component with like functionality)

**Note:** Despite the "Volunteer" naming, these components are shared across all user types in the community section.

## Notes

- This implementation follows the same pattern as the forum answer likes feature
- The feature is independent of the article commenting system
- Like data is stored separately from article metadata for better scalability
- The system uses Firebase Firestore for both like records and article counters
- **The like functionality is implemented ONLY in the shared community article view screen**
- All users (volunteers, guardians, caregivers) use the same article viewing component

---

**Implementation Status:** ✅ Complete
**Tested:** Pending integration testing
**Deployed:** Pending deployment
