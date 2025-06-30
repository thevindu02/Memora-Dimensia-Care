import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import 'guardian_dashboard_screen.dart';
import 'guardian_profile_screen.dart';
import 'guardian_orders_screen.dart';
import 'guardian_signup_screen.dart';

class GuardianRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.guardianSignup:
        return MaterialPageRoute(builder: (_) => GuardianSignupScreen());
      case AppRoutes.guardianDashboard:
        return MaterialPageRoute(builder: (_) => GuardianDashboardScreen());
      case AppRoutes.guardianProfile:
        return MaterialPageRoute(builder: (_) => GuardianProfileScreen());
      case AppRoutes.guardianOrders:
        return MaterialPageRoute(builder: (_) => GuardianOrdersScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Guardian route not found')),
          ),
        );
    }
  }
}
