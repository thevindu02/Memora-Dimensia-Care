import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:payhere_mobilesdk_flutter/payhere_mobilesdk_flutter.dart';
import '../../constants/color_constants.dart';
import '../../constants/payhere_config.dart';
import '../../routes/app_routes.dart';
import '../../services/subscription_service.dart';
import '../../services/payment_service.dart';
import '../../services/auth_service.dart';
import '../../services/guardian_service.dart';
import '../../services/user_service.dart';
import '../../services/patient_service.dart';
import 'dart:math';

class PaymentScreen extends StatefulWidget {
  final int durationMonths; // 3, 6, or 12 months
  final double price;
  final int patientId; // REQUIRED - patient must exist before payment
  final int? guardianId; // Optional for backward compatibility
  final String? patientName; // For display

  // Deprecated parameters - kept for backward compatibility
  @Deprecated('Use durationMonths instead')
  final String? planType;
  @Deprecated('Use durationMonths instead')
  final String? duration;
  final Map<String, dynamic>?
  patientData; // Deprecated - patient should be created before payment

  PaymentScreen({
    required this.durationMonths,
    required this.price,
    required this.patientId,
    this.guardianId,
    this.patientName,
    this.planType,
    this.duration,
    this.patientData,
  });

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isProcessing = false;
  int? _subscriptionId;
  int? _paymentId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Payment',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Summary
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Summary',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 8),
                    if (widget.patientName != null) ...[
                      Text(
                        'Patient: ${widget.patientName}',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.onSurface.withOpacity(0.7),
                        ),
                      ),
                      SizedBox(height: 4),
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Subscription - ${widget.durationMonths} months',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.onSurface,
                          ),
                        ),
                        Text(
                          'LKR ${widget.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      '✨ Includes 3-month free trial',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.purple[700],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),

              // Demo Instructions
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Demo Mode - Test Cards:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '✅ Success: Visa : 4916 2175 0161 1292 | 12/25 | 123',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.primary,
                        fontFamily: 'monospace',
                      ),
                    ),
                    Text(
                      '❌ Declined: 4000 0000 0000 0002 | 12/25 | 123',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.primary,
                        fontFamily: 'monospace',
                      ),
                    ),
                    Text(
                      'Use any name for testing purposes',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.primary.withOpacity(0.7),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),

              // Payment Provider Info
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.security, color: Colors.blue[700], size: 28),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Secure Payment via PayHere',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue[900],
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Click "Proceed to Payment" to securely enter your card details in the PayHere payment window',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.blue[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),

              // Complete Payment Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _processPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
                  ),
                  child: _isProcessing
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.onPrimary,
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Processing...',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          'Proceed to Payment - LKR ${widget.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _processPayment() async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      // 1. Get guardian info
      final int? userId = await AuthService.getCurrentUserId();
      if (userId == null) {
        throw Exception('User not logged in');
      }

      final int? guardianId =
          widget.guardianId ??
          await GuardianService.getGuardianIdByUserId(userId);
      if (guardianId == null) {
        throw Exception('Guardian not found');
      }

      // 2. Handle two cases: existing patient vs new patient
      // For new patients, we'll create a minimal subscription first, then create patient after payment
      // For existing patients, use the provided patientId

      // For NEW patients without patientId yet, create a temporary subscription with guardianId
      // The backend should handle this, or we skip subscription creation until after patient is created

      // Generate unique order ID first
      final orderId =
          'ORD${DateTime.now().millisecondsSinceEpoch}${Random().nextInt(1000)}';

      // Create payment record without subscription first (we'll link it later)
      final paymentResult = await PaymentService.createPayment(
        guardianId: guardianId,
        subscriptionId:
            null, // NULL - will be created after patient exists and payment succeeds
        amount: widget.price,
        paymentMethod: 'CARD', // PayHere handles card payments
        cardHolderName: '', // PayHere collects this
        cardLastFour: '', // PayHere collects this
        payhereOrderId: orderId,
      );

      if (!paymentResult.success || paymentResult.paymentId == null) {
        throw Exception(paymentResult.message);
      }

      _paymentId = paymentResult.paymentId!;

      // 5. Start PayHere payment (or simulate on web)
      if (kIsWeb) {
        // Web: Simulate payment success for testing
        _simulateWebPayment(orderId, guardianId);
      } else {
        // Mobile: Use actual PayHere SDK
        _startPayHerePayment(orderId, guardianId);
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  // Simulate payment for web testing (PayHere SDK doesn't support web)
  Future<void> _simulateWebPayment(String orderId, int guardianId) async {
    setState(() {
      _isProcessing = true;
    });

    // Show dialog to simulate payment process
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('🌐 Web Test Mode'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('PayHere SDK is not available on web.'),
            SizedBox(height: 12),
            Text('Simulating payment success for testing...'),
            SizedBox(height: 16),
            LinearProgressIndicator(),
          ],
        ),
      ),
    );

    // Simulate payment delay
    await Future.delayed(Duration(seconds: 2));

    // Simulate successful payment
    try {
      // Update payment status to success (backend will add paid subscription period)
      await PaymentService.updatePaymentStatus(
        paymentId: _paymentId!,
        status: 'SUCCESS',
        transactionId: 'WEB_TEST_${orderId}',
        patientId: widget.patientId, // NEW: Link payment to patient subscription
        durationMonths: widget.durationMonths, // NEW: Add paid period (3/6/12 months)
      );

      Navigator.of(context).pop(); // Close dialog

      setState(() {
        _isProcessing = false;
      });

      _handlePaymentSuccess('WEB_TEST_${orderId}');
    } catch (e) {
      Navigator.of(context).pop(); // Close dialog

      setState(() {
        _isProcessing = false;
      });

      _handlePaymentError('Simulation failed: $e');
    }
  }

  void _startPayHerePayment(String orderId, int guardianId) async {
    // Get guardian details for payment form
    String email = PayHereConfig.defaultTestEmail;
    String phone = PayHereConfig.defaultTestPhone;

    try {
      final guardianDetails = await GuardianService.getGuardianDetailsById(
        guardianId,
      );
      if (guardianDetails != null) {
        email = guardianDetails['email'] ?? email;
        phone = guardianDetails['phoneNumber'] ?? phone;
      }
    } catch (e) {
      print('Could not fetch guardian details: $e');
    }

    // PayHere configuration using centralized config
    Map paymentObject = {
      "sandbox": PayHereConfig.useSandbox,
      "merchant_id": PayHereConfig.merchantId,
      "merchant_secret": PayHereConfig.merchantSecret,
      "notify_url": PayHereConfig.notifyUrl,
      "order_id": orderId,
      "items":
          "Memora Subscription - ${widget.durationMonths} months${widget.patientName != null ? ' for ${widget.patientName}' : ''}",
      "amount": widget.price.toStringAsFixed(2),
      "currency": PayHereConfig.currency,
      "first_name": widget.patientName?.split(' ').first ?? "Customer",
      "last_name": widget.patientName?.split(' ').length != null && 
                   widget.patientName!.split(' ').length > 1
          ? widget.patientName!.split(' ').last
          : "",
      "email": email,
      "phone": phone,
      "address": "Colombo",
      "city": PayHereConfig.defaultCity,
      "country": PayHereConfig.defaultCountry,
      "delivery_address": "N/A",
      "delivery_city": "N/A",
      "delivery_country": "N/A",
      "custom_1": "$guardianId",
      "custom_2": "$_subscriptionId",
    };

    PayHere.startPayment(
      paymentObject,
      (paymentId) {
        print("Payment Success. Payment ID: $paymentId");
        _handlePaymentSuccess(paymentId);
      },
      (error) {
        print("Payment Error: $error");
        _handlePaymentError(error);
      },
      () {
        print("Payment Dismissed");
        _handlePaymentDismissed();
      },
    );
  }

  void _handlePaymentSuccess(String transactionId) async {
    // Update payment status (backend will add paid subscription period)
    if (_paymentId != null) {
      await PaymentService.updatePaymentStatus(
        paymentId: _paymentId!,
        status: 'SUCCESS',
        transactionId: transactionId,
        patientId: widget.patientId, // NEW: Link payment to patient subscription
        durationMonths: widget.durationMonths, // NEW: Add paid period (3/6/12 months)
      );
    }

    // DEPRECATED: Old flow - patient creation after payment
    // NEW FLOW: Patient must exist before payment (patientId is required)
    // Subscription is auto-created when patient is added (in PENDING status)
    // Payment adds the paid period to existing subscription
    int? createdPatientId = widget.patientId; // Patient must already exist
    int? createdSubscriptionId;

    if (widget.patientData != null && widget.guardianId != null) {
      print('=== DEPRECATED: Old patient creation flow (skip if patientId provided) ===');
      print('⚠️ WARNING: Patient should be created BEFORE payment in new flow');
      print('Patient ID provided: ${widget.patientId}');
      print('==========================================================');
      
      // TODO: Remove this entire block once all screens are updated to new flow
      // For now, keeping for backward compatibility but marking as deprecated
    }

    setState(() {
      _isProcessing = false;
    });

    final paymentData = {
      'durationMonths': widget.durationMonths, // NEW format
      'price': widget.price,
      'transactionId': transactionId,
      'patientId': createdPatientId ?? widget.patientId, // Use created or existing patient ID
      'patientName': widget.patientName,
      'subscriptionId': createdSubscriptionId, // Pass created subscription ID
      // Deprecated fields for backward compatibility
      'planType': widget.planType,
      'duration': widget.duration,
    };

    Navigator.pushNamed(
      context,
      AppRoutes.guardianPaymentSuccess,
      arguments: paymentData,
    );
  }

  void _handlePaymentError(String error) async {
    // Update payment status
    if (_paymentId != null) {
      await PaymentService.updatePaymentStatus(
        paymentId: _paymentId!,
        status: 'FAILED',
      );
    }

    setState(() {
      _isProcessing = false;
    });

    final paymentData = {
      'durationMonths': widget.durationMonths, // NEW format
      'price': widget.price,
      'errorMessage': error,
      'patientName': widget.patientName,
      // Deprecated fields for backward compatibility
      'planType': widget.planType,
      'duration': widget.duration,
    };

    Navigator.pushNamed(
      context,
      AppRoutes.guardianPaymentFailed,
      arguments: paymentData,
    );
  }

  void _handlePaymentDismissed() async {
    // Update payment status
    if (_paymentId != null) {
      await PaymentService.updatePaymentStatus(
        paymentId: _paymentId!,
        status: 'CANCELLED',
      );
    }

    setState(() {
      _isProcessing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment cancelled'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
