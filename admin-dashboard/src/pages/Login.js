import React, { useState, useEffect } from 'react';
import '../styles/Login.css';
import SessionManager from '../utils/SessionManager';

const Login = () => {
  const [credentials, setCredentials] = useState({
    username: '',
    password: ''
  });
  const [error, setError] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  useEffect(() => {
    // Clear any existing session
    SessionManager.terminateSession();
    
    // Prevent back button navigation
    const preventBack = () => {
      window.history.pushState(null, null, window.location.pathname);
    };
    
    window.history.pushState(null, null, window.location.pathname);
    window.addEventListener('popstate', preventBack);
    
    return () => {
      window.removeEventListener('popstate', preventBack);
    };
  }, []);

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setCredentials(prev => ({
      ...prev,
      [name]: value
    }));
    setError('');
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    
    if (!credentials.username || !credentials.password) {
      setError('Please fill in all fields');
      return;
    }

    setIsLoading(true);

    // Simple login check
    setTimeout(() => {
      if (credentials.username === 'admin' && credentials.password === 'admin123') {
        // Start session
        SessionManager.startSession();
        window.location.href = '/';
      } else {
        setError('Invalid username or password');
      }
      setIsLoading(false);
    }, 800);
  };

  return (
    <div className="login-page">
      <div className="login-container">
        <div className="login-box">
          <h1>Admin Login</h1>
          <p>Please sign in to continue</p>

          <form onSubmit={handleSubmit}>
            <div className="input-group">
              <label>Username</label>
              <input
                type="text"
                name="username"
                value={credentials.username}
                onChange={handleInputChange}
                placeholder="Enter username"
                required
              />
            </div>

            <div className="input-group">
              <label>Password</label>
              <input
                type="password"
                name="password"
                value={credentials.password}
                onChange={handleInputChange}
                placeholder="Enter password"
                required
              />
            </div>

            {error && <div className="error">{error}</div>}

            <button type="submit" disabled={isLoading} className="login-btn">
              {isLoading ? 'Signing in...' : 'Sign In'}
            </button>
          </form>

          <div className="demo-info">
            <small>Demo: admin / admin123</small>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Login;
