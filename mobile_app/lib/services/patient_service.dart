import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_constants.dart';

class PatientService {
  static final String url = '${ApiConstants.baseUrl}/api/patients';
  // Add a new patient
  static Future<PatientResult> addPatient({
    required int userId,
    required String dementiaStage,
    required String dateOfDiagnosis, // Format: 'YYYY-MM-DD'
    required String dementiaType,
    required int guardianId, // <-- Add this
    required String relationship, // <-- Add this
  }) async {
    final body = {
      "userId": userId,
      "dementiaStage": dementiaStage,
      "dateOfDiagnosis": dateOfDiagnosis,
      "dementiaType": dementiaType,
      "guardianId": guardianId, // <-- Add this
      "relationship": relationship, // <-- Add this
    };

    try {
      final response = await http.post(
        Uri.parse(url),
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
        Uri.parse('$url/$patientId'),
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
        Uri.parse('$url/$patientId'),
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
        Uri.parse('$url/by-guardian/$guardianId'),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        // Optionally handle error response
        return [];
      }
    } catch (e) {
      // Optionally handle network error
      return [];
    }
  }

  // Fetch all patients for a specific guardian with their latest connection request status
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
}

// Result class for patient operations
class PatientResult {
  final bool success;
  final String message;
  final dynamic data;

  PatientResult({required this.success, required this.message, this.data});
}
