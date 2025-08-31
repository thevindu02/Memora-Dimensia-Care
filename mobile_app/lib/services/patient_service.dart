import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_constants.dart';

class PatientService {
  static final String baseUrl = '${ApiConstants.baseUrl}/api/patients';

  // Add a new patient
  static Future<PatientResult> addPatient({
    required int userId,
    required String dementiaStage, // must be backend enum value (e.g. "MILD")
    required String dateOfDiagnosis, // Format: 'YYYY-MM-DD'
    required String dementiaType, // must be backend enum value (e.g. "ALZHEIMERS_DISEASE")
    required int guardianId,
    required String relationship,
  }) async {
    final body = {
      "userId": userId,
      "dementiaStage": dementiaStage,
      "dateOfDiagnosis": dateOfDiagnosis,
      "dementiaType": dementiaType,
      "guardianId": guardianId,
      "relationship": relationship,
    };

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return PatientResult(
          success: true,
          message: "Patient added successfully",
        );
      } else {
        final responseData = jsonDecode(response.body);
        return PatientResult(
          success: false,
          message: responseData['message'] ?? 'Failed to add patient',
        );
      }
    } catch (e) {
      return PatientResult(success: false, message: 'Network error: $e');
    }
  }

  // Get a patient by ID
  static Future<PatientResult> getPatient(int patientId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$patientId'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PatientResult(success: true, message: "Success", data: data);
      } else {
        return PatientResult(success: false, message: "Patient not found");
      }
    } catch (e) {
      return PatientResult(success: false, message: 'Network error: $e');
    }
  }

  // Delete a patient by ID
  static Future<PatientResult> deletePatient(int patientId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$patientId'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 204) {
        return PatientResult(
          success: true,
          message: "Patient deleted successfully",
        );
      } else {
        return PatientResult(
          success: false,
          message: "Failed to delete patient",
        );
      }
    } catch (e) {
      return PatientResult(success: false, message: 'Network error: $e');
    }
  }

  // Fetch all patients for a specific guardian
  static Future<List<dynamic>> getPatientsByGuardian(int guardianId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/by-guardian/$guardianId'),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // Fetch patients with request status
  static Future<List<dynamic>> getPatientsWithRequestStatus(
    int guardianId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${ApiConstants.baseUrl}/api/guardians/$guardianId/patients-with-request-status',
        ),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // Update patient profile
  static Future<PatientResult> updateProfile({
    required int patientId,
    required String fName,
    required String lName,
    required String birthdate, // must be 'YYYY-MM-DD'
    required String gender,
    required String phoneNumber,
    required String street,
    required String city,
    required String state,
    required String email,
    required String dementiaType, // must be backend enum
    required String dementiaStage, // must be backend enum
    required String label,
    String? profilePic,
  }) async {
    final url = Uri.parse('$baseUrl/$patientId/edit-profile');

    final body = {
      'FName': fName,
      'LName': lName,
      'birthdate': birthdate,
      'gender': gender,
      'phoneNumber': phoneNumber,
      'street': street,
      'city': city,
      'state': state,
      'email': email,
      'dementiaType': dementiaType,
      'dementiaStage': dementiaStage,
      'label': label,
      'profilePic': profilePic ?? '',
    };

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return PatientResult(success: true, message: "Patient updated successfully");
      } else {
        final responseData = jsonDecode(response.body);
        return PatientResult(
          success: false,
          message: responseData['message'] ?? 'Failed to update patient',
        );
      }
    } catch (e) {
      return PatientResult(success: false, message: 'Network error: $e');
    }
  }

  // Get patient profile
  static Future<PatientResult> getPatientProfile(int patientId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$patientId'),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PatientResult(success: true, message: "Success", data: data);
      } else {
        return PatientResult(success: false, message: "Patient not found");
      }
    } catch (e) {
      return PatientResult(success: false, message: 'Network error: $e');
    }
  }
}

// Result class for patient operations
class PatientResult {
  final bool success;
  final String message;
  final dynamic data;

  PatientResult({required this.success, required this.message, this.data});
}

