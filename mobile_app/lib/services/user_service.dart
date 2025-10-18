import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_constants.dart';

class UserService {
  static final String url = '${ApiConstants.baseUrl}/api/users';

  static Future<UserResult> addUser({
    required String FName,
    required String LName,
    required String email,
    required String role,
    required String status,
    String? password,
    String? phoneNumber,
    String? birthdate,
    String? profilePic,
    String? street,
    String? city,
    String? state,
    String? gender,
  }) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "FName": FName,
        "LName": LName,
        "email": email,
        "password": password,
        "role": role,
        "status": status,
        "phoneNumber": phoneNumber,
        "birthdate": birthdate,
        "profilePic": profilePic,
        "street": street,
        "city": city,
        "state": state,
        "gender": gender,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return UserResult(success: true, message: "User created", userId: data['id']);
    } else {
      final responseData = jsonDecode(response.body);
      return UserResult(
        success: false,
        message: responseData['message'] ?? 'Failed to add user',
      );
    }
  }

  static Future<Map<String, dynamic>?> getUserById(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$url/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        print('Failed to get user: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }
}

class UserResult {
  final bool success;
  final String message;
  final int? userId;

  UserResult({required this.success, required this.message, this.userId});
}
