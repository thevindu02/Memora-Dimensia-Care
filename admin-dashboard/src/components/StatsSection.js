import React, { useState, useEffect } from 'react';
import StatCard from './StatCard';
import dashboardApiService from '../services/dashboardApiService';

const StatsSection = () => {
  const [statsData, setStatsData] = useState([
    { number: 0, label: 'Patients', icon: '👥' },
    { number: 0, label: 'Caregivers', icon: '👩‍⚕️' },
    { number: 0, label: 'Articles', icon: '📄' },
    { number: 0, label: 'Volunteers', icon: '🤝' }
  ]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchStats = async () => {
      try {
        setLoading(true);
        const stats = await dashboardApiService.getDashboardStats();
        
        // Update the stats data with real values
        setStatsData([
          { number: stats.patients || 0, label: 'Patients', icon: '👥' },
          { number: stats.caregivers || 0, label: 'Caregivers', icon: '👩‍⚕️' },
          { number: stats.articles || 0, label: 'Articles', icon: '📄' },
          { number: stats.volunteers || 0, label: 'Volunteers', icon: '🤝' }
        ]);
      } catch (error) {
        console.error('Error fetching dashboard stats:', error);
        // Keep default values if fetch fails
      } finally {
        setLoading(false);
      }
    };

    fetchStats();
  }, []);

  if (loading) {
    return (
      <div className="stats-section">
        <div style={{ textAlign: 'center', padding: '2rem', color: '#666' }}>
          Loading statistics...
        </div>
      </div>
    );
  }

  return (
    <div className="stats-section">
      {statsData.map((stat, index) => (
        <StatCard 
          key={index} 
          number={stat.number} 
          label={stat.label}
          icon={stat.icon}
        />
      ))}
    </div>
  );
};

export default StatsSection;
