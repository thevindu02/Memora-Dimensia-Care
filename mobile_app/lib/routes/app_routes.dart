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
  static const String caregiverProfileEdit = '/caregiver/profileEdit';
  static const String patientRoutine = '/caregiver/routine';
  static const String selectType = '/caregiver/selectRoutine';
  static const String viewArticleList = '/caregiver/article';
  static const String guardianRequest = '/caregiver/request';
  static const String caregiverNotification = '/caregiver/notification';
  static const String patientReport = '/caregiver/report';
  static const String completeRoutine = '/caregiver/complete';
  static const String careDetails = '/caregiver/careDetails';



  // Volunteer routes
  static const String volunteerSignup = '/volunteer/signup';
  static const String volunteerDashboard = '/volunteer/dashboard';
  static const String volunteerProfile = '/volunteer/profile';
  static const String volunteerArticles = '/volunteer/articles';

}