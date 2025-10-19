# Article Screens Cleanup Guide

## Overview
After implementing backend-integrated article functionality for all three user types (Volunteer, Caregiver, Guardian), several old screens with mock data need to be removed.

---

## ✅ FILES TO KEEP (Backend Integrated)

### **VOLUNTEER** (Already Complete)
- ✅ `volunteer_community_screen.dart` - Main community screen with tabs
- ✅ `volunteer_articles_screen.dart` - Articles list with backend integration
- ✅ `volunteer_single_article_screen.dart` - Single article view with like/unlike/comments

### **CAREGIVER** (Newly Created)
- ✅ `caregiver_articles_screen.dart` - **NEW** Articles list with backend integration
- ✅ `caregiver_single_article_screen.dart` - **NEW** Single article view with like/unlike/comments

### **GUARDIAN** (Updated/Created)
- ✅ `guardian_articles_tab_body.dart` - **NEW** Articles list with backend integration
- ✅ `guardian_single_article_screen.dart` - **UPDATED** Single article view with like/unlike/comments (now has backend integration)

---

## ❌ FILES TO REMOVE (Outdated/Unused)

### **CAREGIVER Folder**
```
mobile_app/lib/screens/caregiver/
└── view_article_screen.dart  ❌ DELETE THIS
```
**Reason:** 2041 lines, outdated implementation, mixed Q&A forum code, replaced by `caregiver_articles_screen.dart` and `caregiver_single_article_screen.dart`

### **GUARDIAN Folder**
```
mobile_app/lib/screens/guardian/
└── guardian_articles_screen.dart  ❌ DELETE THIS
```
**Reason:** 570 lines with hardcoded mock data, no backend integration, replaced by `guardian_articles_tab_body.dart`

### **VOLUNTEER Folder**
```
mobile_app/lib/screens/volunteer/
├── article_draft_screen.dart  ❌ DELETE THIS
├── view_article_screen.dart  ❌ DELETE THIS
└── volunteer_article_displaying_screen.dart  ❌ DELETE THIS
```
**Reasons:** 
- `article_draft_screen.dart` - Not referenced anywhere
- `view_article_screen.dart` - Unused duplicate/old implementation
- `volunteer_article_displaying_screen.dart` - Imported but never used

---

## 🎯 Changes Made

### Removed Features:
- ❌ Category filters (All, Caregiver Tips, Medication, Technology, Health, Activities)
  - **Reason:** Volunteer implementation doesn't have category filters

### Kept Features:
- ✅ Search functionality (matches volunteer)
- ✅ Article cards with image, title, description
- ✅ Like/Unlike buttons (separate, independent, blue shading when active)
- ✅ Comment functionality (view and add)
- ✅ Pull-to-refresh
- ✅ Backend integration via ArticleService

---

## 📝 Implementation Details

### All Three User Types Now Have:
1. **Articles List Screen**
   - Search bar
   - Article cards (image, title, description, likes, comments)
   - Fetches from backend: `ArticleService.getAllArticles()`
   - Navigation to single article view

2. **Single Article Screen**
   - Full article content display
   - Like button (thumb_up icon, shows count, blue when active)
   - Unlike button (thumb_down icon, "Unlike" text, blue when active)
   - Comment section (view existing, add new)
   - Fetches from backend: `ArticleService.getArticleById()`

### Consistent UI Across All Users:
- Same layout and styling
- Same interaction patterns
- Same backend service usage
- Mobile-only implementation (Android/iOS)

---

## 🔧 How to Use New Guardian Articles Screen

The new `guardian_articles_tab_body.dart` should be integrated into your existing guardian community/articles screen:

```dart
// In your guardian main articles/community screen
import 'guardian_articles_tab_body.dart';

// Then use it in your tab view:
TabBarView(
  children: [
    GuardianArticlesTabBody(), // ← Use this widget
    // ... other tabs
  ],
)
```

---

## 🗑️ Deletion Commands (PowerShell)

Run these commands from the project root to remove old files:

```powershell
# Caregiver
Remove-Item "mobile_app\lib\screens\caregiver\view_article_screen.dart"

# Guardian
Remove-Item "mobile_app\lib\screens\guardian\guardian_articles_screen.dart"

# Volunteer
Remove-Item "mobile_app\lib\screens\volunteer\article_draft_screen.dart"
Remove-Item "mobile_app\lib\screens\volunteer\view_article_screen.dart"
Remove-Item "mobile_app\lib\screens\volunteer\volunteer_article_displaying_screen.dart"
```

---

## ✅ Summary

**Total Files to Delete:** 6 files
- Caregiver: 1 file
- Guardian: 1 file  
- Volunteer: 3 files

**New Files Created:** 3 files
- `caregiver_articles_screen.dart`
- `caregiver_single_article_screen.dart`
- `guardian_articles_tab_body.dart`

**Files Updated:** 1 file
- `guardian_single_article_screen.dart` (replaced mock data with backend integration)

All implementations now use the same backend services and have consistent UI/UX across all three user types!
