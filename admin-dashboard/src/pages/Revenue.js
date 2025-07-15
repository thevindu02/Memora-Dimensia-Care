import React, { useState } from 'react';
import { Header, Sidebar, Footer } from '../components';
import '../styles/Revenue.css';

const Revenue = () => {
  const [selectedPeriod, setSelectedPeriod] = useState('month');
  const [selectedYear, setSelectedYear] = useState('2024');

  // Sample revenue data
  const revenueData = {
    totalRevenue: 45690,
    monthlyGrowth: 12.5,
    totalUsers: 1245,
    userGrowth: 8.2,
    avgRevenue: 36.72,
    avgGrowth: 15.8,
    conversionRate: 3.8,
    conversionChange: -2.1
  };

  // Monthly revenue data for the chart
  const monthlyRevenue = [
    { month: 'Jan', amount: 35000 },
    { month: 'Feb', amount: 38000 },
    { month: 'Mar', amount: 42000 },
    { month: 'Apr', amount: 39000 },
    { month: 'May', amount: 44000 },
    { month: 'Jun', amount: 48000 },
    { month: 'Jul', amount: 52000 },
    { month: 'Aug', amount: 47000 },
    { month: 'Sep', amount: 51000 },
    { month: 'Oct', amount: 45000 },
    { month: 'Nov', amount: 49000 },
    { month: 'Dec', amount: 45690 }
  ];

  const maxRevenue = Math.max(...monthlyRevenue.map(item => item.amount));
  const yAxisLabels = [
    '$60k', '$50k', '$40k', '$30k', '$20k', '$10k', '$0'
  ];

  const handleGenerateReport = (reportType) => {
    // Simple report generation - in real app, this would make an API call
    alert(`Generating ${reportType} report...`);
  };

  return (
    <div className="dashboard-container">
      <Header />
      <div className="main-content">
        <Sidebar />
        <div className="page-content">
          <div className="revenue-page">
            <h1>Revenue Analytics</h1>
            
            {/* Filters */}
            <div className="revenue-filters">
              <div className="filter-group">
                <label>Time Period</label>
                <select 
                  className="filter-select"
                  value={selectedPeriod}
                  onChange={(e) => setSelectedPeriod(e.target.value)}
                >
                  <option value="month">This Month</option>
                  <option value="quarter">This Quarter</option>
                  <option value="year">This Year</option>
                </select>
              </div>
              <div className="filter-group">
                <label>Year</label>
                <select 
                  className="filter-select"
                  value={selectedYear}
                  onChange={(e) => setSelectedYear(e.target.value)}
                >
                  <option value="2024">2024</option>
                  <option value="2023">2023</option>
                  <option value="2022">2022</option>
                </select>
              </div>
            </div>

            {/* Revenue Summary Cards */}
            <div className="revenue-summary">
              <div className="summary-card">
                <div className="summary-icon">💰</div>
                <div className="summary-content">
                  <div className="summary-number">${revenueData.totalRevenue.toLocaleString()}</div>
                  <div className="summary-label">Total Revenue</div>
                  <span className={`summary-change ${revenueData.monthlyGrowth >= 0 ? 'positive' : 'negative'}`}>
                    {revenueData.monthlyGrowth >= 0 ? '+' : ''}{revenueData.monthlyGrowth}% vs last month
                  </span>
                </div>
              </div>

              <div className="summary-card">
                <div className="summary-icon">👥</div>
                <div className="summary-content">
                  <div className="summary-number">{revenueData.totalUsers.toLocaleString()}</div>
                  <div className="summary-label">Paying Users</div>
                  <span className={`summary-change ${revenueData.userGrowth >= 0 ? 'positive' : 'negative'}`}>
                    {revenueData.userGrowth >= 0 ? '+' : ''}{revenueData.userGrowth}% vs last month
                  </span>
                </div>
              </div>

              <div className="summary-card">
                <div className="summary-icon">📊</div>
                <div className="summary-content">
                  <div className="summary-number">${revenueData.avgRevenue}</div>
                  <div className="summary-label">Avg Revenue per User</div>
                  <span className={`summary-change ${revenueData.avgGrowth >= 0 ? 'positive' : 'negative'}`}>
                    {revenueData.avgGrowth >= 0 ? '+' : ''}{revenueData.avgGrowth}% vs last month
                  </span>
                </div>
              </div>

              <div className="summary-card">
                <div className="summary-icon">🎯</div>
                <div className="summary-content">
                  <div className="summary-number">{revenueData.conversionRate}%</div>
                  <div className="summary-label">Conversion Rate</div>
                  <span className={`summary-change ${revenueData.conversionChange >= 0 ? 'positive' : 'negative'}`}>
                    {revenueData.conversionChange >= 0 ? '+' : ''}{revenueData.conversionChange}% vs last month
                  </span>
                </div>
              </div>
            </div>

            {/* Monthly Revenue Chart */}
            <div className="simple-chart-container">
              <div className="chart-card">
                <div className="chart-header">
                  <h3>Monthly Revenue Trend</h3>
                  <div className="chart-actions">
                    <button className="export-btn">
                      📊 Export Chart
                    </button>
                  </div>
                </div>
                <div className="monthly-chart">
                  <div className="chart-y-axis">
                    {yAxisLabels.map((label, index) => (
                      <div key={index}>{label}</div>
                    ))}
                  </div>
                  <div className="chart-bars">
                    {monthlyRevenue.map((item, index) => (
                      <div key={index} className="monthly-bar-container">
                        <div 
                          className="monthly-bar"
                          style={{ 
                            height: `${(item.amount / maxRevenue) * 160}px` 
                          }}
                        >
                          <div className="monthly-value">
                            ${(item.amount / 1000).toFixed(0)}k
                          </div>
                        </div>
                        <div className="monthly-label">{item.month}</div>
                      </div>
                    ))}
                  </div>
                </div>
              </div>
            </div>

            {/* Simple Report Generation */}
            <div className="report-generation">
              <div className="report-card">
                <div className="report-header">
                  <h3>Generate Reports</h3>
                  <p>Download detailed revenue reports and analytics</p>
                </div>
                <div className="report-options">
                  <div className="report-option">
                    <div className="option-icon">📈</div>
                    <div className="option-content">
                      <h4>Monthly Revenue Report</h4>
                      <p>Detailed breakdown of monthly revenue and trends</p>
                      <button 
                        className="generate-btn"
                        onClick={() => handleGenerateReport('Monthly Revenue')}
                      >
                        Generate Report
                      </button>
                    </div>
                  </div>

                  <div className="report-option">
                    <div className="option-icon">📊</div>
                    <div className="option-content">
                      <h4>User Analytics Report</h4>
                      <p>User growth, conversion rates, and engagement metrics</p>
                      <button 
                        className="generate-btn"
                        onClick={() => handleGenerateReport('User Analytics')}
                      >
                        Generate Report
                      </button>
                    </div>
                  </div>

                  <div className="report-option">
                    <div className="option-icon">💼</div>
                    <div className="option-content">
                      <h4>Financial Summary</h4>
                      <p>Complete financial overview with key metrics</p>
                      <button 
                        className="generate-btn"
                        onClick={() => handleGenerateReport('Financial Summary')}
                      >
                        Generate Report
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <Footer />
    </div>
  );
};

export default Revenue;
