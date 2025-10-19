import 'package:flutter/material.dart';
import '../../constants/color_constants.dart';
import '../../routes/app_routes.dart';
import 'guardian_articles_tab_body.dart';
import 'guardian_bottom_nav_bar.dart';

class GuardianCommunityScreen extends StatefulWidget {
  @override
  _GuardianCommunityScreenState createState() =>
      _GuardianCommunityScreenState();
}

class _GuardianCommunityScreenState extends State<GuardianCommunityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 2; // Community tab

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onBottomNavTap(int index) {
    if (index == 2) {
      // Already on Community - no need to navigate
      return;
    }

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
            );
          },
        ),
        title: Text(
          'Community',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primary,
          tabs: [
            Tab(text: 'Articles'),
            Tab(text: 'Q&A Forum'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Articles Tab - Uses the new backend-integrated tab body
          GuardianArticlesTabBody(),

          // Q&A Forum Tab - Navigate to existing Q&A screen
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.forum, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Q&A Forum',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.guardianQAForums);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: Text('Go to Q&A Forum'),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }
}
