import React from 'react';
import StatCard from './StatCard';

const StatsSection = () => {
  const statsData = [
    { number: 8, label: 'Patients', icon: '👥' },
    { number: 2, label: 'Caregivers', icon: '👩‍⚕️' },
    { number: 5, label: 'Volunteers', icon: '🤝' },
    { number: 6, label: 'Blog Posts', icon: '📝' },
    { number: 8, label: 'Articles', icon: '📄' },
    { number: 8, label: 'Videos', icon: '🎬' }
  ];
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
