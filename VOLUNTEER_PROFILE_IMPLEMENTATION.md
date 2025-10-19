# Volunteer Profile - Real Data Integration

## Overview
Implemented real data loading and editing functionality for the volunteer profile screen. Users can now view their actual profile data from the database and update their information, which saves to the backend.

## Changes Made

### Backend Changes

#### 1. UserController.java - Added Update Endpoint
**File:** `backend/src/main/java/Memora/DimensiaCareApplication/controller/UserController.java`

**New Endpoint:** `PUT /api/users/{id}`

**Features:**
- Updates user profile information
- Validates email uniqueness (prevents duplicate emails)
- Only updates provided fields (partial updates supported)
- Returns success/error messages
- Does NOT update password, role, or status (security)

**Request Body Example:**
```json
{
  "FName": "John",
  "LName": "Smith",
  "email": "john.smith@example.com",
  "phoneNumber": "+1 (555) 123-4567",
  "gender": "Male"
}
```

**Response Examples:**
```json
// Success
{
  "message": "User updated successfully",
  "id": 123
}

// Email conflict
{
  "message": "Email already in use by another account"
}
```

**Updatable Fields:**
- First Name (FName)
- Last Name (LName)
- Email
- Phone Number
- Gender
- Birthdate
- Address (Street, City, State)
- Profile Picture

### Frontend Changes

#### 2. UserService.dart - Added Update Method
**File:** `mobile_app/lib/services/user_service.dart`

**New Method:** `updateUser()`

**Features:**
- Sends PUT request to backend
- Supports partial updates (only send changed fields)
- Handles validation errors (email conflicts)
- Returns success/failure result
- Error handling for network issues

**Usage Example:**
```dart
final result = await UserService.updateUser(
  userId: 123,
  FName: 'John',
  LName: 'Smith',
  email: 'john.smith@example.com',
  phoneNumber: '+1 (555) 123-4567',
  gender: 'Male',
);

if (result.success) {
  print(result.message); // "User updated successfully"
} else {
  print(result.message); // Error message
}
```

#### 3. VolunteerProfileScreen.dart - Complete Redesign
**File:** `mobile_app/lib/screens/volunteer/volunteer_profile_screen.dart`

**Before:**
- Hardcoded data (John Smith, john.smith@example.com, etc.)
- Simulated save with 2-second delay
- No actual backend communication

**After:**
- Loads real user data from database on screen load
- Displays loading spinner while fetching data
- Edit functionality updates backend
- Real-time validation and error handling
- Success/failure feedback to user

**Key Features:**

1. **Data Loading (`_loadUserData()`)**
   - Gets current user ID from AuthService
   - Fetches user data from backend using UserService
   - Populates text fields with real data
   - Handles errors gracefully

2. **Data Saving (`_saveProfile()`)**
   - Splits full name into first and last name
   - Calls backend to update user
   - Shows loading state during save
   - Displays success/error messages
   - Reloads data after successful save

3. **Edit Mode**
   - Toggle edit mode with Edit button
   - Fields become editable
   - Cancel button restores original values
   - Save button updates backend

4. **Validation**
   - Email uniqueness check
   - Required field validation
   - Error messages for conflicts

## User Flow

### Viewing Profile
1. User navigates to Profile tab
2. Screen shows loading spinner
3. App fetches user data from backend
4. Profile displays with real data:
   - Full Name
   - Email
   - Phone Number
   - Gender
   - Volunteer badge

### Editing Profile
1. User clicks **Edit** button (top right)
2. Fields become editable
3. User modifies information
4. User clicks **Save Changes**
5. App shows loading spinner on button
6. Backend updates data
7. Success message appears
8. Edit mode exits
9. Profile reloads with updated data

### Error Handling

**Scenarios:**
- **User not found:** Redirects to login
- **Network error:** Shows error message, stays on screen
- **Email conflict:** Shows "Email already in use" message
- **Backend error:** Shows generic error message

## API Endpoints Used

1. **GET /api/users/{id}**
   - Fetches user profile data
   - Called on screen load

2. **PUT /api/users/{id}**
   - Updates user profile
   - Called when saving changes

## Data Mapping

### Backend → Frontend
```
Backend Field    Frontend Display
-------------    ----------------
fname/fName      First part of "Full Name"
lname/lName      Last part of "Full Name"
email            Email field
phoneNumber      Phone Number field
gender           Gender field (dropdown)
```

### Frontend → Backend
```
Frontend Input      Backend Field
--------------      -------------
Full Name (split)   FName + LName
Email               email
Phone Number        phoneNumber
Gender              gender
```

## Testing Checklist

### Load Profile
- [ ] Profile loads on screen open
- [ ] Loading spinner appears while fetching
- [ ] Real user data displays correctly
- [ ] Name combines first + last name
- [ ] Email, phone, gender all populate

### Edit Profile
- [ ] Edit button enables fields
- [ ] All fields become editable
- [ ] Cancel button restores original values
- [ ] Save button is disabled during save
- [ ] Loading spinner shows on save button

### Save Changes
- [ ] Name changes save correctly (split into first/last)
- [ ] Email changes save and validate uniqueness
- [ ] Phone number changes save
- [ ] Gender changes save
- [ ] Success message appears on save
- [ ] Profile reloads with updated data

### Error Handling
- [ ] Email conflict shows appropriate error
- [ ] Network errors show user-friendly message
- [ ] User stays on screen after error
- [ ] Can retry after error

### Edge Cases
- [ ] Empty phone number saves correctly
- [ ] Single-word name saves correctly
- [ ] Multiple-word last name saves correctly
- [ ] Special characters in name/phone work
- [ ] Email validation follows backend rules

## Known Limitations

1. **Profile Picture Upload**
   - UI exists but not yet connected to backend
   - Commented out in save function
   - TODO: Implement image upload when backend supports it

2. **Additional Fields**
   - Birthdate, address fields not shown in UI
   - Backend supports them but UI doesn't display
   - Can be added to UI in future

3. **Password Change**
   - Not available through this screen
   - Should be separate "Change Password" flow
   - Security best practice

## Future Enhancements

1. **Profile Picture Upload**
   - Add image upload to backend
   - Implement file storage (Firebase/S3)
   - Update UI to save profile picture

2. **Additional Fields**
   - Add birthdate field
   - Add address fields (street, city, state)
   - Add optional bio/description

3. **Validation**
   - Add phone number format validation
   - Add email format validation
   - Add real-time validation (before save)

4. **Password Management**
   - Add "Change Password" button
   - Navigate to separate password change screen
   - Implement password change endpoint

## Security Notes

- Password is NOT updatable through this endpoint
- Role and status are NOT updatable (admin only)
- Email uniqueness is enforced
- User can only edit their own profile (checked by userId)

## Files Modified

1. `backend/src/main/java/Memora/DimensiaCareApplication/controller/UserController.java`
2. `mobile_app/lib/services/user_service.dart`
3. `mobile_app/lib/screens/volunteer/volunteer_profile_screen.dart`

## Dependencies

- `http` package (for API calls)
- `shared_preferences` package (for storing user session)
- `image_picker` package (for future profile picture)
- AuthService (for getting current user)
- UserService (for API calls)
