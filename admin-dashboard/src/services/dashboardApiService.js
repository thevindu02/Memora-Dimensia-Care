const API_BASE_URL = 'http://localhost:8080/api';

class DashboardApiService {
  async getDashboardStats() {
    try {
      const response = await fetch(`${API_BASE_URL}/dashboard/stats`, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
        },
      });

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const data = await response.json();
      return data;
    } catch (error) {
      console.error('Error fetching dashboard stats:', error);
      // Return default values in case of error
      return {
        patients: 0,
        caregivers: 0,
        volunteers: 0,
        articles: 0
      };
    }
  }
}

const dashboardApiService = new DashboardApiService();
export default dashboardApiService;