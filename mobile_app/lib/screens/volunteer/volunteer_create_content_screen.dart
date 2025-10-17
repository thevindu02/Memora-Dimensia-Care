import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'volunteer_bottom_navigation_screen.dart';
import '../../routes/app_routes.dart';
import '../../constants/color_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../services/api_constants.dart';
import '../../services/auth_service.dart';
import '../../services/article_service.dart';

class VolunteerCreateContentScreen extends StatelessWidget {
  const VolunteerCreateContentScreen({Key? key}) : super(key: key);

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
      bottomNavigationBar: VolunteerBottomNavigation(currentPage: 'content'),
    );
  }

  void _navigateToArticleCreation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateArticleScreen()),
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

// Article Creation Form Screen
class CreateArticleScreen extends StatefulWidget {
  @override
  _CreateArticleScreenState createState() => _CreateArticleScreenState();
}

class _CreateArticleScreenState extends State<CreateArticleScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _summaryController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();

  List<String> _categories = [
    'General',
    'Caregiver Tips',
    'Technology',
    'Medication',
    'Activities',
    'Nutrition',
  ];
  List<int> _categoryIds = [1, 2, 3, 4, 5, 6];
  int? _selectedCategoryId = 1;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _summaryController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _saveDraft() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Call the article service to save as draft
      final result = await ArticleService.createArticle(
        title: _titleController.text.trim(),
        summary: _summaryController.text.trim(),
        content: _contentController.text.trim(),
        categoryId: _selectedCategoryId!,
        isDraft: true, // This is a draft
        tags: _tagsController.text.trim().isNotEmpty
            ? _tagsController.text.trim()
            : null,
      );

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.green,
          ),
        );

        // Clear form after successful save
        _titleController.clear();
        _summaryController.clear();
        _contentController.clear();
        _tagsController.clear();
        setState(() {
          _selectedCategoryId = 1;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving draft: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _publishArticle() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Call the article service to publish article
      final result = await ArticleService.createArticle(
        title: _titleController.text.trim(),
        summary: _summaryController.text.trim(),
        content: _contentController.text.trim(),
        categoryId: _selectedCategoryId!,
        isDraft: false, // This is not a draft, it's for publishing
        tags: _tagsController.text.trim().isNotEmpty
            ? _tagsController.text.trim()
            : null,
      );

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate back after successful publish
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error publishing article: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

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
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Dropdown
                  Text(
                    'Category',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    value: _selectedCategoryId,
                    items: List.generate(_categories.length, (index) {
                      return DropdownMenuItem(
                        value: _categoryIds[index],
                        child: Text(_categories[index]),
                      );
                    }),
                    onChanged: (val) =>
                        setState(() => _selectedCategoryId = val),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    validator: (val) =>
                        val == null ? 'Please select a category' : null,
                  ),
                  SizedBox(height: 16),

                  // Title Field
                  Text(
                    'Title',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: 'Enter article title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.all(16),
                    ),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Title is required' : null,
                  ),
                  SizedBox(height: 16),

                  // Summary Field
                  Text(
                    'Summary',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _summaryController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Enter a brief summary of your article',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.all(16),
                    ),
                    validator: (val) => val == null || val.isEmpty
                        ? 'Summary is required'
                        : null,
                  ),
                  SizedBox(height: 16),

                  // Content Field
                  Text(
                    'Content',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _contentController,
                    maxLines: 8,
                    decoration: InputDecoration(
                      hintText: 'Write your article content here...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.all(16),
                    ),
                    validator: (val) => val == null || val.isEmpty
                        ? 'Content is required'
                        : null,
                  ),
                  SizedBox(height: 16),

                  // Tags Field
                  Text(
                    'Tags',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _tagsController,
                    decoration: InputDecoration(
                      hintText: 'Enter tags (comma separated)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                  SizedBox(height: 32),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _saveDraft,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF87CEEB), // Sky blue
                            foregroundColor: Colors.black,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Save Draft',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _publishArticle,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.info,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Publish',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
