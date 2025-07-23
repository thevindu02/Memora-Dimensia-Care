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
  static const String patientEmailVerification = '/patient/emailVerification';
  static const String patientVerifyCode = '/patient/verifyCode';
  static const String patientWelcome = '/patient/welcome';
  static const String patientNotifications = '/patient/notification';
  static const String patientGames = '/patient/games';
  static const String patientMain = '/patient/main';
  static const String patientMemoryMatch = '/patient/memory_match_game';
  static const String patientMemoryMatchLevel4 =
      '/patient/memory_match/level/4';
  static const String patientMemoryMatchLevel6 =
      '/patient/memory_match/level/6';
  static const String patientMemoryMatchLevel8 =
      '/patient/memory_match/level/8';
  static const String patientMemoryMatchQuit = '/patient/memory_match/quit';
  static const String patientMemoryMatchControls =
      '/patient/memory_match/controls';
  // Guardian routes
  static const String guardianSignup = '/guardian/signup';
  static const String guardianDashboard = '/guardian/dashboard';
  static const String guardianAddPatient = '/guardian/addpatient';
  static const String guardianPatientDetails = '/guardian/patient_details';
  static const String guardianEditPatientDetails =
      '/guardian/edit_patient_details';
  static const String guardianAddCaregiver = '/guardian/add_caregiver';
  static const String guardianAddUnknownCaregiver =
      '/guardian/add_caregiver/add_unknown_caregiver';
  static const String guardianAddKnownCaregiver =
      '/guardian/add_caregiver/add_known_caregiver';
  static const String guardianPatientsReports = '/guardian/patients_reports';
  static const String guardianSelectedPatientReports =
      '/guardian/patients_reports/selected_patient_reports';
  static const String guardianSettings = '/guardian/settings';
  static const String guardianSettingsPrivacy = '/guardian/settings/privacy';
  static const String guardianSettingsHelpSupport =
      '/guardian/settings/help_support';
  static const String guardianArticles = '/guardian/articles';
  static const String guardianArticleDetail = '/guardian/article-detail';
  static const String guardianQAForums = '/guardian/qa-forums';
  static const String guardianProfile = '/guardian/profile';
  // static const String guardianOrders = '/guardian/orders';

  // Caregiver routes
  static const String caregiverSignup = '/caregiver/signup';
  static const String caregiverRegister = '/caregiver/register';
  static const String caregiverDashboard = '/caregiver/dashboard';
  static const String caregiverPatients = '/caregiver/patients';
  static const String caregiverProfile = '/caregiver/profile';
  static const String caregiverProfileEdit = '/caregiver/profileEdit';
  static const String patientRoutine = '/caregiver/routine';
  static const String selectType = '/caregiver/selectRoutine';
  static const String viewArticleList = '/caregiver/article';
  static const String caregiverNotification = '/caregiver/notification';
  static const String patientReport = '/caregiver/report';
  static const String completeRoutine = '/caregiver/complete';
  static const String careDetails = '/caregiver/careDetails';
  static const String discussionForum = '/caregiver/forum';
  static const String settings = '/caregiver/settings';

  // Volunteer routes
  static const String volunteerSignup = '/volunteer/signup';
  static const String volunteerDashboard = '/volunteer/dashboard';
  static const String volunteerProfile = '/volunteer/profile';
  static const String volunteerArticles = '/volunteer/articles';
  static const String volunteerUploadImage = '/volunteer/uploadimage';
  static const String volunteerConfirmImage = '/volunteer/confirmimage';
  static const String volunteerRegistrationSubmitted =
      '/volunteer/submittedregistration';
  static const String volunteerCompletedRegistration =
      '/volunteer/completedregistration';
  static const String volunteerCreateContent = '/volunteer/createcontent';
  static const String volunteerForum = '/volunteer/forum';
  static const String volunteerScheduleSession = '/volunteer/schedule';
  static const String volunteerDraft = '/volunteer/draft';
  static const String viewArticle = '/volunteer/viewarticle';
  static const String volunteerArticlesTab = '/volunteer/viewarticle';
  
}
