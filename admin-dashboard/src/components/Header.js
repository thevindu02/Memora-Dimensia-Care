import React from 'react';

const Header = ({ pageTitle = "Dashboard" }) => {
  return (
    <div className="header">
      <div className="header-left">
        <span className="page-title">{pageTitle}</span>
      </div>
      <div className="header-right">
        <div className="notification-icon">🔔</div>
        <div className="header-user">
          <div className="user-avatar">JD</div>
        </div>
      </div>
    </div>
  );
};

export default Header;
