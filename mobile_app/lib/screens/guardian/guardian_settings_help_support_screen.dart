import 'package:flutter/material.dart';

class GuardianSettingsHelpSupportScreen extends StatefulWidget {
  @override
  _HelpSupportScreenState createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<GuardianSettingsHelpSupportScreen> {
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
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.blue[700], size: 24),
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
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[600]),
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      ),
    );
  }

  Widget _buildFAQItem({
    required String question,
    required String answer,
  }) {
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
            child: Text(
              answer,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
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
              Text('Choose how you\'d like to contact us:'),
              SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.email, color: Colors.blue),
                title: Text('Email'),
                subtitle: Text('support@guardianapp.com'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Opening email client...')),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.phone, color: Colors.green),
                title: Text('Phone'),
                subtitle: Text('+1-800-GUARDIAN'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Dialing support number...')),
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
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
              Text('We\'d love to hear from you! Please share your thoughts about the app.'),
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
              icon: Icons.chat,
              title: 'Live Chat',
              subtitle: 'Chat with our support team in real-time',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Live chat feature coming soon!')),
                );
              },
            ),
            Divider(height: 1, thickness: 1, color: Colors.grey[200]),
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
            _buildHelpItem(
              icon: Icons.bug_report,
              title: 'Report a Bug',
              subtitle: 'Let us know about any issues you encounter',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Bug report form would open here')),
                );
              },
            ),

            // Resources Section
            _buildSectionHeader('Resources'),
            _buildHelpItem(
              icon: Icons.book,
              title: 'User Guide',
              subtitle: 'Learn how to use the app effectively',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('User guide would open here')),
                );
              },
            ),
            Divider(height: 1, thickness: 1, color: Colors.grey[200]),
            _buildHelpItem(
              icon: Icons.play_circle,
              title: 'Video Tutorials',
              subtitle: 'Watch step-by-step tutorials',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Video tutorials would open here')),
                );
              },
            ),
            Divider(height: 1, thickness: 1, color: Colors.grey[200]),
            _buildHelpItem(
              icon: Icons.article,
              title: 'Terms of Service',
              subtitle: 'Read our terms and conditions',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Terms of service would open here')),
                );
              },
            ),

            // FAQ Section
            _buildSectionHeader('Frequently Asked Questions'),
            _buildFAQItem(
              question: 'How do I reset my password?',
              answer: 'Go to the login screen and tap "Forgot Password". Enter your email address and we\'ll send you a link to reset your password.',
            ),
            Divider(height: 1, thickness: 1, color: Colors.grey[200]),
            _buildFAQItem(
              question: 'How do I update my notification preferences?',
              answer: 'Go to your Profile screen and scroll down to the Notifications section. You can toggle notifications on or off according to your preferences.',
            ),
            Divider(height: 1, thickness: 1, color: Colors.grey[200]),
            _buildFAQItem(
              question: 'Is my data secure?',
              answer: 'Yes, we take data security seriously. All your personal information is encrypted and stored securely. You can learn more in our Privacy Policy.',
            ),
            Divider(height: 1, thickness: 1, color: Colors.grey[200]),
            _buildFAQItem(
              question: 'How do I delete my account?',
              answer: 'Go to Profile > Privacy Settings and scroll down to find the "Delete Account" option. Please note that this action is permanent and cannot be undone.',
            ),
            Divider(height: 1, thickness: 1, color: Colors.grey[200]),
            _buildFAQItem(
              question: 'Can I use the app offline?',
              answer: 'Some features work offline, but most functionality requires an internet connection. We recommend staying connected for the best experience.',
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
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
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
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
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