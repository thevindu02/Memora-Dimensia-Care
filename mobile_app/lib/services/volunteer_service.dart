import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_constants.dart';

class VolunteerService {
  static Future<Map<String, dynamic>?> getVolunteerProfile(int volunteerId) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/api/volunteers/$volunteerId/profile'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }

  static Future<bool> updateVolunteerProfile(int volunteerId, Map<String, dynamic> profile) async {
    final response = await http.put(
      Uri.parse('${ApiConstants.baseUrl}/api/volunteers/$volunteerId/profile'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(profile),
    );
    return response.statusCode == 200;
  }
}