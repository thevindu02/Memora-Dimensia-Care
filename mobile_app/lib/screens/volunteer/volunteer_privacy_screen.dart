import 'package:flutter/material.dart';

class VolunteerPrivacyScreen extends StatefulWidget {
  @override
  _VolunteerPrivacyScreenState createState() => _VolunteerPrivacyScreenState();
}

class _VolunteerPrivacyScreenState extends State<VolunteerPrivacyScreen> {
  bool _privacyExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Privacy Settings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Privacy Policy Expansion
            Container(
              color: Colors.white,
              child: ExpansionTile(
                title: Text(
                  'Privacy Policy',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                initiallyExpanded: _privacyExpanded,
                onExpansionChanged: (expanded) {
                  setState(() {
                    _privacyExpanded = expanded;
                  });
                },
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Privacy Matters',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'We value your privacy and are committed to protecting your personal information as a volunteer. Please review our volunteer privacy policy below:',
                          style: TextStyle(fontSize: 15, color: Colors.black87),
                        ),
                        SizedBox(height: 16),
                        Text(
                          '• We collect only the information needed to manage your volunteer activities, such as your name, contact details, and participation records.\n\n'
                          '• Your information is used to communicate with you about volunteer opportunities, events, and important updates.\n\n'
                          '• We do not share or sell your personal data. Your details may be shared with event organizers or relevant staff only for coordination and safety purposes.\n\n'
                          '• We use secure systems to store your data, and only authorized personnel can access your information.\n\n'
                          '• You have the right to update or request deletion of your volunteer information at any time.',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                            height: 1.6,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'If you have any questions or concerns about your privacy as a volunteer, please contact our support team. Thank you for your dedication and service!',
                          style: TextStyle(fontSize: 15, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, thickness: 1, color: Colors.grey[200]),
            // Delete Account Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  // TODO: Implement delete account logic or confirmation dialog
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.delete, color: Colors.red, size: 28),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Delete Account',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Permanently delete your account and all data',
                          style: TextStyle(color: Colors.black54, fontSize: 14),
                        ),
                      ],
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
}
