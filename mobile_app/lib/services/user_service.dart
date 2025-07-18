import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  static const String baseUrl = 'http://10.22.160.21:8080/api/users';

  static Future<UserResult> addUser({
    required String FName,
    required String LName,
    required String email,
    required String password,
    required String role,
    required String status,
    String? phoneNumber,
    String? birthdate,
    String? profilePic,
    String? street,
    String? city,
    String? state,
    String? gender,
  }) async {
    final response = await http.post(
      Uri.parse(baseUrl),
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
}

class UserResult {
  final bool success;
  final String message;
  final int? userId;

  UserResult({required this.success, required this.message, this.userId});
}
