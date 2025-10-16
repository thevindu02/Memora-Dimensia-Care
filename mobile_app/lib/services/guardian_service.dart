import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_constants.dart';

class GuardianService {
  static final String baseUrl = '${ApiConstants.baseUrl}/api/guardians';

  /// Gets the guardianId for a given userId. Returns the id as int, or null if not found.
  static Future<int?> getGuardianIdByUserId(int userId) async {
    final url = Uri.parse('$baseUrl/by-user/$userId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return int.tryParse(response.body);
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getGuardianDetailsById(
    int guardianId,
  ) async {
    final url = Uri.parse('$baseUrl/$guardianId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      return null;
    }
  }

  /// Sends a caregiver connection request. Returns true if successful, false otherwise.
  static Future<bool> sendCaregiverConnectionRequest({
    required int guardianId,
    required int patientId,
    required int caregiverId, // <-- back to id
  }) async {
    final url = Uri.parse('$baseUrl/send-caregiver-connection-request');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'guardianId': guardianId,
        'patientId': patientId,
        'caregiverId': caregiverId, // <-- send id
      }),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<String> addKnownCaregiver({
    required int guardianId,
    required int patientId,
    required String caregiverEmail,
  }) async {
    final url = '${ApiConstants.baseUrl}/api/guardians/add-known-caregiver';
    final body = {
      'guardianId': guardianId,
      'patientId': patientId,
      'caregiverEmail': caregiverEmail,
    };
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response.body;
      }
    } catch (e) {
      return 'Network error: $e';
    }
  }

  /// Sends a guardian connection email to the patient. Returns true if successful, false otherwise.
  static Future<Map<String, dynamic>> sendGuardianConnectionEmail({
    required String patientEmail,
    required String patientName,
    required String guardianName,
    required String guardianEmail,
    required String relationship,
  }) async {
    final url = Uri.parse('$baseUrl/send-guardian-connection-email');
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'patientEmail': patientEmail,
          'patientName': patientName,
          'guardianName': guardianName,
          'guardianEmail': guardianEmail,
          'relationship': relationship,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        return {
          'success': true,
          'message': responseData['message'] ?? 'Email sent successfully',
          'connectionToken': responseData['connectionToken'],
        };
      } else {
        final errorData = jsonDecode(response.body) as Map<String, dynamic>;
        return {
          'success': false,
          'message': errorData['message'] ?? 'Failed to send email',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  /// Gets guardian connection details by token for the patient guardian request screen
  static Future<Map<String, dynamic>> getGuardianConnectionDetails(String token) async {
    final url = Uri.parse('$baseUrl/connection-request/$token');
    
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        return {
          'success': true,
          'data': responseData,
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData is String ? errorData : errorData['message'] ?? 'Failed to get connection details',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }
}
