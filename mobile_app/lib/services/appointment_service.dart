import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_result.dart';
import 'api_constants.dart';

class AppointmentRequest {
  final String taskName;
  final String hospital;
  final String doctorName;
  final String description;
  final String date;
  final String time;

  AppointmentRequest({
    required this.taskName,
    required this.hospital,
    required this.doctorName,
    required this.description,
    required this.date,
    required this.time,
  });

  Map<String, dynamic> toJson() {
    return {
      'taskName': taskName,
      'hospital': hospital,
      'doctorName': doctorName,
      'description': description,
      'date': date,
      'time': time,
    };
  }
}

class Appointment {
  final int appointmentId;
  final int careActivityId;
  final String taskName;
  final String hospital;
  final String doctorName;
  final String description;
  final String date;
  final String time;
  final String status;

  Appointment({
    required this.appointmentId,
    required this.careActivityId,
    required this.taskName,
    required this.hospital,
    required this.doctorName,
    required this.description,
    required this.date,
    required this.time,
    required this.status,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      appointmentId: json['appointmentId'] ?? 0,
      careActivityId: json['careActivityId'] ?? 0,
      taskName: json['taskName'] ?? '',
      hospital: json['hospital'] ?? '',
      doctorName: json['doctorName'] ?? '',
      description: json['description'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      status: json['status'] ?? 'PENDING',
    );
  }
}

class AppointmentService {
  static Future<ApiResult<Appointment>> createAppointment(
    int scheduleId,
    AppointmentRequest request,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/api/appointments/schedule/$scheduleId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(request.toJson()),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true && responseData['data'] != null) {
          return ApiResult<Appointment>(
            success: true,
            data: Appointment.fromJson(responseData['data']),
            message:
                responseData['message'] ?? 'Appointment created successfully',
          );
        } else {
          return ApiResult<Appointment>(
            success: false,
            message: responseData['message'] ?? 'Failed to create appointment - Invalid response format',
          );
        }
      } else {
        // Try to parse error message from response
        String errorMessage = 'Failed to create appointment - Status code: ${response.statusCode}';
        try {
          final errorData = json.decode(response.body);
          if (errorData['message'] != null) {
            errorMessage = errorData['message'];
          }
        } catch (e) {
          errorMessage += ' - Response: ${response.body}';
        }
        
        return ApiResult<Appointment>(
          success: false,
          message: errorMessage,
        );
      }
    } catch (e) {
      print('Exception creating appointment: $e');
      return ApiResult<Appointment>(
        success: false,
        message: 'Error creating appointment: $e',
      );
    }
  }

  static Future<List<Appointment>> getAppointments(int scheduleId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/api/appointments/schedule/$scheduleId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Appointment.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load appointments');
      }
    } catch (e) {
      print('Error loading appointments: $e');
      return [];
    }
  }
}
