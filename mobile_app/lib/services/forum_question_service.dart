import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_constants.dart';

class ForumQuestionService {
  static final String baseUrl = '${ApiConstants.baseUrl}/api/forum/questions';

  /// Fetch all questions from the backend
  static Future<List<Map<String, dynamic>>> getAllQuestions() async {
    try {
      final url = Uri.parse(baseUrl);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        print('Error fetching questions: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Exception fetching questions: $e');
      return [];
    }
  }

  /// Fetch a single question by ID
  static Future<Map<String, dynamic>?> getQuestionById(
    String questionId,
  ) async {
    try {
      final url = Uri.parse('$baseUrl/$questionId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode == 404) {
        print('Question not found');
        return null;
      } else {
        print('Error fetching question: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception fetching question: $e');
      return null;
    }
  }

  /// Fetch questions by guardian ID
  static Future<List<Map<String, dynamic>>> getQuestionsByGuardianId(
    int guardianId,
  ) async {
    try {
      final url = Uri.parse('$baseUrl/guardian/$guardianId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        print('Error fetching guardian questions: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Exception fetching guardian questions: $e');
      return [];
    }
  }

  /// Fetch unanswered questions
  static Future<List<Map<String, dynamic>>> getUnansweredQuestions() async {
    try {
      final url = Uri.parse('$baseUrl/unanswered');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        print('Error fetching unanswered questions: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Exception fetching unanswered questions: $e');
      return [];
    }
  }

  /// Fetch recent questions (posted within last 24 hours)
  static Future<List<Map<String, dynamic>>> getRecentQuestions() async {
    try {
      final url = Uri.parse('$baseUrl/filter/recent');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        print('Error fetching recent questions: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Exception fetching recent questions: $e');
      return [];
    }
  }

  /// Fetch questions sorted by most replies
  static Future<List<Map<String, dynamic>>> getMostRepliedQuestions() async {
    try {
      final url = Uri.parse('$baseUrl/filter/most-replies');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        print('Error fetching most replied questions: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Exception fetching most replied questions: $e');
      return [];
    }
  }

  /// Fetch filtered questions based on filter type
  /// filterType: 'all', 'unanswered', 'recent', 'most_replies'
  static Future<List<Map<String, dynamic>>> getFilteredQuestions(
    String filterType,
  ) async {
    try {
      final url = Uri.parse('$baseUrl/filter?type=$filterType');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        print('Error fetching filtered questions: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Exception fetching filtered questions: $e');
      return [];
    }
  }

  /// Create a new question
  static Future<Map<String, dynamic>?> createQuestion({
    required int guardianId,
    required String title,
    required String content,
    required List<String> tags,
  }) async {
    try {
      print('Creating question...');
      print('URL: $baseUrl');
      print('Guardian ID: $guardianId');
      print('Title: $title');

      final url = Uri.parse(baseUrl);
      final requestBody = jsonEncode({
        'guardianId': guardianId,
        'title': title,
        'content': content,
        'tags': tags,
      });

      print('Request body: $requestBody');

      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: requestBody,
          )
          .timeout(
            Duration(seconds: 10),
            onTimeout: () {
              print('Request timed out after 10 seconds');
              throw Exception('Request timed out');
            },
          );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        print('Question created successfully!');
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        print('Error creating question: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception creating question: $e');
      return null;
    }
  }

  /// Delete a question
  static Future<bool> deleteQuestion(String questionId, int guardianId) async {
    try {
      final url = Uri.parse('$baseUrl/$questionId?guardianId=$guardianId');
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Error deleting question: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception deleting question: $e');
      return false;
    }
  }
}
