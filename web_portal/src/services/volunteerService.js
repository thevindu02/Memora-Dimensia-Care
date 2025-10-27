// Volunteer API service for web portal
import CONFIG from '../config/api';

const API_BASE_URL = CONFIG.API_BASE_URL;

class VolunteerService {
  // Create a new volunteer request
  static async createVolunteerRequest(volunteerData) {
    try {
      const response = await fetch(`${API_BASE_URL}${CONFIG.ENDPOINTS.VOLUNTEER_REQUESTS}`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          volunteerName: volunteerData.volunteerName,
          email: volunteerData.email,
          phoneNumber: volunteerData.phoneNumber,
          gender: volunteerData.gender,
          volunteerIdImage: volunteerData.volunteerIdImage,
        }),
      });

      if (response.ok) {
        const data = await response.json();
        return {
          success: true,
          data: data,
          message: 'Volunteer request created successfully',
        };
      } else {
        const errorData = await response.json();
        return {
          success: false,
          message: errorData.message || 'Failed to create volunteer request',
        };
      }
    } catch (error) {
      return {
        success: false,
        message: `Error creating volunteer request: ${error.message}`,
      };
    }
  }

  // Upload volunteer ID image
  static async uploadVolunteerImage(imageFile) {
    try {
      // Validate file type
      if (!CONFIG.UPLOAD_SETTINGS.ALLOWED_FILE_TYPES.includes(imageFile.type)) {
        return {
          success: false,
          message: 'Invalid file type. Please upload a valid image file (JPEG, JPG, PNG, GIF).',
        };
      }

      // Validate file size
      if (imageFile.size > CONFIG.UPLOAD_SETTINGS.MAX_FILE_SIZE) {
        return {
          success: false,
          message: 'File size too large. Please upload an image smaller than 5MB.',
        };
      }

      const formData = new FormData();
      formData.append('image', imageFile, `volunteer_id_${Date.now()}.jpg`);

      const response = await fetch(`${API_BASE_URL}${CONFIG.ENDPOINTS.IMAGE_UPLOAD}`, {
        method: 'POST',
        body: formData,
      });

      if (response.ok) {
        const data = await response.json();
        return {
          success: true,
          imageUrl: data.imageUrl,
          message: 'Image uploaded successfully',
        };
      } else {
        const errorData = await response.json();
        return {
          success: false,
          message: errorData.error || 'Failed to upload image',
        };
      }
    } catch (error) {
      return {
        success: false,
        message: `Error uploading image: ${error.message}`,
      };
    }
  }

  // Convert image file to base64 (fallback method)
  static convertImageToBase64(file) {
    return new Promise((resolve, reject) => {
      const reader = new FileReader();
      reader.onload = () => resolve(reader.result);
      reader.onerror = (error) => reject(error);
      reader.readAsDataURL(file);
    });
  }

  // Get volunteer request by email
  static async getVolunteerRequestByEmail(email) {
    try {
      const response = await fetch(`${API_BASE_URL}${CONFIG.ENDPOINTS.VOLUNTEER_REQUESTS}/email/${email}`, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
        },
      });

      if (response.ok) {
        const data = await response.json();
        return {
          success: true,
          data: data,
          message: 'Volunteer request retrieved successfully',
        };
      } else if (response.status === 404) {
        return {
          success: false,
          message: 'Volunteer request not found',
        };
      } else {
        return {
          success: false,
          message: 'Failed to retrieve volunteer request',
        };
      }
    } catch (error) {
      return {
        success: false,
        message: `Error retrieving volunteer request: ${error.message}`,
      };
    }
  }

  // Get volunteer ID by user ID
  static async getVolunteerIdByUserId(userId) {
    try {
      const response = await fetch(`${API_BASE_URL}/volunteers/by-user/${userId}`, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
        },
      });

      if (response.ok) {
        const data = await response.json();
        return {
          success: true,
          volunteerId: data.volunteerId,
          message: 'Volunteer ID retrieved successfully',
        };
      } else if (response.status === 404) {
        return {
          success: false,
          message: 'Volunteer not found for this user',
        };
      } else {
        return {
          success: false,
          message: 'Failed to retrieve volunteer ID',
        };
      }
    } catch (error) {
      return {
        success: false,
        message: `Error retrieving volunteer ID: ${error.message}`,
      };
    }
  }
}

export default VolunteerService;
