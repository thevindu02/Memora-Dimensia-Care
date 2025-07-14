import 'base_auth_service.dart';
import 'patient_auth_service.dart';
import 'guardian_auth_service.dart';

class AuthServiceFactory {
  static BaseAuthService getAuthService(String role) {
    switch (role.toLowerCase()) {
      case 'patient':
        return PatientAuthService();
      case 'guardian':
        return GuardianAuthService();
      //case 'caregiver':
        //return CaregiverAuthService();
      //case 'volunteer':
        //return VolunteerAuthService();
      default:
        throw Exception('Unknown user role: $role');
    }
  }

  static List<String> getSupportedRoles() {
    return ['patient', 'guardian', 'caregiver', 'volunteer'];
  }
}