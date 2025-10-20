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
import 'volunteer_single_article_screen.dart';

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
          builder: (_) => Scaffold(
            appBar: AppBar(
              title: Text('Articles'),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
            ),
            body: VolunteerArticlesTabBody(),
          ),
          settings: settings,
        );
      case AppRoutes.volunteerProfile:
        final volunteerId = settings.arguments as int? ?? 1;
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
        final volunteerId = settings.arguments as int? ?? 1;
        return MaterialPageRoute(
          builder: (_) =>
              VolunteerRegistrationCompletedScreen(volunteerId: volunteerId),
          settings: settings,
        );
      case AppRoutes.volunteerDashboard:
        final volunteerId = settings.arguments as int? ?? 1;
        return MaterialPageRoute(
          builder: (_) => VolunteerDashboardScreen(volunteerId: volunteerId),
          settings: settings,
        );
      case AppRoutes.volunteerCreateContent:
        final volunteerId = settings.arguments as int? ?? 1;
        return MaterialPageRoute(
          builder: (_) =>
              VolunteerCreateContentScreen(volunteerId: volunteerId),
          settings: settings,
        );
      case AppRoutes.volunteerForum:
        final volunteerId = settings.arguments as int? ?? 1;
        return MaterialPageRoute(
          builder: (_) => VolunteerForumScreen(volunteerId: volunteerId),
          settings: settings,
        );
      case AppRoutes.volunteerScheduleSession:
        final volunteerId = settings.arguments as int? ?? 1;
        return MaterialPageRoute(
          builder: (_) =>
              VolunteerScheduleSessionScreen(volunteerId: volunteerId),
          settings: settings,
        );
      case AppRoutes.volunteerDraft:
        return MaterialPageRoute(
          builder: (_) => ArticleDraftScreen(),
          settings: settings,
        );
      case AppRoutes.volunteerMyArticles:
        return MaterialPageRoute(
          builder: (_) => VolunteerArticlesTabBody(),
          settings: settings,
        );
      case AppRoutes.volunteerArticlesTab:
        final articleId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => VolunteerSingleArticleScreen(articleId: articleId),
          settings: settings,
        );
      case AppRoutes.volunteerArticlesTab:
        return MaterialPageRoute(
          builder: (_) => VolunteerArticlesTabBody(),
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
