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
import '../screens/guardian/guardian_notifications_screen.dart';
import '../screens/chat/chat_list_screen.dart';
import '../screens/chat/chat_conversation_screen.dart';
import '../screens/guardian/guardian_chat_history_screen.dart';
import '../screens/guardian/guardian_caregiver_list_screen.dart';
import '../screens/guardian/guardian_caregiver_details_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final String routeName = settings.name ?? '';
    final dynamic arguments = settings.arguments;

    // Splash route
    if (routeName == AppRoutes.splash) {
      return MaterialPageRoute(
        builder: (_) => SplashScreen(),
        settings: settings,
      );
    }

    // Forgot password
    if (routeName == AppRoutes.forgotPassword) {
      return MaterialPageRoute(
        builder: (_) => ForgotPasswordScreen(),
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

    // Guardian notifications (before generic guardian handler)
    if (routeName == AppRoutes.guardianNotifications) {
      return MaterialPageRoute(
        builder: (_) => GuardianNotificationsScreen(),
        settings: settings,
      );
    }

    // Guardian chat history (before generic guardian handler)
    if (routeName == AppRoutes.guardianChatHistory) {
      return MaterialPageRoute(
        builder: (_) => const GuardianChatHistoryScreen(),
        settings: settings,
      );
    }

    // Guardian caregiver list (before generic guardian handler)
    if (routeName == AppRoutes.guardianCaregiverList) {
      return MaterialPageRoute(
        builder: (_) => const GuardianCaregiverListScreen(),
        settings: settings,
      );
    }

    // Guardian caregiver details (before generic guardian handler)
    if (routeName == AppRoutes.guardianCaregiverDetails) {
      return MaterialPageRoute(
        builder: (_) => const GuardianCaregiverDetailsScreen(),
        settings: settings,
      );
    }

    // Patient routes
    if (routeName.startsWith('/patient/')) {
      return PatientRoutes.generateRoute(settings);
    }

    // Guardian routes (generic handler - MUST come after explicit guardian routes)
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

    // Chat routes
    if (routeName == AppRoutes.chatList) {
      return MaterialPageRoute(
        builder: (_) => ChatListScreen(),
        settings: settings,
      );
    }
    if (routeName == AppRoutes.chatConversation) {
      return MaterialPageRoute(
        builder: (_) => ChatConversationScreen(),
        settings: settings,
      );
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
