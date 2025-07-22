import React, { useState } from 'react';
import SessionManager from '../utils/SessionManager';

const Header = ({ pageTitle = "Dashboard" }) => {
  const [showDropdown, setShowDropdown] = useState(false);

  const toggleDropdown = () => {
    setShowDropdown(!showDropdown);
  };

  const handleMyAccount = () => {
    setShowDropdown(false);
    window.location.href = '/my-account';
  };

  const handleLogout = () => {
    setShowDropdown(false);
    if (window.confirm('Are you sure you want to logout?')) {
      // Terminate session
      SessionManager.terminateSession();
      
      // Clear browser history and redirect
      window.history.replaceState(null, null, '/login');
      window.location.href = '/login';
    }
  };

  return (
    <div className="header">
      <div className="header-left">
        <span className="page-title">{pageTitle}</span>
      </div>
      <div className="header-right">
        <div className="notification-icon">🔔</div>
        <div className="header-user">
          <div className="user-info" onClick={toggleDropdown}>
            <span className="user-name">Admin</span>
            <div className="user-avatar">A</div>
          </div>
          {showDropdown && (
            <div className="user-dropdown">
              <div className="dropdown-item" onClick={handleMyAccount}>
                <span>👤 My Account</span>
              </div>
              <div className="dropdown-item" onClick={handleLogout}>
                <span>🚪 Logout</span>
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default Header;
