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
      return UserResult(
        success: true,
        message: "User created",
        userId: data['id'],
      );
    } else {
      // Backend may return plain text or JSON error messages
      String errorMessage;
      try {
        final responseData = jsonDecode(response.body);
        errorMessage = responseData['message'] ?? response.body;
      } catch (e) {
        // If JSON parsing fails, use the raw response body
        errorMessage = response.body;
      }

      return UserResult(success: false, message: errorMessage);
    }
  }
}

class UserResult {
  final bool success;
  final String message;
  final int? userId;

  UserResult({required this.success, required this.message, this.userId});
}
