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

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final String routeName = settings.name ?? '';
    final dynamic arguments = settings.arguments;

    // Splash route
    if (routeName == AppRoutes.splash) {
      return MaterialPageRoute(builder: (_) => SplashScreen());
    }
    if (routeName == AppRoutes.forgotPassword) {
      return MaterialPageRoute(builder: (_) => ForgotPasswordScreen());
    }

    // Auth routes
    if (routeName == AppRoutes.login) {
      return MaterialPageRoute(builder: (_) => LoginScreen());
    }
    if (routeName == AppRoutes.register) {
      return MaterialPageRoute(builder: (_) => RegisterScreen());
    }
    if (routeName == AppRoutes.signup) {
      return MaterialPageRoute(builder: (_) => SignupScreen());
    }

    // Patient routes
    if (routeName.startsWith('/patient/')) {
      return PatientRoutes.generateRoute(settings);
    }

    // Guardian routes
    if (routeName.startsWith('/guardian/')) {
      return GuardianRoutes.generateRoute(settings);
    }

    // Caregiver routes
    if (routeName.startsWith('/caregiver/')) {
      return CaregiverRoutes.generateRoute(settings);
    }

    // Volunteer routes
    if (routeName.startsWith('/volunteer/')) {
      return VolunteerRoutes.generateRoute(settings);
    }

    // Default route for unknown paths
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text('No route defined for ${settings.name}'),
        ),
      ),
    );
  }
}
