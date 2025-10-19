import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_constants.dart';
import 'auth_service.dart';

class ArticleService {
  static const String baseUrl = "${ApiConstants.baseUrl}/api/articles";

  static Future<Map<String, dynamic>> createArticle({
    required String title,
    required String summary,
    required String content,
    required int categoryId,
    required bool isDraft,
    String? tags,
  }) async {
    try {
      // Get current user ID (volunteer ID)
      final volunteerId = await AuthService.getCurrentUserId();
      if (volunteerId == null) {
        throw Exception('User not authenticated');
      }

      // Prepare the article data
      final articleData = {
        'title': title,
        'summary': summary,
        'content': content,
        'categoryId': categoryId,
        'volunteerId': volunteerId,
        'draft': isDraft,
        'status': isDraft
            ? 'draft'
            : 'disapproved', // Published articles start as disapproved for review
      };

      print('=== Creating Article ===');
      print('Article Data: $articleData');
      print('Request URL: $baseUrl');

      // Make API call
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(articleData),
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Success - return the result
        return {
          'success': true,
          'message': isDraft
              ? 'Draft saved successfully!'
              : 'Article submitted for review!',
          'updateTime': response
              .body, // The backend returns the Firebase update time as a string
        };
      } else {
        // Handle error responses
        String errorMessage;
        try {
          final errorData = jsonDecode(response.body);
          errorMessage = errorData['message'] ?? 'Failed to create article';
        } catch (e) {
          errorMessage =
              'Failed to create article (Status: ${response.statusCode})';
        }

        return {'success': false, 'message': errorMessage};
      }
    } catch (e) {
      print('Error creating article: $e');
      return {
        'success': false,
        'message': 'Network error. Please check your connection and try again.',
      };
    }
  }

  static Future<List<Map<String, dynamic>>> getDraftArticles() async {
    try {
      // Get current user ID (volunteer ID)
      final volunteerId = await AuthService.getCurrentUserId();
      if (volunteerId == null) {
        throw Exception('User not authenticated');
      }

      print('=== Getting Draft Articles ===');
      print('Volunteer ID: $volunteerId');
      print('Request URL: $baseUrl/drafts?volunteerId=$volunteerId');

      // Make API call
      final response = await http.get(
        Uri.parse('$baseUrl/drafts?volunteerId=$volunteerId'),
        headers: {'Content-Type': 'application/json'},
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> articlesJson = jsonDecode(response.body);
        return articlesJson
            .map((article) => Map<String, dynamic>.from(article))
            .toList();
      } else {
        throw Exception('Failed to load draft articles');
      }
    } catch (e) {
      print('Error getting draft articles: $e');
      throw Exception('Failed to load draft articles: $e');
    }
  }

  static Future<Map<String, dynamic>?> getArticle(String articleId) async {
    try {
      print('=== Getting Article ===');
      print('Article ID: $articleId');
      print('Request URL: $baseUrl/$articleId');

      final response = await http.get(
        Uri.parse('$baseUrl/$articleId'),
        headers: {'Content-Type': 'application/json'},
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting article: $e');
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> getPublishedArticles() async {
    try {
      print('=== Getting Published Articles ===');
      print('Request URL: $baseUrl/published/all');

      // Make API call to get all published articles from all volunteers
      final response = await http.get(
        Uri.parse('$baseUrl/published/all'),
        headers: {'Content-Type': 'application/json'},
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> articlesJson = jsonDecode(response.body);
        return articlesJson
            .map((article) => Map<String, dynamic>.from(article))
            .toList();
      } else {
        throw Exception('Failed to load published articles');
      }
    } catch (e) {
      print('Error getting published articles: $e');
      throw Exception('Failed to load published articles: $e');
    }
  }

  static Future<Map<String, dynamic>?> getArticleDetail(
    String articleId,
  ) async {
    try {
      print('=== Getting Article Detail ===');
      print('Article ID: $articleId');
      print('Request URL: $baseUrl/detail/$articleId');

      final response = await http.get(
        Uri.parse('$baseUrl/detail/$articleId'),
        headers: {'Content-Type': 'application/json'},
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load article detail');
      }
    } catch (e) {
      print('Error getting article detail: $e');
      return null;
    }
  }

  /// Like an article
  static Future<Map<String, dynamic>> likeArticle({
    required String articleId,
    required int userId,
  }) async {
    try {
      print('=== Liking Article ===');
      print('Article ID: $articleId');
      print('User ID: $userId');
      print('Request URL: $baseUrl/$articleId/like?userId=$userId');

      final response = await http.post(
        Uri.parse('$baseUrl/$articleId/like?userId=$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'success': true,
          'message': responseData['message'] ?? 'Article liked successfully',
        };
      } else {
        return {'success': false, 'message': 'Failed to like article'};
      }
    } catch (e) {
      print('Error liking article: $e');
      return {
        'success': false,
        'message': 'Network error. Please check your connection.',
      };
    }
  }

  /// Unlike an article
  static Future<Map<String, dynamic>> unlikeArticle({
    required String articleId,
    required int userId,
  }) async {
    try {
      print('=== Unliking Article ===');
      print('Article ID: $articleId');
      print('User ID: $userId');
      print('Request URL: $baseUrl/$articleId/like?userId=$userId');

      final response = await http.delete(
        Uri.parse('$baseUrl/$articleId/like?userId=$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'success': true,
          'message': responseData['message'] ?? 'Article unliked successfully',
        };
      } else {
        return {'success': false, 'message': 'Failed to unlike article'};
      }
    } catch (e) {
      print('Error unliking article: $e');
      return {
        'success': false,
        'message': 'Network error. Please check your connection.',
      };
    }
  }

  /// Get article like status (like count and whether current user has liked)
  static Future<Map<String, dynamic>?> getArticleLikeStatus({
    required String articleId,
    int? userId,
  }) async {
    try {
      print('=== Getting Article Like Status ===');
      print('Article ID: $articleId');
      print('User ID: $userId');

      final uri = userId != null
          ? Uri.parse('$baseUrl/$articleId/like-status?userId=$userId')
          : Uri.parse('$baseUrl/$articleId/like-status');

      print('Request URL: $uri');

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'likeCount': responseData['likeCount'] ?? 0,
          'hasLiked': responseData['hasLiked'] ?? false,
        };
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting article like status: $e');
      return null;
    }
  }
}
