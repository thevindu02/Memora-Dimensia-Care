import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_constants.dart';

class DailyActivity {
  final int careActivityId;
  final int dailyTaskId;
  final String taskName;
  final String time;
  final String? description;
  final String status;

  DailyActivity({
    required this.careActivityId,
    required this.dailyTaskId,
    required this.taskName,
    required this.time,
    this.description,
    required this.status,
  });

  factory DailyActivity.fromJson(Map<String, dynamic> json) {
    return DailyActivity(
      careActivityId: json['careActivityId'],
      dailyTaskId: json['dailyTaskId'],
      taskName: json['taskName'],
      time: json['time'],
      description: json['description'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'careActivityId': careActivityId,
      'dailyTaskId': dailyTaskId,
      'taskName': taskName,
      'time': time,
      'description': description,
      'status': status,
    };
  }
}

class DailyActivityRequest {
  final String taskName;
  final String time;
  final String? description;

  DailyActivityRequest({
    required this.taskName,
    required this.time,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {'taskName': taskName, 'time': time, 'description': description};
  }
}

class ApiResult<T> {
  final bool success;
  final String message;
  final T? data;

  ApiResult({required this.success, required this.message, this.data});

  factory ApiResult.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResult<T>(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: fromJsonT != null && json['data'] != null
          ? fromJsonT(json['data'])
          : null,
    );
  }
}

class DailyActivityService {
  static const String baseUrl = ApiConstants.baseUrl;

  static Future<ApiResult<DailyActivity>> addDailyActivity(
    int scheduleId,
    DailyActivityRequest request,
  ) async {
    try {
      final url = Uri.parse(
        '$baseUrl/api/schedules/$scheduleId/daily-activities',
      );

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseData['success'] == true && responseData['data'] != null) {
          return ApiResult<DailyActivity>(
            success: true,
            message:
                responseData['message'] ?? 'Daily activity added successfully',
            data: DailyActivity.fromJson(responseData['data']),
          );
        } else {
          return ApiResult<DailyActivity>(
            success: false,
            message: responseData['message'] ?? 'Failed to add daily activity',
          );
        }
      } else {
        return ApiResult<DailyActivity>(
          success: false,
          message: responseData['message'] ?? 'Server error occurred',
        );
      }
    } catch (e) {
      print('Error adding daily activity: $e');
      return ApiResult<DailyActivity>(
        success: false,
        message: 'Network error: Unable to add daily activity',
      );
    }
  }

  static Future<ApiResult<List<DailyActivity>>> getDailyActivities(
    int scheduleId,
  ) async {
    try {
      final url = Uri.parse(
        '$baseUrl/api/schedules/$scheduleId/daily-activities',
      );

      final response = await http
          .get(url, headers: {'Content-Type': 'application/json'})
          .timeout(Duration(seconds: 10));

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseData['success'] == true && responseData['data'] != null) {
          List<dynamic> activitiesJson = responseData['data'];
          List<DailyActivity> activities = activitiesJson
              .map((json) => DailyActivity.fromJson(json))
              .toList();

          return ApiResult<List<DailyActivity>>(
            success: true,
            message:
                responseData['message'] ??
                'Daily activities retrieved successfully',
            data: activities,
          );
        } else {
          return ApiResult<List<DailyActivity>>(
            success: false,
            message:
                responseData['message'] ??
                'Failed to retrieve daily activities',
            data: [],
          );
        }
      } else {
        return ApiResult<List<DailyActivity>>(
          success: false,
          message: responseData['message'] ?? 'Server error occurred',
          data: [],
        );
      }
    } catch (e) {
      print('Error retrieving daily activities: $e');
      return ApiResult<List<DailyActivity>>(
        success: false,
        message: 'Network error: Unable to retrieve daily activities',
        data: [],
      );
    }
  }

  static Future<ApiResult<DailyActivity>> updateDailyActivity(
    int careActivityId,
    DailyActivityRequest request,
  ) async {
    try {
      final url = Uri.parse(
        '$baseUrl/api/schedules/daily-activities/$careActivityId',
      );

      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseData['success'] == true && responseData['data'] != null) {
          return ApiResult<DailyActivity>(
            success: true,
            message:
                responseData['message'] ??
                'Daily activity updated successfully',
            data: DailyActivity.fromJson(responseData['data']),
          );
        } else {
          return ApiResult<DailyActivity>(
            success: false,
            message:
                responseData['message'] ?? 'Failed to update daily activity',
          );
        }
      } else {
        return ApiResult<DailyActivity>(
          success: false,
          message: responseData['message'] ?? 'Server error occurred',
        );
      }
    } catch (e) {
      print('Error updating daily activity: $e');
      return ApiResult<DailyActivity>(
        success: false,
        message: 'Network error: Unable to update daily activity',
      );
    }
  }

  static Future<ApiResult<void>> deleteDailyActivity(int careActivityId) async {
    try {
      final url = Uri.parse(
        '$baseUrl/api/schedules/daily-activities/$careActivityId',
      );

      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return ApiResult<void>(
          success: true,
          message:
              responseData['message'] ?? 'Daily activity deleted successfully',
        );
      } else {
        return ApiResult<void>(
          success: false,
          message: responseData['message'] ?? 'Server error occurred',
        );
      }
    } catch (e) {
      print('Error deleting daily activity: $e');
      return ApiResult<void>(
        success: false,
        message: 'Network error: Unable to delete daily activity',
      );
    }
  }
}
