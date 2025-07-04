import 'package:flutter/material.dart';
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
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Patient route not found')),
          ),
        );
    }
  }
}