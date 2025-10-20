# Volunteer Drafts Screen Improvements

## Date: October 20, 2025

## Changes Made

### 1. Enhanced Draft Card Layout

#### Updated Visual Design:
- ✅ **Category badge** displayed prominently at the top with blue background
- ✅ **Title** shown in larger, bold font (18px) with draft icon
- ✅ **Summary** displayed with proper line height and 3-line limit
- ✅ **Action buttons** (Edit & Publish) now shown directly on the card

#### New Layout Structure:
```
┌─────────────────────────────────────┐
│ 🏷️ Category Badge (Top)            │
│                                     │
│ 📝 Draft Icon + Title (Bold 18px)  │
│    [Menu Button]                    │
│                                     │
│ Summary text (3 lines max)          │
│                                     │
│ [Edit Button] [Publish Button]     │
└─────────────────────────────────────┘
```

### 2. Improved Publish Functionality

#### Enhanced Publish Dialog:
- ✅ Added **icon** to dialog title (green publish icon)
- ✅ Shows **article preview** with title and category
- ✅ Displays **info banner** explaining admin review process
- ✅ Better visual feedback with color-coded message

#### Loading Indicator:
- ✅ Shows **circular progress** while publishing
- ✅ "Publishing article..." message displayed
- ✅ Non-dismissible during operation

#### Success/Error Feedback:
- ✅ **Green success** snackbar with checkmark icon
- ✅ **Red error** snackbar with error icon
- ✅ Clear messages about submission status
- ✅ 3-second duration for success, 4-second for errors

#### Status Setting:
- ✅ Sets `draft: false` when publishing
- ✅ Sets `status: 'disapproved'` (means "pending admin review")
- ✅ Automatically refreshes draft list after publishing

### 3. UI/UX Improvements

#### Card Interaction:
- ✅ **Edit button** (outlined, blue) - Opens draft editor
- ✅ **Publish button** (filled, green) - Submits for review
- ✅ **3-dot menu** still available with Edit/Publish/Delete options
- ✅ Card tap opens draft editor

#### Visual Feedback:
- ✅ Category badge: Blue background with category icon
- ✅ Draft icon: Blue info color
- ✅ Title: Black87, bold, 18px
- ✅ Summary: Grey700, 14px, 1.4 line height
- ✅ Buttons: Proper spacing and border radius

## User Workflow

### Publishing a Draft:

1. **Open "My Drafts"** from Create Content screen
2. **See draft card** with:
   - Category at top
   - Title in bold
   - Summary preview
   - Edit and Publish buttons
3. **Click "Publish"** button
4. **Review dialog** shows:
   - Article title and category
   - Warning about admin review
5. **Confirm** by clicking "Publish"
6. **See loading** indicator
7. **Get confirmation** via green snackbar
8. **Draft removed** from list (now in "My Published Articles" with "Pending Review" status)

### Editing a Draft:

1. Click **"Edit"** button or tap the card
2. Opens draft editor with pre-filled data
3. Modify content as needed
4. Click **"Save"** to update draft
5. Returns to drafts list with changes saved

### Deleting a Draft:

1. Click **3-dot menu** → **Delete**
2. Confirm deletion in dialog
3. Draft permanently removed

## Technical Details

### Status Flow:
```
draft: true,
status: null
    ↓ (Publish)
draft: false,
status: 'disapproved'  ← Pending Admin Review
    ↓ (Admin Approves)
draft: false,
status: 'approved'  ← Published & Visible
```

### API Endpoints Used:
- **GET** `/api/articles/drafts?volunteerId={id}` - Fetch drafts
- **PUT** `/api/articles/{articleId}` - Update draft (publish/edit)
- **DELETE** `/api/articles/{articleId}` - Delete draft

### Files Modified:
1. ✅ `article_draft_screen.dart` - Enhanced card layout and publish dialog

## Testing Checklist

### Draft Card Display:
- [ ] Category badge shows at top
- [ ] Title displays correctly in bold
- [ ] Summary shows with proper formatting
- [ ] Edit and Publish buttons are visible
- [ ] 3-dot menu works (Edit/Publish/Delete options)

### Publish Functionality:
- [ ] Publish dialog shows article details
- [ ] Info banner explains admin review
- [ ] Loading indicator appears during publish
- [ ] Success message shows after publishing
- [ ] Draft removed from list after publishing
- [ ] Published article appears in "My Published Articles" with "Pending Review" status

### Edit Functionality:
- [ ] Edit button opens draft editor
- [ ] Card tap opens draft editor
- [ ] Draft data pre-fills correctly
- [ ] Save updates draft successfully
- [ ] Returns to draft list after save

### Delete Functionality:
- [ ] Delete confirmation dialog appears
- [ ] Draft deleted successfully
- [ ] Success message shows
- [ ] Draft list refreshes

## Status Indicators

When article is published (moves to "My Published Articles"):

| Status | Display Text | Color | Meaning |
|--------|-------------|-------|---------|
| `disapproved` | Pending Review | Orange | Awaiting admin approval |
| `approved` | Approved | Green | Published & visible to all |
| `rejected` | Rejected | Red | Admin rejected (needs revision) |

## Notes

- **Admin Review Required**: All published articles go through admin review before becoming visible to other users
- **Draft vs Published**: Drafts are private; published articles (after approval) are public
- **Data Persistence**: Draft changes are saved immediately to backend
- **Real-time Updates**: Draft list refreshes after any action

---

## Implementation Complete ✅

The drafts screen now provides:
- ✅ Clear visual hierarchy (Category → Title → Summary)
- ✅ Easy access to Edit and Publish actions
- ✅ Informative publish workflow with loading feedback
- ✅ Professional UI with proper spacing and colors
- ✅ Smooth user experience with proper error handling

**Ready to test!** Press `R` to hot restart your Flutter app.
