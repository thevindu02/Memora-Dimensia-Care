import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_constants.dart';

class CaregiverReviewService {
  static Future<bool> addReview({
    required int guardianId,
    required int caregiverId,
    required int rating,
    required String reviewText,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/api/caregiver-reviews/add-review'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'guardianId': guardianId,
        'caregiverId': caregiverId,
        'rating': rating,
        'reviewText': reviewText,
      }),
    );
    print('Review response: ${response.statusCode} ${response.body}');
    // Optionally, check for backend error message in response.body
    return response.statusCode == 200;
  }

  static Future<List<Map<String, dynamic>>> getReviewsForCaregiver(int caregiverId) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/api/caregivers/$caregiverId/reviews'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      // Defensive: ensure each item is a Map
      return data.map<Map<String, dynamic>>((item) => Map<String, dynamic>.from(item)).toList();
    } else {
      print('Failed to load reviews: ${response.statusCode} ${response.body}');
      throw Exception('Failed to load reviews');
    }
  }
}