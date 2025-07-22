const API_BASE_URL = 'http://localhost:8080/api';

class VolunteerApiService {
  async getAllVolunteerRequestsWithUserData() {
    try {
      // Add timestamp to prevent caching
      const timestamp = new Date().getTime();
      const response = await fetch(`${API_BASE_URL}/volunteer-requests/with-user-data?_t=${timestamp}`, {
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

  async updateVolunteerRequestStatus(requestId, status) {
    try {
      const response = await fetch(`${API_BASE_URL}/volunteer-requests/${requestId}/status`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ status: status }),
      });
      
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      
      const data = await response.json();
      return data;
    } catch (error) {
      console.error('Error updating volunteer request status:', error);
      throw error;
    }
  }
}

const volunteerApiService = new VolunteerApiService();
export default volunteerApiService;
