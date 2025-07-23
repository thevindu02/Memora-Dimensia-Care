import React, { useState } from 'react';
import '../styles/RevenueAnalytics.css';
import {
  Header,
  Sidebar,
  Footer
} from '../components';

const RevenueAnalytics = () => {
  const [selectedPeriod, setSelectedPeriod] = useState('monthly');
  const [showReportModal, setShowReportModal] = useState(false);
  const [reportFilters, setReportFilters] = useState({
    period: 'monthly',
    subscriptionPlan: 'all'
  });

  // Revenue data
  const revenueData = {
    totalRevenue: 2750000, // LKR
    currentMonthRevenue: 450000, // LKR (July 2025)
    activeSubscriptions: 1245,
    avgRevenuePerMonth: 395714, // Total revenue / 7 months
    revenueGrowth: 12.5
  };

  // All transactions in the system
  const allTransactions = [
    { id: 1, user: 'Sarah Johnson', patientId: 'P-1001', plan: 'Premium Health Plan', amount: 35, date: '2025-07-22', status: 'Completed' },
    { id: 2, user: 'Michael Chen', patientId: 'P-1002', plan: 'Basic Health Plan', amount: 15, date: '2025-07-22', status: 'Completed' },
    { id: 3, user: 'Emily Rodriguez', patientId: 'P-1003', plan: 'Premium Health Plan', amount: 35, date: '2025-07-21', status: 'Completed' },
    { id: 4, user: 'David Kim', patientId: 'P-1004', plan: 'Basic Health Plan', amount: 15, date: '2025-07-21', status: 'Pending' },
    { id: 5, user: 'Lisa Thompson', patientId: 'P-1005', plan: 'Free Trial', amount: 0, date: '2025-07-20', status: 'Active' },
    { id: 6, user: 'Robert Wilson', patientId: 'P-2842', plan: 'Premium Health Plan', amount: 35, date: '2025-07-20', status: 'Completed' },
    { id: 7, user: 'Maria Garcia', patientId: 'P-1007', plan: 'Premium Health Plan', amount: 35, date: '2025-07-19', status: 'Completed' },
    { id: 8, user: 'James Brown', patientId: 'P-1011', plan: 'Premium Health Plan', amount: 35, date: '2025-07-19', status: 'Completed' },
    { id: 9, user: 'Jennifer Lopez', patientId: 'P-1008', plan: 'Basic Health Plan', amount: 15, date: '2025-07-18', status: 'Completed' },
    { id: 10, user: 'Mark Thompson', patientId: 'P-1012', plan: 'Basic Health Plan', amount: 15, date: '2025-07-18', status: 'Completed' },
    { id: 11, user: 'Anna Wilson', patientId: 'P-1015', plan: 'Basic Health Plan', amount: 15, date: '2025-07-17', status: 'Completed' },
    { id: 12, user: 'John Smith', patientId: 'P-1009', plan: 'Free Trial', amount: 0, date: '2025-07-17', status: 'Active' },
    { id: 13, user: 'Rachel Green', patientId: 'P-1013', plan: 'Free Trial', amount: 0, date: '2025-07-16', status: 'Active' },
    { id: 14, user: 'Carlos Martinez', patientId: 'P-1016', plan: 'Basic Health Plan', amount: 15, date: '2025-07-15', status: 'Completed' },
    { id: 15, user: 'Emma Davis', patientId: 'P-1017', plan: 'Premium Health Plan', amount: 35, date: '2025-07-15', status: 'Completed' }
  ];

  // Revenue by subscription plan type
  const revenueByPlan = [
    { 
      plan: 'Free Trial', 
      revenue: 0, 
      subscribers: 245, 
      percentage: 0,
      monthlyPrice: 0,
      color: '#2B3F99'
    },
    { 
      plan: 'Basic Health Plan', 
      revenue: 10800, 
      subscribers: 720, 
      percentage: 52.4,
      monthlyPrice: 15,
      color: '#2B3F99'
    },
    { 
      plan: 'Premium Health Plan', 
      revenue: 9800, 
      subscribers: 280, 
      percentage: 47.6,
      monthlyPrice: 35,
      color: '#A0C4FD'
    }
  ];

  const formatCurrency = (amount) => {
    return `$${amount.toLocaleString()}`;
  };

  const handleGenerateReport = () => {
    setShowReportModal(true);
  };

  const handleCloseModal = () => {
    setShowReportModal(false);
  };

  const handleDownloadReport = () => {
    // Logic to generate and download report based on filters
    alert(`Generating ${reportFilters.period} report for ${reportFilters.subscriptionPlan} plan(s)...`);
    setShowReportModal(false);
  };

  return (
    <div className="dashboard">
      <Sidebar currentPage="revenue" />
      
      <div className="main-content">
        <Header pageTitle="Revenue Analytics" />
        
        <div className="content">
          <div className="revenue-analytics-page">
            {/* Header Controls */}
            <div className="analytics-header">
              <div className="period-selector">
                <button 
                  className={selectedPeriod === 'monthly' ? 'active' : ''}
                  onClick={() => setSelectedPeriod('monthly')}
                >
                  Monthly
                </button>
                <button 
                  className={selectedPeriod === 'yearly' ? 'active' : ''}
                  onClick={() => setSelectedPeriod('yearly')}
                >
                  Yearly
                </button>
              </div>
              
              <div className="analytics-actions">
                <button className="refresh-btn">🔄 Refresh</button>
              </div>
            </div>

            {/* Revenue Summary Cards */}
            <div className="revenue-summary">
              <div className="summary-card primary">
                <div className="summary-icon">💰</div>
                <div className="summary-content">
                  <div className="summary-number">{formatCurrency(revenueData.totalRevenue)}</div>
                  <div className="summary-label">Total Revenue</div>
                  <div className="summary-change positive">
                    +{revenueData.revenueGrowth}% growth
                  </div>
                </div>
              </div>

              <div className="summary-card">
                <div className="summary-icon">📅</div>
                <div className="summary-content">
                  <div className="summary-number">{formatCurrency(revenueData.currentMonthRevenue)}</div>
                  <div className="summary-label">Current Month Revenue</div>
                  <div className="summary-note">July 2025</div>
                </div>
              </div>

              <div className="summary-card">
                <div className="summary-icon">👥</div>
                <div className="summary-content">
                  <div className="summary-number">{revenueData.activeSubscriptions.toLocaleString()}</div>
                  <div className="summary-label">Active Subscriptions</div>
                  <div className="summary-note">Paying customers</div>
                </div>
              </div>

              <div className="summary-card">
                <div className="summary-icon">📊</div>
                <div className="summary-content">
                  <div className="summary-number">{formatCurrency(revenueData.avgRevenuePerMonth)}</div>
                  <div className="summary-label">Average Revenue/Month</div>
                  <div className="summary-note">7-month average</div>
                </div>
              </div>
            </div>

            {/* All Transactions */}
            <div className="transactions-container">
              <div className="transactions-card">
                <div className="transactions-header">
                  <h3>All System Transactions</h3>
                  <p>Complete transaction history for all patients</p>
                </div>
                <div className="transactions-table">
                  <div className="table-header">
                    <div className="col-patient">Patient</div>
                    <div className="col-plan">Plan</div>
                    <div className="col-amount">Amount</div>
                    <div className="col-date">Date</div>
                    <div className="col-status">Status</div>
                  </div>
                  <div className="table-body">
                    {allTransactions.slice(0, 10).map((transaction) => (
                      <div key={transaction.id} className="table-row">
                        <div className="col-patient">
                          <div className="patient-info">
                            <div className="patient-name">{transaction.user}</div>
                            <div className="patient-id">{transaction.patientId}</div>
                          </div>
                        </div>
                        <div className="col-plan">
                          <span className="plan-badge">{transaction.plan}</span>
                        </div>
                        <div className="col-amount">
                          <span className="amount">{formatCurrency(transaction.amount)}</span>
                        </div>
                        <div className="col-date">
                          {new Date(transaction.date).toLocaleDateString()}
                        </div>
                        <div className="col-status">
                          <span className={`status-badge ${transaction.status.toLowerCase()}`}>
                            {transaction.status}
                          </span>
                        </div>
                      </div>
                    ))}
                  </div>
                  <div className="table-footer">
                    <button className="view-all-btn">View All {allTransactions.length} Transactions</button>
                  </div>
                </div>
              </div>
            </div>

            {/* Revenue by Subscription Plan */}
            <div className="revenue-by-plan-container">
              <div className="revenue-by-plan-card">
                <div className="revenue-by-plan-header">
                  <h3>Revenue by Subscription Plan Type</h3>
                  <p>Revenue breakdown and performance by plan</p>
                </div>
                <div className="plans-revenue-list">
                  {revenueByPlan.map((plan, index) => (
                    <div key={index} className="plan-revenue-item">
                      <div className="plan-info">
                        <div className="plan-indicator" style={{ backgroundColor: plan.color }}></div>
                        <div className="plan-details">
                          <div className="plan-name">{plan.plan}</div>
                          <div className="plan-pricing">
                            {formatCurrency(plan.monthlyPrice)}/month • {plan.subscribers.toLocaleString()} subscribers
                          </div>
                        </div>
                      </div>
                      <div className="plan-revenue-metrics">
                        <div className="revenue-amount">{formatCurrency(plan.revenue)}</div>
                        <div className="revenue-percentage">{plan.percentage}% of total</div>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            </div>

            {/* Report Generation */}
            <div className="report-generation-container">
              <div className="report-generation-card">
                <div className="report-generation-header">
                  <h3>Generate Revenue Report</h3>
                  <p>Download detailed revenue analytics with custom filters</p>
                </div>
                <div className="report-generation-content">
                  <div className="report-info">
                    <div className="report-icon">📊</div>
                    <div className="report-description">
                      <h4>Custom Revenue Report</h4>
                      <p>Generate comprehensive revenue reports with filters for time period and subscription plans</p>
                    </div>
                  </div>
                  <button className="generate-report-btn" onClick={handleGenerateReport}>
                    Generate Report
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
        
        <Footer />
      </div>

      {/* Report Generation Modal */}
      {showReportModal && (
        <div className="modal-overlay" onClick={handleCloseModal}>
          <div className="modal-content" onClick={(e) => e.stopPropagation()}>
            <div className="modal-header">
              <h3>Generate Revenue Report</h3>
              <button className="close-btn" onClick={handleCloseModal}>×</button>
            </div>
            <div className="modal-body">
              <div className="filter-section">
                <div className="filter-group">
                  <label>Time Period</label>
                  <select 
                    value={reportFilters.period}
                    onChange={(e) => setReportFilters({...reportFilters, period: e.target.value})}
                    className="filter-select"
                  >
                    <option value="monthly">Monthly Report</option>
                    <option value="yearly">Yearly Report</option>
                  </select>
                </div>
                <div className="filter-group">
                  <label>Subscription Plan</label>
                  <select 
                    value={reportFilters.subscriptionPlan}
                    onChange={(e) => setReportFilters({...reportFilters, subscriptionPlan: e.target.value})}
                    className="filter-select"
                  >
                    <option value="all">All Plans</option>
                    <option value="free-trial">Free Trial</option>
                    <option value="basic">Basic Health Plan</option>
                    <option value="premium">Premium Health Plan</option>
                  </select>
                </div>
              </div>
              <div className="report-preview">
                <h4>Report Preview</h4>
                <div className="preview-info">
                  <div className="preview-item">
                    <span className="preview-label">Period:</span>
                    <span className="preview-value">{reportFilters.period === 'monthly' ? 'Monthly' : 'Yearly'}</span>
                  </div>
                  <div className="preview-item">
                    <span className="preview-label">Plan:</span>
                    <span className="preview-value">
                      {reportFilters.subscriptionPlan === 'all' ? 'All Plans' : 
                       reportFilters.subscriptionPlan === 'free-trial' ? 'Free Trial' :
                       reportFilters.subscriptionPlan === 'basic' ? 'Basic Health Plan' : 'Premium Health Plan'}
                    </span>
                  </div>
                </div>
              </div>
            </div>
            <div className="modal-footer">
              <button className="cancel-btn" onClick={handleCloseModal}>Cancel</button>
              <button className="download-btn" onClick={handleDownloadReport}>Download Report</button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default RevenueAnalytics;
