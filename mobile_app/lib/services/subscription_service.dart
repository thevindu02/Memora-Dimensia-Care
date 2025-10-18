import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_constants.dart';

class SubscriptionService {
  static final String baseUrl = '${ApiConstants.baseUrl}/api/subscriptions';

  static Future<SubscriptionResult> createSubscription({
    required int guardianId,
    required int patientId,
    required String planType, // 'BASIC' or 'PREMIUM'
    required int durationMonths, // 3, 6, or 12
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'guardianId': guardianId,
          'patientId': patientId,
          'planType': planType,
          'durationMonths': durationMonths,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return SubscriptionResult(
          success: true,
          message: 'Subscription created successfully',
          subscriptionId: data['subscriptionId'],
          subscription: data,
        );
      } else {
        return SubscriptionResult(
          success: false,
          message: 'Failed to create subscription: ${response.body}',
        );
      }
    } catch (e) {
      return SubscriptionResult(
        success: false,
        message: 'Error creating subscription: $e',
      );
    }
  }

  static Future<List<Map<String, dynamic>>> getGuardianSubscriptions(
    int guardianId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/guardian/$guardianId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      print('Error fetching subscriptions: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getActiveSubscription({
    required int guardianId,
    required int patientId,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/active?guardianId=$guardianId&patientId=$patientId',
        ),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic> &&
            data.containsKey('subscriptionId')) {
          return data;
        }
      }
      return null;
    } catch (e) {
      print('Error fetching active subscription: $e');
      return null;
    }
  }
}

class SubscriptionResult {
  final bool success;
  final String message;
  final int? subscriptionId;
  final Map<String, dynamic>? subscription;

  SubscriptionResult({
    required this.success,
    required this.message,
    this.subscriptionId,
    this.subscription,
  });
}
