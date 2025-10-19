import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../constants/color_constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _receiveNotifications = true;
  String _selectedLanguage = 'English';

  final List<String> _languages = ['English', 'සිංහල', 'தமிழ்'];

  Widget _buildSettingsItem({
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.blue.withOpacity(0.1),
        highlightColor: Colors.blue.withOpacity(0.05),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Row(
            children: [
              Expanded(
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
                    if (subtitle.isNotEmpty) ...[
                      SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Language'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _languages.length,
              itemBuilder: (context, index) {
                final language = _languages[index];
                return RadioListTile<String>(
                  title: Text(language),
                  value: language,
                  groupValue: _selectedLanguage,
                  onChanged: (value) {
                    setState(() {
                      _selectedLanguage = value!;
                    });
                    Navigator.of(context).pop();
                  },
                  activeColor: Color(0xFF2B3F99),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showPrivacyScreen() {
    Navigator.pushNamed(context, AppRoutes.caregiverSettingsPrivacy);
  }

  void _showHelpScreen() {
    Navigator.pushNamed(context, AppRoutes.caregiverSettingsHelpSupport);
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Log Out'),
          content: Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to login screen and clear all previous routes
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (route) => false,
                );
              },
              child: Text('Log Out', style: TextStyle(color: Colors.red)),
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
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.caregiverDashboard,
              (route) => false,
            );
          },
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: Column(
              children: [
                _buildSettingsItem(
                  title: 'Receive notifications',
                  subtitle: '',
                  trailing: Switch(
                    value: _receiveNotifications,
                    onChanged: (value) {
                      setState(() {
                        _receiveNotifications = value;
                      });
                    },
                    activeColor: Color(0xFFA0C4FD),
                  ),
                ),
                Divider(height: 1, thickness: 1, color: Colors.grey[200]),

                _buildSettingsItem(
                  title: 'Language',
                  subtitle: _selectedLanguage,
                  trailing: Icon(Icons.chevron_right, color: Colors.grey[600]),
                  onTap: _showLanguageDialog,
                ),
                Divider(height: 1, thickness: 1, color: Colors.grey[200]),

                _buildSettingsItem(
                  title: 'Privacy',
                  subtitle: 'Manage your data',
                  trailing: Icon(Icons.chevron_right, color: Colors.grey[600]),
                  onTap: _showPrivacyScreen,
                ),
                Divider(height: 1, thickness: 1, color: Colors.grey[200]),

                _buildSettingsItem(
                  title: 'Help',
                  subtitle: 'FAQs and support',
                  trailing: Icon(Icons.chevron_right, color: Color(0xFF2B3F99)),
                  onTap: _showHelpScreen,
                ),
              ],
            ),
          ),

          SizedBox(height: 24),

          // Log out button
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _showLogoutDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryLight.withOpacity(0.35),
                foregroundColor: AppColors.info,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text(
                'Log out',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
