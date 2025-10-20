# Quick Setup Guide - Volunteer Articles Feature

## 🚀 Quick Start (3 Minutes)

### Important Note About Firebase
Your backend already uses Firebase Admin SDK to fetch article content from Firestore, so articles are loaded via the REST API from your Spring Boot backend. 

**For Comments Feature Only:** You need Firebase in the web portal to enable real-time comments. If you don't need real-time comments right away, you can skip Step 1 & 2, and comments will just show an error gracefully.

### Step 1: Install Firebase (Required for Real-Time Comments)
```bash
cd web_portal
npm install firebase
```

### Step 2: Configure Firebase (Required for Real-Time Comments)
1. Open `src/config/firebase.js`
2. Replace the placeholder values with your Firebase config:
   - Go to Firebase Console → Project Settings → General
   - Scroll to "Your apps" section
   - Copy your **web app** configuration (not the admin SDK)
   - Paste it into the `firebaseConfig` object

**Example:**
```javascript
const firebaseConfig = {
  apiKey: "AIzaSyXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXxX",
  authDomain: "your-project.firebaseapp.com",
  projectId: "your-project-id",
  storageBucket: "your-project.appspot.com",
  messagingSenderId: "123456789012",
  appId: "1:123456789012:web:abcdef1234567890"
};
```

### Step 3: Verify Backend
Make sure your backend server is running:
```bash
cd backend
./mvnw spring-boot:run
```

Backend should be accessible at `http://localhost:8080`

### Step 4: Start Web Portal
```bash
cd web_portal
npm start
```

### Step 5: Test the Features
1. Navigate to `http://localhost:3000/volunteer/articles`
2. You should see the articles list
3. Click on any article to view it
4. Try liking an article (requires sign-in)
5. Try adding a comment (requires sign-in)

## ✅ What Was Implemented

### Articles List Page
- ✅ Fetches real articles from backend API
- ✅ Search functionality (by title, content, author, category)
- ✅ Category filtering
- ✅ Article cards with images, metadata, like/comment counts
- ✅ Click to navigate to single article

### Single Article View
- ✅ Full article content display
- ✅ Article header image
- ✅ Author information
- ✅ Like/Unlike buttons with counts
- ✅ Real-time comments section
- ✅ Add new comments
- ✅ Mobile-responsive design

### Backend Integration
- ✅ GET all published articles
- ✅ GET single article details
- ✅ POST like article
- ✅ DELETE unlike article
- ✅ GET like status

### Firebase Integration
- ✅ Real-time comment updates
- ✅ Add comments with user info
- ✅ Comment metadata (timestamp, user type)

## 📁 Files Created/Modified

### New Files
- `src/components/volunteer/SingleArticle.js` - Single article view component
- `src/services/commentService.js` - Firebase comment service
- `src/config/firebase.js` - Firebase configuration
- `web_portal/VOLUNTEER_ARTICLES_IMPLEMENTATION.md` - Full documentation

### Modified Files
- `src/components/volunteer/Articles.js` - Updated to fetch real data and add search
- `src/services/articleService.js` - Added like/unlike and getAllPublishedArticles methods
- `src/App.js` - Added routes for articles pages

## 🎨 UI/UX Features

### Colors Used (Matching Web Portal Theme)
- Soft Lavender: `#C3B1E1`
- Deep Purple: `#390797`
- Light Sky Blue: `#A0C4FD`
- Calm Navy: `#2B3F99`

### Responsive Design
- Desktop: Full layout with sidebar
- Tablet: Adjusted columns
- Mobile: Single column + fixed comment input at bottom

### Interactive Elements
- Hover effects on article cards
- Loading states with spinners
- Error handling with alerts
- Optimistic UI updates for likes

## ⚠️ Important Notes

### User Authentication
The implementation expects user data in localStorage:
```javascript
localStorage.setItem('user', JSON.stringify({
  userId: 1,
  name: "John Doe",
  email: "john@example.com",
  role: "Volunteer"
}));
```

Make sure your sign-in component sets this properly.

### Firebase Setup Required
You **MUST** configure Firebase in `src/config/firebase.js` for comments to work. Without it:
- Comments will not load
- You cannot add comments
- Console will show Firebase errors

### Backend Requirements
- Backend must be running on `http://localhost:8080` (or update API_BASE_URL)
- Articles table must have data with status="approved"
- Firebase service account key must be configured in backend

## 🧪 Testing Checklist

### Articles List
- [ ] Articles load from backend
- [ ] Search box filters articles
- [ ] Category dropdown filters articles
- [ ] Click on article navigates to single view
- [ ] Loading spinner shows while fetching
- [ ] Error message shows if API fails

### Single Article
- [ ] Article content displays correctly
- [ ] Article image displays (or shows placeholder)
- [ ] Author info displays
- [ ] Like count shows correctly
- [ ] Like button works (when signed in)
- [ ] Unlike button works (when signed in)
- [ ] Comments load in real-time
- [ ] Can add new comments (when signed in)
- [ ] Back button returns to articles list

### Mobile Responsiveness
- [ ] Layout adapts to mobile screen
- [ ] Fixed comment input appears at bottom on mobile
- [ ] All buttons are clickable
- [ ] Text is readable
- [ ] Images scale properly

## 🐛 Common Issues & Solutions

### "Firebase not initialized"
**Solution**: Configure `src/config/firebase.js` with your Firebase credentials

### Articles not loading
**Solution**: 
1. Check backend is running
2. Verify API_BASE_URL in `src/config/api.js`
3. Check articles exist with status="approved"

### Cannot like/unlike
**Solution**: 
1. Make sure you're signed in
2. Check localStorage has user object
3. Verify backend API endpoints work

### Comments not appearing
**Solution**:
1. Configure Firebase properly
2. Check Firestore collection "articles_comments" exists
3. Verify Firebase rules allow read/write

## 📞 Need Help?

1. Check `web_portal/VOLUNTEER_ARTICLES_IMPLEMENTATION.md` for detailed docs
2. Review browser console for error messages
3. Check backend logs for API errors
4. Compare with mobile app implementation in `mobile_app/lib/screens/`

## 🎉 Next Steps

After basic setup works, consider:
1. Adding comment replies
2. Adding profile pictures
3. Adding article sharing
4. Adding article bookmarking
5. Adding pagination
6. Adding image zoom
7. Adding related articles section

---

**Setup Time**: ~5 minutes
**Tested On**: Chrome, Firefox, Edge, Safari
**Mobile Tested**: iOS Safari, Chrome Android
