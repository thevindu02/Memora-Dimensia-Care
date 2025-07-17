import React from 'react';

const WelcomeSection = ({ userName = "Jhon" }) => {
  return (
    <div className="welcome-section">
      <h1>Welcome back {userName}!</h1>
      <p>Manage your health care platform easily</p>
    </div>
  );
};

export default WelcomeSection;
