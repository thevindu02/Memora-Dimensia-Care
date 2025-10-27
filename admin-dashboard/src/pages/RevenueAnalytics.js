import React, { useState, useEffect } from 'react';
import '../styles/RevenueAnalytics.css';
import {
  Header,
  Sidebar,
  Footer
} from '../components';
import revenueApiService from '../services/revenueApiService';

const RevenueAnalytics = () => {
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [revenueData, setRevenueData] = useState({
    totalRevenue: 0,
    currentMonthRevenue: 0,
    activeSubscriptions: 0,
    averageRevenuePerMonth: 0,
    monthlyRevenue: {}
  });
  const [transactions, setTransactions] = useState([]);

  // Fetch data on component mount
  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true);
        setError('');
        
        // Fetch revenue analytics and transactions in parallel
        const [analyticsData, transactionsData] = await Promise.all([
          revenueApiService.getRevenueAnalytics(),
          revenueApiService.getAllTransactions()
        ]);
        
        setRevenueData(analyticsData);
        setTransactions(transactionsData);
        console.log('Revenue data loaded:', analyticsData);
        console.log('Transactions loaded:', transactionsData.length);
      } catch (err) {
        console.error('Error fetching revenue data:', err);
        setError('Failed to load revenue data. Please try again.');
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, []);

  // Loading state
  if (loading) {
    return (
      <div className="dashboard">
        <Sidebar currentPage="revenue" />
        <div className="main-content">
          <Header pageTitle="Revenue Analytics" />
          <div className="content">
            <div className="loading-container">
              <div className="loading-spinner"></div>
              <p>Loading revenue data...</p>
            </div>
          </div>
        </div>
      </div>
    );
  }

  // Error state
  if (error) {
    return (
      <div className="dashboard">
        <Sidebar currentPage="revenue" />
        <div className="main-content">
          <Header pageTitle="Revenue Analytics" />
          <div className="content">
            <div className="error-container">
              <div className="error-message">
                <h3>⚠️ Error Loading Data</h3>
                <p>{error}</p>
                <button 
                  className="retry-btn"
                  onClick={() => window.location.reload()}
                >
                  Retry
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="dashboard">
      <Sidebar currentPage="revenue" />
      
      <div className="main-content">
        <Header pageTitle="Revenue Analytics" />
        
        <div className="content">
          <div className="revenue-analytics-page">
            {/* Revenue Summary Cards */}
            <div className="revenue-summary">
              <div className="summary-card primary">
                <div className="summary-icon">💰</div>
                <div className="summary-content">
                  <div className="summary-number">
                    {revenueApiService.formatCurrency(revenueData.totalRevenue)}
                  </div>
                  <div className="summary-label">Total Revenue</div>
                  <div className="summary-change positive">
                    All time earnings
                  </div>
                </div>
              </div>

              <div className="summary-card">
                <div className="summary-icon">📅</div>
                <div className="summary-content">
                  <div className="summary-number">
                    {revenueApiService.formatCurrency(revenueData.currentMonthRevenue)}
                  </div>
                  <div className="summary-label">Current Month Revenue</div>
                  <div className="summary-note">
                    {new Date().toLocaleDateString('en-US', { month: 'long', year: 'numeric' })}
                  </div>
                </div>
              </div>

              <div className="summary-card">
                <div className="summary-icon">👥</div>
                <div className="summary-content">
                  <div className="summary-number">{transactions.filter(t => t.status === 'SUCCESS').length}</div>
                  <div className="summary-label">Successful Payments</div>
                  <div className="summary-note">Completed transactions</div>
                </div>
              </div>

              <div className="summary-card">
                <div className="summary-icon">📊</div>
                <div className="summary-content">
                  <div className="summary-number">
                    {revenueApiService.formatCurrency(revenueData.averageRevenuePerMonth)}
                  </div>
                  <div className="summary-label">Average Revenue/Month</div>
                  <div className="summary-note">Monthly average</div>
                </div>
              </div>
            </div>

            {/* All Transactions */}
            <div className="transactions-container">
              <div className="transactions-card">
                <div className="transactions-header">
                  <h3>Recent Transactions</h3>
                  <p>Latest payment transactions in the system</p>
                </div>
                <div className="transactions-table">
                  <div className="table-header">
                    <div className="col-patient">Payment ID</div>
                    <div className="col-plan">Guardian ID</div>
                    <div className="col-amount">Amount</div>
                    <div className="col-date">Date</div>
                    <div className="col-status">Status</div>
                  </div>
                  <div className="table-body">
                    {transactions.slice(0, 10).map((transaction) => (
                      <div key={transaction.paymentId} className="table-row">
                        <div className="col-patient">
                          <div className="patient-info">
                            <div className="patient-name">#{transaction.paymentId}</div>
                            <div className="patient-id">{transaction.paymentMethod}</div>
                          </div>
                        </div>
                        <div className="col-plan">
                          <span className="plan-badge">{transaction.guardianId}</span>
                        </div>
                        <div className="col-amount">
                          <span className="amount">
                            {revenueApiService.formatCurrency(transaction.amount)}
                          </span>
                        </div>
                        <div className="col-date">
                          {revenueApiService.formatDate(transaction.paymentDate)}
                        </div>
                        <div className="col-status">
                          <span className={`status-badge ${revenueApiService.getStatusBadgeClass(transaction.status)}`}>
                            {transaction.status}
                          </span>
                        </div>
                      </div>
                    ))}
                  </div>
                  <div className="table-footer">
                    <button className="view-all-btn">
                      View All {transactions.length} Transactions
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        
        <Footer />
      </div>
    </div>
  );
};

export default RevenueAnalytics;