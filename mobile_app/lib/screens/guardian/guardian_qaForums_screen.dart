import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import 'guardian_bottom_nav_bar.dart';
import '../../constants/color_constants.dart';
import '../../services/forum_question_service.dart';

class GuardianQAForumsScreen extends StatefulWidget {
  @override
  _GuardianQAForumsScreenState createState() => _GuardianQAForumsScreenState();
}

class _GuardianQAForumsScreenState extends State<GuardianQAForumsScreen> {
  int _selectedIndex = 2; // Q&A Forums is index 2
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Unanswered', 'Recent', 'Most Replies'];
  bool _isLoading = true;
  String? _errorMessage;

  void _onBottomNavTap(int index) {
    if (index == 2) {
      // Already on Q&A Forums - no need to navigate
      return;
    }

    // Update the selected index for visual feedback
    setState(() {
      _selectedIndex = index;
    });

    // Use the helper to handle navigation
    BottomNavHelper.handleNavigation(context, index);
  }

  // Method to navigate back to dashboard
  void _navigateBackToDashboard() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.guardianDashboard,
      (route) => false,
      arguments: {'selectedIndex': 0}, // Pass the home index
    );
  }

  // Questions list - will be fetched from API
  List<Map<String, dynamic>> questions = [];

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  /// Load questions from the API based on selected filter
  Future<void> _loadQuestions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      List<Map<String, dynamic>> fetchedQuestions;

      // Use backend filtering based on selected filter
      switch (_selectedFilter) {
        case 'Unanswered':
          fetchedQuestions =
              await ForumQuestionService.getUnansweredQuestions();
          break;
        case 'Recent':
          fetchedQuestions = await ForumQuestionService.getRecentQuestions();
          break;
        case 'Most Replies':
          fetchedQuestions =
              await ForumQuestionService.getMostRepliedQuestions();
          break;
        default: // 'All'
          fetchedQuestions = await ForumQuestionService.getAllQuestions();
      }

      setState(() {
        questions = fetchedQuestions.map((q) => _convertQuestion(q)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load questions: $e';
        _isLoading = false;
      });
    }
  }

  /// Convert API question to UI format
  Map<String, dynamic> _convertQuestion(Map<String, dynamic> apiQuestion) {
    return {
      'questionId': apiQuestion['questionId'],
      'id': apiQuestion['questionId'], // For compatibility
      'guardianId': apiQuestion['guardianId'],
      'title': apiQuestion['title'],
      'content': apiQuestion['content'],
      'tags': apiQuestion['tags'] ?? [],
      'askedBy': apiQuestion['guardianName'] ?? 'Anonymous Guardian',
      'timeAgo': _formatTimeAgo(apiQuestion['createdAt']),
      'replies': apiQuestion['replies'] ?? 0,
      'views': apiQuestion['views'] ?? 0,
      'isAnswered': apiQuestion['isAnswered'] ?? false,
    };
  }

  /// Format timestamp to "X hours ago" format
  String _formatTimeAgo(dynamic timestamp) {
    if (timestamp == null) return 'Just now';

    try {
      // Debug: Print timestamp format
      print('Timestamp received: $timestamp (Type: ${timestamp.runtimeType})');

      // Handle various timestamp formats
      DateTime dateTime;

      if (timestamp is int) {
        // Handle epoch milliseconds (most common from backend)
        dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      } else if (timestamp is Map && timestamp.containsKey('_seconds')) {
        // Handle Firestore timestamp format with underscore
        dateTime = DateTime.fromMillisecondsSinceEpoch(
          timestamp['_seconds'] * 1000,
        );
      } else if (timestamp is Map && timestamp.containsKey('seconds')) {
        // Handle Firebase Timestamp format without underscore
        dateTime = DateTime.fromMillisecondsSinceEpoch(
          timestamp['seconds'] * 1000,
        );
      } else if (timestamp is String) {
        // Handle ISO 8601 string format
        dateTime = DateTime.parse(timestamp);
      } else {
        print('Unknown timestamp format: $timestamp');
        return 'Just now';
      }

      print('Parsed DateTime: $dateTime');
      final difference = DateTime.now().difference(dateTime);
      print('Time difference: ${difference.inMinutes} minutes');

      if (difference.inSeconds < 60) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
      } else if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).floor();
        return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
      } else {
        final months = (difference.inDays / 30).floor();
        return '$months ${months == 1 ? 'month' : 'months'} ago';
      }
    } catch (e) {
      return 'Just now';
    }
  }

  List<Map<String, dynamic>> get filteredQuestions {
    // Backend filtering is now handled in _loadQuestions()
    // Just return all questions as they're already filtered
    return questions;
  }

  Widget _buildFilterChip(String filter) {
    final isSelected = _selectedFilter == filter;
    return FilterChip(
      label: Text(
        filter,
        style: TextStyle(
          color: isSelected ? AppColors.info : AppColors.info,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = filter;
        });
        // Reload questions with new filter from backend
        _loadQuestions();
      },
      backgroundColor: AppColors.surface,
      selectedColor: AppColors.primaryLight,
      checkmarkColor: AppColors.info,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? AppColors.primaryLight : AppColors.outline,
        ),
      ),
    );
  }

  Widget _buildQuestionCard(Map<String, dynamic> question) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          // Navigate to detail screen and wait for result
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuestionDetailScreen(question: question),
            ),
          );

          // If views were incremented, reload questions to update the list
          if (result == true) {
            _loadQuestions();
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          margin: EdgeInsets.only(bottom: 16),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                spreadRadius: 1,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Question header
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: question['isAnswered']
                          ? Colors.green.withOpacity(0.1)
                          : Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      question['isAnswered'] ? 'Answered' : 'Unanswered',
                      style: TextStyle(
                        fontSize: 10,
                        color: question['isAnswered']
                            ? Colors.green[700]
                            : Colors.orange[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(
                    question['timeAgo'],
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),

              // Question title
              Text(
                question['title'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
              SizedBox(height: 8),

              // Question content preview
              Text(
                question['content'],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 12),

              // Tags
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: question['tags'].map<Widget>((tag) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFFA0C4FD).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF2B3F99),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 12),

              // Question stats
              Row(
                children: [
                  Icon(Icons.visibility, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Text(
                    '${question['views']} views',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  SizedBox(width: 16),
                  Icon(Icons.comment, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Text(
                    '${question['replies']} replies',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  Spacer(),
                  Text(
                    'by ${question['askedBy']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
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

  void _showAskQuestionDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    final tagsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ask a Question',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Your question will be posted anonymously',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Question Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.primaryLight),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: contentController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Question Details',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.primaryLight),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: tagsController,
                decoration: InputDecoration(
                  labelText: 'Tags (comma separated)',
                  hintText: 'e.g., medication, elderly care, nutrition',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.primaryLight),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                  SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () async {
                      if (titleController.text.trim().isEmpty ||
                          contentController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please fill in all required fields'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      // Close dialog first
                      Navigator.pop(context);

                      // Show loading indicator with green background
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Text('Posting question...'),
                            ],
                          ),
                          backgroundColor: Colors.green[700],
                          duration: Duration(seconds: 30),
                        ),
                      );

                      // Parse tags
                      List<String> tags = tagsController.text
                          .trim()
                          .split(',')
                          .map((tag) => tag.trim())
                          .where((tag) => tag.isNotEmpty)
                          .toList();

                      try {
                        // Call API to create question
                        // TODO: Get actual guardianId from current user session
                        final result =
                            await ForumQuestionService.createQuestion(
                              guardianId: 1, // Replace with actual guardian ID
                              title: titleController.text.trim(),
                              content: contentController.text.trim(),
                              tags: tags,
                            );

                        // Hide loading indicator
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();

                        if (result != null) {
                          // Reload questions to get the new one
                          await _loadQuestions();

                          // Show success message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  Icon(Icons.check_circle, color: Colors.white),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Question posted successfully!',
                                    ),
                                  ),
                                ],
                              ),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 3),
                            ),
                          );
                        } else {
                          // Show error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  Icon(Icons.error, color: Colors.white),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Failed to post question. Please try again.',
                                    ),
                                  ),
                                ],
                              ),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 4),
                            ),
                          );
                        }
                      } catch (e) {
                        // Hide loading indicator
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();

                        // Show error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                Icon(Icons.error, color: Colors.white),
                                SizedBox(width: 12),
                                Expanded(child: Text('Error: ${e.toString()}')),
                              ],
                            ),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 4),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFA0C4FD),
                      foregroundColor: Color(0xFF2B3F99),
                    ),
                    child: Text('Post Question'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate back to dashboard
        _navigateBackToDashboard();
        return false; // We're handling the navigation ourselves
      },
      child: Scaffold(
        backgroundColor: AppColors.surfaceVariant,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: _navigateBackToDashboard,
          ),
          title: Text(
            'Q&A Forums',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
          centerTitle: false,
        ),
        body: Column(
          children: [
            // Filter section
            Container(
              padding: EdgeInsets.all(16),
              color: AppColors.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filter Questions',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                  ),
                  SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _filters
                          .map(
                            (filter) => Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: _buildFilterChip(filter),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),

            // Questions list
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryLight,
                      ),
                    )
                  : _errorMessage != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red[300],
                          ),
                          SizedBox(height: 16),
                          Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.red[700],
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadQuestions,
                            child: Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : filteredQuestions.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.forum_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No questions yet',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Be the first to ask a question!',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadQuestions,
                      child: ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: filteredQuestions.length,
                        itemBuilder: (context, index) {
                          return _buildQuestionCard(filteredQuestions[index]);
                        },
                      ),
                    ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _showAskQuestionDialog,
          backgroundColor: AppColors.primaryLight,
          foregroundColor: AppColors.info,
          label: Text('Ask Question'),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onBottomNavTap,
        ),
      ),
    );
  }
}

// Question Detail Screen
class QuestionDetailScreen extends StatefulWidget {
  final Map<String, dynamic> question;

  QuestionDetailScreen({required this.question});

  @override
  _QuestionDetailScreenState createState() => _QuestionDetailScreenState();
}

class _QuestionDetailScreenState extends State<QuestionDetailScreen> {
  // Replies list - will be fetched from API
  List<Map<String, dynamic>> replies = [];
  bool _viewIncremented = false;
  late Map<String, dynamic> _currentQuestion;

  @override
  void initState() {
    super.initState();
    _currentQuestion = Map<String, dynamic>.from(widget.question);
    _incrementViewCount();
  }

  /// Increment view count when question is opened
  Future<void> _incrementViewCount() async {
    try {
      final questionId = widget.question['questionId'] ?? widget.question['id'];
      if (questionId != null) {
        print('Incrementing view count for question: $questionId');

        // Call the API which automatically increments the view count
        final updatedQuestion = await ForumQuestionService.getQuestionById(
          questionId.toString(),
        );

        if (updatedQuestion != null) {
          setState(() {
            // Update the local question data with new view count
            _currentQuestion['views'] =
                updatedQuestion['views'] ?? _currentQuestion['views'];
            _viewIncremented = true;
          });
          print(
            'View count incremented successfully. New count: ${updatedQuestion['views']}',
          );
        }
      }
    } catch (e) {
      print('Error incrementing view count: $e');
    }
  }

  @override
  void dispose() {
    // Return true to indicate views were updated
    super.dispose();
  }

  Widget _buildReplyCard(Map<String, dynamic> reply) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Color(0xFFA0C4FD),
                child: Text(
                  reply['author'][0],
                  style: TextStyle(
                    color: Color(0xFF2B3F99),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reply['author'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                    Text(
                      reply['authorType'],
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                reply['timeAgo'],
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            reply['content'],
            style: TextStyle(
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              InkWell(
                onTap: () {
                  // Handle like functionality
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.thumb_up, size: 16, color: Colors.grey[600]),
                      SizedBox(width: 4),
                      Text(
                        '${reply['likes']}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return true to indicate views were updated
        Navigator.pop(context, _viewIncremented);
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.surfaceVariant,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context, _viewIncremented),
          ),
          title: Text(
            'Question Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question details
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _currentQuestion['isAnswered']
                                      ? Colors.green.withOpacity(0.1)
                                      : Colors.orange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _currentQuestion['isAnswered']
                                      ? 'Answered'
                                      : 'Unanswered',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: _currentQuestion['isAnswered']
                                        ? Colors.green[700]
                                        : Colors.orange[700],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Spacer(),
                              Text(
                                _currentQuestion['timeAgo'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Text(
                            _currentQuestion['title'],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            _currentQuestion['content'],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                              height: 1.4,
                            ),
                          ),
                          SizedBox(height: 16),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: (_currentQuestion['tags'] as List)
                                .map<Widget>((tag) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFA0C4FD).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      tag,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF2B3F99),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                })
                                .toList(),
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(
                                Icons.visibility,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              SizedBox(width: 4),
                              Text(
                                '${_currentQuestion['views']} views',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Spacer(),
                              Text(
                                'Asked by ${_currentQuestion['askedBy']}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),

                    // Replies section
                    Text(
                      'Replies (${replies.length})',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 16),

                    // Replies list
                    for (var reply in replies) _buildReplyCard(reply),
                  ],
                ),
              ),
            ),

            // Reply input (only for volunteers)
            // Container(
            //   padding: EdgeInsets.all(16),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.grey.withOpacity(0.1),
            //         spreadRadius: 1,
            //         blurRadius: 4,
            //         offset: Offset(0, -2),
            //       ),
            //     ],
            //   ),
            //   child: Row(
            //     children: [
            //       Expanded(
            //         child: TextField(
            //           controller: _replyController,
            //           maxLines: null,
            //           decoration: InputDecoration(
            //             hintText: 'Write your reply...',
            //             border: OutlineInputBorder(
            //               borderRadius: BorderRadius.circular(24),
            //               borderSide: BorderSide(color: Colors.grey[300]!),
            //             ),
            //             focusedBorder: OutlineInputBorder(
            //               borderRadius: BorderRadius.circular(24),
            //               borderSide: BorderSide(color: Color(0xFFA0C4FD)),
            //             ),
            //             contentPadding: EdgeInsets.symmetric(
            //               horizontal: 16,
            //               vertical: 12,
            //             ),
            //           ),
            //         ),
            //       ),
            //       SizedBox(width: 12),
            //       CircleAvatar(
            //         radius: 24,
            //         backgroundColor: Color(0xFFA0C4FD),
            //         child: IconButton(
            //           icon: Icon(Icons.send, color: Color(0xFF2B3F99)),
            //           onPressed: () {
            //             if (_replyController.text.trim().isNotEmpty) {
            //               setState(() {
            //                 replies.add({
            //                   'id': replies.length + 1,
            //                   'content': _replyController.text.trim(),
            //                   'author': 'Current User', // This would be dynamic
            //                   'authorType': 'Volunteer',
            //                   'timeAgo': 'Just now',
            //                   'likes': 0,
            //                 });
            //               });
            //               _replyController.clear();
            //             }
            //           },
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
