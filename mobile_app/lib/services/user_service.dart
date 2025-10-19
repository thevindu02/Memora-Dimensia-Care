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

  static Future<UserResult> updateUser({
    required int userId,
    String? FName,
    String? LName,
    String? email,
    String? phoneNumber,
    String? birthdate,
    String? profilePic,
    String? street,
    String? city,
    String? state,
    String? gender,
  }) async {
    try {
      final Map<String, dynamic> updateData = {};

      if (FName != null) updateData['FName'] = FName;
      if (LName != null) updateData['LName'] = LName;
      if (email != null) updateData['email'] = email;
      if (phoneNumber != null) updateData['phoneNumber'] = phoneNumber;
      if (birthdate != null) updateData['birthdate'] = birthdate;
      if (profilePic != null) updateData['profilePic'] = profilePic;
      if (street != null) updateData['street'] = street;
      if (city != null) updateData['city'] = city;
      if (state != null) updateData['state'] = state;
      if (gender != null) updateData['gender'] = gender;

      final response = await http.put(
        Uri.parse('$url/$userId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updateData),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserResult(
          success: true,
          message: data['message'] ?? "User updated successfully",
          userId: userId,
        );
      } else if (response.statusCode == 409) {
        // Conflict - email already in use
        final responseData = jsonDecode(response.body);
        return UserResult(
          success: false,
          message: responseData['message'] ?? 'Email already in use',
        );
      } else {
        String errorMessage;
        try {
          final responseData = jsonDecode(response.body);
          errorMessage = responseData['message'] ?? response.body;
        } catch (e) {
          errorMessage = response.body;
        }
        return UserResult(success: false, message: errorMessage);
      }
    } catch (e) {
      print('Error updating user: $e');
      return UserResult(
        success: false,
        message: 'Network error. Please check your connection.',
      );
    }
  }

  static Future<UserResult> changePassword({
    required int userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$url/$userId/change-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserResult(
          success: true,
          message: data['message'] ?? "Password changed successfully",
          userId: userId,
        );
      } else if (response.statusCode == 400) {
        final responseData = jsonDecode(response.body);
        return UserResult(
          success: false,
          message: responseData['message'] ?? 'Invalid password',
        );
      } else {
        String errorMessage;
        try {
          final responseData = jsonDecode(response.body);
          errorMessage = responseData['message'] ?? response.body;
        } catch (e) {
          errorMessage = response.body;
        }
        return UserResult(success: false, message: errorMessage);
      }
    } catch (e) {
      print('Error changing password: $e');
      return UserResult(
        success: false,
        message: 'Network error. Please check your connection.',
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
