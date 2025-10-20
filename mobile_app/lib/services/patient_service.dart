import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_constants.dart';
import '../models/patient_profile.dart';
import '../models/schedule_task.dart';
import 'api_constants.dart';

class PatientService {
  static final String url = '${ApiConstants.baseUrl}/api/patients';
  static final String baseUrl = '${ApiConstants.baseUrl}/api/patients';
  static const storage = FlutterSecureStorage();

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
        final responseData = jsonDecode(response.body);

        print('=== Patient Service Debug ===');
        print('Backend response: $responseData');
        print('Keys available: ${responseData.keys}');

        // Try both patientId (lowercase) and patientID (uppercase)
        // Backend getter is getPatientID() which serializes to "patientID"
        final patientId =
            responseData['patientId'] ?? responseData['patientID'];

        print('Extracted patientId: $patientId');
        print('Type: ${patientId?.runtimeType}');
        print('=============================');

        return PatientResult(
          success: true,
          message: "Patient added successfully",
          patientId: patientId,
          data: responseData,
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

  // Get patient profile
  static Future<PatientProfile> getPatientProfile(int patientId) async {
    try {
      String? token;
      try {
        token = await storage.read(key: 'auth_token');
      } catch (e) {
        print('Warning: Could not read auth token: $e');
        // Continue without token
      }
      
      final response = await http.get(
        Uri.parse('$url/$patientId/profile'),
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return PatientProfile.fromJson(data);
      } else {
        throw Exception('Failed to load patient profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading patient profile: $e');
    }
  }

  // Get patient ID by user ID
  static Future<int?> getPatientIdByUserId(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/api/patients/user/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['patientId'] as int?;
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting patient ID: $e');
      return null;
    }
  }

  // Get schedule for a specific date
  static Future<List<ScheduleTask>> getScheduleForDate(int patientId, String date) async {
    try {
      String? token;
      try {
        token = await storage.read(key: 'auth_token');
      } catch (e) {
        print('Warning: Could not read auth token: $e');
        // Continue without token
      }
      
      final response = await http.get(
        Uri.parse('$url/$patientId/schedule?date=$date'),
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => ScheduleTask.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load schedule: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading schedule: $e');
    }
  }

  // Create a new task
  static Future<ScheduleTask> createTask(int patientId, Map<String, dynamic> taskData) async {
    try {
      String? token;
      try {
        token = await storage.read(key: 'auth_token');
      } catch (e) {
        print('Warning: Could not read auth token: $e');
        // Continue without token
      }
      
      final response = await http.post(
        Uri.parse('$url/$patientId/tasks'),
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(taskData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return ScheduleTask.fromJson(data);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to create task');
      }
    } catch (e) {
      throw Exception('Error creating task: $e');
    }
  }

  // Update task status
  static Future<void> updateTaskStatus(
    int careActivityId,
    String status, {
    String? skipReason,
  }) async {
    try {
      String? token;
      try {
        token = await storage.read(key: 'auth_token');
      } catch (e) {
        print('Warning: Could not read auth token: $e');
        // Continue without token
      }
      
      final body = {
        'status': status,
        if (skipReason != null) 'skipReason': skipReason,
      };

      final response = await http.put(
        Uri.parse('${ApiConstants.baseUrl}/api/patients/tasks/$careActivityId/status'),
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      if (response.statusCode != 200) {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to update task status');
      }
    } catch (e) {
      throw Exception('Error updating task status: $e');
    }
  }

  // Helper method to format date for API
  static String formatDateForApi(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

// Result class for patient operations
class PatientResult {
  final bool success;
  final String message;
  final int? patientId;
  final dynamic data;

  PatientResult({
    required this.success,
    required this.message,
    this.patientId,
    this.data,
  });
}
