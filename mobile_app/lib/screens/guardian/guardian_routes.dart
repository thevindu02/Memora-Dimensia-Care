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
import 'package:mobile_app/screens/guardian/subscription_plan_screen.dart';
import '../../routes/app_routes.dart';
import 'guardian_dashboard_screen.dart';
import 'guardian_profile_screen.dart';
import 'guardian_signup_screen.dart';
import 'guardian_add_reviews_screen.dart';
import 'payment_success_screen.dart';
import 'payment_failed_screen.dart';

class GuardianRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.guardianSignup:
        return MaterialPageRoute(
          builder: (_) => GuardianSignupScreen(),
          settings: settings,
        );
      case AppRoutes.guardianDashboard:
        return MaterialPageRoute(
          builder: (_) => GuardianDashboardScreen(),
          settings: settings,
        );
      case AppRoutes.guardianAddPatient:
        return MaterialPageRoute(
          builder: (_) => GuardianAddPatientScreen(),
          settings: settings,
        );
      case AppRoutes.guardianPatientDetails:
        return MaterialPageRoute(
          builder: (context) => GuardianPatientDetailsScreen(),
          settings:
              settings, // This is important - it passes the route settings including arguments
        );
      case AppRoutes.guardianEditPatientDetails:
        return MaterialPageRoute(
          builder: (_) => GuardianEditPatientDetailsScreen(),
          settings: settings,
        );
      case AppRoutes.guardianAddCaregiver:
        return MaterialPageRoute(
          builder: (_) => GuardianAddCaregiverScreen(),
          settings: settings,
        );
      case AppRoutes.guardianAddUnknownCaregiver:
        return MaterialPageRoute(
          builder: (_) => GuardianAddUnknownCaregiverScreen(),
          settings: settings,
        );
      case AppRoutes.guardianAddKnownCaregiver:
        return MaterialPageRoute(
          builder: (_) => GuardianAddKnownCaregiverScreen(),
          settings: settings,
        );
      case AppRoutes.guardianPatientsReports:
        return MaterialPageRoute(
          builder: (_) => GuardianPatientsReportsScreen(),
          settings: settings,
        );
      case AppRoutes.guardianSelectedPatientReports:
        return MaterialPageRoute(
          builder: (_) => GuardianSelectedPatientReportsScreen(),
          settings: settings,
        );
      case AppRoutes.guardianSettings:
        return MaterialPageRoute(
          builder: (_) => GuardianSettingsScreen(),
          settings: settings,
        );
      case AppRoutes.guardianArticles:
        return MaterialPageRoute(
          builder: (_) => GuardianArticlesScreen(),
          settings: settings,
        );
      case AppRoutes.guardianQAForums:
        return MaterialPageRoute(
          builder: (_) => GuardianQAForumsScreen(),
          settings: settings,
        );
      case AppRoutes.guardianProfile:
        return MaterialPageRoute(
          builder: (_) => GuardianProfileScreen(),
          settings: settings,
        );
      case AppRoutes.guardianSettingsPrivacy:
        return MaterialPageRoute(
          builder: (_) => GuardianSettingsPrivacyScreen(),
          settings: settings,
        );
      case AppRoutes.guardianSettingsHelpSupport:
        return MaterialPageRoute(
          builder: (_) => GuardianSettingsHelpSupportScreen(),
          settings: settings,
        );
      case AppRoutes.guardianAddReviews:
        return MaterialPageRoute(
          builder: (_) => GuardianAddReviewsScreen(),
          settings: settings,
        );
      case AppRoutes.guardianSubscriptionPlans:
        return MaterialPageRoute(
          builder: (_) => SubscriptionPlanScreen(),
          settings: settings,
        );
      // case AppRoutes.guardianPayment:
      //   return MaterialPageRoute(
      //     builder: (_) => PaymentScreen(planType: planType, duration: duration, price: price),
      //     settings: settings,
      //   );
      case AppRoutes.guardianPaymentSuccess:
        final arguments = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => PaymentSuccessScreen(
            planType: arguments?['planType'] ?? 'Premium',
            duration: arguments?['duration'] ?? 'Monthly',
            price: arguments?['price'] ?? 19.99,
          ),
          settings: settings,
        );
      case AppRoutes.guardianPaymentFailed:
        final arguments = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => PaymentFailedScreen(
            planType: arguments?['planType'] ?? 'Premium',
            duration: arguments?['duration'] ?? 'Monthly',
            price: arguments?['price'] ?? 19.99,
            errorMessage: arguments?['errorMessage'] ?? 'Payment failed',
          ),
          settings: settings,
        );
      // case AppRoutes.guardianOrders:
      //   return MaterialPageRoute(builder: (_) => GuardianOrdersScreen());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              Scaffold(body: Center(child: Text('Guardian route not found'))),
        );
    }
  }
}
