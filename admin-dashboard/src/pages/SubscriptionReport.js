import React, { useState } from 'react';
import '../styles/SubscriptionReport.css';
import {
  Header,
  Sidebar,
  Footer
} from '../components';

const SubscriptionReport = () => {
  const [selectedPeriod, setSelectedPeriod] = useState('monthly');
  const [selectedPlan, setSelectedPlan] = useState('all');

  // Subscription plans data (referencing SubscriptionPlanning page structure)
  const subscriptionPlans = [
    {
      id: 1,
      name: 'Basic Care',
      pricing: {
        '3months': 499,
        '6months': 899,
        'annual': 1499
      },
      color: '#2B3F99',
      description: 'Essential dementia care features'
    },
    {
      id: 2,
      name: 'Premium Care',
      pricing: {
        '3months': 999,
        '6months': 1899,
        'annual': 2499
      },
      color: '#A0C4FD',
      description: 'Comprehensive dementia care with advanced features'
    },
  ];

  // Revenue data by plan
  const revenueByPlan = [
    {
      planId: 1,
      planName: 'Basic Care',
      totalRevenue: 10498, // LKR
      subscribers: 11,
      avgRevenuePerUser: 980,
      monthlyGrowth: 12.8,
      churnRate: 5.2,
      color: '#2B3F99'
    },
    {
      planId: 2,
      planName: 'Premium Care',
      totalRevenue: 21987, // LKR
      subscribers: 13,
      avgRevenuePerUser: 1691,
      monthlyGrowth: 18.5,
      churnRate: 3.1,
      color: '#A0C4FD'
    },
  ];

  // Monthly subscription trends
  const monthlyTrends = [
    { month: 'Jan', basicCare: 580, premiumCare: 320, freeTrial: 150, total: 1050 },
    { month: 'Feb', basicCare: 620, premiumCare: 350, freeTrial: 180, total: 1150 },
    { month: 'Mar', basicCare: 650, premiumCare: 380, freeTrial: 195, total: 1225 },
    { month: 'Apr', basicCare: 675, premiumCare: 410, freeTrial: 210, total: 1295 },
    { month: 'May', basicCare: 690, premiumCare: 435, freeTrial: 220, total: 1345 },
    { month: 'Jun', basicCare: 705, premiumCare: 460, freeTrial: 235, total: 1400 },
    { month: 'Jul', basicCare: 720, premiumCare: 485, freeTrial: 245, total: 1450 }
  ];

  // Plan usage statistics
  const planUsageStats = {
    mostUsedPlan: 'Basic Care',
    mostRevenueGenerating: 'Premium Care',
    fastestGrowing: 'Free Trial',
    totalSubscribers: 24,
    totalRevenue: 32485,
    avgSubscriptionValue: 1353
  };

  // Subscribers by plan
  const subscribersByPlan = {
    'Basic Care': [
      { 
        id: 'U001', 
        name: 'John Anderson', 
        email: 'john.anderson@email.com',
        duration: '6 months', 
        amount: 899, 
        joinDate: '2025-02-15',
        status: 'Active',
        nextBilling: '2025-08-15'
      },
      { 
        id: 'U002', 
        name: 'Mary Johnson', 
        email: 'mary.johnson@email.com',
        duration: 'Annual', 
        amount: 1499, 
        joinDate: '2025-01-10',
        status: 'Active',
        nextBilling: '2026-01-10'
      },
      { 
        id: 'U003', 
        name: 'Robert Chen', 
        email: 'robert.chen@email.com',
        duration: '3 months', 
        amount: 499, 
        joinDate: '2025-05-20',
        status: 'Active',
        nextBilling: '2025-08-20'
      },
      { 
        id: 'U004', 
        name: 'Lisa Thompson', 
        email: 'lisa.thompson@email.com',
        duration: '6 months', 
        amount: 899, 
        joinDate: '2025-03-08',
        status: 'Active',
        nextBilling: '2025-09-08'
      },
      { 
        id: 'U005', 
        name: 'Michael Davis', 
        email: 'michael.davis@email.com',
        duration: 'Annual', 
        amount: 1499, 
        joinDate: '2024-12-05',
        status: 'Active',
        nextBilling: '2025-12-05'
      }
    ],
    'Premium Care': [
      { 
        id: 'U006', 
        name: 'Sarah Williams', 
        email: 'sarah.williams@email.com',
        duration: 'Annual', 
        amount: 2499, 
        joinDate: '2025-01-20',
        status: 'Active',
        nextBilling: '2026-01-20'
      },
      { 
        id: 'U007', 
        name: 'David Kim', 
        email: 'david.kim@email.com',
        duration: '6 months', 
        amount: 1899, 
        joinDate: '2025-04-12',
        status: 'Active',
        nextBilling: '2025-10-12'
      },
      { 
        id: 'U008', 
        name: 'Emily Rodriguez', 
        email: 'emily.rodriguez@email.com',
        duration: '3 months', 
        amount: 999, 
        joinDate: '2025-06-01',
        status: 'Active',
        nextBilling: '2025-09-01'
      },
      { 
        id: 'U009', 
        name: 'James Wilson', 
        email: 'james.wilson@email.com',
        duration: 'Annual', 
        amount: 2499, 
        joinDate: '2024-11-15',
        status: 'Active',
        nextBilling: '2025-11-15'
      },
      { 
        id: 'U010', 
        name: 'Anna Martinez', 
        email: 'anna.martinez@email.com',
        duration: '6 months', 
        amount: 1899, 
        joinDate: '2025-02-28',
        status: 'Active',
        nextBilling: '2025-08-28'
      }
    ],

  };

  const formatCurrency = (amount) => {
    return `LKR ${amount.toLocaleString()}`;
  };

  const formatNumber = (num) => {
    return num.toLocaleString();
  };

  const getPlanPercentage = (planSubscribers) => {
    return ((planSubscribers / planUsageStats.totalSubscribers) * 100).toFixed(1);
  };

  return (
    <div className="dashboard">
      <Sidebar currentPage="subscription-report" />
      
      <div className="main-content">
        <Header pageTitle="Subscription Report" />
        
        <div className="content">
          <div className="subscription-analytics-page">
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
                  className={selectedPeriod === 'quarterly' ? 'active' : ''}
                  onClick={() => setSelectedPeriod('quarterly')}
                >
                  Quarterly
                </button>
                <button 
                  className={selectedPeriod === 'yearly' ? 'active' : ''}
                  onClick={() => setSelectedPeriod('yearly')}
                >
                  Yearly
                </button>
              </div>
              
              <div className="analytics-actions">
                <select 
                  value={selectedPlan}
                  onChange={(e) => setSelectedPlan(e.target.value)}
                  className="plan-filter"
                >
                  <option value="all">All Plans</option>
                  <option value="basic">Basic Care</option>
                  <option value="premium">Premium Care</option>
                </select>
                <button className="refresh-btn">🔄 Refresh</button>
              </div>
            </div>

            {/* Subscription Summary Cards */}
            <div className="subscription-summary">
              <div className="summary-card primary">
                <div className="summary-icon">💰</div>
                <div className="summary-content">
                  <div className="summary-number">{formatCurrency(planUsageStats.totalRevenue)}</div>
                  <div className="summary-label">Total Revenue</div>
                  <div className="summary-change positive">
                    +15.2% growth this month
                  </div>
                </div>
              </div>
              
              <div className="summary-card">
                <div className="summary-icon">👥</div>
                <div className="summary-content">
                  <div className="summary-number">{formatNumber(planUsageStats.totalSubscribers)}</div>
                  <div className="summary-label">Active Subscribers</div>
                  <div className="summary-note">Across all plans</div>
                </div>
              </div>
              
              <div className="summary-card">
                <div className="summary-icon">📊</div>
                <div className="summary-content">
                  <div className="summary-number">{formatCurrency(planUsageStats.avgSubscriptionValue)}</div>
                  <div className="summary-label">Average Revenue Per User</div>
                  <div className="summary-note">Monthly average</div>
                </div>
              </div>
              
              <div className="summary-card">
                <div className="summary-icon">🏆</div>
                <div className="summary-content">
                  <div className="summary-number">{planUsageStats.mostUsedPlan}</div>
                  <div className="summary-label">Most Popular Plan</div>
                  <div className="summary-note">{getPlanPercentage(720)}% of users</div>
                </div>
              </div>
            </div>

            {/* Revenue by Plan Breakdown */}
            <div className="revenue-breakdown-container">
              <div className="breakdown-card">
                <div className="breakdown-header">
                  <h3>Revenue by Subscription Plan</h3>
                  <p>Financial performance and subscriber metrics for each plan</p>
                </div>
                <div className="revenue-plan-grid">
                  {revenueByPlan.map((plan, index) => (
                    <div key={index} className="plan-breakdown-card">
                      <div className="plan-card-header">
                        <div 
                          className="plan-indicator"
                          style={{ backgroundColor: plan.color }}
                        ></div>
                        <h4>{plan.planName}</h4>
                        <div className={`growth-badge ${plan.monthlyGrowth > 0 ? 'positive' : 'negative'}`}>
                          +{plan.monthlyGrowth}%
                        </div>
                      </div>
                      <div className="plan-metrics">
                        <div className="metric-item primary">
                          <span className="metric-label">Total Revenue</span>
                          <span className="metric-value">{formatCurrency(plan.totalRevenue)}</span>
                        </div>
                        <div className="metric-item">
                          <span className="metric-label">Subscribers</span>
                          <span className="metric-value">{formatNumber(plan.subscribers)}</span>
                        </div>
                        <div className="metric-item">
                          <span className="metric-label">Revenue per User</span>
                          <span className="metric-value">{formatCurrency(plan.avgRevenuePerUser)}</span>
                        </div>
                        <div className="metric-item">
                          <span className="metric-label">Churn Rate</span>
                          <span className={`metric-value ${plan.churnRate > 10 ? 'warning' : 'good'}`}>
                            {plan.churnRate}%
                          </span>
                        </div>
                      </div>
                      <div className="plan-share">
                        <div className="share-label">Market Share</div>
                        <div className="share-bar">
                          <div 
                            className="share-fill"
                            style={{ 
                              width: `${getPlanPercentage(plan.subscribers)}%`,
                              backgroundColor: plan.color
                            }}
                          ></div>
                        </div>
                        <div className="share-percentage">{getPlanPercentage(plan.subscribers)}%</div>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            </div>

            {/* Monthly Subscription Trends */}
            <div className="trends-chart-container">
              <div className="chart-card">
                <div className="chart-header">
                  <h3>Monthly Subscription Trends - 2025</h3>
                  <p>Subscriber growth across all plans throughout the year</p>
                </div>
                <div className="chart-content">
                  <div className="subscription-chart">
                    {monthlyTrends.map((month, index) => (
                      <div key={index} className="month-subscription-item">
                        <div className="month-bars">
                          <div 
                            className="subscription-bar basic-care"
                            style={{ height: `${(month.basicCare / 800) * 150}px` }}
                            title={`Basic Care: ${formatNumber(month.basicCare)}`}
                          ></div>
                          <div 
                            className="subscription-bar premium-care"
                            style={{ height: `${(month.premiumCare / 800) * 150}px` }}
                            title={`Premium Care: ${formatNumber(month.premiumCare)}`}
                          ></div>
                          <div 
                            className="subscription-bar free-trial"
                            style={{ height: `${(month.freeTrial / 800) * 150}px` }}
                            title={`Free Trial: ${formatNumber(month.freeTrial)}`}
                          ></div>
                        </div>
                        <div className="month-label">{month.month}</div>
                        <div className="month-total">{formatNumber(month.total)}</div>
                      </div>
                    ))}
                  </div>
                  <div className="chart-legend">
                    <div className="legend-item">
                      <div className="legend-color basic-care"></div>
                      <span>Basic Care</span>
                    </div>
                    <div className="legend-item">
                      <div className="legend-color premium-care"></div>
                      <span>Premium Care</span>
                    </div>

                  </div>
                </div>
              </div>
            </div>

            {/* Subscribers by Plan */}
            <div className="subscribers-container">
              <div className="subscribers-card">
                <div className="subscribers-header">
                  <h3>Subscribers by Plan</h3>
                  <p>All active users organized by their subscription plans</p>
                </div>
                <div className="subscribers-content">
                  {Object.entries(subscribersByPlan).map(([planName, subscribers]) => (
                    <div key={planName} className="plan-subscribers-section">
                      <div className="plan-section-header">
                        <h4>{planName}</h4>
                        <span className="subscriber-count">{subscribers.length} subscribers</span>
                      </div>
                      <div className="subscribers-table">
                        <div className="table-header">
                          <div className="col-user">User</div>
                          <div className="col-duration">Duration</div>
                          <div className="col-amount">Amount</div>
                          <div className="col-status">Status</div>
                          <div className="col-billing">Next Billing</div>
                        </div>
                        <div className="table-body">
                          {subscribers.slice(0, 5).map((subscriber) => (
                            <div key={subscriber.id} className="table-row">
                              <div className="col-user">
                                <div className="user-info">
                                  <div className="user-name">{subscriber.name}</div>
                                  <div className="user-email">{subscriber.email}</div>
                                </div>
                              </div>
                              <div className="col-duration">
                                <span className="duration-badge">{subscriber.duration}</span>
                              </div>
                              <div className="col-amount">
                                <span className="amount">
                                  {subscriber.amount > 0 ? formatCurrency(subscriber.amount) : 'Free'}
                                </span>
                              </div>
                              <div className="col-status">
                                <span className={`status-badge ${subscriber.status.toLowerCase()}`}>
                                  {subscriber.status}
                                </span>
                              </div>
                              <div className="col-billing">
                                <span className="billing-date">{subscriber.nextBilling}</span>
                              </div>
                            </div>
                          ))}
                        </div>
                        {subscribers.length > 5 && (
                          <div className="view-more">
                            <button className="view-more-btn">
                              View all {subscribers.length} subscribers
                            </button>
                          </div>
                        )}
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

export default SubscriptionReport;
