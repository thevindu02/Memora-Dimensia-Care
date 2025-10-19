# Separate Unlike Button Implementation

## Overview
Added a dedicated **unlike button** alongside the like button for articles, replacing the toggle behavior with separate controls.

## What Changed

### UI Changes
**File:** `mobile_app/lib/screens/volunteer/volunteer_single_article_screen.dart`

#### Before (Toggle Behavior):
- Single like button that toggled between liked/unliked states
- Icon changed between `thumb_up` and `thumb_up_outlined`
- One button for both actions

#### After (Separate Buttons with Visual States):
- **Like Button**: 
  - Icon: `thumb_up` (filled when liked, outlined when not)
  - Shows like count number
  - Turns **blue** when active (liked)
  - Tapping adds a like if not already liked
  
- **Unlike Button**: 
  - Icon: `thumb_down` (filled when active, outlined when not)
  - Label: "Unlike"
  - Turns **blue** when active (unliked)
  - Works independently - can be clicked anytime
  - Removes the user's like and sets unliked state

### Backend Functionality

#### Like Button (`_handleLike()`)
1. Checks if user is signed in
2. Prevents duplicate likes (shows warning if already liked)
3. Optimistically updates UI (instant feedback)
4. Calls backend API: `POST /api/articles/{articleId}/like`
5. Shows success/error messages
6. Reverts UI if backend call fails

#### Unlike Button (`_handleUnlike()`)
1. Checks if user is signed in
2. **Works independently** - can be clicked even without prior like
3. Optimistically updates UI (instant feedback)
4. Calls backend API: `DELETE /api/articles/{articleId}/like`
5. Only decreases count if article was previously liked
6. Shows success/error messages
7. Reverts UI if backend call fails

## User Experience

### Like Flow:
1. User sees article with like button (outlined thumb up) and unlike button
2. User clicks **Like** button
3. UI immediately updates: 
   - Thumb up becomes filled and **blue** 
   - Count increases by 1
   - Unlike button returns to grey (inactive)
4. Green snackbar shows: "Article liked successfully"

### Unlike Flow:
1. User clicks **Unlike** button (works regardless of like status)
2. UI immediately updates: 
   - Thumb down becomes filled and **blue**
   - Like button returns to grey (inactive)
   - If article was liked: count decreases by 1
3. Green snackbar shows: "Article unliked successfully"
4. Backend removes any existing like record

### Visual States:
- **Liked State**: Like button is blue and filled, unlike button is grey
- **Unliked State**: Unlike button is blue and filled, like button is grey
- **Neutral State** (on page load): Both buttons are grey and outlined

### Edge Cases Handled:
- **Double like attempt**: Shows orange warning "You have already liked this article"
- **Unlike works independently**: No restriction - can unlike even without prior like
- **Not signed in**: Shows red error prompting user to sign in
- **Network failure**: Reverts UI changes and shows error message

## Visual Layout

**Default State (Neither liked nor unliked):**
```
[👍 12]  [👎 Unlike]  [💬 5 comments]
 grey      grey
```

**Liked State:**
```
[👍 13]  [👎 Unlike]  [💬 5 comments]
 BLUE      grey
```

**Unliked State:**
```
[👍 12]  [👎 Unlike]  [💬 5 comments]
 grey      BLUE
```

- Like button: Shows count and icon, turns **blue** when active
- Unlike button: Shows text label with thumbs down icon, turns **blue** when active
- Only one can be active (blue) at a time
- Both buttons are clearly separated with spacing

## Testing Checklist

- [ ] Like button adds a like when clicked (when not liked)
- [ ] Like button shows warning when already liked
- [ ] Unlike button removes like when clicked (when liked)
- [ ] Unlike button shows warning when not liked
- [ ] Like count updates correctly
- [ ] Icons change state appropriately
- [ ] Success messages appear
- [ ] Error handling works (network issues)
- [ ] Optimistic UI updates are smooth
- [ ] State persists on screen refresh

## Files Modified
1. `mobile_app/lib/screens/volunteer/volunteer_single_article_screen.dart`
   - Added `_isUnliked` state variable to track unlike status
   - Replaced `_toggleLike()` with `_handleLike()` and `_handleUnlike()`
   - Updated `_handleLike()` to clear unlike state when liking
   - Updated `_handleUnlike()` to set unlike state and clear like state
   - Updated UI to show blue color for active like/unlike buttons
   - Icon changes: `thumb_down_outlined` → `thumb_down` when active
   - Text color and weight change when unlike is active
   - Added validation to prevent invalid actions

## Backend APIs Used
- `POST /api/articles/{articleId}/like?userId={id}` - Add like
- `DELETE /api/articles/{articleId}/like?userId={id}` - Remove like
- `GET /api/articles/{articleId}/like-status?userId={id}` - Check like status

## Notes
- Backend services (`ArticleService.java`, `ArticleController.java`) were already implemented
- Frontend service methods (`article_service.dart`) were already implemented
- This change only affects the UI interaction pattern
- The unlike button uses a thumbs down icon for visual distinction
- Both buttons have appropriate user feedback and validation
