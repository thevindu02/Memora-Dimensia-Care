import React from 'react';
import '../styles/Charts.css';

const Charts = () => {
  // More realistic and human-like mock data
  const monthlyRevenue = [
    { month: 'Jan', amount: 12500 },
    { month: 'Feb', amount: 15200 },
    { month: 'Mar', amount: 18700 },
    { month: 'Apr', amount: 16900 },
    { month: 'May', amount: 22100 },
    { month: 'Jun', amount: 19800 }
  ];

  const appUsage = [
    { type: 'Patients', count: 387, color: '#4F46E5', percentage: 61 },
    { type: 'Caregivers', count: 142, color: '#059669', percentage: 22 },
    { type: 'Guardians', count: 89, color: '#DC2626', percentage: 14 },
    { type: 'Volunteers', count: 18, color: '#7C3AED', percentage: 3 }
  ];

  const emergencyAlerts = [
    { day: '3', alerts: 2 },
    { day: '7', alerts: 1 },
    { day: '11', alerts: 3 },
    { day: '14', alerts: 1 },
    { day: '18', alerts: 4 },
    { day: '21', alerts: 2 },
    { day: '24', alerts: 1 },
    { day: '27', alerts: 3 },
    { day: '30', alerts: 2 }
  ];

  const maxAlerts = Math.max(...emergencyAlerts.map(item => item.alerts));
  const totalUsage = appUsage.reduce((sum, item) => sum + item.count, 0);
  
  // Fixed scale to match Y-axis labels (25K max)
  const yAxisMax = 25000;

  return (
    <div className="charts-section">
      {/* Revenue Chart */}
      <div className="chart-card">
        <div className="chart-header">
          <h3>Monthly Revenue</h3>
          <span className="chart-period">Last 6 months</span>
        </div>
        <div className="revenue-chart">
          <div className="chart-y-axis">
            <span>$25K</span>
            <span>$20K</span>
            <span>$15K</span>
            <span>$10K</span>
            <span>$5K</span>
            <span>$0</span>
          </div>
          <div className="chart-bars">
            {monthlyRevenue.map((item, index) => (
              <div key={index} className="bar-container">
                <div 
                  className="revenue-bar"
                  style={{ 
                    height: `${(item.amount / yAxisMax) * 180}px`,
                    backgroundColor: index % 2 === 0 ? '#4F46E5' : '#059669'
                  }}
                >
                  <div className="bar-value">${(item.amount / 1000).toFixed(1)}K</div>
                </div>
                <span className="bar-label">{item.month}</span>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* App Usage Chart */}
      <div className="chart-card">
        <div className="chart-header">
          <h3>Mobile App Usage</h3>
          <span className="chart-period">This month</span>
        </div>
        <div className="usage-chart">
          <div className="pie-chart">
            <div className="pie-center">
              <span className="total-users">{totalUsage}</span>
              <span className="total-label">Active Users</span>
            </div>
          </div>
          <div className="usage-legend">
            {appUsage.map((item, index) => (
              <div key={index} className="legend-item">
                <div 
                  className="legend-color"
                  style={{ backgroundColor: item.color }}
                ></div>
                <div className="legend-info">
                  <span className="legend-type">{item.type}</span>
                  <span className="legend-count">{item.count}</span>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Emergency Alerts Chart */}
      <div className="chart-card emergency-chart">
        <div className="chart-header">
          <h3>Emergency Alerts</h3>
          <span className="chart-period">This month</span>
        </div>
        <div className="alerts-chart">
          <div className="chart-y-axis">
            <span>4</span>
            <span>3</span>
            <span>2</span>
            <span>1</span>
            <span>0</span>
          </div>
          <div className="alerts-line-chart">
            {emergencyAlerts.map((item, index) => (
              <div key={index} className="alert-point">
                <div 
                  className="alert-bar"
                  style={{ height: `${(item.alerts / maxAlerts) * 100}%` }}
                >
                  <div className="alert-value">{item.alerts}</div>
                </div>
                <span className="alert-day">Day {item.day}</span>
              </div>
            ))}
          </div>
        </div>
        <div className="alert-summary">
          <div className="alert-stat">
            <span className="alert-number">19</span>
            <span className="alert-label">Total Alerts</span>
          </div>
          <div className="alert-stat">
            <span className="alert-number">1.8</span>
            <span className="alert-label">Avg/Day</span>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Charts;
