import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_constants.dart';

class GuardianService {
  static final String baseUrl = '${ApiConstants.baseUrl}/api/guardians';

  /// Gets the guardianId for a given userId. Returns the id as int, or null if not found.
  static Future<int?> getGuardianIdByUserId(int userId) async {
    final url = Uri.parse('$baseUrl/by-user/$userId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return int.tryParse(response.body);
    } else {
      return null;
    }
  }
} 