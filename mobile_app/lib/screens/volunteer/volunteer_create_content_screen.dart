import 'package:flutter/material.dart';
import 'volunteer_articles_screen.dart';
import 'volunteer_bottom_navigation_screen.dart';

class VolunteerCreateContentScreen extends StatelessWidget {
  const VolunteerCreateContentScreen({Key? key}) : super(key: key);

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
        title: Text(
          'Create Content',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16), // Reduced space since title is now in app bar
            Center(
              child: Text(
                'Content Type',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildContentTypeCard(
                  Icons.newspaper_rounded, 
                  'Article',
                  onTap: () => _navigateToArticleCreation(context),
                ),
                SizedBox(width: 24),
                _buildContentTypeCard(
                  Icons.edit_note_rounded, 
                  'Blog',
                  onTap: () => _navigateToBlogCreation(context),
                ),
              ],
            ),
            SizedBox(height: 40),
            Text(
              'Drafts',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),
            _buildDraftItem(
              'Draft 1', 
              'assets/images/draft1.jpg',
              onTap: () => _navigateToDraft(context, 'Draft 1'),
            ),
            SizedBox(height: 12),
            _buildDraftItem(
              'Draft 2', 
              'assets/images/draft2.jpg',
              onTap: () => _navigateToDraft(context, 'Draft 2'),
            ),
            Spacer(),
          ],
        ),
      ),
       bottomNavigationBar: VolunteerBottomNavigation(currentPage: 'content'),
    );
  }

  void _navigateToArticleCreation(BuildContext context) {
    // Navigate to Article Creation Screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VolunteerArticlesScreen(),
      ),
    );
  }

  void _navigateToBlogCreation(BuildContext context) {
    // Navigate to Blog Creation Screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateBlogScreen(),
      ),
    );
  }

  void _navigateToDraft(BuildContext context, String draftName) {
    // Navigate to Draft Screen (will be implemented when backend is connected)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening $draftName - Will be implemented with backend'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget _buildContentTypeCard(IconData icon, String title, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.lightBlue[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.lightBlue[100]!),
          boxShadow: [
            BoxShadow(
              color: Colors.lightBlue.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.lightBlue[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon, 
                size: 28, 
                color: Colors.lightBlue[700],
              ),
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.lightBlue[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDraftItem(String title, String imagePath, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.drafts, color: Colors.grey[600], size: 20),
            ),
            SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey[400], size: 16),
          ],
        ),
      ),
    );
  }
}

// Placeholder screens for Article and Blog creation
class CreateArticleScreen extends StatelessWidget {
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
        title: Text(
          'Create Article',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.lightBlue[50],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.newspaper_rounded, 
                size: 64, 
                color: Colors.lightBlue[700],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Article Creation Screen',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'This screen will contain article creation features',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CreateBlogScreen extends StatelessWidget {
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
        title: Text(
          'Create Blog',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.lightBlue[50],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.edit_note_rounded, 
                size: 64, 
                color: Colors.lightBlue[700],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Blog Creation Screen',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'This screen will contain blog creation features',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}