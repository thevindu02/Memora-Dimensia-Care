import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_constants.dart';

class PaymentService {
  static final String baseUrl = '${ApiConstants.baseUrl}/api/payments';

  static Future<PaymentResult> createPayment({
    required int guardianId,
    int?
    subscriptionId, // Nullable - can be null for payments before subscription creation
    required double amount,
    required String paymentMethod, // 'CARD', 'PAYPAL', 'APPLE_PAY'
    String? cardHolderName,
    String? cardLastFour,
    String? payhereOrderId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'guardianId': guardianId,
          'subscriptionId': subscriptionId, // Can be null
          'amount': amount,
          'paymentMethod': paymentMethod,
          'cardHolderName': cardHolderName,
          'cardLastFour': cardLastFour,
          'payhereOrderId': payhereOrderId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PaymentResult(
          success: true,
          message: 'Payment created successfully',
          paymentId: data['paymentId'],
          payment: data,
        );
      } else {
        return PaymentResult(
          success: false,
          message: 'Failed to create payment: ${response.body}',
        );
      }
    } catch (e) {
      return PaymentResult(
        success: false,
        message: 'Error creating payment: $e',
      );
    }
  }

  static Future<bool> updatePaymentStatus({
    required int paymentId,
    required String status, // 'SUCCESS', 'FAILED', 'PENDING'
    String? transactionId,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$paymentId/status'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'status': status, 'transactionId': transactionId}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating payment status: $e');
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getGuardianPayments(
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
      print('Error fetching payments: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getPaymentById(int paymentId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$paymentId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Error fetching payment: $e');
      return null;
    }
  }
}

class PaymentResult {
  final bool success;
  final String message;
  final int? paymentId;
  final Map<String, dynamic>? payment;

  PaymentResult({
    required this.success,
    required this.message,
    this.paymentId,
    this.payment,
  });
}
