import 'package:flutter/material.dart';

class VolunteerHelpSupportScreen extends StatefulWidget {
  @override
  _VolunteerHelpSupportScreenState createState() =>
      _VolunteerHelpSupportScreenState();
}

class _VolunteerHelpSupportScreenState
    extends State<VolunteerHelpSupportScreen> {
  bool _userGuideExpanded = false;
  bool _termsExpanded = false;
  final TextEditingController _feedbackController = TextEditingController();

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
      color: Colors.white,
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Color(0xFFA0C4FD).withOpacity(0.35),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(icon, color: Color(0xFF2B3F99), size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[600]),
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
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: Color(0xFFF5F0FF), // light purple
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contact Support',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "Choose how you'd like to contact us:",
                  style: TextStyle(fontSize: 15, color: Colors.black87),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Icon(Icons.email, color: Color(0xFF4285F4)),
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
                          'support@memoraapp.com',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.phone, color: Color(0xFF34A853)),
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
                        Text(
                          '+1-800-VOLUNTEER',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.deepPurple),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFeedbackDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: Color(0xFFF5F0FF), // light purple
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Send Feedback',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "We'd love to hear from you! Please share your thoughts about the app.",
                  style: TextStyle(fontSize: 15, color: Colors.black87),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _feedbackController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Enter your feedback here...',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        if (_feedbackController.text.isNotEmpty) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Feedback sent'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          _feedbackController.clear();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFD1C4E9),
                        foregroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text('Send'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Help & Support',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
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
                      'Welcome to the Volunteer App!\n\n'
                      '• To view and accept volunteer requests, go to the Requests tab.\n'
                      '• To update your profile, visit the Profile section.\n'
                      '• For event schedules and updates, check the Dashboard.\n'
                      '• Manage your notification preferences in Settings.\n\n'
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
                      'By using the Volunteer App, you agree to our terms and conditions.\n\n'
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
              question: 'How do I view and accept volunteer requests?',
              answer:
                  'Go to the Requests tab to see pending requests. Tap on a request to view details and accept or decline it.',
            ),
            Divider(height: 1, thickness: 1, color: Colors.grey[200]),
            _buildFAQItem(
              question: 'How do I update my profile information?',
              answer:
                  'Navigate to the Profile section and tap the edit icon to update your personal information.',
            ),
            Divider(height: 1, thickness: 1, color: Colors.grey[200]),
            _buildFAQItem(
              question: 'How do I get notified about new events or requests?',
              answer:
                  'Ensure notifications are enabled in Settings. You will receive alerts for new events and requests.',
            ),
            Divider(height: 1, thickness: 1, color: Colors.grey[200]),
            _buildFAQItem(
              question: 'Is my volunteer data secure?',
              answer:
                  'Yes, your data is encrypted and stored securely. Only authorized personnel can access your information.',
            ),
            Divider(height: 1, thickness: 1, color: Colors.grey[200]),
            _buildFAQItem(
              question: 'How do I contact support if I have an issue?',
              answer:
                  'Use the Contact Support option above to email or call our support team for assistance.',
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
