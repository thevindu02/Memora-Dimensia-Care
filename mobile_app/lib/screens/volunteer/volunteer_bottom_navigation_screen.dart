// Create a new file: volunteer_bottom_navigation.dart
import 'package:flutter/material.dart';
import 'volunteer_dashboard_screen.dart';
import 'volunteer_create_content_screen.dart';
import 'volunteer_forum_screen.dart';
import 'volunteer_profile_screen.dart';
import 'volunteer_community_screen.dart';
import '../../constants/color_constants.dart';

class VolunteerBottomNavigation extends StatelessWidget {
  final String currentPage;
  final int volunteerId; // <-- Add this

  const VolunteerBottomNavigation({
    Key? key,
    required this.currentPage,
    required this.volunteerId, // <-- Add this
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.outline, width: 1)),
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
                    builder: (context) => VolunteerDashboardScreen(volunteerId: volunteerId), // <-- FIXED
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
                    builder: (context) => VolunteerCreateContentScreen(volunteerId: volunteerId), // <-- FIXED
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
                    builder: (context) => VolunteerCommunityScreen(volunteerId: volunteerId), // <-- Pass volunteerId here
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
                    builder: (context) => VolunteerProfileScreen(volunteerId: volunteerId), // <-- Pass volunteerId here
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
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.info : AppColors.onSurfaceVariant,
              size: 24,
            ),
            SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isActive ? AppColors.info : AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}