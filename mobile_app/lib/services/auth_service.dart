import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'guardian_service.dart';
import '../routes/app_routes.dart';
import 'api_constants.dart';
import '../services/caregiver_service.dart'; // Added import for CaregiverService
import 'fcm_notification_service.dart'; // Added for FCM token registration

class AuthService {
  static const String _userKey = 'current_user';
  static const String _roleKey = 'user_role';
  static const String _tokenKey = 'auth_token';


  static const String baseUrl = 'http://192.168.8.100:8080/api/auth';

  static int? currentUserId; // Set this after login
  static int? currentCaregiverId; // Store caregiverId for caregivers

  static final String url = "${ApiConstants.baseUrl}/api/auth";

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
  static Future<AuthResult> authenticateUser(
    String email,
    String password,
  ) async {
    try {
      // Prepare request body
      final requestBody = {'email': email, 'password': password};

      // Make HTTP request to backend
      final response = await http.post(
        Uri.parse('$url/login'),
        headers: {'Content-Type': 'application/json'},
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
        final int id = responseData['id'];
        final int? guardianId = responseData['guardianId']; // may be null
        final Map<String, dynamic> userData = {
          'id': id,
          'email': responseData['email'],
          'fName': responseData['fname'],
          'lName': responseData['lname'],
          'role': responseData['role'],
        };

        // Save session data
        await login(role, token: token, userData: userData);
        currentUserId = id; // <-- Set currentUserId after login

        // Save userId to SharedPreferences for FCM token registration
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('userId', id);

        // Register FCM token after successful login
        try {
          await FCMNotificationService().sendTokenToBackendOnLogin();
          print('✅ FCM token sent to backend after login');
        } catch (e) {
          print('⚠️  Failed to send FCM token after login: $e');
        }

        // If caregiver, fetch and store caregiverId
        if (role.toLowerCase() == 'caregiver') {
          final caregiverId = await CaregiverService.getCaregiverIdByUserId(id);
          if (caregiverId != null) {
            currentCaregiverId = caregiverId;
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setInt('current_caregiver_id', caregiverId);
          }
        }

        // If guardian, save guardianId to SharedPreferences (use response or fetch by user id)
        if (role.toLowerCase() == 'guardian') {
          try {
            final prefs = await SharedPreferences.getInstance();
            int? gid;
            if (responseData.containsKey('guardianId')) {
              gid = int.tryParse(responseData['guardianId'].toString());
            }
            if (gid == null) {
              // attempt backend lookup: GuardianService.getGuardianIdByUserId returns int?
              gid = await GuardianService.getGuardianIdByUserId(id);
            }
            if (gid != null) {
              await prefs.setInt('guardianId', gid);
              print('Saved guardianId=$gid to prefs');
            } else {
              print('guardianId not found for user $id');
            }
          } catch (e) {
            print('Failed to save guardianId: $e');
          }
        }

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
        return AuthResult(success: false, message: 'User not found');
      } else {
        // Other errors
        final responseData = jsonDecode(response.body);
        return AuthResult(
          success: false,
          message:
              responseData['message'] ??
              'Login failed (Status: ${response.statusCode})',
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
        Uri.parse('$url/verify'),
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
        return AppRoutes.patientMain;
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
  static Future<void> login(
    String role, {
    String? token,
    Map<String, dynamic>? userData,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Save user session data
      await prefs.setString(_roleKey, role);
      await prefs.setString(
        _tokenKey,
        token ?? 'dummy_token_${DateTime.now().millisecondsSinceEpoch}',
      );

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
            Uri.parse('$url/logout'),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          );
          // Logout endpoint called successfully (optional)
        } catch (e) {
          // Server logout failed or endpoint doesn't exist - continue with local logout
          print(
            'Server logout failed (this is normal if endpoint not implemented): $e',
          );
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

  // Get current user ID (guardian ID)
  static Future<int?> getCurrentUserId() async {
    if (currentUserId != null) return currentUserId;
    final user = await getCurrentUser();
    if (user != null && user['id'] != null) {
      currentUserId = user['id'] is int
          ? user['id']
          : int.tryParse(user['id'].toString());
      return currentUserId;
    }
    return null;
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
      return isCaregiver() ||
          isPatient(); // Higher roles can access user routes
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
        Uri.parse('$url/refresh'),
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

  static Future<ForgotPasswordResult> sendPasswordResetEmail(
    String email,
  ) async {
    try {
      // Prepare request body
      final requestBody = {'email': email};

      // Make HTTP request to backend
      final response = await http.post(
        Uri.parse('$url/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      // Handle different response status codes
      if (response.statusCode == 200) {
        // Success - email sent
        final responseData = jsonDecode(response.body);
        return ForgotPasswordResult(
          success: true,
          message:
              responseData['message'] ??
              'Password reset link sent to your email',
        );
      } else if (response.statusCode == 400) {
        // Bad request (user not found or other validation errors)
        final responseData = jsonDecode(response.body);
        return ForgotPasswordResult(
          success: false,
          message:
              responseData['message'] ??
              'No account found with this email address',
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

  // Reset password with token and new password
  static Future<ForgotPasswordResult> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      // Prepare request body
      final requestBody = {'token': token, 'newPassword': newPassword};

      // Make HTTP request to backend
      final response = await http.post(
        Uri.parse('$url/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      // Handle different response status codes
      if (response.statusCode == 200) {
        // Success - password reset
        final responseData = jsonDecode(response.body);
        return ForgotPasswordResult(
          success: true,
          message: responseData['message'] ?? 'Password reset successfully',
        );
      } else if (response.statusCode == 400) {
        // Bad request (invalid token, expired token, etc.)
        final responseData = jsonDecode(response.body);
        return ForgotPasswordResult(
          success: false,
          message: responseData['message'] ?? 'Invalid or expired reset token',
        );
      } else {
        // Other server errors
        try {
          final responseData = jsonDecode(response.body);
          return ForgotPasswordResult(
            success: false,
            message: responseData['message'] ?? 'Failed to reset password',
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

  static Future<int?> getCurrentCaregiverId() async {
    if (currentCaregiverId != null) return currentCaregiverId;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('current_caregiver_id')) {
      currentCaregiverId = prefs.getInt('current_caregiver_id');
      return currentCaregiverId;
    }
    // If not found, try to fetch by userId
    final userId = await getCurrentUserId();
    if (userId != null) {
      final caregiverId = await CaregiverService.getCaregiverIdByUserId(userId);
      if (caregiverId != null) {
        currentCaregiverId = caregiverId;
        await prefs.setInt('current_caregiver_id', caregiverId);
        return caregiverId;
      }
    }
    return null;
  }

  // Ensure guardian ID is saved in SharedPreferences
  static Future<void> _ensureGuardianIdSaved(int userId, int? maybeGuardianId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (maybeGuardianId != null) {
        await prefs.setInt('guardianId', maybeGuardianId);
        return;
      }
      // If already present, nothing to do
      if (prefs.containsKey('guardianId')) return;

      // Try fetch guardian record from backend (adjust path if your API differs)
      final uri = Uri.parse('${ApiConstants.baseUrl}/guardians/user/$userId');
      final resp = await http.get(uri, headers: {'Content-Type': 'application/json'});
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        // try multiple possible field names
        final fetched = data['guardianId'] ?? data['id'] ?? data['guardian_id'];
        if (fetched != null) {
          final int gid = fetched is int ? fetched : int.parse(fetched.toString());
          await prefs.setInt('guardianId', gid);
        }
      }
    } catch (e) {
      // silently ignore - login shouldn't fail due to missing guardianId
      print('Failed to fetch/save guardianId: $e');
    }
  }
  static Future<AuthResult> authenticatePatientWithCode(
    String email,
    String code,
  ) async {
    try {
      final requestBody = {'email': email, 'code': code};

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/api/patients/verify-code'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      print('Patient Verification Response Status: ${response.statusCode}');
      print('Patient Verification Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['success'] == true) {
          final String token = responseData['accessToken'];
          final String role = responseData['role'];
          final int id = responseData['id'];
          final Map<String, dynamic> userData = {
            'id': id,
            'email': responseData['email'],
            'fName': responseData['fname'],
            'lName': responseData['lname'],
            'role': role,
          };

          // Save session data
          await login(role, token: token, userData: userData);
          currentUserId = id;

          return AuthResult(
            success: true,
            role: role,
            dashboardRoute: getDashboardRoute(role),
            message: 'Login successful',
            userData: userData,
          );
        } else {
          return AuthResult(
            success: false,
            message: responseData['message'] ?? 'Verification failed',
          );
        }
      } else if (response.statusCode == 401) {
        final responseData = jsonDecode(response.body);
        return AuthResult(
          success: false,
          message: responseData['message'] ?? 'Invalid verification code',
        );
      } else if (response.statusCode == 429) {
        final responseData = jsonDecode(response.body);
        return AuthResult(
          success: false,
          message:
              responseData['message'] ??
              'Too many attempts. Please try again later.',
        );
      } else if (response.statusCode == 410) {
        return AuthResult(
          success: false,
          message: 'Verification code has expired. Please request a new code.',
        );
      } else {
        final responseData = jsonDecode(response.body);
        return AuthResult(
          success: false,
          message: responseData['message'] ?? 'Verification failed',
        );
      }
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'Network error. Please check your connection and try again.',
      );
    }
  }

  // NEW: Send verification code to patient email
  static Future<VerificationCodeResult> sendPatientVerificationCode(
    String email,
  ) async {
    try {
      final requestBody = {'email': email};

      final response = await http.post(
        Uri.parse(
          '${ApiConstants.baseUrl}/api/patients/send-verification-code',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      print('Send Code Response Status: ${response.statusCode}');
      print('Send Code Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return VerificationCodeResult(
          success: true,
          message: responseData['message'] ?? 'Verification code sent',
          expiresInMinutes: responseData['expiresInMinutes'],
        );
      } else if (response.statusCode == 429) {
        final responseData = jsonDecode(response.body);
        return VerificationCodeResult(
          success: false,
          message:
              responseData['message'] ??
              'Please wait before requesting a new code',
          locked: responseData['locked'] ?? false,
          cooldown: responseData['cooldown'] ?? false,
          minutesRemaining: responseData['minutesRemaining'],
          secondsRemaining: responseData['secondsRemaining'],
        );
      } else if (response.statusCode == 404) {
        return VerificationCodeResult(
          success: false,
          message: 'No patient account found with this email',
        );
      } else {
        final responseData = jsonDecode(response.body);
        return VerificationCodeResult(
          success: false,
          message:
              responseData['message'] ?? 'Failed to send verification code',
        );
      }
    } catch (e) {
      return VerificationCodeResult(
        success: false,
        message: 'Network error. Please check your connection and try again.',
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

  ForgotPasswordResult({required this.success, required this.message});
}

// NEW: Verification code result class
class VerificationCodeResult {
  final bool success;
  final String message;
  final int? expiresInMinutes;
  final bool? locked;
  final bool? cooldown;
  final int? minutesRemaining;
  final int? secondsRemaining;

  VerificationCodeResult({
    required this.success,
    required this.message,
    this.expiresInMinutes,
    this.locked,
    this.cooldown,
    this.minutesRemaining,
    this.secondsRemaining,
  });
}
