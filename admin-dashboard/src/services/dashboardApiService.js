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

  async getDashboardChartData() {
    try {
      const response = await fetch(`${API_BASE_URL}/dashboard/charts`, {
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
      console.error('Error fetching dashboard chart data:', error);
      // Return default values in case of error
      return {
        monthlyRevenue: {},
        appUsage: {
          patients: 0,
          caregivers: 0,
          volunteers: 0,
          totalActive: 0
        }
      };
    }
  }

  // Format currency for display
  formatCurrency(amount) {
    if (typeof amount === 'string') {
      amount = parseFloat(amount);
    }
    if (isNaN(amount)) return 'LKR 0';
    
    return new Intl.NumberFormat('en-LK', {
      style: 'currency',
      currency: 'LKR',
      minimumFractionDigits: 0,
      maximumFractionDigits: 0
    }).format(amount);
  }

  // Convert monthly revenue map to chart format
  convertMonthlyRevenueToChart(monthlyRevenueMap) {
    const monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    const currentMonth = new Date().getMonth();
    const chartData = [];

    // Get last 6 months of data
    for (let i = 5; i >= 0; i--) {
      const monthIndex = (currentMonth - i + 12) % 12;
      const monthKey = (monthIndex + 1).toString().padStart(2, '0'); // Format as "01", "02", etc.
      const amount = monthlyRevenueMap[monthKey] || 0;
      
      chartData.push({
        month: monthNames[monthIndex],
        amount: parseFloat(amount)
      });
    }

    return chartData;
  }
}



const dashboardApiService = new DashboardApiService();
export default dashboardApiService;