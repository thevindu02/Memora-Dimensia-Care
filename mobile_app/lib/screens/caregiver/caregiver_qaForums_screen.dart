import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../constants/color_constants.dart';
import '../../services/forum_question_service.dart';

class CaregiverQAForumsScreen extends StatefulWidget {
  @override
  _CaregiverQAForumsScreenState createState() =>
      _CaregiverQAForumsScreenState();
}

class _CaregiverQAForumsScreenState extends State<CaregiverQAForumsScreen> {
  int _selectedIndex = 2; // Q&A Forums is index 2
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Unanswered', 'Recent', 'Most Replies'];
  bool _isLoading = true;
  String? _errorMessage;

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
      'askedBy': apiQuestion['guardianName'] ?? 'Anonymous User',
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
      DateTime dateTime;

      if (timestamp is int) {
        dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      } else if (timestamp is Map && timestamp.containsKey('_seconds')) {
        dateTime = DateTime.fromMillisecondsSinceEpoch(
          timestamp['_seconds'] * 1000,
        );
      } else if (timestamp is Map && timestamp.containsKey('seconds')) {
        dateTime = DateTime.fromMillisecondsSinceEpoch(
          timestamp['seconds'] * 1000,
        );
      } else if (timestamp is String) {
        dateTime = DateTime.parse(timestamp);
      } else {
        return 'Just now';
      }

      final difference = DateTime.now().difference(dateTime);

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
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuestionDetailScreen(question: question),
            ),
          );

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
              // Question title
              Text(
                question['title'] ?? '',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),

              // Question preview
              Text(
                question['content'] ?? '',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 12),

              // Tags
              if (question['tags'] != null &&
                  (question['tags'] as List).isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: (question['tags'] as List).take(3).map<Widget>((
                    tag,
                  ) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primaryLight,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        tag.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.info,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              SizedBox(height: 12),

              // Meta information
              Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(width: 4),
                  Text(
                    question['askedBy'] ?? 'Anonymous',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(width: 16),
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(width: 4),
                  Text(
                    question['timeAgo'] ?? 'Just now',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Spacer(),
                  // Reply count
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: (question['replies'] ?? 0) > 0
                          ? AppColors.success.withOpacity(0.1)
                          : AppColors.textSecondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 14,
                          color: (question['replies'] ?? 0) > 0
                              ? AppColors.success
                              : AppColors.textSecondary,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '${question['replies'] ?? 0}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: (question['replies'] ?? 0) > 0
                                ? AppColors.success
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  // View count
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.info.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.visibility_outlined,
                          size: 14,
                          color: AppColors.info,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '${question['views'] ?? 0}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.info,
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
      ),
    );
  }

  /// Show dialog to ask a new question (caregivers can also ask questions)
  void _showAskQuestionDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    final tagController = TextEditingController();
    List<String> tags = [];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Ask a Question'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                      maxLength: 100,
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: contentController,
                      decoration: InputDecoration(
                        labelText: 'Question Details',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 5,
                      maxLength: 500,
                    ),
                    SizedBox(height: 16),
                    // Tags input
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: tagController,
                            decoration: InputDecoration(
                              labelText: 'Add Tag',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            if (tagController.text.trim().isNotEmpty) {
                              setDialogState(() {
                                tags.add(tagController.text.trim());
                                tagController.clear();
                              });
                            }
                          },
                          child: Text('Add'),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    // Display added tags
                    if (tags.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        children: tags.map((tag) {
                          return Chip(
                            label: Text(tag),
                            deleteIcon: Icon(Icons.close, size: 16),
                            onDeleted: () {
                              setDialogState(() {
                                tags.remove(tag);
                              });
                            },
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (titleController.text.trim().isEmpty ||
                        contentController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please fill in all required fields'),
                        ),
                      );
                      return;
                    }

                    Navigator.pop(context);

                    // Show loading notification
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            CircularProgressIndicator(color: Colors.white),
                            SizedBox(width: 16),
                            Text('Posting your question...'),
                          ],
                        ),
                        backgroundColor: Colors.green[700],
                        duration: Duration(seconds: 2),
                      ),
                    );

                    try {
                      // TODO: Change caregiverId to actual logged-in caregiver ID
                      await ForumQuestionService.createQuestion(
                        guardianId:
                            1, // Temporary - replace with actual caregiver ID
                        title: titleController.text.trim(),
                        content: contentController.text.trim(),
                        tags: tags,
                      );

                      // Show success notification
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.white),
                              SizedBox(width: 16),
                              Text('Question posted successfully!'),
                            ],
                          ),
                          backgroundColor: Colors.green[700],
                          duration: Duration(seconds: 2),
                        ),
                      );

                      // Reload questions
                      await _loadQuestions();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to post question: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: Text('Post'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Q&A Forums',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: AppColors.textPrimary),
            onPressed: _loadQuestions,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadQuestions,
        child: Column(
          children: [
            // Filter chips
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: SingleChildScrollView(
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
            ),

            // Questions list
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: AppColors.error,
                          ),
                          SizedBox(height: 16),
                          Text(
                            _errorMessage!,
                            style: TextStyle(color: AppColors.error),
                            textAlign: TextAlign.center,
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
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No questions yet',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Be the first to ask a question!',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: filteredQuestions.length,
                      itemBuilder: (context, index) {
                        return _buildQuestionCard(filteredQuestions[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAskQuestionDialog,
        backgroundColor: AppColors.primary,
        icon: Icon(Icons.add),
        label: Text('Ask Question'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == _selectedIndex) return;

          setState(() {
            _selectedIndex = index;
          });

          // Navigate based on index
          switch (index) {
            case 0:
              Navigator.pushNamed(context, AppRoutes.caregiverDashboard);
              break;
            case 1:
              Navigator.pushNamed(context, AppRoutes.caregiverPatients);
              break;
            case 2:
              // Already on Q&A Forum
              break;
            case 3:
              Navigator.pushNamed(context, AppRoutes.caregiverProfile);
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outlined),
            label: 'Patients',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.forum), label: 'Q&A'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Question Detail Screen (to be imported from guardian screen or created separately)
class QuestionDetailScreen extends StatefulWidget {
  final Map<String, dynamic> question;

  const QuestionDetailScreen({Key? key, required this.question})
    : super(key: key);

  @override
  _QuestionDetailScreenState createState() => _QuestionDetailScreenState();
}

class _QuestionDetailScreenState extends State<QuestionDetailScreen> {
  Map<String, dynamic>? _currentQuestion;

  @override
  void initState() {
    super.initState();
    _currentQuestion = widget.question;
    _incrementViewCount();
  }

  Future<void> _incrementViewCount() async {
    try {
      final questionId = widget.question['questionId'] as String;
      await ForumQuestionService.getQuestionById(questionId);

      // Update local view count
      setState(() {
        _currentQuestion = {
          ...widget.question,
          'views': (widget.question['views'] ?? 0) + 1,
        };
      });
    } catch (e) {
      print('Failed to increment view count: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = _currentQuestion ?? widget.question;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () => Navigator.pop(context, true),
          ),
          title: Text(
            'Question Details',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Question title
              Text(
                question['title'] ?? '',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 16),

              // Meta information
              Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(width: 4),
                  Text(
                    question['askedBy'] ?? 'Anonymous',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(width: 16),
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(width: 4),
                  Text(
                    question['timeAgo'] ?? 'Just now',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.visibility_outlined,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(width: 4),
                  Text(
                    '${question['views'] ?? 0} views',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),

              // Question content
              Text(
                question['content'] ?? '',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 24),

              // Tags
              if (question['tags'] != null &&
                  (question['tags'] as List).isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (question['tags'] as List).map<Widget>((tag) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primaryLight,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        tag.toString(),
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.info,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              SizedBox(height: 32),

              // Replies section
              Text(
                'Replies (${question['replies'] ?? 0})',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 16),

              // TODO: Add replies list here when reply service is implemented
              Center(
                child: Text(
                  'No replies yet',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
