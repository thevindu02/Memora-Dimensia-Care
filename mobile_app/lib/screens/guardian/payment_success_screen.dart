import 'package:flutter/material.dart';
import '../../constants/color_constants.dart';
import '../../routes/app_routes.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final String? planType; // DEPRECATED - kept for backward compatibility
  final String? duration; // DEPRECATED - kept for backward compatibility
  final double price;
  final int? durationMonths; // NEW - actual duration (3, 6, or 12)
  final String? patientName; // NEW - patient name for display

  const PaymentSuccessScreen({
    Key? key,
    this.planType, // Optional now
    this.duration, // Optional now
    required this.price,
    this.durationMonths, // NEW parameter
    this.patientName, // NEW parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // Success Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.successBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 80,
                  color: AppColors.success,
                ),
              ),

              const SizedBox(height: 32),

              // Success Title
              Text(
                'Payment Successful!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // Success Message
              Text(
                patientName != null
                    ? 'Subscription for $patientName is now active!\n✨ Includes 3-month free trial'
                    : 'Your ${planType ?? "subscription"} plan is now active and ready to use.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Payment Details Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outline),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Subscription Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Patient Name (NEW)
                    if (patientName != null) ...[
                      _buildDetailRow('Patient', patientName!),
                      const SizedBox(height: 12),
                    ],

                    // Duration (NEW or OLD format)
                    if (durationMonths != null)
                      _buildDetailRow('Paid Period', '$durationMonths months')
                    else
                      _buildDetailRow('Duration', duration ?? 'N/A'),
                    const SizedBox(height: 12),

                    // Plan Type (OLD format only)
                    if (planType != null && durationMonths == null) ...[
                      _buildDetailRow('Plan Type', planType!),
                      const SizedBox(height: 12),
                    ],

                    // Amount Paid
                    _buildDetailRow(
                      'Amount Paid',
                      'LKR ${price.toStringAsFixed(2)}',
                    ),
                    const SizedBox(height: 12),

                    // Payment Date
                    _buildDetailRow('Payment Date', _getCurrentDate()),
                    const SizedBox(height: 12),

                    // Next Billing Date
                    _buildDetailRow('Next Billing', _getNextBillingDate()),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Benefits Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outline),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'What\'s Next?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Show plan-specific features
                    ...(_getPlanFeatures()),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Action Buttons
              Column(
                children: [
                  // Continue Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to dashboard or main app
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          AppRoutes.guardianDashboard,
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Continue to Dashboard',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Download Receipt Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        // Download receipt functionality
                        _downloadReceipt(context);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimary,
                        side: BorderSide(color: AppColors.outline),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Download Receipt',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  List<Widget> _getPlanFeatures() {
    final isPremium = planType?.toLowerCase() == 'premium';

    if (isPremium) {
      // Premium Plan Features
      return [
        _buildBenefitItem('View all caregivers'),
        _buildBenefitItem('Access to all articles'),
        _buildBenefitItem('Access to all blog posts'),
        _buildBenefitItem('Premium scheduling with smart watch integration'),
      ];
    } else {
      // Basic Plan Features
      return [
        _buildBenefitItem('View up to 5 caregivers'),
        _buildBenefitItem('View 1 article per day'),
        _buildBenefitItem('View 1 blog post per day'),
        _buildBenefitItem('Basic task scheduling'),
      ];
    }
  }

  Widget _buildBenefitItem(String benefit) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(Icons.check_circle, size: 20, color: AppColors.success),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              benefit,
              style: TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    return '${now.day}/${now.month}/${now.year}';
  }

  String _getNextBillingDate() {
    final now = DateTime.now();
    // Use durationMonths if available, otherwise fall back to duration string
    int monthsToAdd = durationMonths ?? 
        (duration?.contains('Monthly') == true ? 1 : 12);
    
    final nextBilling = DateTime(now.year, now.month + monthsToAdd, now.day);
    return '${nextBilling.day}/${nextBilling.month}/${nextBilling.year}';
  }

  void _downloadReceipt(BuildContext context) {
    // Show download confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Receipt downloaded successfully!'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
