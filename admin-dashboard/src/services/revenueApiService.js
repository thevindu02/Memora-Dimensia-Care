const API_BASE_URL = process.env.REACT_APP_API_URL || 'http://localhost:8080';

const revenueApiService = {
  // Get revenue analytics data
  async getRevenueAnalytics() {
    try {
      console.log('Fetching revenue analytics...');
      
      const response = await fetch(`${API_BASE_URL}/api/payments/analytics/revenue`, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
        },
      });

      if (!response.ok) {
        throw new Error(`Failed to fetch revenue analytics: ${response.status}`);
      }

      const analytics = await response.json();
      console.log('Revenue analytics fetched:', analytics);
      
      return analytics;
    } catch (error) {
      console.error('Error fetching revenue analytics:', error);
      throw error;
    }
  },

  // Get all transactions
  async getAllTransactions() {
    try {
      console.log('Fetching all transactions...');
      
      const response = await fetch(`${API_BASE_URL}/api/payments/analytics/transactions`, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
        },
      });

      if (!response.ok) {
        throw new Error(`Failed to fetch transactions: ${response.status}`);
      }

      const transactions = await response.json();
      console.log(`Fetched ${transactions.length} transactions`);
      
      return transactions;
    } catch (error) {
      console.error('Error fetching transactions:', error);
      throw error;
    }
  },

  // Format currency for display
  formatCurrency(amount) {
    if (amount === null || amount === undefined) return 'LKR 0';
    return `LKR ${Number(amount).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`;
  },

  // Format date for display
  formatDate(dateString) {
    try {
      if (!dateString) return 'Unknown';
      
      const date = new Date(dateString);
      return date.toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'short',
        day: 'numeric'
      });
    } catch (error) {
      console.error('Error formatting date:', error);
      return 'Invalid Date';
    }
  },

  // Get month name from YYYY-MM format
  getMonthName(monthKey) {
    try {
      if (!monthKey) return '';
      
      const [year, month] = monthKey.split('-');
      const date = new Date(year, month - 1, 1);
      
      return date.toLocaleDateString('en-US', {
        month: 'short',
        year: 'numeric'
      });
    } catch (error) {
      console.error('Error formatting month:', error);
      return monthKey;
    }
  },

  // Calculate percentage change
  calculatePercentageChange(current, previous) {
    if (!previous || previous === 0) return 0;
    return ((current - previous) / previous * 100).toFixed(1);
  },

  // Get status badge class for payment status
  getStatusBadgeClass(status) {
    const statusMap = {
      'SUCCESS': 'completed',
      'PENDING': 'pending',
      'FAILED': 'failed',
      'CANCELLED': 'cancelled',
      'REFUNDED': 'refunded'
    };
    
    return statusMap[status] || 'pending';
  },

  // Get display text for payment status
  getStatusDisplayText(status) {
    const statusMap = {
      'SUCCESS': 'Completed',
      'PENDING': 'Pending',
      'FAILED': 'Failed',
      'CANCELLED': 'Cancelled',
      'REFUNDED': 'Refunded'
    };
    
    return statusMap[status] || status;
  },

  // Get payment method display text
  getPaymentMethodDisplayText(method) {
    const methodMap = {
      'CARD': 'Credit/Debit Card',
      'PAYPAL': 'PayPal',
      'APPLE_PAY': 'Apple Pay',
      'GOOGLE_PAY': 'Google Pay'
    };
    
    return methodMap[method] || method;
  }
};

export default revenueApiService;