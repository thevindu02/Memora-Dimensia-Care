import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_constants.dart';

class DailyReportService {
  /// Get all reports for a guardian
  static Future<List<Map<String, dynamic>>> getReportsByGuardianId(
    int guardianId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/api/reports/guardian/$guardianId'),
        headers: {'Content-Type': 'application/json'},
      );

      print('DailyReportService - Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        print('Error fetching reports: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error in getReportsByGuardianId: $e');
      return [];
    }
  }

  /// Get all reports for a patient
  static Future<List<Map<String, dynamic>>> getReportsByPatientId(
    int patientId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/api/reports/patient/$patientId'),
        headers: {'Content-Type': 'application/json'},
      );

      print('DailyReportService - Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        print('Error fetching reports: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error in getReportsByPatientId: $e');
      return [];
    }
  }

  /// Get report for a specific patient and date
  static Future<Map<String, dynamic>?> getReportByPatientIdAndDate(
    int patientId,
    String date, // Format: YYYY-MM-DD
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${ApiConstants.baseUrl}/api/reports/patient/$patientId/date/$date',
        ),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic> && data.containsKey('reportId')) {
          return data;
        }
        return null;
      } else {
        return null;
      }
    } catch (e) {
      print('Error in getReportByPatientIdAndDate: $e');
      return null;
    }
  }

  /// Get reports for a patient within a date range
  static Future<List<Map<String, dynamic>>> getReportsByPatientIdAndDateRange(
    int patientId,
    String startDate,
    String endDate,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${ApiConstants.baseUrl}/api/reports/patient/$patientId/range?startDate=$startDate&endDate=$endDate',
        ),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        return [];
      }
    } catch (e) {
      print('Error in getReportsByPatientIdAndDateRange: $e');
      return [];
    }
  }

  /// Get report summary for a patient (count and last report date)
  static Future<Map<String, dynamic>> getReportSummaryForPatient(
    int patientId,
  ) async {
    try {
      final reports = await getReportsByPatientId(patientId);

      if (reports.isEmpty) {
        return {'totalReports': 0, 'lastReportDate': null};
      }

      // Reports are already sorted by date descending from backend
      final lastReport = reports.first;
      final lastDate = lastReport['date'];

      return {'totalReports': reports.length, 'lastReportDate': lastDate};
    } catch (e) {
      print('Error in getReportSummaryForPatient: $e');
      return {'totalReports': 0, 'lastReportDate': null};
    }
  }
}
