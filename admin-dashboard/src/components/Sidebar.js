import React from 'react';
import { useNavigate } from 'react-router-dom';
import memoraLogo from '../assets/memora.png';

const Sidebar = ({ currentPage = 'dashboard' }) => {
  const navigate = useNavigate();

  const handleNavigation = (page) => {
    if (page === 'patients') {
      navigate('/patients');
    } else if (page === 'dashboard') {
      navigate('/');
    } else if (page === 'caregiver') {
      navigate('/caregiver');
    } else if (page === 'volunteer') {
      navigate('/volunteer');
    // } else if (page === 'blogpost') {
    //   navigate('/blogpost');
    } else if (page === 'revenue') {
      navigate('/revenue');
    } else if (page === 'usage-report') {
      navigate('/usage-report');
    } else if (page === 'volunteer-engagement') {
      navigate('/volunteer-engagement');
    } else if (page === 'subscription-report') {
      navigate('/subscription-report');
    } else if (page === 'articles') {
      navigate('/articles');
    // } else if (page === 'video-lessons') {
    //   navigate('/video-lessons');
    } else if (page === 'subscription-planning') {
      navigate('/subscription-planning');
    }
  };

  return (
    <div className="sidebar">
      {/* Static Header - Logo Section */}
      <div className="sidebar-header">
        <div className="sidebar-logo">
          <img src={memoraLogo} alt="Memora Logo" className="logo-image" />
          <span className="logo-text">Memora</span>
        </div>
      </div>
      
      {/* Scrollable Navigation Section */}
      <div className="sidebar-nav-container">
        <div className="sidebar-nav">
          <div className="sidebar-section">
            <h3>Main</h3>
            <ul>
              <li 
                className={currentPage === 'dashboard' ? 'active' : ''}
                onClick={() => handleNavigation('dashboard')}
              >
                <span className="sidebar-icon">🏠</span>
                Dashboard
              </li>
            </ul>
          </div>
          
          <div className="sidebar-section">
            <h3>User Management</h3>
            <ul>
              <li 
                className={currentPage === 'patients' ? 'active' : ''}
                onClick={() => handleNavigation('patients')}
              >
                <span className="sidebar-icon">👥</span>
                Patients
              </li>
              <li 
                className={currentPage === 'caregiver' ? 'active' : ''}
                onClick={() => handleNavigation('caregiver')}
              >
                <span className="sidebar-icon">👩‍⚕️</span>
                Caregiver
              </li>
              <li 
                className={currentPage === 'volunteer' ? 'active' : ''}
                onClick={() => handleNavigation('volunteer')}
              >
                <span className="sidebar-icon">🤝</span>
                Volunteer
              </li>
            </ul>
          </div>
          
          <div className="sidebar-section">
            <h3>Content Management</h3>
            <ul>
              {/* <li 
                className={currentPage === 'blogpost' ? 'active' : ''}
                onClick={() => handleNavigation('blogpost')}
              >
                <span className="sidebar-icon">📝</span>
                Blog Posts
              </li> */}
              <li 
                className={currentPage === 'articles' ? 'active' : ''}
                onClick={() => handleNavigation('articles')}
              >
                <span className="sidebar-icon">📄</span>
                Articles
              </li>
              {/* <li 
                className={currentPage === 'video-lessons' ? 'active' : ''}
                onClick={() => handleNavigation('video-lessons')}
              >
                <span className="sidebar-icon">🎬</span>
                Video Lessons
              </li> */}
            </ul>
          </div>

          <div className="sidebar-section">
            <h3>Business Management</h3>
            <ul>
              <li 
                className={currentPage === 'subscription-planning' ? 'active' : ''}
                onClick={() => handleNavigation('subscription-planning')}
              >
                <span className="sidebar-icon">💳</span>
                Subscription Planning
              </li>
            </ul>
          </div>
          
          <div className="sidebar-section">
            <h3>Reports & Analysis</h3>
            <ul>
              <li 
                className={currentPage === 'revenue' ? 'active' : ''}
                onClick={() => handleNavigation('revenue')}
              >
                <span className="sidebar-icon">💰</span>
                Revenue Analytics
              </li>
              <li 
                className={currentPage === 'usage-report' ? 'active' : ''}
                onClick={() => handleNavigation('usage-report')}
              >
                <span className="sidebar-icon">📊</span>
                Usage Report
              </li>
              <li 
                className={currentPage === 'volunteer-engagement' ? 'active' : ''}
                onClick={() => handleNavigation('volunteer-engagement')}
              >
                <span className="sidebar-icon">📈</span>
                Volunteer Engagement
              </li>
              <li 
                className={currentPage === 'subscription-report' ? 'active' : ''}
                onClick={() => handleNavigation('subscription-report')}
              >
                <span className="sidebar-icon">�</span>
                Subscription Report
              </li>
            </ul>
          </div>
        </div>
      </div>
      
      {/* Static Footer - User Section */}
      <div className="sidebar-footer">
        <div className="sidebar-user">
          <div className="user-avatar">PW</div>
          <div className="user-details">
            <div className="user-name">Priyantha Wickramasinghe</div>
            <div className="user-role">Administrator</div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Sidebar;
