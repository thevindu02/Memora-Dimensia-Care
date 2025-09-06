import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_constants.dart';

class CaregiverService {
  static final String url = '${ApiConstants.baseUrl}/api/caregivers';

  static Future<List<Map<String, dynamic>>> getCaregiversByCity(
    String city,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$url/by-city/$city'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load caregivers: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load caregivers: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getAllCaregivers() async {
    try {
      final response = await http.get(
        Uri.parse('$url/all'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        // Add 'name' field to each caregiver map
        return data.map<Map<String, dynamic>>((c) {
          final map = Map<String, dynamic>.from(c);
          final fName = map['fName'] ?? '';
          final lName = map['lName'] ?? '';
          map['name'] = (fName + ' ' + lName).trim();
          return map;
        }).toList();
      } else {
        throw Exception('Failed to load caregivers: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load caregivers: $e');
    }
  }

  static Future<Map<String, dynamic>> getCaregiverById(int caregiverId) async {
    try {
      final response = await http.get(
        Uri.parse('$url/$caregiverId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load caregiver: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load caregiver: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getPendingRequests(
    int caregiverId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$url/$caregiverId/pending-requests'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception(
          'Failed to load pending requests: \\${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to load pending requests: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getConnectedRequests(
    int caregiverId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$url/$caregiverId/connected-requests'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception(
          'Failed to load connected requests: \\${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to load connected requests: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getAvailableCaregiversForPatient(
    int patientId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$url/available-for-patient/$patientId'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map<Map<String, dynamic>>((c) {
          final map = Map<String, dynamic>.from(c);
          final fName = map['fName'] ?? '';
          final lName = map['lName'] ?? '';
          map['name'] = (fName + ' ' + lName).trim();
          return map;
        }).toList();
      } else {
        throw Exception('Failed to load caregivers: \\${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load caregivers: $e');
    }
  }

  static Future<int?> getCaregiverIdByUserId(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$url/by-user/$userId'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return int.tryParse(response.body);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<void> acceptConnectionRequest(int connectionId) async {
    final response = await http.post(
      Uri.parse('$url/connection-request/$connectionId/accept'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to accept request');
    }
  }

  static Future<void> rejectConnectionRequest(int connectionId) async {
    final response = await http.post(
      Uri.parse('$url/connection-request/$connectionId/reject'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to reject request');
    }
  }

  static Future<Map<String, dynamic>?> getPatientDetails(int patientId) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/api/patients/$patientId'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  static Future<bool> updateProfile({
    required int caregiverId,
    required String fName,
    required String lName,
    required String email,
    required String phoneNumber,
    required String gender,
    required String birthdate,
    required String street,
    required String city,
    required String state,
    required String profilePic,
    required String experience,
    required String qualifications,
    required List<String> skills,
  }) async {
    final url = Uri.parse(
        '${ApiConstants.baseUrl}/api/caregivers/$caregiverId/edit-profile');
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
      'profilePic': profilePic,
      'experience': experience,
      'qualifications': qualifications,
      'skills': skills,
    };
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    return response.statusCode == 200;
  }

  static Future<List<Map<String, dynamic>>> getExpiredInactiveCaregivers() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/api/caregivers/expired-inactive'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load expired caregivers');
    }
  }
}
