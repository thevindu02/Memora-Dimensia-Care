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
  static const String guardianAddPatient = '/guardian/addpatient';
  static const String guardianPatientDetails = '/guardian/patient_details';
  static const String guardianEditPatientDetails = '/guardian/edit_patient_details';
  static const String guardianAddCaregiver = '/guardian/add_caregiver';
  static const String guardianAddUnknownCaregiver = '/guardian/add_caregiver/add_unknown_caregiver';
  static const String guardianAddKnownCaregiver = '/guardian/add_caregiver/add_known_caregiver';
  static const String guardianPatientsReports = '/guardian/patients_reports';
  static const String guardianSelectedPatientReports = '/guardian/patients_reports/selected_patient_reports';
  static const String guardianSettings = '/guardian/settings';
  static const String guardianSettingsPrivacy = '/guardian/settings/privacy';
  static const String guardianSettingsHelpSupport = '/guardian/settings/help_support';
  static const String guardianForums = '/guardian/forums';
  static const String guardianForumArticle = '/guardian/forum/article';
  static const String guardianProfile = '/guardian/profile';
  // static const String guardianOrders = '/guardian/orders';

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