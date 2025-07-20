import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLanguage = 'English';
  bool _notificationsEnabled = true;
  double _fontSize = 16;
  bool _highContrast = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),
        ),
        centerTitle: true,

      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSectionTitle('Language'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLanguageButton('English'),
              _buildLanguageButton('සිංහල'),
              _buildLanguageButton('தமிழ்'),
            ],
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Notifications'),
          SwitchListTile(
            title: Text('Enable Notifications'),
            value: _notificationsEnabled,
            onChanged: (val) {
              setState(() {
                _notificationsEnabled = val;
              });
            },
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Accessibility'),
          ListTile(
            leading: Icon(Icons.text_fields),
            title: Text('Font Size'),
            trailing: DropdownButton<double>(
              value: _fontSize,
              items: [14, 16, 18, 20]
                  .map((size) => DropdownMenuItem(
                        value: size.toDouble(),
                        child: Text(size.toString()),
                      ))
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _fontSize = val;
                  });
                }
              },
            ),
          ),
          SwitchListTile(
            title: Text('High Contrast Mode'),
            value: _highContrast,
            onChanged: (val) {
              setState(() {
                _highContrast = val;
              });
            },
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Privacy & Security'),
          ListTile(
            leading: Icon(Icons.privacy_tip_outlined),
            title: Text('Privacy Policy'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.description_outlined),
            title: Text('Terms of Service'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.delete_outline),
            title: Text('Delete Account'),
            onTap: () {},
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Help & Support'),
          ListTile(
            leading: Icon(Icons.help_outline),
            title: Text('FAQ'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.contact_support_outlined),
            title: Text('Contact Support'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('App Version: 1.0.0'),
            onTap: () {},
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('About'),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('About the App'),
            onTap: () {},
          ),

        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
      ),
    );
  }

  Widget _buildLanguageButton(String lang) {
    final bool selected = _selectedLanguage == lang;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedLanguage = lang;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: selected ? Color(0xFF2B3F99) : Colors.grey[200],
        foregroundColor: selected ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Text(lang),
    );
  }
}
