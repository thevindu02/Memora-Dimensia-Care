// Session management utility
class SessionManager {
  constructor() {
    this.SESSION_KEY = 'adminSession';
    this.TIMEOUT_KEY = 'sessionTimeout';
    this.SESSION_DURATION = 30 * 60 * 1000; // 30 minutes
  }

  // Start a new session
  startSession() {
    const sessionData = {
      isLoggedIn: true,
      loginTime: Date.now(),
      lastActivity: Date.now()
    };
    
    localStorage.setItem(this.SESSION_KEY, JSON.stringify(sessionData));
    this.setSessionTimeout();
  }

  // Check if session is valid
  isSessionValid() {
    const sessionData = this.getSessionData();
    
    if (!sessionData || !sessionData.isLoggedIn) {
      return false;
    }

    const currentTime = Date.now();
    const timeSinceLastActivity = currentTime - sessionData.lastActivity;

    // Check if session has expired
    if (timeSinceLastActivity > this.SESSION_DURATION) {
      this.terminateSession();
      return false;
    }

    return true;
  }

  // Update last activity time
  updateActivity() {
    const sessionData = this.getSessionData();
    if (sessionData && sessionData.isLoggedIn) {
      sessionData.lastActivity = Date.now();
      localStorage.setItem(this.SESSION_KEY, JSON.stringify(sessionData));
    }
  }

  // Get session data
  getSessionData() {
    try {
      const data = localStorage.getItem(this.SESSION_KEY);
      return data ? JSON.parse(data) : null;
    } catch {
      return null;
    }
  }

  // Terminate session
  terminateSession() {
    localStorage.removeItem(this.SESSION_KEY);
    localStorage.removeItem(this.TIMEOUT_KEY);
    this.clearSessionTimeout();
  }

  // Set session timeout
  setSessionTimeout() {
    this.clearSessionTimeout();
    
    const timeoutId = setTimeout(() => {
      this.terminateSession();
      window.location.href = '/login';
      alert('Session expired. Please login again.');
    }, this.SESSION_DURATION);

    localStorage.setItem(this.TIMEOUT_KEY, timeoutId.toString());
  }

  // Clear session timeout
  clearSessionTimeout() {
    const timeoutId = localStorage.getItem(this.TIMEOUT_KEY);
    if (timeoutId) {
      clearTimeout(parseInt(timeoutId));
      localStorage.removeItem(this.TIMEOUT_KEY);
    }
  }
}

const sessionManager = new SessionManager();
export default sessionManager;
