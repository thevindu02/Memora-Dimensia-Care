import 'package:flutter/material.dart';
import 'package:mobile_app/screens/guardian/guardian_add_caregiver_screen.dart';
import 'package:mobile_app/screens/guardian/guardian_add_known_caregiver_screen.dart';
import 'package:mobile_app/screens/guardian/guardian_add_patient_screen.dart';
import 'package:mobile_app/screens/guardian/guardian_add_unknown_caregiver_screen.dart';
import 'package:mobile_app/screens/guardian/guardian_edit_patient_details_screen.dart';
import 'package:mobile_app/screens/guardian/guardian_qaForums_screen.dart';
import 'package:mobile_app/screens/guardian/guardian_single_article_screen.dart';
import 'package:mobile_app/screens/guardian/guardian_articles_screen.dart';
import 'package:mobile_app/screens/guardian/guardian_patient_details_screen.dart';
import 'package:mobile_app/screens/guardian/guardian_patients_reports_screen.dart';
import 'package:mobile_app/screens/guardian/guardian_selected_patient_reports_screen.dart';
import 'package:mobile_app/screens/guardian/guardian_settings_help_support_screen.dart';
import 'package:mobile_app/screens/guardian/guardian_settings_privacy_screen.dart';
import 'package:mobile_app/screens/guardian/guardian_settings_screen.dart';
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
      case AppRoutes.guardianAddPatient:
        return MaterialPageRoute(
            builder: (_) => GuardianAddPatientScreen(),
            settings: settings,
        );
      case AppRoutes.guardianPatientDetails:
        return MaterialPageRoute(
          builder: (context) => GuardianPatientDetailsScreen(),
          settings: settings, // This is important - it passes the route settings including arguments
      );
      case AppRoutes.guardianEditPatientDetails:
        return MaterialPageRoute(builder: (_) => GuardianEditPatientDetailsScreen());
      case AppRoutes.guardianAddCaregiver:
        return MaterialPageRoute(builder: (_) => GuardianAddCaregiverScreen());
      case AppRoutes.guardianAddUnknownCaregiver:
        return MaterialPageRoute(builder: (_) => GuardianAddUnknownCaregiverScreen());
      case AppRoutes.guardianAddKnownCaregiver:
        return MaterialPageRoute(builder: (_) => GuardianAddKnownCaregiverScreen());
      case AppRoutes.guardianPatientsReports:
        return MaterialPageRoute(builder: (_) => GuardianPatientsReportsScreen());
      case AppRoutes.guardianSelectedPatientReports:
        return MaterialPageRoute(builder: (_) => GuardianSelectedPatientReportsScreen());
      case AppRoutes.guardianSettings:
        return MaterialPageRoute(builder: (_) => GuardianSettingsScreen());
      case AppRoutes.guardianArticles:
        return MaterialPageRoute(builder: (_) => GuardianArticlesScreen());
      case AppRoutes.guardianArticleDetail:
        return MaterialPageRoute(builder: (_) => GuardianSingleArticleScreen());
      case AppRoutes.guardianQAForums:
        return MaterialPageRoute(builder: (_) => GuardianQAForumsScreen());
      case AppRoutes.guardianProfile:
        return MaterialPageRoute(builder: (_) => GuardianProfileScreen());
      case AppRoutes.guardianSettingsPrivacy:
        return MaterialPageRoute(builder: (_) => GuardianSettingsPrivacyScreen());
      case AppRoutes.guardianSettingsHelpSupport:
        return MaterialPageRoute(builder: (_) => GuardianSettingsHelpSupportScreen());
      // case AppRoutes.guardianOrders:
      //   return MaterialPageRoute(builder: (_) => GuardianOrdersScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Guardian route not found')),
          ),
        );
    }
  }
}
