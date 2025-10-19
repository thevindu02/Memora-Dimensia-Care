import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import 'guardian_bottom_nav_bar.dart';
import 'guardian_articles_tab_body.dart';

class GuardianArticlesScreen extends StatefulWidget {
  @override
  _GuardianArticlesScreenState createState() => _GuardianArticlesScreenState();
}

class _GuardianArticlesScreenState extends State<GuardianArticlesScreen> {
  int _selectedIndex = 1; // Articles is index 1

  void _onBottomNavTap(int index) {
    if (index == 1) {
      // Already on Articles - no need to navigate
      return;
    }

    // Update the selected index for visual feedback
    setState(() {
      _selectedIndex = index;
    });

    // Use the helper to handle navigation
    BottomNavHelper.handleNavigation(context, index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.guardianDashboard,
              (route) => false,
              arguments: {'selectedIndex': 0},
            );
          },
        ),
        title: Text(
          'Articles',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: GuardianArticlesTabBody(),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }
}
