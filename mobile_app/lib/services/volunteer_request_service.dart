import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_constants.dart';

class VolunteerRequestService {
  static final String baseUrl =
      '${ApiConstants.baseUrl}/api/volunteer-requests';

  static Future<VolunteerRequestResult> createVolunteerRequest({
    required int userId,
    required String volunteerIdImage,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/api/users/volunteer-request'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'volunteerIdImage': volunteerIdImage,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return VolunteerRequestResult(
          success: true,
          message: 'Volunteer request created successfully',
          volunteerRequest: data,
        );
      } else {
        final responseData = jsonDecode(response.body);
        return VolunteerRequestResult(
          success: false,
          message:
              responseData['message'] ?? 'Failed to create volunteer request',
        );
      }
    } catch (e) {
      return VolunteerRequestResult(
        success: false,
        message: 'Error creating volunteer request: $e',
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
          volunteerRequest: data,
        );
      } else if (response.statusCode == 404) {
        return VolunteerRequestResult(
          success: false,
          message: 'Volunteer request not found',
        );
      } else {
        return VolunteerRequestResult(
          success: false,
          message: 'Failed to retrieve volunteer request',
        );
      }
    } catch (e) {
      return VolunteerRequestResult(
        success: false,
        message: 'Error retrieving volunteer request: $e',
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
          volunteerRequests: data,
        );
      } else {
        return VolunteerRequestResult(
          success: false,
          message: 'Failed to retrieve volunteer requests',
        );
      }
    } catch (e) {
      return VolunteerRequestResult(
        success: false,
        message: 'Error retrieving volunteer requests: $e',
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
          volunteerRequest: data,
        );
      } else {
        final responseData = jsonDecode(response.body);
        return VolunteerRequestResult(
          success: false,
          message:
              responseData['message'] ??
              'Failed to update volunteer request status',
        );
      }
    } catch (e) {
      return VolunteerRequestResult(
        success: false,
        message: 'Error updating volunteer request status: $e',
      );
    }
  }
}

class VolunteerRequestResult {
  final bool success;
  final String message;
  final dynamic volunteerRequest;
  final List<dynamic>? volunteerRequests;

  VolunteerRequestResult({
    required this.success,
    required this.message,
    this.volunteerRequest,
    this.volunteerRequests,
  });
}
