import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_result.dart';
import 'api_constants.dart';

class CareActivityService {
  /// Update the status of a care activity
  /// Returns ApiResult with success/failure information
  static Future<ApiResult<Map<String, dynamic>>> updateStatus(
    int careActivityId,
    String status,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConstants.baseUrl}/api/care-activities/$careActivityId/status'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'status': status,
        }),
      );

      print('CareActivity updateStatus - Status code: ${response.statusCode}');
      print('CareActivity updateStatus - Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          return ApiResult<Map<String, dynamic>>(
            success: true,
            data: responseData['data'],
            message: responseData['message'] ?? 'Status updated successfully',
          );
        } else {
          return ApiResult<Map<String, dynamic>>(
            success: false,
            message: responseData['message'] ?? 'Failed to update status',
          );
        }
      } else {
        final responseData = json.decode(response.body);
        return ApiResult<Map<String, dynamic>>(
          success: false,
          message: responseData['message'] ?? 'Failed to update status - HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error updating care activity status: $e');
      return ApiResult<Map<String, dynamic>>(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  /// Update the status of a care activity with skip reason
  /// Returns ApiResult with success/failure information
  static Future<ApiResult<Map<String, dynamic>>> updateStatusWithReason(
    int careActivityId,
    String status,
    String? skipReason,
  ) async {
    try {
      final Map<String, dynamic> requestBody = {
        'status': status,
      };
      
      // Add skipReason to request body if provided
      if (skipReason != null && skipReason.trim().isNotEmpty) {
        requestBody['skipReason'] = skipReason;
      }

      final response = await http.put(
        Uri.parse('${ApiConstants.baseUrl}/api/care-activities/$careActivityId/status'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      print('CareActivity updateStatusWithReason - Status code: ${response.statusCode}');
      print('CareActivity updateStatusWithReason - Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          return ApiResult<Map<String, dynamic>>(
            success: true,
            data: responseData['data'],
            message: responseData['message'] ?? 'Status updated successfully',
          );
        } else {
          return ApiResult<Map<String, dynamic>>(
            success: false,
            message: responseData['message'] ?? 'Failed to update status',
          );
        }
      } else {
        final responseData = json.decode(response.body);
        return ApiResult<Map<String, dynamic>>(
          success: false,
          message: responseData['message'] ?? 'Failed to update status - HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error updating care activity status with reason: $e');
      return ApiResult<Map<String, dynamic>>(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }
}
