import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_result.dart';
import 'api_constants.dart';

class ScheduleService {
  /// Mark a schedule as completed
  /// Returns ApiResult with success/failure information
  static Future<ApiResult<Map<String, dynamic>>> completeSchedule(
    int scheduleId,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConstants.baseUrl}/api/schedules/$scheduleId/completion?isCompleted=true'),
        headers: {'Content-Type': 'application/json'},
      );

      print('Schedule completeSchedule - Status code: ${response.statusCode}');
      print('Schedule completeSchedule - Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          return ApiResult<Map<String, dynamic>>(
            success: true,
            data: responseData['data'],
            message: responseData['message'] ?? 'Schedule completed successfully',
          );
        } else {
          return ApiResult<Map<String, dynamic>>(
            success: false,
            message: responseData['message'] ?? 'Failed to complete schedule',
          );
        }
      } else {
        final responseData = json.decode(response.body);
        return ApiResult<Map<String, dynamic>>(
          success: false,
          message: responseData['message'] ?? 'Failed to complete schedule - HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error completing schedule: $e');
      return ApiResult<Map<String, dynamic>>(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  /// Get or create a schedule for a patient on a specific date
  /// Returns ApiResult with schedule data (scheduleId, patientId, date, isCompleted)
  static Future<ApiResult<Map<String, dynamic>>> getOrCreateSchedule(
    int patientId,
    String date, // Format: YYYY-MM-DD
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/api/schedules/get-or-create'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'patientId': patientId,
          'date': date,
        }),
      );

      print('Schedule getOrCreateSchedule - Status code: ${response.statusCode}');
      print('Schedule getOrCreateSchedule - Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          return ApiResult<Map<String, dynamic>>(
            success: true,
            data: responseData['data'],
            message: responseData['message'] ?? 'Schedule retrieved successfully',
          );
        } else {
          return ApiResult<Map<String, dynamic>>(
            success: false,
            message: responseData['message'] ?? 'Failed to get or create schedule',
          );
        }
      } else {
        final responseData = json.decode(response.body);
        return ApiResult<Map<String, dynamic>>(
          success: false,
          message: responseData['message'] ?? 'Failed to get or create schedule - HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error getting or creating schedule: $e');
      return ApiResult<Map<String, dynamic>>(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  /// Move a care activity to a different schedule
  /// Returns ApiResult with updated care activity data
  static Future<ApiResult<Map<String, dynamic>>> moveCareActivityToSchedule(
    int careActivityId,
    int newScheduleId,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConstants.baseUrl}/api/care-activities/$careActivityId/schedule'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'scheduleId': newScheduleId,
        }),
      );

      print('Schedule moveCareActivityToSchedule - Status code: ${response.statusCode}');
      print('Schedule moveCareActivityToSchedule - Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          return ApiResult<Map<String, dynamic>>(
            success: true,
            data: responseData['data'],
            message: responseData['message'] ?? 'Care activity moved successfully',
          );
        } else {
          return ApiResult<Map<String, dynamic>>(
            success: false,
            message: responseData['message'] ?? 'Failed to move care activity',
          );
        }
      } else {
        final responseData = json.decode(response.body);
        return ApiResult<Map<String, dynamic>>(
          success: false,
          message: responseData['message'] ?? 'Failed to move care activity - HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error moving care activity: $e');
      return ApiResult<Map<String, dynamic>>(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }
}
