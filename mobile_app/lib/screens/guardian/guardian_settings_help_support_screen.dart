import 'package:flutter/material.dart';
import '../../constants/color_constants.dart';

class GuardianSettingsHelpSupportScreen extends StatefulWidget {
  @override
  _HelpSupportScreenState createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<GuardianSettingsHelpSupportScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  bool _userGuideExpanded = false;
  bool _termsExpanded = false;

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  Widget _buildHelpItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      color: AppColors.surface,
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withOpacity(0.35),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(icon, color: AppColors.info, size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.onSurface,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant),
        ),
        trailing: Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      ),
    );
  }

  Widget _buildFAQItem({required String question, required String answer}) {
    return Container(
      color: Colors.white,
      child: ExpansionTile(
        title: Text(
          question,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                answer,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      color: Colors.grey[50],
      padding: EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  void _showContactDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Contact Support'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Choose how you'd like to contact us:"),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.email, color: Colors.blue),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'support@memora.com',
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.phone, color: Colors.green),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Phone',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Text('+94 011 1234567', style: TextStyle(fontSize: 15)),
                    ],
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: Colors.deepPurple)),
            ),
          ],
        );
      },
    );
  }

  void _showFeedbackDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Send Feedback'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'We\'d love to hear from you! Please share your thoughts about the app.',
              ),
              SizedBox(height: 16),
              TextField(
                controller: _feedbackController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Enter your feedback here...',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_feedbackController.text.isNotEmpty) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Thank you for your feedback!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  _feedbackController.clear();
                }
              },
              child: Text('Send'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceVariant,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Help & Support',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Help Section
            _buildSectionHeader('Quick Help'),
            _buildHelpItem(
              icon: Icons.contact_support,
              title: 'Contact Support',
              subtitle: 'Email or call our support team',
              onTap: _showContactDialog,
            ),
            Divider(height: 1, thickness: 1, color: Colors.grey[200]),
            _buildHelpItem(
              icon: Icons.feedback,
              title: 'Send Feedback',
              subtitle: 'Share your thoughts and suggestions',
              onTap: _showFeedbackDialog,
            ),
            Divider(height: 1, thickness: 1, color: Colors.grey[200]),

            // Resources Section
            _buildSectionHeader('Resources'),
            Container(
              color: Colors.white,
              child: ExpansionTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFFA0C4FD).withOpacity(0.35),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(Icons.book, color: Color(0xFF2B3F99), size: 22),
                ),
                title: Text(
                  'User Guide',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                subtitle: Text(
                  'Learn how to use the app effectively',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                initiallyExpanded: _userGuideExpanded,
                onExpansionChanged: (expanded) {
                  setState(() {
                    _userGuideExpanded = expanded;
                  });
                },
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: Text(
                      'Welcome to the Guardian App!\n\n'
                      '• To add a patient, go to the Dashboard and tap "Add Patient".\n'
                      '• To connect with caregivers, use the "Add Caregiver" option.\n'
                      '• View reports and alerts from the Dashboard.\n'
                      '• Manage your account and privacy settings from the Settings menu.\n\n'
                      'For more help, contact our support team.',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, thickness: 1, color: Colors.grey[200]),
            Container(
              color: Colors.white,
              child: ExpansionTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFFA0C4FD).withOpacity(0.35),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.article,
                    color: Color(0xFF2B3F99),
                    size: 22,
                  ),
                ),
                title: Text(
                  'Terms of Service',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                subtitle: Text(
                  'Read our terms and conditions',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                initiallyExpanded: _termsExpanded,
                onExpansionChanged: (expanded) {
                  setState(() {
                    _termsExpanded = expanded;
                  });
                },
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: Text(
                      'By using the Guardian App, you agree to our terms and conditions.\n\n'
                      '• Use the app responsibly and only for its intended purpose.\n'
                      '• Do not share your login credentials with others.\n'
                      '• We are not liable for any misuse of the app or data breaches caused by user negligence.\n'
                      '• For full terms, please contact our support team.',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, thickness: 1, color: Colors.grey[200]),

            // FAQ Section
            _buildSectionHeader('Frequently Asked Questions'),
            _buildFAQItem(
              question: 'How do I reset my password?',
              answer:
                  'Go to the login screen and tap "Forgot Password". Enter your email address and we\'ll send you a link to reset your password.',
            ),
            Divider(height: 1, thickness: 1, color: Colors.grey[200]),
            _buildFAQItem(
              question: 'How do I update my notification preferences?',
              answer:
                  'Go to your Settings screen and use the Receive notifications toggle.',
            ),
            Divider(height: 1, thickness: 1, color: Colors.grey[200]),
            _buildFAQItem(
              question: 'Is my data secure?',
              answer:
                  'Yes, we take data security seriously. All your personal information is encrypted and stored securely. You can learn more in our Privacy Policy.',
            ),
            Divider(height: 1, thickness: 1, color: Colors.grey[200]),
            _buildFAQItem(
              question: 'How do I delete my account?',
              answer:
                  'Go to Settings > Privacy Settings and scroll down to find the "Delete Account" option. Please note that this action is permanent and cannot be undone.',
            ),
            Divider(height: 1, thickness: 1, color: Colors.grey[200]),
            _buildFAQItem(
              question: 'Can I use the app offline?',
              answer:
                  'Some features work offline, but most functionality requires an internet connection. We recommend staying connected for the best experience.',
            ),

            // App Info Section
            _buildSectionHeader('App Information'),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.grey[600]),
                      SizedBox(width: 12),
                      Text(
                        'Version 1.0.0',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.update, color: Colors.grey[600]),
                      SizedBox(width: 12),
                      Text(
                        'Last updated: January 2025',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Checking for updates...')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFA0C4FD),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Check for Updates',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2B3F99),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
