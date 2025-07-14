import 'package:flutter/material.dart';
import 'volunteer_bottom_navigation_screen.dart';

class VolunteerProfileScreen extends StatefulWidget {
  const VolunteerProfileScreen({Key? key}) : super(key: key);

  @override
  State<VolunteerProfileScreen> createState() => _VolunteerProfileScreenState();
}

class _VolunteerProfileScreenState extends State<VolunteerProfileScreen> {
  bool receiveNotifications = true;

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
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face'),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John Smith',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Volunteer',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 40),
            
            // Profile Details Section
            Text(
              'Profile Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 24),
            
            // Edit Profile
            _buildProfileItem(
              Icons.edit_outlined,
              'Edit Profile',
              onTap: () {
                // Handle edit profile
              },
            ),
            SizedBox(height: 16),
            
            // Upload ID Image
            _buildProfileItem(
              Icons.image_outlined,
              'Upload ID Image',
              onTap: () {
                // Handle upload ID image
              },
            ),
            SizedBox(height: 16),
            
            // Receive Notifications with Toggle
            _buildProfileItem(
              null,
              'Receive notifications',
              hasToggle: true,
              isEnabled: receiveNotifications,
              onToggle: (value) {
                setState(() {
                  receiveNotifications = value;
                });
              },
            ),
            
            Spacer(),
          ],
        ),
      ),
       bottomNavigationBar: VolunteerBottomNavigation(currentPage: 'profile'),
    );
  }

  Widget _buildProfileItem(
    IconData? icon, 
    String title, {
    bool hasToggle = false, 
    bool isEnabled = false,
    VoidCallback? onTap,
    Function(bool)? onToggle,
  }) {
    return GestureDetector(
      onTap: hasToggle ? null : onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            if (icon != null) ...[
              Container(
                width: 24,
                height: 24,
                child: Icon(icon, color: Colors.black, size: 20),
              ),
              SizedBox(width: 16),
            ],
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            if (hasToggle)
              Switch(
                value: isEnabled,
                onChanged: onToggle,
                activeColor: Colors.blue,
                activeTrackColor: Colors.blue.withOpacity(0.3),
                inactiveTrackColor: Colors.grey[300],
                inactiveThumbColor: Colors.white,
              ),
          ],
        ),
      ),
    );
  }
}