import React, { useState, useEffect } from 'react';
import '../styles/Dashboard.css';
import {
  Header,
  Sidebar,
  Calendar,
  StatsSection,
  Charts,
  Footer
} from '../components';
import { getDateBasedStats } from '../services/dateService';

const Dashboard = () => {
  const [selectedDate, setSelectedDate] = useState(new Date());
  const [statsData, setStatsData] = useState([]);

  useEffect(() => {
    // Load stats for the initially selected date (today)
    const stats = getDateBasedStats(selectedDate);
    setStatsData(stats);
  }, [selectedDate]);

  const handleDateSelect = (date) => {
    setSelectedDate(date);
    const stats = getDateBasedStats(date);
    setStatsData(stats);
  };

  return (
    <div className="dashboard">
      <Sidebar currentPage="dashboard" />
      
      <div className="main-content">
        <Header pageTitle="Dashboard" />
        
        <div className="content">
          <div className="dashboard-top">
            <div className="calendar-section">
              <Calendar onDateSelect={handleDateSelect} />
            </div>
            <div className="stats-container">
              <StatsSection statsData={statsData} />
            </div>
          </div>
          
          <Charts />
        </div>
        
        <Footer />
      </div>
    </div>
  );
};

export default Dashboard;
