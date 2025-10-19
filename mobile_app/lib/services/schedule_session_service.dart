import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_constants.dart';

class ScheduleSessionService {
  static const String baseUrl = '${ApiConstants.baseUrl}/api/schedule-sessions';

  static Future<ScheduleSessionResult> createScheduleSession({
    required DateTime sessionDate,
    required String sessionTime,
    required String sessionTopic,
    String? description,
    String? meetingLink,
  }) async {
    try {
      // Format date to YYYY-MM-DD
      String formattedDate =
          '${sessionDate.year}-${sessionDate.month.toString().padLeft(2, '0')}-${sessionDate.day.toString().padLeft(2, '0')}';

      // Format time to HH:MM:SS
      String formattedTime = '$sessionTime:00';

      final requestBody = {
        'sessionDate': formattedDate,
        'sessionTime': formattedTime,
        'sessionTopic': sessionTopic,
        'description': description ?? '',
        'meetingLink': meetingLink ?? '',
      };

      print('Sending request to: $baseUrl');
      print('Request body: ${jsonEncode(requestBody)}');

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return ScheduleSessionResult(
          success: true,
          message: 'Session scheduled successfully!',
          sessionId: responseData['id'],
        );
      } else if (response.statusCode == 400) {
        final responseData = jsonDecode(response.body);
        return ScheduleSessionResult(
          success: false,
          message: responseData['message'] ?? 'Invalid data provided',
        );
      } else {
        return ScheduleSessionResult(
          success: false,
          message: 'Failed to schedule session. Please try again.',
        );
      }
    } catch (e) {
      print('Error scheduling session: $e');
      return ScheduleSessionResult(
        success: false,
        message: 'Network error. Please check your connection and try again.',
      );
    }
  }
}

class ScheduleSessionResult {
  final bool success;
  final String message;
  final int? sessionId;

  ScheduleSessionResult({
    required this.success,
    required this.message,
    this.sessionId,
  });
}
