import React, { useState } from 'react';
import '../styles/RevenueAnalytics.css';
import {
  Header,
  Sidebar,
  Footer
} from '../components';

// Sample subscription data - replace with actual API calls later
const subscriptionData = {
  totalRevenue: 2750000, // LKR
  monthlyRevenue: 450000, // LKR
  activeSubscriptions: 156,
  newSubscriptions: 23,
  cancelledSubscriptions: 8,
  revenueGrowth: 12.5, // percentage
  
  // Revenue by plan type
  planRevenue: [
    { plan: '3 Months', revenue: 850000, subscribers: 45, avgPrice: 18889 },
    { plan: '6 Months', revenue: 1200000, subscribers: 67, avgPrice: 17910 },
    { plan: 'Annual', revenue: 700000, subscribers: 44, avgPrice: 15909 }
  ],
  
  // Monthly revenue trend (last 12 months)
  monthlyTrend: [
    { month: 'Jan', revenue: 380000 },
    { month: 'Feb', revenue: 420000 },
    { month: 'Mar', revenue: 390000 },
    { month: 'Apr', revenue: 465000 },
    { month: 'May', revenue: 520000 },
    { month: 'Jun', revenue: 485000 },
    { month: 'Jul', revenue: 450000 },
    { month: 'Aug', revenue: 0 }, // Future months
    { month: 'Sep', revenue: 0 },
    { month: 'Oct', revenue: 0 },
    { month: 'Nov', revenue: 0 },
    { month: 'Dec', revenue: 0 }
  ],
  
  // Recent transactions
  recentTransactions: [
    { id: 1, user: 'Kasun Perera', plan: '6 Months', amount: 17500, date: '2025-07-18', status: 'Completed' },
    { id: 2, user: 'Nimali Fernando', plan: 'Annual', amount: 15000, date: '2025-07-17', status: 'Completed' },
    { id: 3, user: 'Ruwan Silva', plan: '3 Months', amount: 19000, date: '2025-07-16', status: 'Completed' },
    { id: 4, user: 'Sandani Rathnayake', plan: '6 Months', amount: 18000, date: '2025-07-15', status: 'Pending' },
    { id: 5, user: 'Chaminda Jayasinghe', plan: 'Annual', amount: 16500, date: '2025-07-14', status: 'Completed' },
    { id: 6, user: 'Chaminda Jayasinghe', plan: 'Annual', amount: 16500, date: '2025-07-14', status: 'Completed' },
    { id: 7, user: 'Chaminda Jayasinghe', plan: 'Annual', amount: 16500, date: '2025-07-14', status: 'Completed' }

  ],
  
  // Churn analysis
  churnData: {
    churnRate: 5.1, // percentage
    avgLifetime: 8.3, // months
    lifetimeValue: 45000 // LKR
  }
};

const RevenueAnalytics = () => {
  const [selectedPeriod, setSelectedPeriod] = useState('monthly');

  const formatCurrency = (amount) => {
    return new Intl.NumberFormat('en-LK', {
      style: 'currency',
      currency: 'LKR',
      minimumFractionDigits: 0,
      maximumFractionDigits: 0
    }).format(amount);
  };

  const formatNumber = (num) => {
    return new Intl.NumberFormat('en-LK').format(num);
  };

  const getGrowthIcon = (growth) => {
    return growth >= 0 ? '📈' : '📉';
  };

  const getGrowthColor = (growth) => {
    return growth >= 0 ? 'var(--success-color)' : 'var(--danger-color)';
  };

  return (
    <div className="dashboard">
      <Sidebar currentPage="revenue" />
      
      <div className="main-content">
        <Header pageTitle="Revenue Analytics" />
        
        <div className="content">
          <div className="revenue-analytics-container">
            {/* Header Controls */}
            <div className="analytics-header">
              <div className="period-selector">
                <button 
                  className={selectedPeriod === 'weekly' ? 'active' : ''}
                  onClick={() => setSelectedPeriod('weekly')}
                >
                  Weekly
                </button>
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
                <button className="export-btn">📊 Export Report</button>
                <button className="refresh-btn">🔄 Refresh</button>
              </div>
            </div>

            {/* Revenue Overview Cards */}
            <div className="revenue-cards-grid">
              <div className="revenue-card primary">
                <div className="card-icon">💰</div>
                <div className="card-content">
                  <h3>{formatCurrency(subscriptionData.totalRevenue)}</h3>
                  <p>Total Revenue</p>
                  <div className="card-trend">
                    <span className="trend-icon">{getGrowthIcon(subscriptionData.revenueGrowth)}</span>
                    <span 
                      className="trend-value"
                      style={{ color: getGrowthColor(subscriptionData.revenueGrowth) }}
                    >
                      {subscriptionData.revenueGrowth}% vs last period
                    </span>
                  </div>
                </div>
              </div>
              
              <div className="revenue-card">
                <div className="card-icon">📅</div>
                <div className="card-content">
                  <h3>{formatCurrency(subscriptionData.monthlyRevenue)}</h3>
                  <p>Monthly Revenue</p>
                  <div className="card-subtitle">Current month</div>
                </div>
              </div>
              
              <div className="revenue-card">
                <div className="card-icon">👥</div>
                <div className="card-content">
                  <h3>{formatNumber(subscriptionData.activeSubscriptions)}</h3>
                  <p>Active Subscriptions</p>
                  <div className="card-subtitle">+{subscriptionData.newSubscriptions} new this month</div>
                </div>
              </div>
              
              <div className="revenue-card">
                <div className="card-icon">💳</div>
                <div className="card-content">
                  <h3>{formatCurrency(Math.round(subscriptionData.totalRevenue / subscriptionData.activeSubscriptions))}</h3>
                  <p>Average Revenue Per User</p>
                  <div className="card-subtitle">ARPU</div>
                </div>
              </div>
            </div>

            {/* Charts Section */}
            <div className="charts-grid">
              {/* Revenue Trend Chart */}
              <div className="chart-container">
                <div className="chart-header">
                  <h3>Revenue Trend</h3>
                  <div className="chart-period">Last 12 Months</div>
                </div>
                <div className="chart-content">
                  <div className="simple-bar-chart">
                    {subscriptionData.monthlyTrend.map((month, index) => (
                      <div key={index} className="bar-item">
                        <div 
                          className="bar"
                          style={{ 
                            height: `${(month.revenue / 600000) * 200}px`,
                            backgroundColor: month.revenue > 0 ? 'var(--primary-color)' : 'var(--gray-200)'
                          }}
                        ></div>
                        <span className="bar-label">{month.month}</span>
                        <span className="bar-value">
                          {month.revenue > 0 ? formatCurrency(month.revenue) : '-'}
                        </span>
                      </div>
                    ))}
                  </div>
                </div>
              </div>

              {/* Plan Revenue Breakdown */}
              <div className="chart-container">
                <div className="chart-header">
                  <h3>Revenue by Plan Type</h3>
                  <div className="chart-period">Current Period</div>
                </div>
                <div className="chart-content">
                  <div className="plan-revenue-list">
                    {subscriptionData.planRevenue.map((plan, index) => (
                      <div key={index} className="plan-revenue-item">
                        <div className="plan-info">
                          <div className="plan-name">{plan.plan}</div>
                          <div className="plan-subscribers">{plan.subscribers} subscribers</div>
                        </div>
                        <div className="plan-revenue">
                          <div className="revenue-amount">{formatCurrency(plan.revenue)}</div>
                          <div className="avg-price">Avg: {formatCurrency(plan.avgPrice)}</div>
                        </div>
                        <div className="plan-percentage">
                          <div 
                            className="percentage-bar"
                            style={{ 
                              width: `${(plan.revenue / subscriptionData.totalRevenue) * 100}%` 
                            }}
                          ></div>
                          <span>{Math.round((plan.revenue / subscriptionData.totalRevenue) * 100)}%</span>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              </div>
            </div>

            {/* Analytics Grid */}
            <div className="analytics-grid">
              {/* Customer Metrics */}
              <div className="analytics-card">
                <div className="card-header">
                  <h3>Customer Metrics</h3>
                  <span className="metric-icon">👤</span>
                </div>
                <div className="metrics-list">
                  <div className="metric-item">
                    <span className="metric-label">New Subscriptions</span>
                    <span className="metric-value positive">+{subscriptionData.newSubscriptions}</span>
                  </div>
                  <div className="metric-item">
                    <span className="metric-label">Cancelled Subscriptions</span>
                    <span className="metric-value negative">-{subscriptionData.cancelledSubscriptions}</span>
                  </div>
                  <div className="metric-item">
                    <span className="metric-label">Churn Rate</span>
                    <span className="metric-value">{subscriptionData.churnData.churnRate}%</span>
                  </div>
                  <div className="metric-item">
                    <span className="metric-label">Avg. Customer Lifetime</span>
                    <span className="metric-value">{subscriptionData.churnData.avgLifetime} months</span>
                  </div>
                </div>
              </div>

              {/* Recent Transactions */}
              <div className="analytics-card">
                <div className="card-header">
                  <h3>Recent Transactions</h3>
                  <span className="metric-icon">💳</span>
                </div>
                <div className="transactions-list">
                  {subscriptionData.recentTransactions.map((transaction) => (
                    <div key={transaction.id} className="transaction-item">
                      <div className="transaction-user">
                        <div className="user-avatar">{transaction.user.split(' ').map(n => n[0]).join('')}</div>
                        <div className="user-info">
                          <div className="user-name">{transaction.user}</div>
                          <div className="transaction-plan">{transaction.plan}</div>
                        </div>
                      </div>
                      <div className="transaction-details">
                        <div className="transaction-amount">{formatCurrency(transaction.amount)}</div>
                        <div className="transaction-date">{transaction.date}</div>
                      </div>
                      <div className={`transaction-status ${transaction.status.toLowerCase()}`}>
                        {transaction.status}
                      </div>
                    </div>
                  ))}
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
