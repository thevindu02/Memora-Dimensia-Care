const API_BASE_URL = 'http://localhost:8080/api';

class VolunteerApiService {
  async getAllVolunteerRequestsWithUserData() {
    try {
      // Add timestamp to prevent caching
      const timestamp = new Date().getTime();
      const response = await fetch(`${API_BASE_URL}/volunteer-requests?_t=${timestamp}`, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'Cache-Control': 'no-cache, no-store, must-revalidate',
          'Pragma': 'no-cache',
          'Expires': '0'
        },
        cache: 'no-store'
      });
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      const data = await response.json();
      return data;
    } catch (error) {
      console.error('Error fetching volunteer requests:', error);
      throw error;
    }
  }

  async getVolunteerRequestsByStatus(status) {
    try {
      const response = await fetch(`${API_BASE_URL}/volunteer-requests/with-user-data/status/${status}`);
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      const data = await response.json();
      return data;
    } catch (error) {
      console.error(`Error fetching volunteer requests with status ${status}:`, error);
      throw error;
    }
  }

  async rejectVolunteerRequest(requestId) {
    try {
      const response = await fetch(`${API_BASE_URL}/volunteer-requests/${requestId}/reject`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        }
      });
      
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      
      const data = await response.json();
      return data;
    } catch (error) {
      console.error('Error rejecting volunteer request:', error);
      throw error;
    }
  }

  async acceptVolunteerRequest(requestId, password) {
    try {
      const response = await fetch(`${API_BASE_URL}/volunteer-requests/${requestId}/accept`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ password: password }),
      });
      
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      
      const data = await response.json();
      return data;
    } catch (error) {
      console.error('Error accepting volunteer request:', error);
      throw error;
    }
  }

  async getAllVolunteersAndRequests() {
    try {
      // Add timestamp to prevent caching
      const timestamp = new Date().getTime();
      const response = await fetch(`${API_BASE_URL}/volunteer-requests/all-volunteers?_t=${timestamp}`, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
          'Cache-Control': 'no-cache, no-store, must-revalidate',
          'Pragma': 'no-cache',
          'Expires': '0'
        },
        cache: 'no-store'
      });
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      const data = await response.json();
      return data;
    } catch (error) {
      console.error('Error fetching combined volunteer data:', error);
      throw error;
    }
  }

  async disableVolunteer(volunteerId) {
    try {
      const response = await fetch(`${API_BASE_URL}/volunteer-requests/volunteer/${volunteerId}/disable`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        }
      });
      
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      
      const data = await response.json();
      return data;
    } catch (error) {
      console.error('Error disabling volunteer:', error);
      throw error;
    }
  }

  async enableVolunteer(volunteerId) {
    try {
      const response = await fetch(`${API_BASE_URL}/volunteer-requests/volunteer/${volunteerId}/enable`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        }
      });
      
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      
      const data = await response.json();
      return data;
    } catch (error) {
      console.error('Error enabling volunteer:', error);
      throw error;
    }
  }
}

const volunteerApiService = new VolunteerApiService();
export default volunteerApiService;
