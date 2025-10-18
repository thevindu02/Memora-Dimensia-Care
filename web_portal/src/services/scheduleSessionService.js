import CONFIG from '../config/api.js';

class ScheduleSessionService {
  constructor() {
    this.baseURL = `${CONFIG.API_BASE_URL}/schedule-sessions`;
  }

  /**
   * Create a new schedule session
   * @param {Object} sessionData - The session data
   * @param {string} sessionData.sessionDate - Date in YYYY-MM-DD format
   * @param {string} sessionData.sessionTime - Time in HH:MM format
   * @param {string} sessionData.sessionTopic - Session topic
   * @param {string} sessionData.description - Session description (optional)
   * @param {string} sessionData.meetingLink - Meeting link (optional)
   * @returns {Promise<Object>} Response with success status and session data
   */
  async createScheduleSession(sessionData) {
    try {
      console.log('Creating schedule session with data:', sessionData);

      // Validate required fields
      if (!sessionData.sessionDate) {
        throw new Error('Session date is required');
      }
      if (!sessionData.sessionTime) {
        throw new Error('Session time is required');
      }
      if (!sessionData.sessionTopic || sessionData.sessionTopic.trim() === '') {
        throw new Error('Session topic is required');
      }

      // Format the request body to match backend DTO
      const requestBody = {
        sessionDate: sessionData.sessionDate, // YYYY-MM-DD format
        sessionTime: sessionData.sessionTime, // HH:MM format (backend will add seconds)
        sessionTopic: sessionData.sessionTopic.trim(),
        description: sessionData.description?.trim() || '',
        meetingLink: sessionData.meetingLink?.trim() || ''
      };

      const response = await fetch(this.baseURL, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(requestBody),
      });

      if (!response.ok) {
        let errorMessage = 'Failed to create schedule session';
        
        if (response.status === 400) {
          // Bad request - likely validation error
          const errorText = await response.text();
          errorMessage = errorText || 'Invalid session data provided';
        } else if (response.status === 500) {
          errorMessage = 'Server error. Please try again later.';
        }
        
        throw new Error(errorMessage);
      }

      const result = await response.json();
      console.log('Schedule session created successfully:', result);

      return {
        success: true,
        message: 'Session scheduled successfully!',
        data: result
      };

    } catch (error) {
      console.error('Error creating schedule session:', error);
      
      // Handle network errors
      if (error.name === 'TypeError' && error.message.includes('fetch')) {
        return {
          success: false,
          message: 'Network error. Please check your connection and try again.',
          error: error.message
        };
      }

      return {
        success: false,
        message: error.message || 'Failed to schedule session. Please try again.',
        error: error.message
      };
    }
  }

  /**
   * Get all schedule sessions
   * @returns {Promise<Object>} Response with sessions data
   */
  async getAllScheduleSessions() {
    try {
      const response = await fetch(this.baseURL, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
        },
      });

      if (!response.ok) {
        throw new Error('Failed to fetch schedule sessions');
      }

      const sessions = await response.json();
      return {
        success: true,
        data: sessions
      };

    } catch (error) {
      console.error('Error fetching schedule sessions:', error);
      return {
        success: false,
        message: 'Failed to fetch schedule sessions',
        error: error.message
      };
    }
  }

  /**
   * Get schedule sessions by date
   * @param {string} date - Date in YYYY-MM-DD format
   * @returns {Promise<Object>} Response with sessions data
   */
  async getScheduleSessionsByDate(date) {
    try {
      const response = await fetch(`${this.baseURL}/date/${date}`, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
        },
      });

      if (!response.ok) {
        throw new Error('Failed to fetch schedule sessions for the specified date');
      }

      const sessions = await response.json();
      return {
        success: true,
        data: sessions
      };

    } catch (error) {
      console.error('Error fetching schedule sessions by date:', error);
      return {
        success: false,
        message: 'Failed to fetch schedule sessions for the specified date',
        error: error.message
      };
    }
  }

  /**
   * Get schedule session by ID
   * @param {number} id - Session ID
   * @returns {Promise<Object>} Response with session data
   */
  async getScheduleSessionById(id) {
    try {
      const response = await fetch(`${this.baseURL}/${id}`, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
        },
      });

      if (!response.ok) {
        if (response.status === 404) {
          throw new Error('Schedule session not found');
        }
        throw new Error('Failed to fetch schedule session');
      }

      const session = await response.json();
      return {
        success: true,
        data: session
      };

    } catch (error) {
      console.error('Error fetching schedule session:', error);
      return {
        success: false,
        message: error.message || 'Failed to fetch schedule session',
        error: error.message
      };
    }
  }

  /**
   * Update a schedule session
   * @param {number} id - Session ID
   * @param {Object} sessionData - Updated session data
   * @returns {Promise<Object>} Response with updated session data
   */
  async updateScheduleSession(id, sessionData) {
    try {
      const requestBody = {
        sessionDate: sessionData.sessionDate,
        sessionTime: sessionData.sessionTime,
        sessionTopic: sessionData.sessionTopic?.trim(),
        description: sessionData.description?.trim() || '',
        meetingLink: sessionData.meetingLink?.trim() || ''
      };

      const response = await fetch(`${this.baseURL}/${id}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(requestBody),
      });

      if (!response.ok) {
        let errorMessage = 'Failed to update schedule session';
        
        if (response.status === 400) {
          const errorText = await response.text();
          errorMessage = errorText || 'Invalid session data provided';
        } else if (response.status === 404) {
          errorMessage = 'Schedule session not found';
        }
        
        throw new Error(errorMessage);
      }

      const result = await response.json();
      return {
        success: true,
        message: 'Session updated successfully!',
        data: result
      };

    } catch (error) {
      console.error('Error updating schedule session:', error);
      return {
        success: false,
        message: error.message || 'Failed to update session',
        error: error.message
      };
    }
  }

  /**
   * Delete a schedule session
   * @param {number} id - Session ID
   * @returns {Promise<Object>} Response with success status
   */
  async deleteScheduleSession(id) {
    try {
      const response = await fetch(`${this.baseURL}/${id}`, {
        method: 'DELETE',
        headers: {
          'Content-Type': 'application/json',
        },
      });

      if (!response.ok) {
        if (response.status === 404) {
          throw new Error('Schedule session not found');
        }
        throw new Error('Failed to delete schedule session');
      }

      return {
        success: true,
        message: 'Session deleted successfully!'
      };

    } catch (error) {
      console.error('Error deleting schedule session:', error);
      return {
        success: false,
        message: error.message || 'Failed to delete session',
        error: error.message
      };
    }
  }

  /**
   * Format date to YYYY-MM-DD format
   * @param {Date} date - JavaScript Date object
   * @returns {string} Formatted date string
   */
  formatDateForAPI(date) {
    if (!date || !(date instanceof Date)) {
      throw new Error('Invalid date provided');
    }

    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    
    return `${year}-${month}-${day}`;
  }

  /**
   * Format time to HH:MM format
   * @param {number} hours - Hours (0-23)
   * @param {number} minutes - Minutes (0-59)
   * @returns {string} Formatted time string
   */
  formatTimeForAPI(hours, minutes) {
    if (typeof hours !== 'number' || typeof minutes !== 'number') {
      throw new Error('Invalid time values provided');
    }

    if (hours < 0 || hours > 23 || minutes < 0 || minutes > 59) {
      throw new Error('Invalid time range');
    }

    return `${String(hours).padStart(2, '0')}:${String(minutes).padStart(2, '0')}`;
  }

  /**
   * Validate session data before sending to API
   * @param {Object} sessionData - Session data to validate
   * @returns {Object} Validation result with isValid flag and errors array
   */
  validateSessionData(sessionData) {
    const errors = [];

    // Validate session date
    if (!sessionData.sessionDate) {
      errors.push('Session date is required');
    } else {
      // Check if date is in the future
      const sessionDate = new Date(sessionData.sessionDate);
      const today = new Date();
      today.setHours(0, 0, 0, 0); // Reset time to compare only dates
      
      if (sessionDate < today) {
        errors.push('Cannot schedule sessions in the past');
      }
    }

    // Validate session time
    if (!sessionData.sessionTime) {
      errors.push('Session time is required');
    }

    // Validate session topic
    if (!sessionData.sessionTopic || sessionData.sessionTopic.trim() === '') {
      errors.push('Session topic is required');
    } else if (sessionData.sessionTopic.trim().length < 3) {
      errors.push('Session topic must be at least 3 characters long');
    }

    // Validate meeting link format if provided
    if (sessionData.meetingLink && sessionData.meetingLink.trim() !== '') {
      const urlPattern = /^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/;
      if (!urlPattern.test(sessionData.meetingLink.trim())) {
        errors.push('Please enter a valid meeting link URL');
      }
    }

    return {
      isValid: errors.length === 0,
      errors
    };
  }
}

// Create and export a singleton instance
const scheduleSessionService = new ScheduleSessionService();
export default scheduleSessionService;
