# Volunteer Articles Implementation - Mobile App

## Overview
This document describes the implementation of the "View Your Articles" and "My Drafts" functionality in the mobile app for volunteers.

## Implementation Date
October 20, 2025

## Features Implemented

### 1. View Your Published Articles
**Screen:** `VolunteerMyArticlesScreen`
**Route:** `/volunteer/myarticles`

**Functionality:**
- Displays all published articles created by the currently logged-in volunteer
- Shows article title, summary, header image, category, status, like count, and comment count
- Tappable cards that navigate to the full article detail screen
- Pull-to-refresh functionality
- Empty state when no articles are published
- Error handling with retry button

**Status Badges:**
- **Approved** (Green) - Article is approved and visible to all users
- **Pending Review** (Orange) - Article is submitted but waiting for admin approval
- **Rejected** (Red) - Article was rejected by admin

### 2. My Drafts
**Screen:** `ArticleDraftScreen` (Already existed, now properly integrated)
**Route:** `/volunteer/draft`

**Functionality:**
- Displays all draft articles created by the currently logged-in volunteer
- Edit draft articles
- Publish drafts (submits for admin review)
- Delete drafts
- Pull-to-refresh functionality

## Backend API Endpoints Used

### Get Published Articles
```
GET /api/articles/published?volunteerId={volunteerId}
```
- Returns all published articles (approved + pending) for a specific volunteer
- Includes article metadata: title, summary, category, status, likes, comments

### Get Draft Articles
```
GET /api/articles/drafts?volunteerId={volunteerId}
```
- Returns all draft articles for a specific volunteer
- Includes editable article data

## Files Created/Modified

### New Files:
1. **`mobile_app/lib/screens/volunteer/volunteer_my_articles_screen.dart`**
   - Screen to display volunteer's published articles
   - Article cards with images, status badges, and stats
   - Navigation to article detail screen

### Modified Files:
1. **`mobile_app/lib/services/article_service.dart`**
   - Added `getMyPublishedArticles()` method
   - Fetches published articles for the current volunteer

2. **`mobile_app/lib/routes/app_routes.dart`**
   - Added `volunteerMyArticles` route constant
   - Added `volunteerSingleArticle` route constant

3. **`mobile_app/lib/screens/volunteer/volunteer_routes.dart`**
   - Added route handler for `volunteerMyArticles`
   - Added route handler for `volunteerSingleArticle`
   - Imported necessary screen files

4. **`mobile_app/lib/screens/volunteer/volunteer_create_content_screen.dart`**
   - Updated "View Your Articles" button to navigate to `volunteerMyArticles`
   - Updated "My Drafts" button navigation (removed hardcoded volunteerId)

## User Flow

### Viewing Published Articles:
1. User clicks "View Your Articles" on the Create Content screen
2. App navigates to `VolunteerMyArticlesScreen`
3. Screen fetches articles using `ArticleService.getMyPublishedArticles()`
4. Articles are displayed in a list with cards showing:
   - Header image
   - Category badge
   - Title (max 2 lines)
   - Summary (max 3 lines)
   - Status badge
   - Like and comment counts
5. User taps an article card
6. App navigates to `VolunteerSingleArticleScreen` with the article ID
7. Full article content is displayed with comments and like functionality

### Viewing/Managing Drafts:
1. User clicks "My Drafts" on the Create Content screen
2. App navigates to `ArticleDraftScreen`
3. Screen fetches drafts using `ArticleService.getDraftArticles()`
4. Drafts are displayed in a list with options to:
   - Edit draft
   - Publish draft (submits for review)
   - Delete draft
5. User can tap a draft to edit it
6. User can use the menu to publish or delete

## Authentication
- Both features automatically get the current user's ID from `AuthService.getCurrentUserId()`
- No need to pass volunteerId as arguments
- Ensures volunteers only see their own articles and drafts

## Error Handling
- Network errors are caught and displayed to the user
- Empty states are shown when no articles/drafts exist
- Retry functionality for failed API calls
- Loading indicators during data fetching

## UI/UX Features
- **Material Design** cards with elevation and rounded corners
- **Color-coded status badges** for easy status identification
- **Responsive images** with error fallback
- **Pull-to-refresh** for easy data updates
- **Empty states** with helpful messaging
- **Loading states** with progress indicators
- **Tappable cards** with visual feedback

## Testing Steps

### Test Published Articles:
1. Login as a volunteer who has published articles
2. Navigate to "Create Content"
3. Tap "View Your Articles"
4. Verify articles are displayed correctly
5. Tap an article to view details
6. Verify the article opens correctly
7. Pull down to refresh
8. Verify articles reload

### Test Drafts:
1. Login as a volunteer who has draft articles
2. Navigate to "Create Content"
3. Tap "My Drafts"
4. Verify drafts are displayed correctly
5. Tap a draft to edit
6. Make changes and save
7. Verify changes are saved
8. Try publishing a draft
9. Verify draft moves to published articles
10. Try deleting a draft
11. Verify draft is removed

## Notes
- The backend already had the necessary endpoints implemented
- The `ArticleDraftScreen` already existed and just needed proper integration
- The `VolunteerSingleArticleScreen` already existed for viewing article details
- All screens use the existing `ArticleService` for API communication
- Authentication is handled automatically through `AuthService`

## Future Enhancements (Optional)
- Add search/filter functionality for published articles
- Add sorting options (newest, most liked, most commented)
- Add edit functionality for published articles (if business logic allows)
- Add analytics (views, engagement metrics)
- Add sharing functionality
- Add offline caching for articles

## Status
✅ **COMPLETED** - All functionality has been implemented and is ready for testing.

## Developer Notes
- Make sure to hot restart the Flutter app after these changes
- The backend endpoints are already working and tested
- All error handling is in place
- The UI follows the existing app's design patterns
