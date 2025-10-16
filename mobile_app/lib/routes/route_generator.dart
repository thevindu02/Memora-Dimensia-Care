import 'package:flutter/material.dart';
import 'app_routes.dart';
import '../screens/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/patient/patient_routes.dart';
import '../screens/guardian/guardian_routes.dart';
import '../screens/caregiver/caregiver_routes.dart';
import '../screens/volunteer/volunteer_routes.dart';
import '../screens/signup_screen.dart';
import '../screens/forgot_password_screen.dart';
import '../screens/reset_password_screen.dart';
import '../screens/guardian/guardian_notifications_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final String routeName = settings.name ?? '';
    final dynamic arguments = settings.arguments;

    print('RouteGenerator: Processing route: "$routeName" with arguments: $arguments');

    // Handle root route with token (for deep links)
    if (routeName == '/' || routeName.isEmpty || routeName.startsWith('/?token=')) {
      String? token;
      
      // Try to extract token from route name if it contains token parameter
      if (routeName.contains('token=')) {
        final uri = Uri.parse(routeName.startsWith('/') ? 'http://dummy$routeName' : routeName);
        token = uri.queryParameters['token'];
      }
      
      // Also check arguments for token
      if (token == null && arguments is Map<String, dynamic>) {
        token = arguments['token'];
      }
      
      if (token != null && token.isNotEmpty) {
        // Redirect to reset password screen with token
        return MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(token: token),
          settings: RouteSettings(
            name: AppRoutes.resetPassword,
            arguments: {'token': token},
          ),
        );
      } else {
        // Default root route - go to splash
        return MaterialPageRoute(
          builder: (_) => SplashScreen(),
          settings: settings,
        );
      }
    }

    // Splash route
    if (routeName == AppRoutes.splash) {
      return MaterialPageRoute(
        builder: (_) => SplashScreen(),
        settings: settings,
      );
    }
    if (routeName == AppRoutes.forgotPassword) {
      return MaterialPageRoute(
        builder: (_) => ForgotPasswordScreen(),
        settings: settings,
      );
    }
    if (routeName == AppRoutes.resetPassword) {
      final token = arguments is Map<String, dynamic> ? arguments['token'] : null;
      return MaterialPageRoute(
        builder: (_) => ResetPasswordScreen(token: token),
        settings: settings,
      );
    }

    // Auth routes
    if (routeName == AppRoutes.login) {
      return MaterialPageRoute(
        builder: (_) => LoginScreen(),
        settings: settings,
      );
    }
    if (routeName == AppRoutes.register) {
      return MaterialPageRoute(
        builder: (_) => RegisterScreen(),
        settings: settings,
      );
    }
    if (routeName == AppRoutes.signup) {
      return MaterialPageRoute(
        builder: (_) => SignupScreen(),
        settings: settings,
      );
    }

    // Patient routes
    if (routeName.startsWith('/patient/')) {
      return PatientRoutes.generateRoute(settings);
    }

    // Guardian routes
    if (routeName.startsWith('/guardian/')) {
      return GuardianRoutes.generateRoute(settings);
    }

    // Caregiver connection requests (special case)
    if (routeName == AppRoutes.caregiverConnectionRequests) {
      return CaregiverRoutes.generateRoute(settings);
    }

    // Caregiver routes
    if (routeName.startsWith('/caregiver/')) {
      return CaregiverRoutes.generateRoute(settings);
    }

    // Volunteer routes
    if (routeName.startsWith('/volunteer/')) {
      return VolunteerRoutes.generateRoute(settings);
    }

    // Guardian notifications
    if (routeName == AppRoutes.guardianNotifications) {
      return MaterialPageRoute(builder: (_) => GuardianNotificationsScreen());
    }

    // Default route for unknown paths
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(child: Text('No route defined for ${settings.name}')),
      ),
      settings: settings,
    );
  }
}
