import 'dart:convert';
import 'package:http/http.dart' as http;

// Task model
class Task {
  final int taskId;
  final int careActivityId;
  final int scheduleId;
  final String gameName;
  final int gameId;
  final String time;
  final String status;

  Task({
    required this.taskId,
    required this.careActivityId,
    required this.scheduleId,
    required this.gameName,
    required this.gameId,
    required this.time,
    required this.status,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      taskId: json['taskId'] ?? 0,
      careActivityId: json['careActivityId'] ?? 0,
      scheduleId: json['scheduleId'] ?? 0,
      gameName: json['gameName'] ?? '',
      gameId: json['gameId'] ?? 0,
      time: json['time'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taskId': taskId,
      'careActivityId': careActivityId,
      'scheduleId': scheduleId,
      'gameName': gameName,
      'gameId': gameId,
      'time': time,
      'status': status,
    };
  }
}

// API Result wrapper
class ApiResult<T> {
  final bool success;
  final T? data;
  final String message;
  final int? statusCode;

  ApiResult({
    required this.success,
    this.data,
    required this.message,
    this.statusCode,
  });
}

// Task Service for API calls
class TaskService {
  static const String baseUrl = 'http://192.168.8.166:8080';

  /// Create a new task
  static Future<ApiResult<Task>> createTask({
    required int scheduleId,
    required String gameName,
    required String time,
  }) async {
    try {
      print(
        'TaskService - Creating task: scheduleId=$scheduleId, gameName=$gameName, time=$time',
      );

      final response = await http.post(
        Uri.parse('$baseUrl/api/tasks'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'scheduleId': scheduleId,
          'gameName': gameName,
          'time': time,
        }),
      );

      print('TaskService - Response status: ${response.statusCode}');
      print('TaskService - Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final task = Task.fromJson(data);

        return ApiResult<Task>(
          success: true,
          data: task,
          message: 'Task created successfully',
          statusCode: response.statusCode,
        );
      } else {
        final errorData = jsonDecode(response.body);
        return ApiResult<Task>(
          success: false,
          message: errorData['error'] ?? 'Failed to create task',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('TaskService - Error creating task: $e');
      return ApiResult<Task>(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  /// Get tasks by schedule ID
  static Future<ApiResult<List<Task>>> getTasksByScheduleId(
    int scheduleId,
  ) async {
    try {
      print('TaskService - Getting tasks for schedule ID: $scheduleId');

      final response = await http
          .get(
            Uri.parse('$baseUrl/api/tasks/schedule/$scheduleId'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(Duration(seconds: 10));

      print('TaskService - Response status: ${response.statusCode}');
      print('TaskService - Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Task> tasks = data
            .map((json) => Task.fromJson(json))
            .toList();

        return ApiResult<List<Task>>(
          success: true,
          data: tasks,
          message: 'Tasks retrieved successfully',
          statusCode: response.statusCode,
        );
      } else {
        final errorData = jsonDecode(response.body);
        return ApiResult<List<Task>>(
          success: false,
          message: errorData['error'] ?? 'Failed to get tasks',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('TaskService - Error getting tasks: $e');
      return ApiResult<List<Task>>(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  /// Update task status
  static Future<ApiResult<Task>> updateTaskStatus(
    int taskId,
    String status,
  ) async {
    try {
      print('TaskService - Updating task $taskId status to: $status');

      final response = await http.put(
        Uri.parse('$baseUrl/api/tasks/$taskId/status'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'status': status}),
      );

      print('TaskService - Response status: ${response.statusCode}');
      print('TaskService - Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final task = Task.fromJson(data);

        return ApiResult<Task>(
          success: true,
          data: task,
          message: 'Task status updated successfully',
          statusCode: response.statusCode,
        );
      } else {
        final errorData = jsonDecode(response.body);
        return ApiResult<Task>(
          success: false,
          message: errorData['error'] ?? 'Failed to update task status',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('TaskService - Error updating task status: $e');
      return ApiResult<Task>(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  /// Delete a task
  static Future<ApiResult<String>> deleteTask(int taskId) async {
    try {
      print('TaskService - Deleting task: $taskId');

      final response = await http.delete(
        Uri.parse('$baseUrl/api/tasks/$taskId'),
        headers: {'Content-Type': 'application/json'},
      );

      print('TaskService - Response status: ${response.statusCode}');
      print('TaskService - Response body: ${response.body}');

      if (response.statusCode == 200) {
        return ApiResult<String>(
          success: true,
          data: 'Task deleted successfully',
          message: 'Task deleted successfully',
          statusCode: response.statusCode,
        );
      } else {
        final errorData = jsonDecode(response.body);
        return ApiResult<String>(
          success: false,
          message: errorData['error'] ?? 'Failed to delete task',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('TaskService - Error deleting task: $e');
      return ApiResult<String>(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }
}
