import 'package:flutter/material.dart';
import 'package:mobile_app/screens/patient/games/memory_match/memory_match_game.dart';
import 'package:mobile_app/screens/patient/games/memory_match/ui/pages/memory_match_page.dart';
import 'package:mobile_app/screens/patient/games/memory_match/ui/pages/game_controls_page.dart';
import 'package:mobile_app/screens/patient/games/sudoku/main.dart'
    show HomePage;
import 'package:mobile_app/screens/patient/patient_email_verification_screen.dart';
import 'package:mobile_app/screens/patient/patient_games_screen.dart';
import 'package:mobile_app/screens/patient/patient_main_screen.dart';
import 'package:mobile_app/screens/patient/patient_notification_screen.dart';
import 'package:mobile_app/screens/patient/patient_verify_code_screen.dart';
import 'package:mobile_app/screens/patient/patient_welcome_screen.dart';
import 'package:mobile_app/screens/patient/patient_guardian_request_screen.dart';
import '../../routes/app_routes.dart';
import 'patient_dashboard_screen.dart';
import 'patient_profile_screen.dart';
import 'patient_settings_screens.dart';
import 'patient_settings_help_support.dart';
import 'patient_settings_privacy_screen.dart';
import 'patient_task_selection_screen.dart';

class PatientRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.patientDashboard:
        return MaterialPageRoute(
          builder: (_) => PatientDashboardScreen(),
          settings: settings,
        );
      case AppRoutes.patientProfile:
        final patientId = settings.arguments as int? ?? 1; // Default to 1 if not provided
        return MaterialPageRoute(
          builder: (_) => PatientProfileScreen(patientId: patientId),
          settings: settings,
        );
      case AppRoutes.patientEmailVerification:
        final arguments = settings.arguments as Map<String, dynamic>?;
        final email = arguments?['email'] as String?;
        return MaterialPageRoute(
          builder: (_) => PatientEmailVerificationScreen(email: email),
          settings: settings,
        );
      case AppRoutes.patientVerifyCode:
        final arguments = settings.arguments as Map<String, dynamic>?;
        final email = arguments?['email'] as String?;
        return MaterialPageRoute(
          builder: (_) => PatientVerifyCodeScreen(email: email),
          settings: settings,
        );
      case AppRoutes.patientGuardianRequest:
        final arguments = settings.arguments as Map<String, dynamic>?;
        final token = arguments?['token'] as String?;
        return MaterialPageRoute(
          builder: (_) => PatientGuardianRequestScreen(token: token),
          settings: settings,
        );
      case AppRoutes.patientWelcome:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              PatientWelcomeScreen(),
          settings: settings,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          barrierDismissible: false, // Prevents back button
        );
      case AppRoutes.patientNotifications:
        return MaterialPageRoute(
          builder: (_) => PatientNotificationScreen(),
          settings: settings,
        );
      case AppRoutes.patientGames:
        return MaterialPageRoute(
          builder: (_) => PatientGamesScreen(),
          settings: settings,
        );
      case AppRoutes.patientMain:
        return MaterialPageRoute(
          builder: (_) => PatientMainScreen(),
          settings: settings,
        );
      case AppRoutes.patientMemoryMatch:
        return MaterialPageRoute(
          builder: (_) => MemoryMatchGame(),
          settings: settings,
        );
      case AppRoutes.patientSudoku:
        return MaterialPageRoute(
          builder: (_) => HomePage(),
          settings: settings,
        );
      case AppRoutes.patientMemoryMatchLevel4:
        return MaterialPageRoute(
          builder: (_) => MemoryMatchPage(gameLevel: 4),
          settings: settings,
        );
      case AppRoutes.patientMemoryMatchLevel6:
        return MaterialPageRoute(
          builder: (_) => MemoryMatchPage(gameLevel: 6),
          settings: settings,
        );
      case AppRoutes.patientMemoryMatchLevel8:
        return MaterialPageRoute(
          builder: (_) => MemoryMatchPage(gameLevel: 8),
          settings: settings,
        );
      case AppRoutes.patientMemoryMatchQuit:
        return MaterialPageRoute(
          builder: (_) => MemoryMatchGame(),
          settings: settings,
        );
      case AppRoutes.patientMemoryMatchControls:
        return MaterialPageRoute(
          builder: (_) => GameControlsPage(),
          settings: settings,
        );
      case AppRoutes.patientSettings:
        return MaterialPageRoute(
          builder: (_) => PatientSettingsScreen(),
          settings: settings,
        );
      case AppRoutes.patientSettingsHelpSupport:
        return MaterialPageRoute(
          builder: (_) => PatientSettingsHelpSupportScreen(),
          settings: settings,
        );
      case AppRoutes.patientSettingsPrivacy:
        return MaterialPageRoute(
          builder: (_) => PatientSettingsPrivacyScreen(),
          settings: settings,
        );
      case AppRoutes.patientSelectRoutine:
        return MaterialPageRoute(
          builder: (_) => PatientTaskSelectionScreen(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No patient route defined for ${settings.name}'),
            ),
          ),
          settings: settings,
        );
    }
  }
}
