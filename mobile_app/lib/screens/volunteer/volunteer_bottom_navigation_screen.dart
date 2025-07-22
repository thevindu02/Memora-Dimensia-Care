// Create a new file: volunteer_bottom_navigation.dart
import 'package:flutter/material.dart';
import 'volunteer_dashboard_screen.dart';
import 'volunteer_create_content_screen.dart';
import 'volunteer_forum_screen.dart';
import 'volunteer_profile_screen.dart';
import 'volunteer_community_screen.dart';

class VolunteerBottomNavigation extends StatelessWidget {
  final String currentPage;

  const VolunteerBottomNavigation({Key? key, required this.currentPage})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavButton(
            context,
            'Home',
            Icons.home,
            currentPage == 'home',
            () {
              if (currentPage != 'home') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VolunteerDashboardScreen(),
                  ),
                );
              }
            },
          ),
          _buildNavButton(
            context,
            'Content',
            Icons.create,
            currentPage == 'content',
            () {
              if (currentPage != 'content') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VolunteerCreateContentScreen(),
                  ),
                );
              }
            },
          ),
          _buildNavButton(
            context,
            'Community',
            Icons.forum,
            currentPage == 'community',
            () {
              if (currentPage != 'community') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VolunteerCommunityScreen(),
                  ),
                );
              }
            },
          ),
          _buildNavButton(
            context,
            'Profile',
            Icons.person,
            currentPage == 'profile',
            () {
              if (currentPage != 'profile') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VolunteerProfileScreen(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(
    BuildContext context,
    String title,
    IconData icon,
    bool isActive,
    VoidCallback onPressed,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? Color(0xFF2B3F99) : Colors.grey[500],
            size: 24,
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isActive ? Color(0xFF2B3F99) : Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
