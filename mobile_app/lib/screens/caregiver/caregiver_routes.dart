import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import 'home_screen.dart';
import 'patient_list_screen.dart';
import 'caregiver_signup_screen.dart';
import 'schedule_routine_screen.dart';
import 'select_routine_screen.dart';
import 'view_article_screen.dart';
import 'profile_view_screen.dart';
import 'caregiver_notification.dart';
import 'schedule_report_screen.dart';
import 'complete_routine_screen.dart';
import 'care_details_screen.dart';
import 'register_screen.dart';
import 'discussion_forum_screen.dart';
import 'settings_screen.dart';

class CaregiverRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      //case AppRoutes.caregiverSignup:
      //return MaterialPageRoute(builder: (_) => CaregiverSignupScreen());
      case AppRoutes.caregiverDashboard:
        return MaterialPageRoute(builder: (_) => MainScreen());
      case AppRoutes.caregiverRegister:
        return MaterialPageRoute(builder: (_) => CaregiverRegisterPage());
      case AppRoutes.caregiverPatients:
        return MaterialPageRoute(builder: (_) => PatientListScreen());
      case AppRoutes.caregiverProfile:
        return MaterialPageRoute(builder: (_) => CaregiverProfileScreen());
      case AppRoutes.patientRoutine:
        return MaterialPageRoute(builder: (_) => ScheduleRoutine());
      case AppRoutes.selectType:
        return MaterialPageRoute(builder: (_) => SelectTypeWithErrorHandling());
      case AppRoutes.viewArticleList:
        return MaterialPageRoute(builder: (_) => ArticleList());
      case AppRoutes.caregiverNotification:
        return MaterialPageRoute(builder: (_) => CaregiverNotificationScreen());
      case AppRoutes.patientReport:
        return MaterialPageRoute(builder: (_) => ScheduleReportScreen());
      case AppRoutes.completeRoutine:
        return MaterialPageRoute(builder: (_) => ScheduleRoutineDialog());
      case AppRoutes.careDetails:
        return MaterialPageRoute(builder: (_) => CareDetailsScreen());
      case AppRoutes.discussionForum:
        return MaterialPageRoute(builder: (_) => DiscussionForumScreen());
      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => SettingsScreen());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              Scaffold(body: Center(child: Text('Caregiver route not found'))),
        );
    }
  }
}
