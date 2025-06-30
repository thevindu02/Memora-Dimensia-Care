import 'base_auth_service.dart';
import '../auth_service.dart';

class PatientAuthService extends BaseAuthService {
  @override
  Future<Map<String, dynamic>> signup(Map<String, dynamic> userData) async {
    try {
      _validatePatientData(userData);
      Map<String, dynamic> result = await _performPatientSignup(userData);

      if (result['success']) {
        await AuthService.login('patient',
            token: result['token'],
            userData: result['user']
        );
      }

      return result;
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  void _validatePatientData(Map<String, dynamic> userData) {
    List<String> requiredFields = [
      'email', 'password', 'firstName', 'lastName',
      'dateOfBirth', 'emergencyContact', 'medicalConditions'
    ];

    for (String field in requiredFields) {
      if (!userData.containsKey(field) ||
          userData[field] == null ||
          userData[field].toString().trim().isEmpty) {
        throw Exception('$field is required');
      }
    }

    if (!BaseAuthService.isValidEmail(userData['email'])) {
      throw Exception('Please enter a valid email address');
    }

    if (!BaseAuthService.isValidPassword(userData['password'])) {
      throw Exception('Password must be at least 6 characters long');
    }

    DateTime? birthDate = DateTime.tryParse(userData['dateOfBirth']);
    if (birthDate == null || birthDate.isAfter(DateTime.now())) {
      throw Exception('Please enter a valid date of birth');
    }
  }

  Future<Map<String, dynamic>> _performPatientSignup(Map<String, dynamic> userData) async {
    await Future.delayed(Duration(seconds: 2)); // Simulate API call

    return {
      'success': true,
      'token': 'patient_token_${DateTime.now().millisecondsSinceEpoch}',
      'user': {
        ...userData,
        'id': 'patient_${DateTime.now().millisecondsSinceEpoch}',
        'role': 'patient',
        'createdAt': DateTime.now().toIso8601String(),
      }..remove('password'),
    };
  }
}