import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import 'home_screen.dart';
import 'patient_list_screen.dart';
import 'caregiver_signup_screen.dart';
import 'schedule_routine_screen.dart';
import 'select_routine_screen.dart';
import 'view_article_screen.dart';
import 'profile_view_screen.dart';
import 'request_list_screen.dart';
import 'profile_edit_screen.dart';
import 'request_details_screen.dart';

class CaregiverRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      //case AppRoutes.caregiverSignup:
        //return MaterialPageRoute(builder: (_) => CaregiverSignupScreen());
      case AppRoutes.caregiverDashboard:
        return MaterialPageRoute(builder: (_) => MainScreen());
      case AppRoutes.caregiverPatients:
        return MaterialPageRoute(builder: (_) => PatientListScreen());
      case AppRoutes.caregiverProfile:
        return MaterialPageRoute(builder: (_) => CaregiverProfileScreen());
      case AppRoutes.caregiverProfileEdit:
        return MaterialPageRoute(builder: (_) => EditProfileEdit());
      case AppRoutes.patientRoutine:
        return MaterialPageRoute(builder: (_) => ScheduleRoutine());
      case AppRoutes.selectType:
        return MaterialPageRoute(builder: (_) => SelectType());
      case AppRoutes.viewArticleList:
        return MaterialPageRoute(builder: (_) => ArticleList());
      case AppRoutes.guardianRequest:
        return MaterialPageRoute(builder: (_) => GuardianRequestsPage());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Caregiver route not found')),
          ),
        );
    }
  }
}