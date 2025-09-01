import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import 'volunteer_articles_screen.dart';
import 'volunteer_profile_screen.dart';
import 'volunteer_signup_screen.dart';
import 'volunteer_upload_Id_image_screen.dart';
import 'volunteer_confirm_image_upload_screen.dart';
import 'volunteer_registration_submitted_screen.dart';
import 'volunteer_registration_completed_screen.dart';
import 'volunteer_dashboard_screen.dart';
import 'volunteer_create_content_screen.dart';
import 'volunteer_forum_screen.dart';
import 'volunteer_schedule_session_screen.dart';
import 'article_draft_screen.dart';
import 'view_article_screen.dart';

class VolunteerRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.volunteerSignup:
        return MaterialPageRoute(
          builder: (_) => VolunteerSignupScreen(),
          settings: settings,
        );
      case AppRoutes.volunteerArticles:
        return MaterialPageRoute(
          builder: (_) => VolunteerArticlesScreen(),
          settings: settings,
        );
      case AppRoutes.volunteerProfile:
        final volunteerId = settings.arguments as int? ?? 1; // Default to 1 if not provided
        return MaterialPageRoute(
          builder: (_) => VolunteerProfileScreen(volunteerId: volunteerId),
          settings: settings,
        );
      case AppRoutes.volunteerUploadImage:
        return MaterialPageRoute(
          builder: (_) => VolunteerUploadIdimageScreen(),
          settings: settings,
        );
      case AppRoutes.volunteerConfirmImage:
        return MaterialPageRoute(
          builder: (_) => VolunteerConfirmImageUploadScreen(),
          settings: settings,
        );
      case AppRoutes.volunteerRegistrationSubmitted:
        return MaterialPageRoute(
          builder: (_) => VolunteerRegistrationSubmittedScreen(),
          settings: settings,
        );
      case AppRoutes.volunteerCompletedRegistration:
        return MaterialPageRoute(
          builder: (_) => VolunteerRegistrationCompletedScreen(),
          settings: settings,
        );
      case AppRoutes.volunteerDashboard:
        return MaterialPageRoute(
          builder: (_) => VolunteerDashboardScreen(),
          settings: settings,
        );
      case AppRoutes.volunteerCreateContent:
        return MaterialPageRoute(
          builder: (_) => VolunteerCreateContentScreen(),
          settings: settings,
        );
      case AppRoutes.volunteerForum:
        return MaterialPageRoute(
          builder: (_) => VolunteerForumScreen(),
          settings: settings,
        );
      case AppRoutes.volunteerScheduleSession:
        return MaterialPageRoute(
          builder: (_) => VolunteerScheduleSessionScreen(),
          settings: settings,
        );
      case AppRoutes.volunteerDraft:
        return MaterialPageRoute(
          builder: (_) => ArticleDraftScreen(),
          settings: settings,
        );

      case AppRoutes.volunteerArticlesTab:
        return MaterialPageRoute(
          builder: (_) => VolunteerArticlesTab(),
          settings: settings,
        );


      default:
        return MaterialPageRoute(
          builder: (_) =>
              Scaffold(body: Center(child: Text('Volunteer route not found'))),
        );
    }
  }
}
