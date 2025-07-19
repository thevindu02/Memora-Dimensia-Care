import 'package:flutter/material.dart';
import 'package:mobile_app/screens/patient/games/memory_match/memory_match_game.dart';
import 'package:mobile_app/screens/patient/games/memory_match/ui/pages/memory_match_page.dart';
import 'package:mobile_app/screens/patient/games/memory_match/ui/pages/game_controls_page.dart';
import 'package:mobile_app/screens/patient/patient_email_verification_screen.dart';
import 'package:mobile_app/screens/patient/patient_games_screen.dart';
import 'package:mobile_app/screens/patient/patient_main_screen.dart';
import 'package:mobile_app/screens/patient/patient_notification_screen.dart';
import 'package:mobile_app/screens/patient/patient_verify_code_screen.dart';
import 'package:mobile_app/screens/patient/patient_welcome_screen.dart';
import '../../routes/app_routes.dart';
import 'patient_dashboard_screen.dart';
import 'patient_profile_screen.dart';
import 'patient_settings.dart';

class PatientRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.patientDashboard:
        return MaterialPageRoute(
          builder: (_) => PatientDashboardScreen(),
          settings: settings,
        );
      case AppRoutes.patientProfile:
        return MaterialPageRoute(
          builder: (_) => PatientProfileScreen(),
          settings: settings,
        );
      case AppRoutes.patientSettings:
        return MaterialPageRoute(
          builder: (_) => PatientSettingsScreen(),
          settings: settings,
        );
      case AppRoutes.patientEmailVerification:
        return MaterialPageRoute(
          builder: (_) => PatientEmailVerificationScreen(),
          settings: settings,
        );
      case AppRoutes.patientVerifyCode:
        return MaterialPageRoute(
          builder: (_) => PatientVerifyCodeScreen(),
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
