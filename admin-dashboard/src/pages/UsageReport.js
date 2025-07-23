import React, { useState } from 'react';
import '../styles/UsageReport.css';
import {
  Header,
  Sidebar,
  Footer
} from '../components';

const UsageReport = () => {
  const [selectedPeriod, setSelectedPeriod] = useState('monthly');
  const [selectedYear, setSelectedYear] = useState('2025');

  // App usage data by month
  const monthlyUsageData = [
    { month: 'Jan', patients: 850, customers: 1200, volunteers: 45, total: 2095 },
    { month: 'Feb', patients: 920, customers: 1350, volunteers: 52, total: 2322 },
    { month: 'Mar', patients: 980, customers: 1480, volunteers: 58, total: 2518 },
    { month: 'Apr', patients: 1050, customers: 1620, volunteers: 62, total: 2732 },
    { month: 'May', patients: 1120, customers: 1750, volunteers: 68, total: 2938 },
    { month: 'Jun', patients: 1180, customers: 1890, volunteers: 72, total: 3142 },
    { month: 'Jul', patients: 1245, customers: 2020, volunteers: 78, total: 3343 }
  ];

  // Daily usage statistics
  const dailyUsageStats = {
    avgDailyUsers: 3343,
    avgSessionDuration: 24.5, // minutes
    newRegistrationsThisWeek: 186,
    peakUsageHour: '14:00 - 15:00',
    avgDailyGrowth: 2.8 // percentage
  };

  // Usage breakdown by user type
  const usageBreakdown = [
    {
      userType: 'Patients',
      totalUsers: 1245,
      activeUsers: 1180,
      avgSessionTime: 32.5,
      topFeatures: ['Health Monitoring', 'Medication Reminders', 'Caregiver Communication'],
      engagementRate: 94.8,
      color: '#2B3F99'
    },
    {
      userType: 'Customers (Family/Guardians)',
      totalUsers: 2020,
      activeUsers: 1950,
      avgSessionTime: 18.7,
      topFeatures: ['Patient Monitoring', 'Reports & Analytics', 'Communication'],
      engagementRate: 96.5,
      color: '#2B3F99'
    },
    {
      userType: 'Volunteers',
      totalUsers: 78,
      activeUsers: 72,
      avgSessionTime: 45.2,
      topFeatures: ['Patient Support', 'Training Materials', 'Schedule Management'],
      engagementRate: 92.3,
      color: '#A0C4FD'
    }
  ];

  const formatNumber = (num) => {
    return num.toLocaleString();
  };

  const getMaxUsage = () => {
    return Math.max(...monthlyUsageData.map(item => item.total));
  };

  return (
    <div className="dashboard">
      <Sidebar currentPage="usage-report" />
      
      <div className="main-content">
        <Header pageTitle="Usage Report" />
        
        <div className="content">
          <div className="usage-report-page">
            {/* Header Controls */}
            <div className="report-header">
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
              
              <div className="year-selector">
                <select 
                  value={selectedYear}
                  onChange={(e) => setSelectedYear(e.target.value)}
                  className="year-select"
                >
                  <option value="2025">2025</option>
                  <option value="2024">2024</option>
                  <option value="2023">2023</option>
                </select>
              </div>
            </div>

            {/* Usage Overview Cards */}
            <div className="usage-overview">
              <div className="overview-card primary">
                <div className="card-icon">📱</div>
                <div className="card-content">
                  <div className="card-number">{formatNumber(dailyUsageStats.avgDailyUsers)}</div>
                  <div className="card-label">Average Daily Users</div>
                  <div className="card-trend positive">+{dailyUsageStats.avgDailyGrowth}% growth</div>
                </div>
              </div>

              <div className="overview-card">
                <div className="card-icon">⏱️</div>
                <div className="card-content">
                  <div className="card-number">{dailyUsageStats.avgSessionDuration} min</div>
                  <div className="card-label">Avg Session Duration</div>
                  <div className="card-note">Per user session</div>
                </div>
              </div>

              <div className="overview-card">
                <div className="card-icon">�</div>
                <div className="card-content">
                  <div className="card-number">{formatNumber(dailyUsageStats.newRegistrationsThisWeek)}</div>
                  <div className="card-label">New Registrations This Week</div>
                  <div className="card-note">Weekly new users</div>
                </div>
              </div>

              <div className="overview-card">
                <div className="card-icon">📈</div>
                <div className="card-content">
                  <div className="card-number">{dailyUsageStats.peakUsageHour}</div>
                  <div className="card-label">Peak Usage Time</div>
                  <div className="card-note">Daily peak hours</div>
                </div>
              </div>
            </div>

            {/* Monthly Usage Chart */}
            <div className="usage-chart-container">
              <div className="chart-card">
                <div className="chart-header">
                  <h3>App Usage by Month - 2025</h3>
                  <p>User activity across different user types</p>
                </div>
                <div className="chart-content">
                  <div className="usage-chart">
                    {monthlyUsageData.map((month, index) => (
                      <div key={index} className="month-usage-item">
                        <div className="month-bars">
                          <div 
                            className="usage-bar patients"
                            style={{ height: `${(month.patients / getMaxUsage()) * 200}px` }}
                            title={`Patients: ${formatNumber(month.patients)}`}
                          ></div>
                          <div 
                            className="usage-bar customers"
                            style={{ height: `${(month.customers / getMaxUsage()) * 200}px` }}
                            title={`Customers: ${formatNumber(month.customers)}`}
                          ></div>
                          <div 
                            className="usage-bar volunteers"
                            style={{ height: `${(month.volunteers / getMaxUsage()) * 200}px` }}
                            title={`Volunteers: ${formatNumber(month.volunteers)}`}
                          ></div>
                        </div>
                        <div className="month-label">{month.month}</div>
                        <div className="month-total">{formatNumber(month.total)}</div>
                      </div>
                    ))}
                  </div>
                  <div className="chart-legend">
                    <div className="legend-item">
                      <div className="legend-color patients"></div>
                      <span>Patients</span>
                    </div>
                    <div className="legend-item">
                      <div className="legend-color customers"></div>
                      <span>Customers</span>
                    </div>
                    <div className="legend-item">
                      <div className="legend-color volunteers"></div>
                      <span>Volunteers</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            {/* Usage by User Type */}
            <div className="user-type-usage">
              <div className="user-type-header">
                <h3>Usage by User Type</h3>
                <p>Detailed breakdown of app usage across different user categories</p>
              </div>
              <div className="user-type-grid">
                {usageBreakdown.map((userType, index) => (
                  <div key={index} className="user-type-card">
                    <div className="user-type-header-card">
                      <div 
                        className="user-type-indicator"
                        style={{ backgroundColor: userType.color }}
                      ></div>
                      <h4>{userType.userType}</h4>
                    </div>
                    <div className="user-type-stats">
                      <div className="stat-row">
                        <span className="stat-label">Total Users:</span>
                        <span className="stat-value">{formatNumber(userType.totalUsers)}</span>
                      </div>
                      <div className="stat-row">
                        <span className="stat-label">Active Users:</span>
                        <span className="stat-value">{formatNumber(userType.activeUsers)}</span>
                      </div>
                      <div className="stat-row">
                        <span className="stat-label">Avg Session:</span>
                        <span className="stat-value">{userType.avgSessionTime} min</span>
                      </div>
                      <div className="stat-row">
                        <span className="stat-label">Engagement:</span>
                        <span className="stat-value engagement">{userType.engagementRate}%</span>
                      </div>
                    </div>
                    <div className="user-type-features">
                      <h5>Top Features Used:</h5>
                      <ul>
                        {userType.topFeatures.map((feature, idx) => (
                          <li key={idx}>{feature}</li>
                        ))}
                      </ul>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>
        </div>
        
        <Footer />
      </div>
    </div>
  );
};

export default UsageReport;
