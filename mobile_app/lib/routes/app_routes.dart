class AppRoutes {
  // Auth routes
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgotPassword';

  // Patient routes
  static const String patientDashboard = '/patient/dashboard';
  static const String patientProfile = '/patient/profile';
  static const String patientSettings = '/patient/settings';
  static const String patientGuardianRequest = '/patient/guardianRequest';
  static const String patientEmailVerification = '/patient/emailVerification';
  static const String patientVerifyCode = '/patient/verifyCode';
  static const String patientWelcome = '/patient/welcome';
  static const String patientNotifications = '/patient/notification';
  static const String patientGames = '/patient/games';
  static const String patientMain = '/patient/main';

  // Guardian routes
  static const String guardianSignup = '/guardian/signup';
  static const String guardianDashboard = '/guardian/dashboard';
  static const String guardianProfile = '/guardian/profile';
  static const String guardianOrders = '/guardian/orders';

  // Caregiver routes
  static const String caregiverSignup = '/caregiver/signup';
  static const String caregiverDashboard = '/caregiver/dashboard';
  static const String caregiverPatients = '/caregiver/patients';
  static const String caregiverProfile = '/caregiver/profile';

  // Volunteer routes
  static const String volunteerSignup = '/volunteer/signup';
  static const String volunteerDashboard = '/volunteer/dashboard';
  static const String volunteerProfile = '/volunteer/profile';
  static const String volunteerArticles = '/volunteer/articles';

}