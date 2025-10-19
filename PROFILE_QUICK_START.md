# Volunteer Profile - Quick Start Guide

## What Was Implemented

✅ **Load Real User Data**
- Profile now fetches actual data from database
- Displays user's name, email, phone, and gender
- Shows loading spinner while fetching

✅ **Edit Functionality**
- Click "Edit" button to enable editing
- Modify any field (name, email, phone, gender)
- Click "Save Changes" to update database

✅ **Backend Integration**
- New API endpoint: `PUT /api/users/{id}`
- Updates user information in database
- Validates email uniqueness

## How to Test

### 1. Start Backend
```bash
cd backend
mvn spring-boot:run
```

### 2. Run Mobile App
```bash
cd mobile_app
flutter run
```

### 3. Test Flow
1. Login as a volunteer
2. Navigate to Profile tab (bottom right)
3. Profile loads with your real data
4. Click "Edit" button
5. Change any field (e.g., phone number)
6. Click "Save Changes"
7. See success message
8. Changes are saved to database!

## Key Features

### Loading State
- Shows spinner while fetching data
- Prevents interaction during load
- Handles errors gracefully

### Edit Mode
- **Edit button** → Fields become editable
- **Cancel button** → Restores original values
- **Save button** → Updates database

### Validation
- **Email uniqueness**: Can't use email of another user
- **Network errors**: Shows user-friendly messages
- **Success feedback**: Green snackbar on save

### Data Mapping
- **Full Name** → Split into first + last name
- **Email** → Direct mapping
- **Phone** → Direct mapping
- **Gender** → Dropdown selection

## API Endpoints

### GET /api/users/{id}
Fetch user profile data

**Response:**
```json
{
  "id": 123,
  "fname": "John",
  "lname": "Smith",
  "email": "john.smith@example.com",
  "phoneNumber": "+1 (555) 123-4567",
  "gender": "Male",
  "role": "VOLUNTEER"
}
```

### PUT /api/users/{id}
Update user profile

**Request:**
```json
{
  "FName": "John",
  "LName": "Smith",
  "email": "john.smith@example.com",
  "phoneNumber": "+1 (555) 123-4567",
  "gender": "Male"
}
```

**Response:**
```json
{
  "message": "User updated successfully",
  "id": 123
}
```

## Error Messages

| Error | Message | Action |
|-------|---------|--------|
| User not found | "User not found. Please login again." | Redirects to login |
| Network error | "Failed to load user data" | Stay on screen, can retry |
| Email conflict | "Email already in use by another account" | Can change email and retry |
| Save failed | "Failed to save profile. Please try again." | Can retry save |

## Files Changed

### Backend
- `UserController.java` - Added PUT endpoint

### Frontend
- `user_service.dart` - Added updateUser() method
- `volunteer_profile_screen.dart` - Complete redesign with real data

## Next Steps (Optional Enhancements)

1. **Profile Picture Upload**
   - Add image upload endpoint
   - Implement file storage
   
2. **Password Change**
   - Add separate password change screen
   - Implement password update endpoint

3. **Additional Fields**
   - Birthdate
   - Address (street, city, state)
   - Bio/description

## Troubleshooting

**Problem:** Profile shows loading forever
- **Solution:** Check backend is running on port 8080
- **Solution:** Check network connection
- **Solution:** Verify user is logged in

**Problem:** Save button doesn't work
- **Solution:** Check console for error messages
- **Solution:** Verify all required fields are filled
- **Solution:** Check backend logs

**Problem:** Email conflict error
- **Solution:** Use different email address
- **Solution:** Email might already be used by another account

## Success Indicators

✅ Profile loads with real user data
✅ Edit button enables fields
✅ Save button updates database
✅ Success message appears after save
✅ Changes persist after screen reload
✅ Error messages show for invalid input
