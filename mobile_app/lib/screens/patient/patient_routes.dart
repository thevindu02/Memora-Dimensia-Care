import 'package:flutter/material.dart';
import 'package:mobile_app/screens/patient/patient_email_verification_screen.dart';
import 'package:mobile_app/screens/patient/patient_guardian_request_screen.dart';
import 'package:mobile_app/screens/patient/patient_verify_code_screen.dart';
import 'package:mobile_app/screens/patient/patient_welcome_screen.dart';
import '../../routes/app_routes.dart';
import 'patient_dashboard_screen.dart';
import 'patient_profile_screen.dart';
import 'patient_settings.dart';
import 'patient_verification_screen.dart';

class PatientRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.patientDashboard:
        return MaterialPageRoute(builder: (_) => PatientDashboardScreen());
      case AppRoutes.patientProfile:
        return MaterialPageRoute(builder: (_) => PatientProfileScreen());
      case AppRoutes.patientSettings:
        return MaterialPageRoute(builder: (_) => PatientSettingsScreen());
      case AppRoutes.patientGuardianRequest:
        return MaterialPageRoute(builder: (_) => PatientGuardianRequestScreen());
      case AppRoutes.patientEmailVerification:
        return MaterialPageRoute(builder: (_) => PatientEmailVerificationScreen());
      case AppRoutes.patientVerifyCode:
        return MaterialPageRoute(builder: (_) => PatientVerifyCodeScreen());
      case AppRoutes.patientWelcome:
        return MaterialPageRoute(builder: (_) => PatientWelcomeScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Patient route not found')),
          ),
        );
    }
  }
}