import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import 'caregiver_dashboard_screen.dart';
import 'caregiver_patients_screen.dart';
import 'caregiver_profile_screen.dart';

class CaregiverRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      //case AppRoutes.caregiverSignup:
        //return MaterialPageRoute(builder: (_) => CaregiverSignupScreen());
      case AppRoutes.caregiverDashboard:
        return MaterialPageRoute(builder: (_) => CaregiverDashboardScreen());
      case AppRoutes.caregiverPatients:
        return MaterialPageRoute(builder: (_) => CaregiverPatientsScreen());
      case AppRoutes.caregiverProfile:
        return MaterialPageRoute(builder: (_) => CaregiverProfileScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Caregiver route not found')),
          ),
        );
    }
  }
}