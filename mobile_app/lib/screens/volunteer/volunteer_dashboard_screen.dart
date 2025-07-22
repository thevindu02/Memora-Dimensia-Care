import 'package:flutter/material.dart';
import 'volunteer_create_content_screen.dart';
import 'volunteer_forum_screen.dart';
import 'volunteer_schedule_session_screen.dart';
import 'volunteer_profile_screen.dart';
import 'volunteer_bottom_navigation_screen.dart';
import '../../utils/system_ui_utils.dart';

class VolunteerDashboardScreen extends StatefulWidget {
  const VolunteerDashboardScreen({Key? key}) : super(key: key);

  @override
  State<VolunteerDashboardScreen> createState() =>
      _VolunteerDashboardScreenState();
}

class _VolunteerDashboardScreenState extends State<VolunteerDashboardScreen> {
  int _currentImageIndex = 0;

  // List of network images for the carousel
  final List<String> _networkImages = [
    'https://images.unsplash.com/photo-1559027615-cd4628902d4a?w=400&h=300&fit=crop',
    'https://images.unsplash.com/photo-1582213782179-e0d53f98f2ca?w=400&h=300&fit=crop',
    'https://images.unsplash.com/photo-1531482615713-2afd69097998?w=400&h=300&fit=crop',
    'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=400&h=300&fit=crop',
  ];

  @override
  void initState() {
    super.initState();
    _startImageCarousel();
  }

  void _startImageCarousel() {
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _currentImageIndex = (_currentImageIndex + 1) % _networkImages.length;
        });
        _startImageCarousel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              // Quick Actions Section (moved to top)
              Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildQuickActionButton(
                      context,
                      'Create\nContent',
                      Icons.create,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const VolunteerCreateContentScreen(),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    _buildQuickActionButton(
                      context,
                      'Reply to\nForum',
                      Icons.forum,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VolunteerForumScreen(),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    _buildQuickActionButton(
                      context,
                      'Schedule\nSession',
                      Icons.schedule,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              VolunteerScheduleSessionScreen(),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    _buildQuickActionButton(
                      context,
                      'View\nProfile',
                      Icons.person,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VolunteerProfileScreen(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 28),
              // Stats Section
              Text(
                'Your Stats',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildStatCard('Scheduled Sessions', '3', Icons.schedule),
                    SizedBox(width: 12),
                    _buildStatCard('Articles Contributed', '5', Icons.article),
                    SizedBox(width: 12),
                    _buildStatCard('Forum Replies', '12', Icons.forum),
                    SizedBox(width: 12),
                    _buildStatCard('Hours Volunteered', '8', Icons.access_time),
                  ],
                ),
              ),
              SizedBox(height: 28),
              // Upcoming Session Section
              Text(
                'Upcoming',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 12),
              _buildUpcomingSessionCard(),
              SizedBox(height: 28),
              // Recent Activities Section (optional, can be added later)
            ],
          ),
        ),
      ),
      bottomNavigationBar: VolunteerBottomNavigation(currentPage: 'home'),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 85,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Color(0xFFEEF1F8),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(icon, color: Color(0xFF2B3F99), size: 28),
              ),
            ),
            SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      width: 85,
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(0xFFEEF1F8),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(icon, color: Color(0xFF2B3F99), size: 22),
            ),
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2B3F99),
            ),
          ),
          SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingSessionCard() {
    // Placeholder for demo; in real app, pull from data
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Color(0xFFEEF1F8),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(Icons.schedule, color: Color(0xFF2B3F99), size: 24),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Next Session',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'With: Jane Doe',
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
                Text(
                  'Today at 3:00 PM',
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: Color(0xFF2B3F99), size: 18),
        ],
      ),
    );
  }
}
