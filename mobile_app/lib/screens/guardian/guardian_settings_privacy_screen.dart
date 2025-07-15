import 'package:flutter/material.dart';

class GuardianSettingsPrivacyScreen extends StatefulWidget {
  @override
  _PrivacySettingsScreenState createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<GuardianSettingsPrivacyScreen> {
  bool _profileVisibility = true;
  bool _shareLocation = false;
  bool _allowMessages = true;
  bool _shareActivity = false;
  bool _dataCollection = true;
  bool _marketingEmails = false;
  String _selectedDataRetention = '1 year';

  final List<String> _dataRetentionOptions = [
    '6 months',
    '1 year',
    '2 years',
    '5 years',
    'Until deleted'
  ];

  Widget _buildSettingTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      color: Colors.white,
      child: SwitchListTile(
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
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blue,
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      ),
    );
  }

  Widget _buildDropdownTile({
    required String title,
    required String subtitle,
    required String value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              underline: SizedBox(),
              onChanged: onChanged,
              items: options.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    Color? titleColor,
  }) {
    return Container(
      color: Colors.white,
      child: ListTile(
        leading: Icon(icon, color: titleColor ?? Colors.grey[700]),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: titleColor ?? Colors.black87,
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
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
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

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Account'),
          content: Text(
            'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently removed.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Account deletion process initiated'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
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
          'Privacy Settings',
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
            // Profile Privacy Section
            _buildSectionHeader('Profile Privacy'),
            _buildSettingTile(
              title: 'Profile Visibility',
              subtitle: 'Make your profile visible to other users',
              value: _profileVisibility,
              onChanged: (value) {
                setState(() {
                  _profileVisibility = value;
                });
              },
            ),
            Divider(height: 1, thickness: 1, color: Colors.grey[200]),
            _buildSettingTile(
              title: 'Share Location',
              subtitle: 'Allow the app to access your location',
              value: _shareLocation,
              onChanged: (value) {
                setState(() {
                  _shareLocation = value;
                });
              },
            ),
            Divider(height: 1, thickness: 1, color: Colors.grey[200]),
            _buildSettingTile(
              title: 'Allow Messages',
              subtitle: 'Receive messages from other users',
              value: _allowMessages,
              onChanged: (value) {
                setState(() {
                  _allowMessages = value;
                });
              },
            ),

            // Data & Activity Section
            _buildSectionHeader('Data & Activity'),
            _buildSettingTile(
              title: 'Share Activity',
              subtitle: 'Share your app activity with other users',
              value: _shareActivity,
              onChanged: (value) {
                setState(() {
                  _shareActivity = value;
                });
              },
            ),
            Divider(height: 1, thickness: 1, color: Colors.grey[200]),
            _buildSettingTile(
              title: 'Data Collection',
              subtitle: 'Allow anonymous data collection for app improvement',
              value: _dataCollection,
              onChanged: (value) {
                setState(() {
                  _dataCollection = value;
                });
              },
            ),
            Divider(height: 1, thickness: 1, color: Colors.grey[200]),
            _buildDropdownTile(
              title: 'Data Retention',
              subtitle: 'How long should we keep your data',
              value: _selectedDataRetention,
              options: _dataRetentionOptions,
              onChanged: (value) {
                setState(() {
                  _selectedDataRetention = value!;
                });
              },
            ),

            // Communications Section
            _buildSectionHeader('Communications'),
            _buildSettingTile(
              title: 'Marketing Emails',
              subtitle: 'Receive promotional emails and updates',
              value: _marketingEmails,
              onChanged: (value) {
                setState(() {
                  _marketingEmails = value;
                });
              },
            ),

            // Account Management Section
            _buildSectionHeader('Account Management'),
            _buildActionTile(
              title: 'Download My Data',
              subtitle: 'Request a copy of your personal data',
              icon: Icons.download,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Data download request submitted')),
                );
              },
            ),
            Divider(height: 1, thickness: 1, color: Colors.grey[200]),
            _buildActionTile(
              title: 'Privacy Policy',
              subtitle: 'Read our privacy policy',
              icon: Icons.privacy_tip,
              onTap: () {
                // TODO: Navigate to privacy policy
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Privacy policy would open here')),
                );
              },
            ),
            Divider(height: 1, thickness: 1, color: Colors.grey[200]),
            _buildActionTile(
              title: 'Delete Account',
              subtitle: 'Permanently delete your account and all data',
              icon: Icons.delete_forever,
              titleColor: Colors.red,
              onTap: _showDeleteAccountDialog,
            ),

            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}