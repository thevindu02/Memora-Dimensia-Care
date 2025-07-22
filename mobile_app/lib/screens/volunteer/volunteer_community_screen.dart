import 'package:flutter/material.dart';
import 'volunteer_article_displaying_screen.dart';
import 'volunteer_q&a_forum_screen.dart';
import '../guardian/guardian_forum_article_screen.dart' as guardian;
import '../guardian/guardian_forums_screen.dart' as guardian;

class VolunteerCommunityScreen extends StatefulWidget {
  const VolunteerCommunityScreen({Key? key}) : super(key: key);

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
            Navigator.pop(context);
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
          labelColor: Color(0xFF2B3F99),
          unselectedLabelColor: Colors.grey,
          indicatorColor: Color(0xFF2B3F99),
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
          tabs: const [
            Tab(text: 'Articles'),
            Tab(text: 'Q & A'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          guardian.GuardianForumArticleScreen(),
          guardian.GuardianForumsScreen(),
        ],
      ),
    );
  }
}
