import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationApiService {
  // Update this with your actual backend URL
  static const String baseUrl = 'http://10.0.2.2:8080/api/notifications';

  // Get authentication token
  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  // Get caregiver ID from local storage
  Future<int?> _getCaregiverId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId'); // Adjust key as needed
  }

  // Get patient ID from local storage
  Future<int?> _getPatientId() async {
    final prefs = await SharedPreferences.getInstance();
    final patientId = prefs.getInt('patientId');
    print('🔑 Retrieved patientId from prefs: $patientId');
    return patientId; // Use stored patientId
  }

  // Fetch all notifications for caregiver
  Future<List<NotificationModel>> getCaregiverNotifications() async {
    try {
      final caregiverId = await _getCaregiverId();
      if (caregiverId == null) {
        throw Exception('Caregiver ID not found');
      }

      final token = await _getAuthToken();
      final response = await http.get(
        Uri.parse('$baseUrl/caregiver/$caregiverId'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        return jsonList
            .map((json) => NotificationModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load notifications: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching notifications: $e');
      rethrow;
    }
  }

  // Fetch unread notifications
  Future<List<NotificationModel>> getUnreadNotifications() async {
    try {
      final caregiverId = await _getCaregiverId();
      if (caregiverId == null) {
        throw Exception('Caregiver ID not found');
      }

      final token = await _getAuthToken();
      final response = await http.get(
        Uri.parse('$baseUrl/caregiver/$caregiverId/unread'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        return jsonList
            .map((json) => NotificationModel.fromJson(json))
            .toList();
      } else {
        throw Exception(
          'Failed to load unread notifications: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching unread notifications: $e');
      rethrow;
    }
  }

  // Fetch read notifications
  Future<List<NotificationModel>> getReadNotifications() async {
    try {
      final caregiverId = await _getCaregiverId();
      if (caregiverId == null) {
        throw Exception('Caregiver ID not found');
      }

      final token = await _getAuthToken();
      final response = await http.get(
        Uri.parse('$baseUrl/caregiver/$caregiverId/read'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        return jsonList
            .map((json) => NotificationModel.fromJson(json))
            .toList();
      } else {
        throw Exception(
          'Failed to load read notifications: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching read notifications: $e');
      rethrow;
    }
  }

  // Mark notification as read
  Future<void> markAsRead(int notificationId) async {
    try {
      final token = await _getAuthToken();
      final response = await http.put(
        Uri.parse('$baseUrl/$notificationId/read'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to mark as read: ${response.statusCode}');
      }
    } catch (e) {
      print('Error marking notification as read: $e');
      rethrow;
    }
  }

  // Delete notification
  Future<void> deleteNotification(int notificationId) async {
    try {
      final token = await _getAuthToken();
      final response = await http.delete(
        Uri.parse('$baseUrl/$notificationId'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to delete notification: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error deleting notification: $e');
      rethrow;
    }
  }

  // Get unread count
  Future<int> getUnreadCount() async {
    try {
      final caregiverId = await _getCaregiverId();
      if (caregiverId == null) {
        throw Exception('Caregiver ID not found');
      }

      final token = await _getAuthToken();
      final response = await http.get(
        Uri.parse('$baseUrl/caregiver/$caregiverId/count'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['count'] ?? 0;
      } else {
        throw Exception('Failed to get unread count: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting unread count: $e');
      return 0;
    }
  }

  // Mark all as read
  Future<void> markAllAsRead() async {
    try {
      final caregiverId = await _getCaregiverId();
      if (caregiverId == null) {
        throw Exception('Caregiver ID not found');
      }

      final token = await _getAuthToken();
      final response = await http.put(
        Uri.parse('$baseUrl/caregiver/$caregiverId/read-all'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to mark all as read: ${response.statusCode}');
      }
    } catch (e) {
      print('Error marking all as read: $e');
      rethrow;
    }
  }

  // ========== PATIENT NOTIFICATION METHODS ==========

  // Fetch all notifications for patient
  Future<List<NotificationModel>> getPatientNotifications() async {
    try {
      final patientId = await _getPatientId();
      print('📱 getPatientNotifications - patientId: $patientId');

      if (patientId == null) {
        print('❌ Patient ID is null - cannot fetch notifications');
        throw Exception('Patient ID not found');
      }

      final token = await _getAuthToken();
      final url = '$baseUrl/patient/$patientId';
      print('🌐 Fetching patient notifications from: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      print('📡 Response status: ${response.statusCode}');
      print('📡 Response body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        print('✅ Successfully loaded ${jsonList.length} patient notifications');
        return jsonList
            .map((json) => NotificationModel.fromJson(json))
            .toList();
      } else {
        print('❌ Failed to load notifications: ${response.statusCode}');
        throw Exception('Failed to load notifications: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching patient notifications: $e');
      rethrow;
    }
  }

  // Fetch unread notifications for patient
  Future<List<NotificationModel>> getPatientUnreadNotifications() async {
    try {
      final patientId = await _getPatientId();
      if (patientId == null) {
        throw Exception('Patient ID not found');
      }

      final token = await _getAuthToken();
      final response = await http.get(
        Uri.parse('$baseUrl/patient/$patientId/unread'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        return jsonList
            .map((json) => NotificationModel.fromJson(json))
            .toList();
      } else {
        throw Exception(
          'Failed to load unread notifications: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching patient unread notifications: $e');
      rethrow;
    }
  }

  // Fetch read notifications for patient
  Future<List<NotificationModel>> getPatientReadNotifications() async {
    try {
      final patientId = await _getPatientId();
      if (patientId == null) {
        throw Exception('Patient ID not found');
      }

      final token = await _getAuthToken();
      final response = await http.get(
        Uri.parse('$baseUrl/patient/$patientId/read'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        return jsonList
            .map((json) => NotificationModel.fromJson(json))
            .toList();
      } else {
        throw Exception(
          'Failed to load read notifications: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching patient read notifications: $e');
      rethrow;
    }
  }

  // Get unread count for patient
  Future<int> getPatientUnreadCount() async {
    try {
      final patientId = await _getPatientId();
      if (patientId == null) {
        throw Exception('Patient ID not found');
      }

      final token = await _getAuthToken();
      final response = await http.get(
        Uri.parse('$baseUrl/patient/$patientId/count'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['count'] ?? 0;
      } else {
        throw Exception('Failed to get unread count: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting patient unread count: $e');
      return 0;
    }
  }

  // Mark all as read for patient
  Future<void> markAllPatientNotificationsAsRead() async {
    try {
      final patientId = await _getPatientId();
      if (patientId == null) {
        throw Exception('Patient ID not found');
      }

      final token = await _getAuthToken();
      final response = await http.put(
        Uri.parse('$baseUrl/patient/$patientId/read-all'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to mark all as read: ${response.statusCode}');
      }
    } catch (e) {
      print('Error marking all patient notifications as read: $e');
      rethrow;
    }
  }
}

// Model class for notification
class NotificationModel {
  final int notificationId;
  final int caregiverId;
  final int patientId;
  final String patientName;
  final String title;
  final String message;
  final String notificationType;
  final int? taskId;
  final String? taskName;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.notificationId,
    required this.caregiverId,
    required this.patientId,
    required this.patientName,
    required this.title,
    required this.message,
    required this.notificationType,
    this.taskId,
    this.taskName,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationId: json['notificationId'],
      caregiverId: json['caregiverId'],
      patientId: json['patientId'],
      patientName: json['patientName'],
      title: json['title'],
      message: json['message'],
      notificationType: json['notificationType'],
      taskId: json['taskId'],
      taskName: json['taskName'],
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationId': notificationId,
      'caregiverId': caregiverId,
      'patientId': patientId,
      'patientName': patientName,
      'title': title,
      'message': message,
      'notificationType': notificationType,
      'taskId': taskId,
      'taskName': taskName,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
