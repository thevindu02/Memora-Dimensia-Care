// Authentication service for web portal
import CONFIG from '../config/api';

class AuthService {
  // Login user
  static async login(email, password) {
    try {
      const response = await fetch(`${CONFIG.API_BASE_URL}${CONFIG.ENDPOINTS.AUTH}/login`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          email: email,
          password: password,
        }),
      });

      if (response.ok) {
        const data = await response.json();
        
        // Store user data and token in localStorage
        const userData = {
          id: data.id,
          email: data.email,
          firstName: data.fName,
          lastName: data.lName,
          role: data.role,
          token: data.token || data.accessToken,
        };
        
        localStorage.setItem('user', JSON.stringify(userData));
        localStorage.setItem('token', userData.token);
        localStorage.setItem('userRole', userData.role);
        
        return {
          success: true,
          user: userData,
          message: 'Login successful',
        };
      } else {
        const errorData = await response.json();
        return {
          success: false,
          message: errorData.message || 'Invalid email or password',
        };
      }
    } catch (error) {
      return {
        success: false,
        message: `Login error: ${error.message}`,
      };
    }
  }

  // Logout user
  static logout() {
    localStorage.removeItem('user');
    localStorage.removeItem('token');
    localStorage.removeItem('userRole');
    return {
      success: true,
      message: 'Logged out successfully',
    };
  }

  // Get current user from localStorage
  static getCurrentUser() {
    try {
      const userData = localStorage.getItem('user');
      return userData ? JSON.parse(userData) : null;
    } catch (error) {
      return null;
    }
  }

  // Check if user is logged in
  static isLoggedIn() {
    const user = this.getCurrentUser();
    const token = localStorage.getItem('token');
    return !!(user && token);
  }

  // Check if user has volunteer role
  static isVolunteer() {
    const user = this.getCurrentUser();
    return user && user.role && user.role.toLowerCase() === 'volunteer';
  }

  // Get authorization header for API requests
  static getAuthHeader() {
    const token = localStorage.getItem('token');
    return token ? { 'Authorization': `Bearer ${token}` } : {};
  }

  // Validate token (check if still valid)
  static async validateToken() {
    try {
      const token = localStorage.getItem('token');
      if (!token) return false;

      const response = await fetch(`${CONFIG.API_BASE_URL}${CONFIG.ENDPOINTS.AUTH}/validate`, {
        method: 'GET',
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json',
        },
      });

      return response.ok;
    } catch (error) {
      return false;
    }
  }

  // Password reset request
  static async requestPasswordReset(email) {
    try {
      const response = await fetch(`${CONFIG.API_BASE_URL}${CONFIG.ENDPOINTS.AUTH}/forgot-password`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ email }),
      });

      if (response.ok) {
        return {
          success: true,
          message: 'Password reset instructions sent to your email',
        };
      } else {
        const errorData = await response.json();
        return {
          success: false,
          message: errorData.message || 'Failed to send password reset email',
        };
      }
    } catch (error) {
      return {
        success: false,
        message: `Password reset error: ${error.message}`,
      };
    }
  }
}

export default AuthService;
