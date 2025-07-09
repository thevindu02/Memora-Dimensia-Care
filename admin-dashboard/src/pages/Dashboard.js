import React from 'react';
import '../styles/Dashboard.css';
import {
  Header,
  Sidebar,
  Calendar,
  StatsSection,
  Charts,
  Footer
} from '../components';

const Dashboard = () => {
  return (
    <div className="dashboard">
      <Sidebar currentPage="dashboard" />
      
      <div className="main-content">
        <Header pageTitle="Dashboard" />
        
        <div className="content">
          <div className="dashboard-top">
            <div className="calendar-section">
              <Calendar />
            </div>
            <div className="stats-container">
              <StatsSection />
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
