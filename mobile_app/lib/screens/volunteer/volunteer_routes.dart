import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import 'volunteer_dashboard_screen.dart';
import 'volunteer_articles_screen.dart';
import 'volunteer_profile_screen.dart';
import 'volunteer_signup_screen.dart';

class VolunteerRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
     // case AppRoutes.volunteerSignup:

       // return MaterialPageRoute(builder: (_) => VolunteerSignupScreen());
      case AppRoutes.volunteerDashboard:
        return MaterialPageRoute(builder: (_) => VolunteerDashboardScreen());
      case AppRoutes.volunteerArticles:
        return MaterialPageRoute(builder: (_) => VolunteerArticlesScreen());
      case AppRoutes.volunteerProfile:
        return MaterialPageRoute(builder: (_) => VolunteerProfileScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Volunteer route not found')),
          ),
        );
    }
  }
}