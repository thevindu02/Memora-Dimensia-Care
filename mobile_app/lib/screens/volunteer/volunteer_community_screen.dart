import 'package:flutter/material.dart';

import 'volunteer_q&a_forum_screen.dart';
import 'volunteer_bottom_navigation_screen.dart';
import '../../routes/app_routes.dart';
import 'volunteer_articles_screen.dart';
import '../../widgets/volunteer_qa_tab_body.dart';
import '../../constants/color_constants.dart';

class VolunteerCommunityScreen extends StatefulWidget {
  final int volunteerId;
  const VolunteerCommunityScreen({Key? key, required this.volunteerId}) : super(key: key);

  @override
  State<VolunteerCommunityScreen> createState() =>
      _VolunteerCommunityScreenState();
}

class _VolunteerCommunityScreenState extends State<VolunteerCommunityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
            Navigator.pushNamed(context, AppRoutes.volunteerDashboard);
          },
        ),
        title: const Text(
          'Community',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.info,
          unselectedLabelColor: AppColors.onSurfaceVariant,
          indicatorColor: AppColors.info,
          splashFactory: NoSplash.splashFactory,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
          tabs: const [
            Tab(text: 'Articles'),
            Tab(text: 'Q & A'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [VolunteerArticlesTabBody(), VolunteerQATabBody()],
      ),
      bottomNavigationBar: VolunteerBottomNavigation(
        currentPage: 'community',
        volunteerId: widget.volunteerId, // <-- Pass volunteerId here
      ),
    );
  }
}
