import React, { useEffect, useState } from 'react';
import SessionManager from '../utils/SessionManager';

const AuthWrapper = ({ children }) => {
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [isChecking, setIsChecking] = useState(true);

  useEffect(() => {
    // Check authentication on mount
    const checkAuth = () => {
      const isValid = SessionManager.isSessionValid();
      
      if (!isValid) {
        window.location.href = '/login';
        return;
      }
      
      setIsAuthenticated(true);
      setIsChecking(false);
      
      // Update activity
      SessionManager.updateActivity();
    };

    checkAuth();

    // Set up activity tracking
    const trackActivity = () => {
      SessionManager.updateActivity();
    };

    // Track user activity
    const events = ['mousedown', 'mousemove', 'keypress', 'scroll', 'touchstart', 'click'];
    events.forEach(event => {
      document.addEventListener(event, trackActivity, true);
    });

    // Check session validity every minute
    const intervalId = setInterval(() => {
      if (!SessionManager.isSessionValid()) {
        window.location.href = '/login';
      }
    }, 60000);

    return () => {
      // Cleanup
      events.forEach(event => {
        document.removeEventListener(event, trackActivity, true);
      });
      clearInterval(intervalId);
    };
  }, []);

  // Show loading while checking authentication
  if (isChecking) {
    return (
      <div style={{
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
        minHeight: '100vh',
        backgroundColor: '#f5f5f5'
      }}>
        <div>Loading...</div>
      </div>
    );
  }

  // Render children if authenticated
  return isAuthenticated ? children : null;
};

export default AuthWrapper;
