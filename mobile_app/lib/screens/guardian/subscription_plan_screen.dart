import 'package:flutter/material.dart';
import '../../constants/color_constants.dart';
import 'payment_screen.dart';

// ⚠️ DEPRECATED: This screen uses the old BASIC/PREMIUM plan model
// NEW SCREEN: Use subscription_duration_screen.dart instead
// This file is kept for backward compatibility with existing navigation flows
// TODO: Migrate all navigation to subscription_duration_screen.dart and remove this file

class SubscriptionPlanScreen extends StatefulWidget {
  @override
  _SubscriptionPlanScreenState createState() => _SubscriptionPlanScreenState();
}

class _SubscriptionPlanScreenState extends State<SubscriptionPlanScreen> {
  String? selectedPlan;
  String? selectedDuration;
  int? patientId;
  int? guardianId;
  Map<String, dynamic>? patientData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get guardian ID and patient data from navigation arguments
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    print('=== SubscriptionPlanScreen Debug ===');
    print('Arguments received: $args');

    if (args != null) {
      patientId = args['patientId'] as int?;
      guardianId = args['guardianId'] as int?;
      patientData = args['patientData'] as Map<String, dynamic>?;

      print('Extracted patientId: $patientId');
      print('Extracted guardianId: $guardianId');
      print(
        'Extracted patientData: ${patientData != null ? "Present" : "None"}',
      );
    } else {
      print('WARNING: No arguments received!');
    }
    print('===================================');
  }

  final Map<String, double> planPrices = {
    'basic_3': 499.00, // ~$30 USD
    'basic_6': 899.00, // ~$55 USD
    'basic_12': 1499.00, // ~$100 USD
    'premium_3': 999.00, // ~$50 USD
    'premium_6': 1899.00, // ~$90 USD
    'premium_12': 2499.00, // ~$160 USD
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Choose Your Plan',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Select Your Care Plan',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Choose the plan that best fits your healthcare needs',
              style: TextStyle(fontSize: 16, color: AppColors.onSurfaceVariant),
            ),
            SizedBox(height: 32),

            // Plan Selection
            Text(
              'Plan Type',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 16),

            _buildPlanCard(
              'basic',
              'Basic Plan',
              'Essential healthcare features',
              [
                'View up to 5 caregivers',
                'View 1 article per day',
                'View 1 blog post per day',
                'Basic scheduling (task scheduling only)',
              ],
            ),
            SizedBox(height: 16),

            _buildPlanCard(
              'premium',
              'Premium Plan',
              'Complete healthcare solution',
              [
                'View all caregivers',
                'View all articles',
                'View all blog posts',
                'Premium scheduling with smart watch',
              ],
            ),
            SizedBox(height: 32),

            // Duration Selection
            if (selectedPlan != null) ...[
              Text(
                'Plan Duration',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 16),

              _buildDurationOptions(),
              SizedBox(height: 32),
            ],

            // Price Summary and Continue Button
            if (selectedPlan != null && selectedDuration != null) ...[
              _buildPriceSummary(),
              SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    _proceedToPayment();
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
                    'Proceed to Payment',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(
    String planType,
    String title,
    String subtitle,
    List<String> features,
  ) {
    bool isSelected = selectedPlan == planType;
    bool isPremium = planType == 'premium';

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPlan = planType;
          selectedDuration = null; // Reset duration when changing plan
        });
      },
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryLight.withOpacity(0.1)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outline,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.outline,
                      width: 2,
                    ),
                    color: isSelected ? AppColors.primary : AppColors.surface,
                  ),
                  child: isSelected
                      ? Icon(Icons.check, size: 16, color: AppColors.onPrimary)
                      : null,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (isPremium) ...[
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'POPULAR',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ...features.map(
              (feature) => Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 16,
                      color: AppColors.success,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        feature,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationOptions() {
    return Column(
      children: [
        _buildDurationCard('3', '3 Months', _getPrice(selectedPlan!, '3'), ''),
        SizedBox(height: 12),
        _buildDurationCard(
          '6',
          '6 Months',
          _getPrice(selectedPlan!, '6'),
          'Save 8%',
        ),
        SizedBox(height: 12),
        _buildDurationCard(
          '12',
          '1 Year',
          _getPrice(selectedPlan!, '12'),
          'Save 17%',
        ),
      ],
    );
  }

  Widget _buildDurationCard(
    String duration,
    String title,
    double price,
    String savings,
  ) {
    bool isSelected = selectedDuration == duration;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDuration = duration;
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
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (savings.isNotEmpty) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.successBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  savings,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.success,
                  ),
                ),
              ),
              SizedBox(width: 12),
            ],
            Text(
              'LKR ${price.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceSummary() {
    double price = _getPrice(selectedPlan!, selectedDuration!);
    double monthlyPrice = price / int.parse(selectedDuration!);

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${selectedPlan!.toUpperCase()} Plan - ${selectedDuration!} months',
                style: TextStyle(fontSize: 14, color: AppColors.onSurface),
              ),
              Text(
                'LKR ${price.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Monthly equivalent',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              Text(
                'LKR ${monthlyPrice.toStringAsFixed(2)}/month',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          Divider(height: 24, color: AppColors.outline),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'LKR ${price.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double _getPrice(String plan, String duration) {
    String key = '${plan}_$duration';
    return planPrices[key] ?? 0.0;
  }

  void _proceedToPayment() {
    // Check if we have patient data (new flow) or patientId (old flow for existing patients)
    if (patientData == null && patientId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: Patient information missing'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Navigate to payment screen with NEW parameters
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          durationMonths: int.parse(selectedDuration!), // NEW: int instead of string
          patientId: patientId ?? 0, // REQUIRED: patient must exist (0 as fallback for old flow)
          price: _getPrice(selectedPlan!, selectedDuration!),
          patientName: patientData?['firstName'] ?? 'Patient', // NEW: for display
          guardianId: guardianId,
          // Deprecated - for backward compatibility:
          planType: selectedPlan!,
          duration: selectedDuration!,
          patientData: patientData, // Still needed for old creation flow
        ),
      ),
    );
  }
}
