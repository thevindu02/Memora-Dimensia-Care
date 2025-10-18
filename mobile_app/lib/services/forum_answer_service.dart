import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_constants.dart';

class ForumAnswerService {
  static const String baseUrl = '${ApiConstants.baseUrl}/api/forum/answers';

  /// Fetch all answers for a specific question
  static Future<List<Map<String, dynamic>>> getAnswersByQuestionId(
    String questionId, {
    int? userId,
  }) async {
    try {
      String url = '$baseUrl/question/$questionId';
      if (userId != null) {
        url += '?userId=$userId';
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        print('Error fetching answers: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Exception fetching answers: $e');
      return [];
    }
  }

  /// Like an answer
  static Future<bool> likeAnswer(String answerId, int userId) async {
    try {
      final url = Uri.parse('$baseUrl/$answerId/like?userId=$userId');
      final response = await http.post(url);

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Error liking answer: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception liking answer: $e');
      return false;
    }
  }

  /// Unlike an answer
  static Future<bool> unlikeAnswer(String answerId, int userId) async {
    try {
      final url = Uri.parse('$baseUrl/$answerId/like?userId=$userId');
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Error unliking answer: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception unliking answer: $e');
      return false;
    }
  }

  /// Create a new answer (volunteers only)
  static Future<Map<String, dynamic>?> createAnswer({
    required String questionId,
    required int volunteerId,
    required String content,
  }) async {
    try {
      final url = Uri.parse(baseUrl);
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'questionId': questionId,
          'volunteerId': volunteerId,
          'content': content,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        print('Error creating answer: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception creating answer: $e');
      return null;
    }
  }
}
