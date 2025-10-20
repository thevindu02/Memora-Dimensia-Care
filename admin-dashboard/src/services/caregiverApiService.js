const API_BASE_URL = 'http://localhost:8080/api';

class CaregiverApiService {
  async getAllCaregivers() {
    try {
      // Add timestamp to prevent caching
      const timestamp = new Date().getTime();
      const response = await fetch(`${API_BASE_URL}/caregivers/all?_t=${timestamp}`, {
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
      console.error('Error fetching caregivers:', error);
      throw error;
    }
  }

  async getCaregiverById(caregiverId) {
    try {
      const response = await fetch(`${API_BASE_URL}/caregivers/${caregiverId}`, {
        method: 'GET',
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
      console.error('Error fetching caregiver:', error);
      throw error;
    }
  }
}

const caregiverApiService = new CaregiverApiService();
export default caregiverApiService;