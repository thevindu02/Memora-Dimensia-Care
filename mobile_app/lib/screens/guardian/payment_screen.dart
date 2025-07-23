import 'package:flutter/material.dart';
import '../../constants/color_constants.dart';
import '../../routes/app_routes.dart';

class PaymentScreen extends StatefulWidget {
  final String planType;
  final String duration;
  final double price;

  PaymentScreen({
    required this.planType,
    required this.duration,
    required this.price,
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
                          '\$${widget.price.toStringAsFixed(2)}',
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

              _buildPaymentMethodCard('card', 'Credit/Debit Card', Icons.credit_card),
              SizedBox(height: 12),
              _buildPaymentMethodCard('paypal', 'PayPal', Icons.account_balance_wallet),
              SizedBox(height: 12),
              _buildPaymentMethodCard('apple', 'Apple Pay', Icons.phone_iphone),

              SizedBox(height: 32),

              // Card Details (if card is selected)
              if (selectedPaymentMethod == 'card') ...[
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
                        selection: TextSelection.collapsed(offset: formatted.length),
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
                              selection: TextSelection.collapsed(offset: formatted.length),
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
              ],

              // Complete Payment Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedPaymentMethod == 'card' && !_formKey.currentState!.validate()) {
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
                  ),
                  child: Text(
                    'Complete Payment - \$${widget.price.toStringAsFixed(2)}',
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
          color: isSelected ? AppColors.primaryLight.withOpacity(0.1) : AppColors.surface,
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
                  ? Icon(
                Icons.check,
                size: 12,
                color: AppColors.onPrimary,
              )
                  : null,
            ),
            SizedBox(width: 12),
            Icon(
              icon,
              color: AppColors.textPrimary,
              size: 24,
            ),
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

  void _processPayment() {
    // Simulate payment processing based on card number
    // In a real app, you would integrate with a payment gateway
    
    bool paymentSucceeded = true;
    String errorMessage = '';
    
    if (selectedPaymentMethod == 'card') {
      String cardNumber = _cardNumberController.text.replaceAll(' ', '');
      
      // Demo card logic
      if (cardNumber == '4242424242424242') {
        paymentSucceeded = true;
      } else if (cardNumber == '4000000000000002') {
        paymentSucceeded = false;
        errorMessage = 'Your card was declined. Please try a different payment method.';
      } else if (cardNumber.startsWith('4000000000000069')) {
        paymentSucceeded = false;
        errorMessage = 'Your card has expired. Please check the expiry date.';
      } else if (cardNumber.startsWith('4000000000000127')) {
        paymentSucceeded = false;
        errorMessage = 'Incorrect CVC. Please check your card details.';
      } else {
        // Random success/failure for other cards
        paymentSucceeded = DateTime.now().millisecondsSinceEpoch % 3 != 0;
        errorMessage = 'Payment could not be processed. Please check your card details and try again.';
      }
    } else {
      // For other payment methods, simulate success
      paymentSucceeded = true;
    }
    
    final paymentData = {
      'planType': widget.planType,
      'duration': widget.duration,
      'price': widget.price,
    };
    
    if (paymentSucceeded) {
      // Navigate to success screen using named route
      Navigator.pushNamed(
        context,
        AppRoutes.guardianPaymentSuccess,
        arguments: paymentData,
      );
    } else {
      // Navigate to failed screen using named route
      Navigator.pushNamed(
        context,
        AppRoutes.guardianPaymentFailed,
        arguments: {
          ...paymentData,
          'errorMessage': errorMessage.isNotEmpty ? errorMessage : 'Payment failed. Please try again.',
        },
      );
    }
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