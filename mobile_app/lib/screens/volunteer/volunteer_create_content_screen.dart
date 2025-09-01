import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'volunteer_articles_screen.dart';
import 'volunteer_bottom_navigation_screen.dart';
import '../../routes/app_routes.dart';
import '../../constants/color_constants.dart';

class VolunteerCreateContentScreen extends StatelessWidget {
  final int volunteerId;
  const VolunteerCreateContentScreen({Key? key, required this.volunteerId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.volunteerDashboard);
          },
        ),
        title: Text(
          'Create Content',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => _navigateToViewArticles(context),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Color(0x33ADD8E6), // Light sky blue with 20% opacity
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.article_rounded,
                              color: Color(0xFF000080), // Deep navy
                              size: 28,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'View Your Articles',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF000080), // Deep navy
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'See and manage the articles you\'ve created',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF000080).withOpacity(
                                      0.9,
                                    ), // Deep navy with opacity
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Color(
                              0xFF000080,
                            ).withOpacity(0.8), // Deep navy with opacity
                            size: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 32),

            // Content Options
            Text(
              'Content Options',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
            SizedBox(height: 16),

            // Two Cards Row
            Row(
              children: [
                Expanded(
                  child: _buildContentTypeCard(
                    Icons.add_circle_outline_rounded,
                    'Create New Article',
                    'Write and publish new content',
                    Color(0xFF2B3F99),
                    onTap: () => _navigateToArticleCreation(context),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildContentTypeCard(
                    Icons.drafts_rounded,
                    'My Drafts',
                    'Continue working on saved drafts',
                    Color(0xFF2B3F99),
                    onTap: () => _navigateToDraft(context, 'Draft List'),
                  ),
                ),
              ],
            ),

            SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: VolunteerBottomNavigation(
        currentPage: 'home',
        volunteerId: volunteerId, // <-- Use volunteerId here
      ),
    );
  }

  void _navigateToArticleCreation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => VolunteerArticlesScreen()),
    );
  }

  void _navigateToViewArticles(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.viewArticle);
  }

  void _navigateToDraft(BuildContext context, String draftName) {
    final int volunteerId = 1;
    Navigator.pushNamed(
      context,
      AppRoutes.volunteerDraft,
      arguments: volunteerId,
    );
  }

  Widget _buildContentTypeCard(
    IconData icon,
    String title,
    String subtitle,
    Color color, {
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.primaryLight.withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, size: 32, color: AppColors.info),
              ),
              SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 6),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.onSurfaceVariant,
                  fontWeight: FontWeight.w400,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Color(0x33ADD8E6), // Light sky blue with 20% opacity
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Open',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF000080), // Deep navy
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: Color(0xFF000080), // Deep navy
                      size: 14,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Enhanced Article Creation Screen
class CreateArticleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.arrow_back, color: AppColors.info, size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Create Article',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withOpacity(0.2),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.info.withOpacity(0.2),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.article_rounded,
                size: 80,
                color: AppColors.info,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Article Creation',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'This screen will contain comprehensive article creation features with rich text editing capabilities',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.onSurfaceVariant,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
