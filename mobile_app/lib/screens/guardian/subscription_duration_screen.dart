import 'package:flutter/material.dart';
import 'payment_screen.dart';
import '../../routes/app_routes.dart';

class SubscriptionDurationScreen extends StatefulWidget {
  final int guardianId;
  final int patientId;
  final String patientName;
  final Map<String, dynamic>? currentSubscription;

  const SubscriptionDurationScreen({
    Key? key,
    required this.guardianId,
    required this.patientId,
    required this.patientName,
    this.currentSubscription,
  }) : super(key: key);

  @override
  State<SubscriptionDurationScreen> createState() =>
      _SubscriptionDurationScreenState();
}

class _SubscriptionDurationScreenState
    extends State<SubscriptionDurationScreen> {
  int? _selectedDuration;

  final Map<int, double> _prices = {
    3: 499.0,
    6: 999.0,
    12: 1399.0,
  };

  int _calculateTotalMonths(int paidMonths) {
    int trialMonths = 3; // 3-month free trial
    bool hasActiveTrial = false;

    if (widget.currentSubscription != null) {
      final trialEndDate = widget.currentSubscription!['trialEndDate'];
      if (trialEndDate != null) {
        final endDate = DateTime.parse(trialEndDate);
        hasActiveTrial = endDate.isAfter(DateTime.now());
      }
    }

    return hasActiveTrial ? trialMonths + paidMonths : paidMonths;
  }

  bool _hasActiveTrial() {
    if (widget.currentSubscription != null) {
      final status = widget.currentSubscription!['status'];
      return status == 'TRIAL';
    }
    return false;
  }

  Widget _buildDurationCard(int months, double price) {
    final isSelected = _selectedDuration == months;
    final totalMonths = _calculateTotalMonths(months);

    return Card(
      elevation: isSelected ? 8 : 2,
      color: isSelected ? Colors.blue[50] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? Colors.blue : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedDuration = months;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Radio button
              Radio<int>(
                value: months,
                groupValue: _selectedDuration,
                onChanged: (value) {
                  setState(() {
                    _selectedDuration = value;
                  });
                },
              ),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$months Months',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.blue[900] : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'LKR ${price.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.green[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (_hasActiveTrial())
                      Text(
                        'Total: $totalMonths months (includes trial)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                  ],
                ),
              ),
              // Check icon
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: Colors.blue,
                  size: 28,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSkipPayment() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Skip Payment'),
        content: const Text(
          'The patient will get a 3-month free trial when a caregiver accepts your request. '
          'You can add a paid subscription anytime before the trial expires.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              // Navigate to guardian dashboard and remove all previous routes
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.guardianDashboard,
                (route) => false,
              );
            },
            child: const Text('Skip for Now'),
          ),
        ],
      ),
    );
  }

  void _handleContinueToPayment() {
    if (_selectedDuration == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a subscription duration'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Navigate to payment screen with NEW parameters
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          durationMonths: _selectedDuration!, // Required: 3, 6, or 12
          patientId: widget.patientId, // Required: patient must exist
          price: _prices[_selectedDuration]!, // Price from map
          patientName: widget.patientName, // For display
          guardianId: widget.guardianId, // Guardian ID
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Subscription Period'),
        backgroundColor: Colors.blue[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Patient info
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Patient: ${widget.patientName}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue[700]),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '3-Month Free Trial included\n(starts when caregiver accepts)',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue[900],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Title
            const Text(
              'Choose Your Subscription',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select the duration for paid subscription period',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),

            // Duration options
            _buildDurationCard(3, _prices[3]!),
            const SizedBox(height: 12),
            _buildDurationCard(6, _prices[6]!),
            const SizedBox(height: 12),
            _buildDurationCard(12, _prices[12]!),
            const SizedBox(height: 32),

            // Continue button
            ElevatedButton(
              onPressed: _handleContinueToPayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Continue to Payment',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Skip button
            OutlinedButton(
              onPressed: _handleSkipPayment,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side: BorderSide(color: Colors.grey[400]!),
              ),
              child: Text(
                'Skip Payment (Use Free Trial Only)',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Info box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb_outline, color: Colors.orange[700]),
                      const SizedBox(width: 8),
                      const Text(
                        'How it works',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInfoItem(
                    '1. Patient gets 3-month free trial immediately',
                  ),
                  _buildInfoItem(
                    '2. Paid period starts after trial ends',
                  ),
                  _buildInfoItem(
                    '3. You can skip payment and pay later before trial expires',
                  ),
                  _buildInfoItem(
                    '4. Total subscription = Trial + Paid period',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
