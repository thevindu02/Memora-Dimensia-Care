import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_constants.dart';

class CaregiverService {
  static final String url = '${ApiConstants.baseUrl}/api/caregivers';

  static Future<List<Map<String, dynamic>>> getCaregiversByCity(
    String city,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$url/by-city/$city'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load caregivers: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load caregivers: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getAllCaregivers() async {
    try {
      final response = await http.get(
        Uri.parse('$url/all'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load caregivers: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load caregivers: $e');
    }
  }

  static Future<Map<String, dynamic>> getCaregiverById(int caregiverId) async {
    try {
      final response = await http.get(
        Uri.parse('$url/$caregiverId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load caregiver: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load caregiver: $e');
    }
  }
}
