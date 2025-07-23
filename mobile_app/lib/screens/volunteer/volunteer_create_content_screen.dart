import 'package:flutter/material.dart';
import 'volunteer_articles_screen.dart';
import 'volunteer_bottom_navigation_screen.dart';
import '../../routes/app_routes.dart';

class VolunteerCreateContentScreen extends StatelessWidget {
  const VolunteerCreateContentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.arrow_back, color: Colors.black87, size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Create Content',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            
            // Welcome Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[600]!, Colors.blue[700]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 20,
                    offset: Offset(0, 8),
                    spreadRadius: -5,
                  ),
                ],
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
                          Icons.create_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Start Creating',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Share your knowledge with the community',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 32),
            
            // Content Options
            Text(
              'Content Options',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
                letterSpacing: -0.3,
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
                    Colors.blue,
                    onTap: () => _navigateToArticleCreation(context),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildContentTypeCard(
                    Icons.drafts_rounded,
                    'My Drafts',
                    'Continue working on saved drafts',
                    Colors.orange,
                    onTap: () => _navigateToDraft(context, 'Draft List'),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: VolunteerBottomNavigation(currentPage: 'content'),
    );
  }

  void _navigateToArticleCreation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => VolunteerArticlesScreen()),
    );
  }

  void _navigateToDraft(BuildContext context, String draftName) {
    final int volunteerId = 1;
    Navigator.pushNamed(context, AppRoutes.volunteerDraft, arguments: volunteerId);
  }

  Widget _buildContentTypeCard(
    IconData icon,
    String title,
    String subtitle,
    MaterialColor color, {
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: Offset(0, 4),
              spreadRadius: -2,
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color[50]!, color[100]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                size: 32,
                color: color[700],
              ),
            ),
            SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
                letterSpacing: -0.2,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 6),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
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
                color: color[600],
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
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 14,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDraftItem(
    String title,
    String subtitle, {
    required VoidCallback onTap,
  }) {
    // This method is no longer used but kept for compatibility
    return Container();
  }
}

// Enhanced Article Creation Screen
class CreateArticleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.arrow_back, color: Colors.black87, size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Create Article',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
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
                gradient: LinearGradient(
                  colors: [Colors.blue[50]!, Colors.blue[100]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                Icons.article_rounded,
                size: 80,
                color: Colors.blue[700],
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Article Creation',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'This screen will contain comprehensive article creation features with rich text editing capabilities',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
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