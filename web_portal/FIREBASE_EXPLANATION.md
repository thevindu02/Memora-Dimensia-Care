# Understanding Firebase Usage in This Project

## How Firebase is Currently Used

### Backend (Spring Boot) - ✅ Already Configured
Your backend uses **Firebase Admin SDK** to:
- Store article content in Firestore (`articles` collection)
- Fetch article content from Firestore
- Return article data via REST API to the web portal

**Files:**
- `backend/src/main/java/.../ArticleService.java` - Uses Firestore to read/write articles
- `memora-2025-firebase-adminsdk-fbsvc-c45cc799ae.json` - Firebase Admin credentials

### Web Portal (React) - Articles
The web portal fetches articles via **REST API** from your backend:
- `GET /api/articles/published/all` - Gets all published articles
- `GET /api/articles/detail/:id` - Gets single article with full content from Firebase

**The article content comes from Firebase via your backend API, NOT directly from Firebase in the web portal.**

### Web Portal (React) - Comments (NEW) - ⚠️ Needs Configuration
For **real-time comments**, the web portal needs **direct Firebase access**:
- Uses Firebase Client SDK (not Admin SDK)
- Directly listens to Firestore `articles_comments` collection
- Provides real-time updates when new comments are added

This is why you need to:
1. Install `firebase` package in web_portal
2. Configure Firebase client credentials in `src/config/firebase.js`

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────┐
│                    Firebase (Cloud)                      │
│  ┌──────────────────┐      ┌────────────────────────┐  │
│  │    Firestore     │      │   Firestore            │  │
│  │   "articles"     │      │ "articles_comments"    │  │
│  │  collection      │      │   collection           │  │
│  └────────┬─────────┘      └─────────┬──────────────┘  │
└───────────┼──────────────────────────┼──────────────────┘
            │                          │
            │                          │
    ┌───────▼────────┐         ┌───────▼────────┐
    │  Backend API   │         │  Web Portal    │
    │  (Spring Boot) │         │  (React)       │
    │                │         │                │
    │  Firebase      │         │  Firebase      │
    │  Admin SDK     │         │  Client SDK    │
    │  ✅ Configured │         │  ⚠️ Needs Setup│
    └───────┬────────┘         └────────────────┘
            │
            │ REST API
            │ /api/articles/*
            │
    ┌───────▼────────┐
    │  Web Portal    │
    │  (React)       │
    │  Article Views │
    └────────────────┘
```

## What Works Without Firebase Client SDK

### ✅ These Features Work (Use Backend API):
- View all published articles
- Search articles
- Filter by category
- View single article with full content
- Like/unlike articles (uses backend API)
- View like counts

### ⚠️ These Features Need Firebase Client SDK:
- **Real-time comments** (listen to new comments as they're added)
- **Add new comments** (write to Firestore)
- Comment timestamps and metadata

## Setup Options

### Option 1: Full Setup (Recommended)
Install Firebase and configure for complete functionality including real-time comments:

```bash
cd web_portal
npm install firebase
```

Then edit `src/config/firebase.js` with your Firebase **web app** credentials.

### Option 2: Without Real-Time Comments
You can use the articles feature without installing Firebase. The comments section will show an error message, but everything else works fine:
- Articles list ✅
- Search & filter ✅
- Single article view ✅
- Like/unlike ✅

## How to Get Firebase Web App Credentials

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project (memora-2025 or similar)
3. Click on **Project Settings** (gear icon)
4. Scroll down to **"Your apps"** section
5. If you have a web app already, copy the config
6. If not, click **"Add app"** → **Web** (</>) → Register app
7. Copy the `firebaseConfig` object

**Important:** Use the **web app config**, NOT the admin SDK credentials!

## Firebase Security Rules

For comments to work, ensure your Firestore security rules allow authenticated users to read/write comments:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow anyone to read comments
    match /articles_comments/{commentId} {
      allow read: if true;
      allow write: if request.auth != null; // Only authenticated users can write
    }
  }
}
```

You can update these in Firebase Console → Firestore Database → Rules

## Common Questions

### Q: Why do I need Firebase in the web portal if backend already has it?
**A:** For real-time features! The backend uses Firebase Admin SDK which is great for server-side operations but doesn't provide real-time subscriptions to the client. For real-time comments, the web portal needs to directly listen to Firestore changes.

### Q: Can I just use backend API for comments too?
**A:** Yes, but you'd lose the real-time feature. You'd need to poll the API every few seconds to check for new comments, which is inefficient. With Firebase Client SDK, comments appear instantly using WebSocket connections.

### Q: Is it safe to put Firebase config in the web portal code?
**A:** Yes! The Firebase **web app** config (API key, project ID, etc.) is meant to be public. Security is handled by:
1. Firebase Security Rules (controls who can read/write)
2. Firebase Authentication (identifies users)
3. Backend validation (your Spring Boot API validates actions)

The **Admin SDK credentials** (the .json file in backend) should NEVER be in the web portal - only in the backend.

### Q: What if I don't want to configure Firebase now?
**A:** The articles feature will work perfectly! You'll just see:
- "Comments not available" message where comments would be
- Console errors about Firebase (which you can ignore)
- Everything else functions normally

You can add Firebase later when you're ready to enable comments.

## Testing Without Firebase

If you want to test without configuring Firebase:

1. Start backend: `cd backend && ./mvnw spring-boot:run`
2. Start web portal: `cd web_portal && npm start`
3. Navigate to `http://localhost:3000/volunteer/articles`
4. Articles will load ✅
5. Single article view works ✅
6. Like/unlike works ✅
7. Comments section shows error ⚠️ (expected)

## Summary

| Feature | Backend Firebase | Web Portal Firebase | Works Without Web Firebase? |
|---------|-----------------|---------------------|----------------------------|
| Load articles | ✅ Required | ❌ Not needed | ✅ Yes |
| View article content | ✅ Required | ❌ Not needed | ✅ Yes |
| Search & filter | ❌ Not needed | ❌ Not needed | ✅ Yes |
| Like/unlike | ⚠️ Optional | ❌ Not needed | ✅ Yes (uses backend API) |
| View comments | ✅ Possible | ✅ Required for real-time | ⚠️ No (needs Firebase) |
| Add comments | ✅ Possible | ✅ Required | ⚠️ No (needs Firebase) |
| Real-time updates | ❌ Not possible | ✅ Required | ❌ No |

---

**TL;DR:**
- **Backend** uses Firebase Admin SDK (already configured) ✅
- **Web portal** needs Firebase Client SDK for **comments only**
- Articles, search, and likes work without Firebase in web portal
- Install Firebase in web portal for real-time comments feature
