const API_BASE_URL = 'http://localhost:8080/api';

class VolunteerEngagementApiService {
  async getVolunteerEngagementStats() {
    try {
      const response = await fetch(`${API_BASE_URL}/volunteer-engagement/stats`, {
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
      console.error('Error fetching volunteer engagement stats:', error);
      return {
        totalVolunteers: 0,
        totalArticles: 0,
        avgArticlesPerMonth: 0
      };
    }
  }

  async getArticlesByCategory() {
    try {
      const response = await fetch(`${API_BASE_URL}/volunteer-engagement/articles-by-category`, {
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
      console.error('Error fetching articles by category:', error);
      return [];
    }
  }

  async getMonthlyEngagement() {
    try {
      const response = await fetch(`${API_BASE_URL}/volunteer-engagement/monthly-engagement`, {
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
      console.error('Error fetching monthly engagement:', error);
      return [];
    }
  }

  async getTopVolunteers() {
    try {
      const response = await fetch(`${API_BASE_URL}/volunteer-engagement/top-volunteers`, {
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
      console.error('Error fetching top volunteers:', error);
      return [];
    }
  }

  async getVolunteersDetails() {
    try {
      const response = await fetch(`${API_BASE_URL}/volunteer-engagement/volunteers-details`, {
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
      console.error('Error fetching volunteers details:', error);
      return [];
    }
  }

  async getArticlesDetails() {
    try {
      const response = await fetch(`${API_BASE_URL}/volunteer-engagement/articles-details`, {
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
      console.error('Error fetching articles details:', error);
      return [];
    }
  }
}

const volunteerEngagementApiService = new VolunteerEngagementApiService();
export default volunteerEngagementApiService;