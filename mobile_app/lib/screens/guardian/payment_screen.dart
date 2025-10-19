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
  final String planType;
  final String duration;
  final double price;
  final int?
  patientId; // Optional: Will be null for new patients (created after payment)
  final int? guardianId; // Required for creating patient after payment
  final Map<String, dynamic>?
  patientData; // Patient form data to create after payment success

  PaymentScreen({
    required this.planType,
    required this.duration,
    required this.price,
    this.patientId,
    this.guardianId,
    this.patientData,
  });

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedPaymentMethod = 'card';
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.planType.toUpperCase()} Plan - ${widget.duration} months',
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
                      '✅ Success: 4242 4242 4242 4242 | 12/25 | 123',
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

              // Payment Methods
              Text(
                'Payment Method',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 16),

              _buildPaymentMethodCard(
                'card',
                'Credit/Debit Card',
                Icons.credit_card,
              ),

              SizedBox(height: 32),

              // Card Details
              Text(
                'Card Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Cardholder Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter cardholder name';
                  }
                  if (value!.length < 2) {
                    return 'Name must be at least 2 characters';
                  }
                  if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                    return 'Name can only contain letters and spaces';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _cardNumberController,
                decoration: InputDecoration(
                  labelText: 'Card Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
                keyboardType: TextInputType.number,
                maxLength: 19, // 16 digits + 3 spaces for formatting
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter card number';
                  }
                  String cleanValue = value!.replaceAll(' ', '');
                  if (cleanValue.length != 16) {
                    return 'Card number must be 16 digits';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(cleanValue)) {
                    return 'Card number can only contain digits';
                  }
                  return null;
                },
                onChanged: (value) {
                  // Format card number with spaces
                  String formatted = _formatCardNumber(value);
                  if (formatted != value) {
                    _cardNumberController.value = TextEditingValue(
                      text: formatted,
                      selection: TextSelection.collapsed(
                        offset: formatted.length,
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _expiryController,
                      decoration: InputDecoration(
                        labelText: 'MM/YY',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 5, // MM/YY format
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Required';
                        }
                        if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value!)) {
                          return 'Format: MM/YY';
                        }
                        List<String> parts = value.split('/');
                        int month = int.parse(parts[0]);
                        int year = 2000 + int.parse(parts[1]);

                        if (month < 1 || month > 12) {
                          return 'Invalid month';
                        }

                        DateTime now = DateTime.now();
                        DateTime cardDate = DateTime(year, month);

                        if (cardDate.isBefore(DateTime(now.year, now.month))) {
                          return 'Card expired';
                        }

                        return null;
                      },
                      onChanged: (value) {
                        // Format MM/YY
                        String formatted = _formatExpiryDate(value);
                        if (formatted != value) {
                          _expiryController.value = TextEditingValue(
                            text: formatted,
                            selection: TextSelection.collapsed(
                              offset: formatted.length,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _cvvController,
                      decoration: InputDecoration(
                        labelText: 'CVV',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      maxLength: 4,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Required';
                        }
                        if (value!.length < 3 || value.length > 4) {
                          return '3-4 digits';
                        }
                        if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return 'Numbers only';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),

              // Complete Payment Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isProcessing
                      ? null
                      : () {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          _processPayment();
                        },
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
                          'Complete Payment - LKR ${widget.price.toStringAsFixed(2)}',
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

  Widget _buildPaymentMethodCard(String method, String title, IconData icon) {
    bool isSelected = selectedPaymentMethod == method;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = method;
        });
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryLight.withOpacity(0.1)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outline,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.outline,
                  width: 2,
                ),
                color: isSelected ? AppColors.primary : AppColors.surface,
              ),
              child: isSelected
                  ? Icon(Icons.check, size: 12, color: AppColors.onPrimary)
                  : null,
            ),
            SizedBox(width: 12),
            Icon(icon, color: AppColors.textPrimary, size: 24),
            SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ],
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
        paymentMethod: selectedPaymentMethod.toUpperCase(),
        cardHolderName: _nameController.text.trim(),
        cardLastFour: _cardNumberController.text
            .replaceAll(' ', '')
            .substring(12),
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
      // Update payment status to success (backend will activate subscription)
      await PaymentService.updatePaymentStatus(
        paymentId: _paymentId!,
        status: 'SUCCESS',
        transactionId: 'WEB_TEST_${orderId}',
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
          "${widget.planType.toUpperCase()} Plan - ${widget.duration} months",
      "amount": widget.price.toStringAsFixed(2),
      "currency": PayHereConfig.currency,
      "first_name": _nameController.text.split(' ').first,
      "last_name": _nameController.text.split(' ').length > 1
          ? _nameController.text.split(' ').last
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
    // Update payment status
    if (_paymentId != null) {
      await PaymentService.updatePaymentStatus(
        paymentId: _paymentId!,
        status: 'SUCCESS',
        transactionId: transactionId,
      );
    }

    // NEW: Create patient AND subscription AFTER successful payment
    int? createdPatientId = widget.patientId; // Use existing if available
    int? createdSubscriptionId;

    if (widget.patientData != null && widget.guardianId != null) {
      print('=== Creating Patient & Subscription After Payment Success ===');
      try {
        // 1. Create user account for the patient
        final userResult = await UserService.addUser(
          FName: widget.patientData!['firstName'],
          LName: widget.patientData!['lastName'],
          email: widget.patientData!['email'],
          password: null, // Patients don't need passwords
          phoneNumber: widget.patientData!['phoneNumber'],
          role: "PATIENT",
          status: "ACTIVE",
          birthdate: widget.patientData!['birthdate'],
          profilePic: "",
          street: widget.patientData!['street'],
          city: widget.patientData!['city'],
          state: widget.patientData!['state'],
          gender: widget.patientData!['gender'],
        );

        if (!userResult.success || userResult.userId == null) {
          print('Failed to create user: ${userResult.message}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Payment successful but patient creation failed. Contact support.',
              ),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 5),
            ),
          );
        } else {
          // 2. Create patient record
          final patientResult = await PatientService.addPatient(
            userId: userResult.userId!,
            dementiaStage: widget.patientData!['dementiaStage'],
            dateOfDiagnosis: widget.patientData!['dateOfDiagnosis'],
            dementiaType: widget.patientData!['dementiaType'],
            guardianId: widget.guardianId!,
            relationship: widget.patientData!['relationship'],
          );

          if (patientResult.success && patientResult.patientId != null) {
            createdPatientId = patientResult.patientId;
            print('Patient created successfully with ID: $createdPatientId');

            // 3. NOW create subscription with the patient ID
            final subscriptionResult =
                await SubscriptionService.createSubscription(
                  guardianId: widget.guardianId!,
                  patientId: createdPatientId!,
                  planType: widget.planType.toUpperCase(),
                  durationMonths: int.parse(widget.duration),
                );

            if (subscriptionResult.success &&
                subscriptionResult.subscriptionId != null) {
              createdSubscriptionId = subscriptionResult.subscriptionId;
              print(
                'Subscription created successfully with ID: $createdSubscriptionId',
              );
            } else {
              print(
                'Failed to create subscription: ${subscriptionResult.message}',
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Patient created but subscription failed. Contact support.',
                  ),
                  backgroundColor: Colors.orange,
                  duration: Duration(seconds: 5),
                ),
              );
            }
          } else {
            print('Failed to create patient: ${patientResult.message}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Payment successful but patient creation failed. Contact support.',
                ),
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 5),
              ),
            );
          }
        }
      } catch (e) {
        print('Exception creating patient/subscription after payment: $e');
      }
      print('==========================================================');
    }

    setState(() {
      _isProcessing = false;
    });

    final paymentData = {
      'planType': widget.planType,
      'duration': widget.duration,
      'price': widget.price,
      'transactionId': transactionId,
      'patientId': createdPatientId, // Pass created patient ID
      'subscriptionId': createdSubscriptionId, // Pass created subscription ID
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
      'planType': widget.planType,
      'duration': widget.duration,
      'price': widget.price,
      'errorMessage': error,
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

  String _formatCardNumber(String value) {
    // Remove all non-digits
    String digitsOnly = value.replaceAll(RegExp(r'\D'), '');

    // Limit to 16 digits
    if (digitsOnly.length > 16) {
      digitsOnly = digitsOnly.substring(0, 16);
    }

    // Add spaces every 4 digits
    String formatted = '';
    for (int i = 0; i < digitsOnly.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formatted += ' ';
      }
      formatted += digitsOnly[i];
    }

    return formatted;
  }

  String _formatExpiryDate(String value) {
    // Remove all non-digits
    String digitsOnly = value.replaceAll(RegExp(r'\D'), '');

    // Limit to 4 digits
    if (digitsOnly.length > 4) {
      digitsOnly = digitsOnly.substring(0, 4);
    }

    // Add slash after 2 digits
    if (digitsOnly.length >= 2) {
      return '${digitsOnly.substring(0, 2)}/${digitsOnly.substring(2)}';
    }

    return digitsOnly;
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}
