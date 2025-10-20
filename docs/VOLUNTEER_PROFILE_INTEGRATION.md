# Volunteer Profile Backend Integration

## Overview
This document details the complete backend integration for the Volunteer Profile screen, matching the Guardian Profile functionality.

## Date: October 19, 2025

---

## Backend Changes

### 1. UserController.java - New Password Change Endpoint

**Endpoint:** `PUT /api/users/{id}/change-password`

**Request Body:**
```json
{
  "currentPassword": "string",
  "newPassword": "string"
}
```

**Response:**
- **200 OK**: Password changed successfully
```json
{
  "message": "Password changed successfully"
}
```

- **400 Bad Request**: Current password incorrect or new password invalid
```json
{
  "message": "Current password is incorrect"
}
```
or
```json
{
  "message": "New password must be at least 6 characters"
}
```

- **404 Not Found**: User not found

**Features:**
- Verifies current password using BCrypt password encoder
- Validates new password (minimum 6 characters)
- Encrypts new password before saving
- Separate from profile update for security

**Implementation Details:**
- Added `ChangePasswordRequest` inner class with getters/setters
- Uses existing `PasswordEncoder` bean for password hashing
- Validates current password with `passwordEncoder.matches()`
- Returns appropriate HTTP status codes

---

### 2. Existing UserController.java - Profile Update Endpoint

**Endpoint:** `PUT /api/users/{id}`

**Already Supports (No Changes Needed):**
- `FName`, `LName` - Name fields ✅
- `email` - Email with uniqueness validation ✅
- `phoneNumber` - Phone number ✅
- `gender` - Gender ✅
- `birthdate` - Birthday (NEW field now being used) ✅
- `street` - Street address (NEW field now being used) ✅
- `city` - City (NEW field now being used) ✅
- `state` - State/Province (NEW field now being used) ✅
- `profilePic` - Profile picture URL ✅

**Note:** Password updates are intentionally NOT handled by this endpoint for security reasons.

---

## Frontend Changes

### 1. user_service.dart - New Password Change Method

**Method:** `changePassword()`

```dart
static Future<UserResult> changePassword({
  required int userId,
  required String currentPassword,
  required String newPassword,
}) async
```

**Features:**
- Calls `/api/users/{userId}/change-password` endpoint
- Handles success/error responses
- Returns `UserResult` with success status and message
- Handles network errors gracefully

---

### 2. volunteer_profile_screen.dart - Enhanced Save Logic

**Updated `_saveProfile()` Method:**

**Two-Step Save Process:**
1. **Profile Update**: Updates all profile fields (name, email, phone, gender, birthday, address)
2. **Password Change** (if provided): Separately changes password

**Password Change Logic:**
- Only attempts password change if both current and new passwords are provided
- Validates passwords on frontend (form validation)
- Calls backend password change endpoint separately
- Shows appropriate error if current password is wrong
- Stops save process if password change fails
- Shows combined success message if both operations succeed

**Success Messages:**
- Profile only: "Profile updated successfully!"
- Profile + Password: "Profile and password updated successfully!"

**Error Handling:**
- Shows specific error messages from backend
- Returns early if password change fails (doesn't update profile status)
- Handles network errors with user-friendly messages

---

## Complete Feature List

### Fields Now Integrated with Backend:

#### Personal Information
- ✅ **Full Name** → Split into FName/LName
- ✅ **Email** → With uniqueness validation
- ✅ **Phone Number**
- ✅ **Gender** → With picker dialog
- ✅ **Birthday** → With date picker (NEW)

#### Address Information (NEW)
- ✅ **Street Address** → Required field
- ✅ **City** → Required field
- ✅ **State/Province** → Required field

#### Password Change (NEW)
- ✅ **Current Password** → Verified against database
- ✅ **New Password** → Minimum 6 characters, encrypted
- ✅ **Confirm Password** → Must match new password

#### Additional Features
- ✅ **Profile Picture** → Support ready (upload pending)
- ✅ **Form Validation** → All fields validated
- ✅ **Focus Handling** → Text color changes
- ✅ **Modified Tracking** → Tracks changed fields
- ✅ **Cancel/Reset** → Restores original values

---

## API Endpoints Summary

| Method | Endpoint | Purpose | Status |
|--------|----------|---------|--------|
| GET | `/api/users/{id}` | Fetch user data | ✅ Existing |
| PUT | `/api/users/{id}` | Update profile | ✅ Existing |
| PUT | `/api/users/{id}/change-password` | Change password | ✅ **NEW** |

---

## Security Features

1. **Password Verification**: Current password must be correct to change
2. **Password Encryption**: BCrypt hashing for all passwords
3. **Separate Endpoint**: Password changes isolated from profile updates
4. **Email Uniqueness**: Prevents duplicate emails
5. **Validation**: Frontend and backend validation
6. **Minimum Length**: 6 characters for passwords

---

## Testing Checklist

### Profile Update Tests
- [ ] Update name successfully
- [ ] Update email successfully (unique)
- [ ] Update email fails if duplicate
- [ ] Update phone number successfully
- [ ] Update gender successfully
- [ ] Update birthday successfully
- [ ] Update street address successfully
- [ ] Update city successfully
- [ ] Update state successfully
- [ ] Required fields show errors when empty
- [ ] Cancel restores original values

### Password Change Tests
- [ ] Change password with correct current password
- [ ] Change password fails with wrong current password
- [ ] Change password fails if new password < 6 chars
- [ ] Change password fails if new ≠ confirm
- [ ] Password change clears fields after success
- [ ] Can update profile without changing password
- [ ] Combined update (profile + password) works

### UI/UX Tests
- [ ] Modified fields turn black
- [ ] Unmodified fields stay grey
- [ ] Profile header hides when editing
- [ ] Save button shows loading indicator
- [ ] Success message shows appropriate text
- [ ] Error messages are user-friendly
- [ ] Back button exits edit mode first

---

## Known Limitations

1. **Profile Picture Upload**: Backend supports URL but file upload not implemented
2. **Password Strength**: Only checks minimum length (6 chars)
3. **Two-Factor Auth**: Not implemented

---

## Files Modified

### Backend
- `backend/src/main/java/Memora/DimensiaCareApplication/controller/UserController.java`
  - Added `changePassword()` endpoint
  - Added `ChangePasswordRequest` inner class

### Frontend
- `mobile_app/lib/services/user_service.dart`
  - Added `changePassword()` method

- `mobile_app/lib/screens/volunteer/volunteer_profile_screen.dart`
  - Updated `_saveProfile()` to handle password changes
  - Enhanced success/error messaging
  - Improved validation flow

---

## Deployment Notes

### Backend
- **Restart Required**: Yes - New endpoint requires Spring Boot restart
- **Database Changes**: None - Uses existing User table columns
- **Dependencies**: None - Uses existing PasswordEncoder bean

### Frontend
- **Build Required**: Yes - New service method and UI updates
- **Breaking Changes**: None - Backward compatible
- **Hot Reload**: Supported for UI changes only

---

## Conclusion

All additional functionalities from the Guardian Profile have been successfully integrated into the Volunteer Profile with full backend support:

✅ Birthday field with backend persistence
✅ Address fields (street, city, state) with backend persistence  
✅ Password change with secure backend endpoint
✅ Complete form validation
✅ Proper error handling
✅ User-friendly messaging

The volunteer profile now has feature parity with the guardian profile and full backend integration.
