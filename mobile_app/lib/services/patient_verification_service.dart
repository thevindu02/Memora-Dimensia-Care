import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class PatientVerificationService {
  final String baseUrl = ApiConfig.baseUrl;

  Future<Map<String, dynamic>> sendVerificationCode(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/patients/send-verification-code'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'],
          'expiresInMinutes': data['expiresInMinutes'],
        };
      } else if (response.statusCode == 429) {
        // Rate limit or locked
        return {
          'success': false,
          'message': data['message'],
          'locked': data['locked'] ?? false,
          'cooldown': data['cooldown'] ?? false,
          'minutesRemaining': data['minutesRemaining'],
          'secondsRemaining': data['secondsRemaining'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to send verification code',
        };
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> verifyCode(String email, String code) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/patients/verify-code'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'code': code}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'accessToken': data['accessToken'],
          'tokenType': data['tokenType'],
          'id': data['id'],
          'email': data['email'],
          'role': data['role'],
          'fname': data['fname'],
          'lname': data['lname'],
          'expiresInDays': data['expiresInDays'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Verification failed',
          'locked': data['locked'] ?? false,
          'expired': data['expired'] ?? false,
          'attemptsRemaining': data['attemptsRemaining'],
          'minutesRemaining': data['minutesRemaining'],
        };
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> resendVerificationCode(String email) async {
    return await sendVerificationCode(email);
  }
}