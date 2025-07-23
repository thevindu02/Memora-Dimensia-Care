import 'package:flutter/material.dart';
import 'volunteer_bottom_navigation_screen.dart';
import 'volunteer_help_support_screen.dart';
import 'volunteer_privacy_screen.dart';

class VolunteerSettingsScreen extends StatefulWidget {
  const VolunteerSettingsScreen({Key? key}) : super(key: key);

  @override
  State<VolunteerSettingsScreen> createState() =>
      _VolunteerSettingsScreenState();
}

class _VolunteerSettingsScreenState extends State<VolunteerSettingsScreen> {
  bool receiveNotifications = true;
  String selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          SizedBox(height: 24), // Gap between title and first field
          Expanded(
            child: ListView(
              children: [
                // Receive notifications
                ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 0,
                  ),
                  minVerticalPadding: 24, // Increase field height
                  title: Text(
                    'Receive notifications',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  trailing: Switch(
                    value: receiveNotifications,
                    onChanged: (value) {
                      setState(() {
                        receiveNotifications = value;
                      });
                    },
                    activeColor: Color(0xFF2B3F99), // calm navy
                    activeTrackColor: Color(
                      0x59A0C4FD,
                    ), // light sky blue with 35% opacity
                  ),
                ),
                Divider(height: 1),
                // Language
                ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 0,
                  ),
                  minVerticalPadding: 24, // Increase field height
                  title: Text(
                    'Language',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    selectedLanguage,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.grey[500],
                  ),
                  onTap: () async {
                    final lang = await showModalBottomSheet<String>(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      builder: (context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 16),
                            Text(
                              'Select Language',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            ...['English', 'Sinhala', 'Tamil'].map(
                              (langOption) => ListTile(
                                title: Text(
                                  langOption,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                trailing: selectedLanguage == langOption
                                    ? Icon(
                                        Icons.check,
                                        color: Color(0xFF2B3F99),
                                      )
                                    : null,
                                onTap: () => Navigator.pop(context, langOption),
                              ),
                            ),
                            SizedBox(height: 16),
                          ],
                        );
                      },
                    );
                    if (lang != null && lang != selectedLanguage) {
                      setState(() {
                        selectedLanguage = lang;
                      });
                    }
                  },
                ),
                Divider(height: 1),
                // Privacy
                ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 0,
                  ),
                  minVerticalPadding: 24, // Increase field height
                  title: Text(
                    'Privacy',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Manage your data',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.grey[500],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VolunteerPrivacyScreen(),
                      ),
                    );
                  },
                ),
                Divider(height: 1),
                // Help
                ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 0,
                  ),
                  minVerticalPadding: 24, // Increase field height
                  title: Text(
                    'Help',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'FAQs & support',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.grey[500],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VolunteerHelpSupportScreen(),
                      ),
                    );
                  },
                ),
                Divider(height: 1),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () async {
                  final shouldLogout = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Log out'),
                      content: Text('Are you sure you want to log out?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text('Yes'),
                        ),
                      ],
                    ),
                  );
                  if (shouldLogout == true) {
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil('/login', (route) => false);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(
                    0x59A0C4FD,
                  ), // light sky blue with 35% opacity
                  foregroundColor: Color(0xFF2B3F99), // calm navy
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Text(
                  'Log out',
                  style: TextStyle(
                    color: Color(0xFF2B3F99),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: VolunteerBottomNavigation(currentPage: 'profile'),
    );
  }
}
