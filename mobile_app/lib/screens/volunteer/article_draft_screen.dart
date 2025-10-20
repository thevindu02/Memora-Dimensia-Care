import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../services/api_constants.dart';
import '../../services/auth_service.dart';
import '../../services/article_service.dart';
import '../../constants/color_constants.dart';

class ArticleDraftScreen extends StatefulWidget {
  const ArticleDraftScreen({Key? key}) : super(key: key);

  @override
  State<ArticleDraftScreen> createState() => _ArticleDraftScreenState();
}

class _ArticleDraftScreenState extends State<ArticleDraftScreen> {
  late Future<List<Map<String, dynamic>>> _draftsFuture;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      // Get the volunteerId from arguments or use current user ID
      int volunteerId = _getVolunteerId();
      _draftsFuture = fetchAllDrafts(volunteerId);
      _initialized = true;
    }
  }

  /// Get volunteer ID from navigation arguments or AuthService
  int _getVolunteerId() {
    // Try to get from navigation arguments first
    final Object? args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is int) {
      return args;
    }

    // Fallback to AuthService current user ID
    if (AuthService.currentUserId != null) {
      return AuthService.currentUserId!;
    }

    // Default fallback (this should not happen in production)
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Drafts'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.black),
            onPressed: () {
              setState(() {
                _draftsFuture = fetchAllDrafts(_getVolunteerId());
              });
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _draftsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _draftsFuture = fetchAllDrafts(_getVolunteerId());
                      });
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.drafts, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No drafts found.',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Create your first article draft!',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }
          final drafts = snapshot.data!;
          return ListView.separated(
            padding: EdgeInsets.all(16),
            itemCount: drafts.length,
            separatorBuilder: (_, __) => SizedBox(height: 12),
            itemBuilder: (context, index) {
              final draft = drafts[index];
              return _buildDraftCard(draft);
            },
          );
        },
      ),
    );
  }

  Widget _buildDraftCard(Map<String, dynamic> draft) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _editDraft(draft),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Badge at the top
              if (draft['categoryName'] != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.category_outlined,
                        size: 14,
                        color: Colors.blue[700],
                      ),
                      SizedBox(width: 4),
                      Text(
                        draft['categoryName'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 12),
              // Title Row (without menu)
              Row(
                children: [
                  Icon(Icons.drafts, color: AppColors.info, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      draft['title'] ?? 'Untitled',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              // Summary
              if (draft['summary'] != null && draft['summary'].isNotEmpty)
                Text(
                  draft['summary'],
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              SizedBox(height: 12),
              // Action Buttons Row with 3 buttons
              Row(
                children: [
                  // Edit Button
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _editDraft(draft),
                      icon: Icon(Icons.edit, size: 16),
                      label: Text('Edit', style: TextStyle(fontSize: 13)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 6),
                  // Publish Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _publishDraft(draft),
                      icon: Icon(Icons.publish, size: 16),
                      label: Text('Publish', style: TextStyle(fontSize: 13)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 6),
                  // Delete Button
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _deleteDraft(draft),
                      icon: Icon(Icons.delete_outline, size: 16),
                      label: Text('Delete', style: TextStyle(fontSize: 13)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: BorderSide(color: Colors.red.withOpacity(0.5)),
                        padding: EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _editDraft(Map<String, dynamic> draft) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DraftEditScreen(draft: draft)),
    ).then((_) {
      // Refresh drafts when returning from edit screen
      setState(() {
        _draftsFuture = fetchAllDrafts(_getVolunteerId());
      });
    });
  }

  void _publishDraft(Map<String, dynamic> draft) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.publish, color: Colors.green),
            SizedBox(width: 8),
            Text('Publish Draft'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to publish this article?'),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    draft['title'] ?? 'Untitled',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  if (draft['categoryName'] != null) ...[
                    SizedBox(height: 4),
                    Text(
                      'Category: ${draft['categoryName']}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: Colors.orange[700]),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Your article will be submitted for admin review',
                      style: TextStyle(fontSize: 11, color: Colors.orange[700]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _performPublish(draft);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: Text('Publish'),
          ),
        ],
      ),
    );
  }

  void _deleteDraft(Map<String, dynamic> draft) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Draft'),
        content: Text(
          'Are you sure you want to delete "${draft['title']}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _performDelete(draft);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _performPublish(Map<String, dynamic> draft) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Publishing article...'),
            ],
          ),
        ),
      ),
    );

    try {
      final response = await http.put(
        Uri.parse('${ApiConstants.baseUrl}/api/articles/${draft['articleId']}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          ...draft,
          'draft': false,
          'status': 'pending', // Pending admin review
        }),
      );

      // Close loading dialog
      Navigator.pop(context);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Expanded(
                  child: Text('Article submitted for review successfully!'),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
        setState(() {
          _draftsFuture = fetchAllDrafts(_getVolunteerId());
        });
      } else {
        throw Exception('Failed to publish article: ${response.statusCode}');
      }
    } catch (e) {
      // Close loading dialog if still open
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 8),
              Expanded(child: Text('Error publishing article: $e')),
            ],
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  Future<void> _performDelete(Map<String, dynamic> draft) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Deleting draft...'),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      final result = await ArticleService.deleteArticle(
        articleId: draft['articleId'].toString(),
        volunteerId: _getVolunteerId(),
      );

      Navigator.pop(context); // Close loading dialog

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Expanded(child: Text('Draft deleted successfully!')),
              ],
            ),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          _draftsFuture = fetchAllDrafts(_getVolunteerId());
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Failed to delete draft'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context); // Close loading dialog if still open
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting draft: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

Future<List<Map<String, dynamic>>> fetchAllDrafts(int volunteerId) async {
  print('========================================');
  print('📝 FETCHING DRAFTS');
  print('Volunteer ID: $volunteerId');
  print('========================================');

  final response = await http.get(
    Uri.parse(
      '${ApiConstants.baseUrl}/api/articles/drafts?volunteerId=$volunteerId',
    ),
  );

  print('Response Status: ${response.statusCode}');
  print('Response Body: ${response.body}');

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);

    if (data.isNotEmpty) {
      print('First draft data: ${data[0]}');
    }
    print('Total drafts: ${data.length}');
    print('========================================');

    return data.cast<Map<String, dynamic>>();
  } else {
    throw Exception('Failed to load drafts');
  }
}

// Draft Edit Screen
class DraftEditScreen extends StatefulWidget {
  final Map<String, dynamic> draft;

  const DraftEditScreen({Key? key, required this.draft}) : super(key: key);

  @override
  State<DraftEditScreen> createState() => _DraftEditScreenState();
}

class _DraftEditScreenState extends State<DraftEditScreen> {
  late TextEditingController _titleController;
  late TextEditingController _summaryController;
  late TextEditingController _contentController;
  late TextEditingController _tagsController;

  List<String> _categories = [];
  List<int> _categoryIds = [];
  int? _selectedCategoryId;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _fetchCategories();
  }

  void _initializeControllers() {
    _titleController = TextEditingController(text: widget.draft['title'] ?? '');
    _summaryController = TextEditingController(
      text: widget.draft['summary'] ?? '',
    );
    _contentController = TextEditingController(
      text: widget.draft['content'] ?? '',
    );
    _tagsController = TextEditingController(text: widget.draft['tags'] ?? '');
    _selectedCategoryId = widget.draft['categoryId'];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _summaryController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/api/categories'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _categories = data
              .map<String>((cat) => cat['categoryName'] as String)
              .toList();
          _categoryIds = data
              .map<int>((cat) => cat['categoryId'] as int)
              .toList();

          // Validate that the selected category ID exists in the loaded categories
          if (_selectedCategoryId != null &&
              !_categoryIds.contains(_selectedCategoryId)) {
            _selectedCategoryId = null;
          }
        });
      }
    } catch (e) {
      print('Failed to load categories: $e');
    }
  }

  Future<void> _saveDraft() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final updatedDraft = {
        ...widget.draft,
        'title': _titleController.text,
        'summary': _summaryController.text,
        'content': _contentController.text,
        'tags': _tagsController.text,
        'categoryId': _selectedCategoryId,
        'draft': true,
      };

      final response = await http.put(
        Uri.parse(
          '${ApiConstants.baseUrl}/api/articles/${widget.draft['articleId']}',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedDraft),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Draft saved successfully!')));
        Navigator.pop(context);
      } else {
        throw Exception('Failed to save draft');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving draft: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Draft'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: ElevatedButton(
              onPressed: _isLoading ? null : _saveDraft,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryLight, // Light Sky Blue color
                foregroundColor: AppColors.deep,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
              ),
              child: Text(
                'Save',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.deep,
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Dropdown
                  Text(
                    'Category',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    value: _selectedCategoryId,
                    items: List.generate(_categories.length, (index) {
                      return DropdownMenuItem(
                        value: _categoryIds[index],
                        child: Text(
                          _categories[index],
                          style: TextStyle(color: Colors.black),
                        ),
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
                    hint: Text(
                      'Select Category',
                      style: TextStyle(color: Colors.grey),
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(height: 16),

                  // Title Field
                  Text(
                    'Title',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _titleController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Enter article title',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.all(16),
                    ),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Title is required' : null,
                  ),
                  SizedBox(height: 16),

                  // tag Field
                  Text(
                    'Tags',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _summaryController,
                    maxLines: 1,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Enter tags (comma separated)',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Content Field
                  Text(
                    'Content',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _contentController,
                    maxLines: 8,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Write your article content here...',
                      hintStyle: TextStyle(color: Colors.grey),
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

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _saveDraft,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppColors.primaryLight, // Light Sky Blue color
                            foregroundColor: AppColors.deep,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text('Save Draft'),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isLoading
                              ? null
                              : () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text('Cancel'),
                        ),
                      ),
                    ],
                  ),
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
