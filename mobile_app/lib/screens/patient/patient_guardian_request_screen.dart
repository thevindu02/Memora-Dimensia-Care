import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class PatientGuardianRequestScreen extends StatefulWidget {
  const PatientGuardianRequestScreen({Key? key}) : super(key: key);

  @override
  State<PatientGuardianRequestScreen> createState() => _PatientGuardianRequestScreenState();
}

class _PatientGuardianRequestScreenState extends State<PatientGuardianRequestScreen> {
  // Mock data - in real app, this would come from API
  final String guardianName = "Sarah Johnson";
  final String guardianEmail = "sarah.johnson@email.com";

  void _showLearnMoreDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Color(0xFF2B3F99),
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                'About Guardians',
                style: TextStyle(
                  color: Color(0xFF2B3F99),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What is a Guardian?',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xFF2B3F99),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'A guardian is a trusted family member or friend who helps manage your care and monitors your well-being.',
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              SizedBox(height: 16),
              Text(
                'What can guardians do?',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xFF2B3F99),
                ),
              ),
              SizedBox(height: 8),
              _buildPermissionItem('👀', 'View your health reports and progress'),
              _buildPermissionItem('📅', 'Help schedule appointments and activities'),
              _buildPermissionItem('💊', 'Monitor medication reminders'),
              _buildPermissionItem('🔔', 'Receive important health notifications'),
              _buildPermissionItem('👨‍⚕️', 'Coordinate with your caregivers'),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFFA0C4FD).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Your privacy and autonomy are always respected. You can revoke guardian access at any time.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF2B3F99),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Got it',
                style: TextStyle(
                  color: Color(0xFF2B3F99),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPermissionItem(String emoji, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: TextStyle(fontSize: 16)),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  void _acceptConnection() {
    // Handle accept connection logic here
    // For now, just show a success message and navigate
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                'Connection Accepted',
                style: TextStyle(
                  color: Color(0xFF2B3F99),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            'You have successfully connected with $guardianName as your guardian.',
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pushReplacementNamed(
                  AppRoutes.patientEmailVerification,
                ); // Navigate to next step
              },
              child: Text(
                'Continue',
                style: TextStyle(
                  color: Color(0xFF2B3F99),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _declineConnection() {
    // Handle decline logic here
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Decline Connection',
            style: TextStyle(
              color: Color(0xFF2B3F99),
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Are you sure you want to decline this guardian request?',
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pushReplacementNamed(
                  AppRoutes.patientEmailVerification,
                ); // Navigate to next step
              },
              child: Text(
                'Decline',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Memora Logo
                    Image.asset(
                      'assets/images/light_logo.png',
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 40),

                    // Main message
                    Text(
                      'Your guardian has sent you a connection request',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2B3F99),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 32),

                    // Guardian info card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Color(0xFFA0C4FD).withOpacity(0.3),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Color(0xFFA0C4FD).withOpacity(0.5),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            guardianName,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2B3F99),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'wants to connect as your guardian',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF2B3F99),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Action buttons
              Column(
                children: [
                  // Accept button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _acceptConnection,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFA0C4FD),
                        foregroundColor: Color(0xFF2B3F99),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Accept Connection',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2B3F99),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Learn More button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: _showLearnMoreDialog,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Color(0xFF2B3F99),
                        side: BorderSide(color: Color(0xFF2B3F99)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Learn More',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2B3F99),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),

                  // Decline button
                  TextButton(
                    onPressed: _declineConnection,
                    child: Text(
                      'Decline Request',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
