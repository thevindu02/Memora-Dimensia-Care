import React from 'react';
import StatCard from './StatCard';

const StatsSection = ({ statsData }) => {
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
