import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_result.dart';
import '../models/medication_reminder.dart';
import 'api_constants.dart';

class MedicationService {
  static Future<List<MedicationScheduleItem>> getMedicationSchedule(
    int scheduleId,
  ) async {
    try {
      final response = await http
          .get(
            Uri.parse(
              '${ApiConstants.baseUrl}/api/medications/schedule/$scheduleId',
            ),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        print('DEBUG: Medication API Response Status: ${response.statusCode}');
        print('DEBUG: Medication API Response Body: ${response.body}');

        final Map<String, dynamic> responseData = json.decode(response.body);

        // Check if response has success field and data field
        if (responseData['success'] == true && responseData['data'] != null) {
          final List<dynamic> data = responseData['data'];
          print('DEBUG: Found ${data.length} medications in response data');
          final medications = data
              .map((item) => MedicationScheduleItem.fromJson(item))
              .toList();
          print('DEBUG: Parsed ${medications.length} medication items');
          return medications;
        } else {
          print(
            'DEBUG: No success field or data is null, trying direct array parse',
          );
          // If no success field, assume it's a direct array (fallback)
          final List<dynamic> data = json.decode(response.body);
          return data
              .map((item) => MedicationScheduleItem.fromJson(item))
              .toList();
        }
      } else {
        throw Exception('Failed to load medication schedule');
      }
    } catch (e) {
      print('Error loading medication schedule: $e');
      return [];
    }
  }

  static Future<ApiResult<MedicationReminder>> createMedicationReminder(
    int scheduleId,
    MedicationReminderRequest request,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(
          '${ApiConstants.baseUrl}/api/medications/schedule/$scheduleId',
        ),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true && responseData['data'] != null) {
          return ApiResult<MedicationReminder>(
            success: true,
            data: MedicationReminder.fromJson(responseData['data']),
            message:
                responseData['message'] ??
                'Medication reminder created successfully',
          );
        } else {
          return ApiResult<MedicationReminder>(
            success: false,
            message:
                responseData['message'] ??
                'Failed to create medication reminder',
          );
        }
      } else {
        return ApiResult<MedicationReminder>(
          success: false,
          message: 'Failed to create medication reminder',
        );
      }
    } catch (e) {
      return ApiResult<MedicationReminder>(
        success: false,
        message: 'Error creating medication reminder: $e',
      );
    }
  }

  static Future<ApiResult<bool>> updateMedicationStatus(
    int medicationId,
    String status,
  ) async {
    try {
      final response = await http.put(
        Uri.parse(
          '${ApiConstants.baseUrl}/api/medications/$medicationId/status',
        ),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'status': status}),
      );

      if (response.statusCode == 200) {
        return ApiResult<bool>(
          success: true,
          data: true,
          message: 'Medication status updated successfully',
        );
      } else {
        return ApiResult<bool>(
          success: false,
          message: 'Failed to update medication status',
        );
      }
    } catch (e) {
      return ApiResult<bool>(
        success: false,
        message: 'Error updating medication status: $e',
      );
    }
  }

  static Future<ApiResult<MedicationReminder>> addMedicationReminder(
    int scheduleId,
    MedicationReminderRequest request,
  ) async {
    return await createMedicationReminder(scheduleId, request);
  }
}
