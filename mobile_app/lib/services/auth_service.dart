import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../routes/app_routes.dart';

class AuthService {
  static const String _userKey = 'current_user';
  static const String _roleKey = 'user_role';
  static const String _tokenKey = 'auth_token';

  static const String baseUrl = 'http://172.20.10.10:8080/api/auth';

  static String? currentUserRole;
  static bool isLoggedIn = false;

  // Check if user is authenticated and get initial route
  static Future<String> getInitialRoute() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString(_tokenKey);
      String? role = prefs.getString(_roleKey);

      if (token != null && role != null) {
        // Verify token is still valid
        bool isValid = await _verifyToken(token);
        if (isValid) {
          // User is logged in, set current user data
          currentUserRole = role;
          isLoggedIn = true;

          // Return appropriate dashboard based on role
          return getDashboardRoute(role);
        } else {
          // Token expired or invalid, clear session
          await logout();
          return AppRoutes.login;
        }
      } else {
        // User not logged in, go to login
        return AppRoutes.login;
      }
    } catch (e) {
      // Error reading preferences, default to login
      return AppRoutes.login;
    }
  }

  // Authenticate user with email and password
  static Future<AuthResult> authenticateUser(String email, String password) async {
    try {
      // Prepare request body
      final requestBody = {
        'email': email,
        'password': password,
      };

      // Make HTTP request to backend
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      // Debug logging
      print('Login Response Status: ${response.statusCode}');
      print('Login Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Parse response
        final responseData = jsonDecode(response.body);

        // Extract user data from the actual backend response structure
        final String token = responseData['accessToken'];
        final String role = responseData['role'];
        final Map<String, dynamic> userData = {
          'id': responseData['id'],
          'email': responseData['email'],
          'fName': responseData['fname'],
          'lName': responseData['lname'],
          'role': responseData['role'],
        };

        // Save session data
        await login(role, token: token, userData: userData);

        return AuthResult(
          success: true,
          role: role,
          dashboardRoute: getDashboardRoute(role),
          message: 'Login successful',
          userData: userData,
        );
      } else if (response.statusCode == 400) {
        // Invalid credentials (backend returns 400 for invalid credentials)
        final responseData = jsonDecode(response.body);
        return AuthResult(
          success: false,
          message: responseData['message'] ?? 'Invalid email or password',
        );
      } else if (response.statusCode == 401) {
        // Unauthorized
        final responseData = jsonDecode(response.body);
        return AuthResult(
          success: false,
          message: responseData['message'] ?? 'Unauthorized access',
        );
      } else if (response.statusCode == 404) {
        // User not found
        return AuthResult(
          success: false,
          message: 'User not found',
        );
      } else {
        // Other errors
        final responseData = jsonDecode(response.body);
        return AuthResult(
          success: false,
          message: responseData['message'] ?? 'Login failed (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      // Network or other errors
      return AuthResult(
        success: false,
        message: 'Network error. Please check your connection and try again.',
      );
    }
  }

  // Verify if token is still valid
  static Future<bool> _verifyToken(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/verify'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Get dashboard route based on user role
  static String getDashboardRoute(String role) {
    switch (role.toLowerCase()) {
      case 'patient':
        return AppRoutes.patientDashboard;
      case 'guardian':
        return AppRoutes.guardianDashboard;
      case 'caregiver':
        return AppRoutes.caregiverDashboard;
      case 'volunteer':
        return AppRoutes.volunteerDashboard;
      default:
        return AppRoutes.login;
    }
  }

  // Login user and save session
  static Future<void> login(String role, {String? token, Map<String, dynamic>? userData}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Save user session data
      await prefs.setString(_roleKey, role);
      await prefs.setString(_tokenKey, token ?? 'dummy_token_${DateTime.now().millisecondsSinceEpoch}');

      if (userData != null) {
        await prefs.setString(_userKey, jsonEncode(userData));
      }

      // Update current state
      currentUserRole = role;
      isLoggedIn = true;
    } catch (e) {
      throw Exception('Failed to save user session: $e');
    }
  }

  // Logout user and clear session
  static Future<void> logout() async {
    try {
      // Call logout endpoint if token exists (optional - server may not have this endpoint)
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString(_tokenKey);

      if (token != null) {
        try {
          final response = await http.post(
            Uri.parse('$baseUrl/logout'),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          );
          // Logout endpoint called successfully (optional)
        } catch (e) {
          // Server logout failed or endpoint doesn't exist - continue with local logout
          print('Server logout failed (this is normal if endpoint not implemented): $e');
        }
      }

      // Clear all user data (this is the important part)
      await prefs.remove(_userKey);
      await prefs.remove(_roleKey);
      await prefs.remove(_tokenKey);

      // Update current state
      currentUserRole = null;
      isLoggedIn = false;
    } catch (e) {
      throw Exception('Failed to clear user session: $e');
    }
  }

  // Get current user data
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userData = prefs.getString(_userKey);

      if (userData != null) {
        return jsonDecode(userData);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Check user permissions
  static bool isPatient() => currentUserRole?.toLowerCase() == 'patient';
  static bool isGuardian() => currentUserRole?.toLowerCase() == 'guardian';
  static bool isCaregiver() => currentUserRole?.toLowerCase() == 'caregiver';
  static bool isVolunteer() => currentUserRole?.toLowerCase() == 'volunteer';

  // Check if user has permission for specific route
  static bool hasPermission(String route) {
    if (!isLoggedIn) return false;

    if (route.startsWith('/patient/')) {
      return isPatient();
    } else if (route.startsWith('/guardian/')) {
      return isGuardian() || isPatient(); // Admin can access manager routes
    } else if (route.startsWith('/caregiver/')) {
      return isCaregiver() || isPatient(); // Higher roles can access user routes
    } else if (route.startsWith('/volunteer/')) {
      return isVolunteer();
    }

    return true; // Public routes
  }

  // Refresh user token
  static Future<bool> refreshToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? currentToken = prefs.getString(_tokenKey);

      if (currentToken == null) return false;

      final response = await http.post(
        Uri.parse('$baseUrl/refresh'),
        headers: {
          'Authorization': 'Bearer $currentToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final String newToken = responseData['token'];

        // Update stored token
        await prefs.setString(_tokenKey, newToken);
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }
  static Future<ForgotPasswordResult> sendPasswordResetEmail(String email) async {
    try {
      // Prepare request body
      final requestBody = {
        'email': email,
      };

      // Make HTTP request to backend
      final response = await http.post(
        Uri.parse('$baseUrl/forgot-password'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      // Handle different response status codes
      if (response.statusCode == 200) {
        // Success - email sent
        final responseData = jsonDecode(response.body);
        return ForgotPasswordResult(
          success: true,
          message: responseData['message'] ?? 'Password reset link sent to your email',
        );
      } else if (response.statusCode == 400) {
        // Bad request (user not found or other validation errors)
        final responseData = jsonDecode(response.body);
        return ForgotPasswordResult(
          success: false,
          message: responseData['message'] ?? 'No account found with this email address',
        );
      } else {
        // Other server errors
        try {
          final responseData = jsonDecode(response.body);
          return ForgotPasswordResult(
            success: false,
            message: responseData['message'] ?? 'Failed to send reset email',
          );
        } catch (e) {
          return ForgotPasswordResult(
            success: false,
            message: 'Server error occurred. Please try again later',
          );
        }
      }
    } on http.ClientException {
      // Network connectivity issues
      return ForgotPasswordResult(
        success: false,
        message: 'Network error. Please check your internet connection',
      );
    } on FormatException {
      // JSON parsing errors
      return ForgotPasswordResult(
        success: false,
        message: 'Invalid response from server',
      );
    } catch (e) {
      // Any other unexpected errors
      return ForgotPasswordResult(
        success: false,
        message: 'An unexpected error occurred. Please try again',
      );
    }
  }
}

// Authentication result class
class AuthResult {
  final bool success;
  final String? role;
  final String? dashboardRoute;
  final String message;
  final Map<String, dynamic>? userData;

  AuthResult({
    required this.success,
    this.role,
    this.dashboardRoute,
    required this.message,
    this.userData,
  });
}

class ForgotPasswordResult {
  final bool success;
  final String message;

  ForgotPasswordResult({
    required this.success,
    required this.message,
  });
}
