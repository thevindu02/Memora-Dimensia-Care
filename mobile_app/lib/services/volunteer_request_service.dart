import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_constants.dart';

class VolunteerRequestService {
  static final String baseUrl =
      '${ApiConstants.baseUrl}/api/volunteer-requests';

  static Future<VolunteerRequestResult> createVolunteerRequest({
    required String volunteerName,
    required String email,
    required String phoneNumber,
    required String gender,
    required String volunteerIdImage,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'volunteerName': volunteerName,
          'email': email,
          'phoneNumber': phoneNumber,
          'gender': gender,
          'volunteerIdImage': volunteerIdImage,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return VolunteerRequestResult(
          success: true,
          message: 'Volunteer request created successfully',
          volunteerId: data['volunteerId'] ?? 0, // <-- Extract volunteerId from response
          volunteerRequest: data,
        );
      } else {
        final responseData = jsonDecode(response.body);
        return VolunteerRequestResult(
          success: false,
          message: responseData['message'] ?? 'Failed to create volunteer request',
          volunteerId: 0,
        );
      }
    } catch (e) {
      return VolunteerRequestResult(
        success: false,
        message: 'Error creating volunteer request: $e',
        volunteerId: 0,
      );
    }
  }

  static Future<VolunteerRequestResult> getVolunteerRequestByUserId(
    int userId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return VolunteerRequestResult(
          success: true,
          message: 'Volunteer request retrieved successfully',
          volunteerId: data['volunteerId'] ?? 0,
          volunteerRequest: data,
        );
      } else if (response.statusCode == 404) {
        return VolunteerRequestResult(
          success: false,
          message: 'Volunteer request not found',
          volunteerId: 0,
        );
      } else {
        return VolunteerRequestResult(
          success: false,
          message: 'Failed to retrieve volunteer request',
          volunteerId: 0,
        );
      }
    } catch (e) {
      return VolunteerRequestResult(
        success: false,
        message: 'Error retrieving volunteer request: $e',
        volunteerId: 0,
      );
    }
  }

  static Future<VolunteerRequestResult> getVolunteerRequestsByStatus(
    String status,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/status/$status'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return VolunteerRequestResult(
          success: true,
          message: 'Volunteer requests retrieved successfully',
          volunteerId: 0,
          volunteerRequests: data,
        );
      } else {
        return VolunteerRequestResult(
          success: false,
          message: 'Failed to retrieve volunteer requests',
          volunteerId: 0,
        );
      }
    } catch (e) {
      return VolunteerRequestResult(
        success: false,
        message: 'Error retrieving volunteer requests: $e',
        volunteerId: 0,
      );
    }
  }

  static Future<VolunteerRequestResult> updateRequestStatus({
    required int requestId,
    required String status,
    String? adminNotes,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$requestId/status'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'status': status,
          if (adminNotes != null) 'adminNotes': adminNotes,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return VolunteerRequestResult(
          success: true,
          message: 'Volunteer request status updated successfully',
          volunteerId: data['volunteerId'] ?? 0,
          volunteerRequest: data,
        );
      } else {
        final responseData = jsonDecode(response.body);
        return VolunteerRequestResult(
          success: false,
          message: responseData['message'] ?? 'Failed to update volunteer request status',
          volunteerId: 0,
        );
      }
    } catch (e) {
      return VolunteerRequestResult(
        success: false,
        message: 'Error updating volunteer request status: $e',
        volunteerId: 0,
      );
    }
  }
}

class VolunteerRequestResult {
  final bool success;
  final String message;
  final int volunteerId;
  final dynamic volunteerRequest;
  final dynamic volunteerRequests;

  VolunteerRequestResult({
    required this.success,
    required this.message,
    required this.volunteerId,
    this.volunteerRequest,
    this.volunteerRequests,
  });

  factory VolunteerRequestResult.fromJson(Map<String, dynamic> json) {
    return VolunteerRequestResult(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      volunteerId: json['volunteerId'] ?? 0,
      volunteerRequest: json['volunteerRequest'],
      volunteerRequests: json['volunteerRequests'],
    );
  }
}
