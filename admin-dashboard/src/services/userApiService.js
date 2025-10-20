const API_BASE_URL = 'http://localhost:8080/api';

class UserApiService {
  async updateUserStatus(userId, status) {
    try {
      const response = await fetch(`${API_BASE_URL}/users/${userId}/status`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ status: status })
      });

      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.message || `HTTP error! status: ${response.status}`);
      }

      const data = await response.json();
      return data;
    } catch (error) {
      console.error('Error updating user status:', error);
      throw error;
    }
  }
}

const userApiService = new UserApiService();
export default userApiService;