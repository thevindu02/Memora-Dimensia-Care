# Volunteer Signup Integration

This document describes the integration of the volunteer signup form with the backend API.

## Overview
The volunteer signup form has been updated to connect with the backend API that was originally created for the mobile app. The form now handles:

- Real API calls to create volunteer requests
- Image upload to the backend server
- Proper error handling and validation
- Success/failure feedback to users

## Files Modified/Created

### New Files:
1. `src/services/volunteerService.js` - Service class for volunteer API calls
2. `src/config/api.js` - API configuration and settings

### Modified Files:
1. `src/components/volunteer/VolunteerSignup.js` - Updated to use real API calls

## API Integration Details

### Backend Endpoint Used:
- **POST** `/api/volunteer-requests` - Creates a new volunteer request
- **POST** `/api/upload/image` - Uploads volunteer ID image

### Request Format:
```javascript
{
  "volunteerName": "First Last",
  "email": "user@example.com", 
  "phoneNumber": "0712345678",
  "gender": "Male/Female/Other",
  "volunteerIdImage": "base64_string_or_image_url"
}
```

### Response Format:
```javascript
// Success
{
  "requestId": 123,
  "volunteerName": "First Last",
  "email": "user@example.com",
  "phoneNumber": "0712345678", 
  "gender": "Male",
  "volunteerIdImage": "image_url",
  "requestStatus": "pending",
  "createdAt": "2025-01-XX..."
}

// Error
{
  "message": "Error description"
}
```

## Features Implemented

### 1. Image Upload
- Files are uploaded to the backend server first
- If upload fails, falls back to base64 encoding
- Client-side validation for file type and size
- Supports JPEG, JPG, PNG, GIF formats
- Maximum file size: 5MB

### 2. Form Validation
- All required fields validated
- Email format validation
- Sri Lankan phone number validation
- Image upload validation

### 3. Error Handling
- Network errors are caught and displayed
- Server errors are shown to users
- Loading states during submission
- Success feedback with navigation

### 4. User Experience
- Loading spinner during submission
- Success animation on completion
- Clear error messages
- Automatic navigation to success page

## Configuration

### Backend URL
Update the API base URL in `src/config/api.js`:
```javascript
API_BASE_URL: 'http://your-backend-server:8080/api'
```

### File Upload Settings
Modify upload settings in `src/config/api.js`:
```javascript
UPLOAD_SETTINGS: {
  MAX_FILE_SIZE: 5 * 1024 * 1024, // 5MB
  ALLOWED_FILE_TYPES: ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'],
}
```

## Backend Requirements

The integration expects the backend to have:

1. **VolunteerRequestController** with POST endpoint at `/api/volunteer-requests`
2. **Image upload endpoint** at `/api/upload/image`
3. **CORS configuration** to allow requests from the web portal
4. **File upload handling** for multipart form data

## Usage

The VolunteerSignup component can be used in two ways:

### 1. As a Dialog/Modal:
```jsx
<VolunteerSignup open={isOpen} onClose={handleClose} />
```

### 2. As a Standalone Page:
```jsx
<VolunteerSignup />
```

## Error Scenarios Handled

1. **Network connectivity issues**
2. **Server errors (4xx, 5xx responses)**
3. **Invalid file uploads**
4. **Validation failures**
5. **Image upload failures (with fallback)**

## Testing

To test the integration:

1. Ensure backend server is running on the configured URL
2. Try submitting forms with various inputs
3. Test with different image file types and sizes
4. Test network failure scenarios
5. Verify data appears in backend database

## Notes

- The form uses the same backend endpoints as the mobile app
- Image handling includes both server upload and base64 fallback
- All API calls are asynchronous with proper error handling
- The component maintains backward compatibility with existing usage
