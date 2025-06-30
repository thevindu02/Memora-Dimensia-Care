import 'base_auth_service.dart';
import '../auth_service.dart';

class GuardianAuthService extends BaseAuthService {
  @override
  Future<Map<String, dynamic>> signup(Map<String, dynamic> userData) async {
    try {
      _validateGuardianData(userData);
      Map<String, dynamic> result = await _performGuardianSignup(userData);

      if (result['success']) {
        await AuthService.login('guardian',
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

  void _validateGuardianData(Map<String, dynamic> userData) {
    List<String> requiredFields = [
      'email', 'password', 'firstName', 'lastName',
      'relationship', 'patientId', 'phoneNumber'
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

    if (!RegExp(r'^\+?[\d\s\-\(\)]+$').hasMatch(userData['phoneNumber'])) {
      throw Exception('Please enter a valid phone number');
    }
  }

  Future<Map<String, dynamic>> _performGuardianSignup(Map<String, dynamic> userData) async {
    await Future.delayed(Duration(seconds: 2));

    return {
      'success': true,
      'token': 'guardian_token_${DateTime.now().millisecondsSinceEpoch}',
      'user': {
        ...userData,
        'id': 'guardian_${DateTime.now().millisecondsSinceEpoch}',
        'role': 'guardian',
        'createdAt': DateTime.now().toIso8601String(),
      }..remove('password'),
    };
  }
}
