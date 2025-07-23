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
import 'caregiver_connection_requests_screen.dart';
import 'discussion_forum_screen.dart';
import 'settings_screen.dart';

class CaregiverRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      //case AppRoutes.caregiverSignup:
      //return MaterialPageRoute(builder: (_) => CaregiverSignupScreen());
      case AppRoutes.caregiverDashboard:
        return MaterialPageRoute(
          builder: (_) => MainScreen(),
          settings: settings,
        );
      case AppRoutes.caregiverRegister:
        return MaterialPageRoute(
          builder: (_) => CaregiverRegisterPage(),
          settings: settings,
        );
      case AppRoutes.caregiverPatients:
        return MaterialPageRoute(
          builder: (_) => PatientListScreen(),
          settings: settings,
        );
      case AppRoutes.caregiverProfile:
        return MaterialPageRoute(
          builder: (_) => CaregiverProfileScreen(),
          settings: settings,
        );
      case AppRoutes.patientRoutine:
        return MaterialPageRoute(
          builder: (_) => ScheduleRoutine(),
          settings: settings,
        );
      case AppRoutes.selectType:
        return MaterialPageRoute(
          builder: (_) => SelectTypeWithErrorHandling(),
          settings: settings,
        );
      case AppRoutes.viewArticleList:
        return MaterialPageRoute(
          builder: (_) => ArticleList(),
          settings: settings,
        );
      case AppRoutes.caregiverNotification:
        return MaterialPageRoute(
          builder: (_) => CaregiverNotificationScreen(),
          settings: settings,
        );
      case AppRoutes.patientReport:
        return MaterialPageRoute(
          builder: (_) => ScheduleReportScreen(),
          settings: settings,
        );
      case AppRoutes.completeRoutine:
        return MaterialPageRoute(
          builder: (_) => ScheduleRoutineDialog(),
          settings: settings,
        );
      case AppRoutes.careDetails:
        return MaterialPageRoute(
            builder: (_) => CareDetailsScreen(),
            settings: settings,
        );
      case AppRoutes.caregiverConnectionRequests:
        return MaterialPageRoute(
          builder: (_) => CaregiverConnectionRequestsScreen(),
          settings: settings,
        );
        return MaterialPageRoute(
          builder: (_) => CareDetailsScreen(),
          settings: settings,
        );
      case AppRoutes.discussionForum:
        return MaterialPageRoute(
          builder: (_) => DiscussionForumScreen(),
          settings: settings,
        );
      case AppRoutes.settings:
        return MaterialPageRoute(
          builder: (_) => SettingsScreen(),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) =>
              Scaffold(body: Center(child: Text('Caregiver route not found'))),
        );
    }
  }
}
