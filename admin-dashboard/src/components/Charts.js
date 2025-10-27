import React, { useState, useEffect } from 'react';
import '../styles/Charts.css';
import dashboardApiService from '../services/dashboardApiService';

const Charts = () => {
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [monthlyRevenue, setMonthlyRevenue] = useState([]);
  const [appUsage, setAppUsage] = useState([]);

  // Fetch data on component mount
  useEffect(() => {
    const fetchChartData = async () => {
      try {
        setLoading(true);
        setError('');
        
        const chartData = await dashboardApiService.getDashboardChartData();
        
        // Process monthly revenue data
        const revenueData = dashboardApiService.convertMonthlyRevenueToChart(chartData.monthlyRevenue);
        setMonthlyRevenue(revenueData);
        
        // Process app usage data
        const usageData = [
          { type: 'Patients', count: chartData.appUsage.patients, color: '#390797' },
          { type: 'Caregivers', count: chartData.appUsage.caregivers, color: '#2B3F99' },
          { type: 'Volunteers', count: chartData.appUsage.volunteers, color: '#A0C4FD' }
        ];
        
        // Calculate percentages
        const total = chartData.appUsage.totalActive || 1; // Avoid division by zero
        const usageWithPercentages = usageData.map(item => ({
          ...item,
          percentage: total > 0 ? Math.round((item.count / total) * 100) : 0
        }));
        
        setAppUsage(usageWithPercentages);
        
        console.log('Chart data loaded:', { revenueData, usageWithPercentages });
      } catch (err) {
        console.error('Error fetching chart data:', err);
        setError('Failed to load chart data. Please try again.');
        
        // Set fallback data
        setMonthlyRevenue([
          { month: 'Jan', amount: 0 },
          { month: 'Feb', amount: 0 },
          { month: 'Mar', amount: 0 },
          { month: 'Apr', amount: 0 },
          { month: 'May', amount: 0 },
          { month: 'Jun', amount: 0 }
        ]);
        setAppUsage([
          { type: 'Patients', count: 0, color: '#390797', percentage: 0 },
          { type: 'Caregivers', count: 0, color: '#2B3F99', percentage: 0 },
          { type: 'Volunteers', count: 0, color: '#A0C4FD', percentage: 0 }
        ]);
      } finally {
        setLoading(false);
      }
    };

    fetchChartData();
  }, []);

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
  
  // Dynamic scale based on max revenue value
  const maxRevenue = Math.max(...monthlyRevenue.map(item => item.amount), 50000);
  const yAxisMax = Math.ceil(maxRevenue / 10000) * 10000; // Round up to nearest 10K

  // Loading state
  if (loading) {
    return (
      <div className="charts-section">
        <div className="chart-card">
          <div className="chart-loading">Loading charts...</div>
        </div>
        <div className="chart-card">
          <div className="chart-loading">Loading charts...</div>
        </div>
      </div>
    );
  }

  // Error state
  if (error) {
    return (
      <div className="charts-section">
        <div className="chart-card">
          <div className="chart-error">
            <p>⚠️ {error}</p>
            <button onClick={() => window.location.reload()}>Retry</button>
          </div>
        </div>
        <div className="chart-card">
          <div className="chart-error">
            <p>⚠️ {error}</p>
            <button onClick={() => window.location.reload()}>Retry</button>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="charts-section">
      {/* Revenue Chart */}
      <div className="chart-card">
        <div className="chart-header">
          <h3>Monthly Revenue</h3>
          <span className="chart-period">Last 6 months (Real Data)</span>
        </div>
        <div className="revenue-chart">
          <div className="chart-y-axis">
            <span>LKR {Math.round(yAxisMax / 1000)}K</span>
            <span>LKR {Math.round((yAxisMax * 0.8) / 1000)}K</span>
            <span>LKR {Math.round((yAxisMax * 0.6) / 1000)}K</span>
            <span>LKR {Math.round((yAxisMax * 0.4) / 1000)}K</span>
            <span>LKR {Math.round((yAxisMax * 0.2) / 1000)}K</span>
            <span>LKR 0</span>
          </div>
          <div className="chart-bars">
            {monthlyRevenue.map((item, index) => (
              <div key={index} className="bar-container">
                <div 
                  className="revenue-bar"
                  style={{ 
                    height: `${(item.amount / yAxisMax) * 180}px`,
                    backgroundColor: index % 4 === 0 ? '#390797' : 
                                   index % 4 === 1 ? '#2B3F99' : 
                                   index % 4 === 2 ? '#A0C4FD' : '#C3B1E1'
                  }}
                >
                  <div className="bar-value">
                    {item.amount > 0 ? `LKR ${(item.amount / 1000).toFixed(0)}K` : 'LKR 0'}
                  </div>
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
          <span className="chart-period">Active Users (Real Data)</span>
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
                  <span className="legend-count">
                    {item.count} ({item.percentage}%)
                  </span>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Emergency Alerts Chart */}

    </div>
  );
};

export default Charts;