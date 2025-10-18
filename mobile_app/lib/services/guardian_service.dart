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

  /// Cancels a pending connection request. Returns true if successful, false otherwise.
  static Future<bool> cancelConnectionRequest(int connectionId) async {
    final url = Uri.parse('$baseUrl/cancel-connection-request/$connectionId');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
    );
    return response.statusCode == 200;
  }

  static Future<bool> updateProfile({
    required int guardianId,
    required String fName,
    required String lName,
    required String email,
    required String phoneNumber,
    required String gender,
    required String birthdate,
    required String street,
    required String city,
    required String state,
    String? profilePic,
  }) async {
    final url = Uri.parse('$baseUrl/$guardianId/edit-profile');
    final body = {
      'fName': fName,
      'lName': lName,
      'email': email,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'birthdate': birthdate,
      'street': street,
      'city': city,
      'state': state,
      'profilePic': profilePic ?? '',
    };
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    return response.statusCode == 200;
  }

  static Future<List<Map<String, dynamic>>> getAllCaregiversForGuardian(int guardianId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$guardianId/all-caregivers'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map<Map<String, dynamic>>((c) => Map<String, dynamic>.from(c)).toList();
      } else {
        throw Exception('Failed to load caregivers: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load caregivers: $e');
    }
  }
}
