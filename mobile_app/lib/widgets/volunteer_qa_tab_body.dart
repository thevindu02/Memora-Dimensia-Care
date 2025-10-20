import 'package:flutter/material.dart';
import '../services/forum_question_service.dart';
import '../services/forum_answer_service.dart';
import '../services/auth_service.dart';
import '../constants/color_constants.dart';

class VolunteerQATabBody extends StatefulWidget {
  const VolunteerQATabBody({Key? key}) : super(key: key);

  @override
  State<VolunteerQATabBody> createState() => _VolunteerQATabBodyState();
}

class _VolunteerQATabBodyState extends State<VolunteerQATabBody> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Unanswered', 'Recent', 'Most Replies'];
  bool _isLoading = true;
  String? _errorMessage;
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
        default:
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
      'id': apiQuestion['questionId'],
      'guardianId': apiQuestion['guardianId'],
      'title': apiQuestion['title'],
      'content': apiQuestion['content'],
      'tags': List<String>.from(apiQuestion['tags'] ?? []),
      'views': apiQuestion['views'] ?? 0,
      'replies': apiQuestion['replies'] ?? 0,
      'isAnswered': apiQuestion['isAnswered'] ?? false,
      'timeAgo': _formatTimeAgo(apiQuestion['createdAt']),
      'createdAt': apiQuestion['createdAt'],
    };
  }

  /// Format timestamp to "time ago" format
  String _formatTimeAgo(dynamic timestamp) {
    if (timestamp == null) return 'Just now';

    try {
      DateTime dateTime;
      if (timestamp is int) {
        dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      } else if (timestamp is String) {
        dateTime = DateTime.parse(timestamp);
      } else {
        return 'Just now';
      }

      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inHours < 1) {
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
              builder: (context) =>
                  VolunteerQuestionDetailScreen(question: question),
            ),
          );

          if (result != null && result is Map<String, dynamic>) {
            setState(() {
              final questionId = result['questionId'] ?? result['id'];
              final index = questions.indexWhere(
                (q) => (q['questionId'] ?? q['id']) == questionId,
              );
              if (index != -1) {
                questions[index]['views'] = result['views'];
                questions[index]['replies'] = result['replies'];
                questions[index]['isAnswered'] = result['isAnswered'];
              }
            });
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
              Text(
                question['title'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
              SizedBox(height: 8),
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
              if (question['tags'] != null &&
                  (question['tags'] as List).isNotEmpty) ...[
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: (question['tags'] as List<String>).map((tag) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.info,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 12),
              ],
              Row(
                children: [
                  Icon(
                    Icons.visibility,
                    size: 16,
                    color: AppColors.onSurfaceVariant,
                  ),
                  SizedBox(width: 4),
                  Text(
                    '${question['views']} ${question['views'] == 1 ? 'view' : 'views'}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(width: 16),
                  Icon(
                    Icons.comment,
                    size: 16,
                    color: AppColors.onSurfaceVariant,
                  ),
                  SizedBox(width: 4),
                  Text(
                    '${question['replies']} ${question['replies'] == 1 ? 'reply' : 'replies'}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.onSurfaceVariant,
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter chips section - NO "Filter Questions" label
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: AppColors.surface,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filters.map((filter) {
                return Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: _buildFilterChip(filter),
                );
              }).toList(),
            ),
          ),
        ),
        // Questions list
        Expanded(
          child: _isLoading
              ? Center(child: CircularProgressIndicator(color: AppColors.info))
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
                        style: TextStyle(color: Colors.red[700], fontSize: 14),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadQuestions,
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                )
              : questions.isEmpty
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
                        'Questions from guardians and caregivers will appear here',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadQuestions,
                  child: ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      return _buildQuestionCard(questions[index]);
                    },
                  ),
                ),
        ),
      ],
    );
  }
}

// ===== QUESTION DETAIL SCREEN =====

class VolunteerQuestionDetailScreen extends StatefulWidget {
  final Map<String, dynamic> question;

  const VolunteerQuestionDetailScreen({Key? key, required this.question})
    : super(key: key);

  @override
  State<VolunteerQuestionDetailScreen> createState() =>
      _VolunteerQuestionDetailScreenState();
}

class _VolunteerQuestionDetailScreenState
    extends State<VolunteerQuestionDetailScreen> {
  List<Map<String, dynamic>> replies = [];
  final TextEditingController _replyController = TextEditingController();
  bool _loadingReplies = true;
  late Map<String, dynamic> _currentQuestion;

  @override
  void initState() {
    super.initState();
    _currentQuestion = Map<String, dynamic>.from(widget.question);
    _incrementViewCount();
    _loadReplies();
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  /// Increment view count when question is opened
  Future<void> _incrementViewCount() async {
    try {
      final questionId = widget.question['questionId'] ?? widget.question['id'];
      if (questionId != null) {
        final updatedQuestion = await ForumQuestionService.getQuestionById(
          questionId.toString(),
        );

        if (updatedQuestion != null && mounted) {
          setState(() {
            _currentQuestion['views'] = updatedQuestion['views'];
          });
        }
      }
    } catch (e) {
      print('Error incrementing view count: $e');
    }
  }

  /// Load replies for this question from backend
  Future<void> _loadReplies() async {
    setState(() {
      _loadingReplies = true;
    });

    try {
      final questionId = widget.question['questionId'] ?? widget.question['id'];

      final fetchedReplies = await ForumAnswerService.getAnswersByQuestionId(
        questionId.toString(),
        userId: 13, // TODO: Replace with actual volunteer ID from session
      );

      setState(() {
        replies = fetchedReplies.map((reply) {
          return {
            'id': reply['answerId'],
            'content': reply['content'],
            'author': reply['volunteerName'] ?? 'Anonymous',
            'authorType': reply['volunteerRole'] ?? 'Volunteer',
            'timeAgo': _formatTimeAgo(reply['createdAt']),
            'likes': reply['likes'] ?? 0,
            'isLiked': reply['isLiked'] ?? false,
          };
        }).toList();

        _currentQuestion['replies'] = replies.length;
        _currentQuestion['isAnswered'] = replies.isNotEmpty;

        _loadingReplies = false;
      });
    } catch (e) {
      print('Error loading replies: $e');
      setState(() {
        _loadingReplies = false;
      });
    }
  }

  String _formatTimeAgo(dynamic timestamp) {
    if (timestamp == null) return 'Just now';

    try {
      DateTime dateTime;
      if (timestamp is int) {
        dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      } else if (timestamp is String) {
        dateTime = DateTime.parse(timestamp);
      } else {
        return 'Just now';
      }

      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inHours < 1) {
        return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
      } else {
        final weeks = (difference.inDays / 7).floor();
        return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
      }
    } catch (e) {
      return 'Just now';
    }
  }

  Widget _buildReplyCard(Map<String, dynamic> reply) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reply header
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primaryLight,
                child: Text(
                  reply['author'][0].toUpperCase(),
                  style: TextStyle(
                    color: AppColors.info,
                    fontWeight: FontWeight.bold,
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
          // Reply content
          Text(
            reply['content'],
            style: TextStyle(
              fontSize: 14,
              color: AppColors.onSurface,
              height: 1.5,
            ),
          ),
          SizedBox(height: 12),
          // Like button
          InkWell(
            onTap: () async {
              try {
                final answerId = reply['id'];
                final isLiked = reply['isLiked'] ?? false;
                final currentLikes = reply['likes'] ?? 0;
                bool success = false;

                if (isLiked) {
                  success = await ForumAnswerService.unlikeAnswer(
                    answerId.toString(),
                    13, // TODO: Replace with actual volunteer ID from session
                  );

                  if (success) {
                    setState(() {
                      reply['isLiked'] = false;
                      reply['likes'] = currentLikes - 1;
                    });
                  }
                } else {
                  success = await ForumAnswerService.likeAnswer(
                    answerId.toString(),
                    13, // TODO: Replace with actual volunteer ID from session
                  );

                  if (success) {
                    setState(() {
                      reply['isLiked'] = true;
                      reply['likes'] = currentLikes + 1;
                    });
                  }
                }
              } catch (e) {
                print('Error toggling like: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to update like'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: (reply['isLiked'] ?? false)
                    ? AppColors.info.withOpacity(0.1)
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    (reply['isLiked'] ?? false)
                        ? Icons.thumb_up
                        : Icons.thumb_up_outlined,
                    size: 16,
                    color: (reply['isLiked'] ?? false)
                        ? AppColors.info
                        : Colors.grey[600],
                  ),
                  SizedBox(width: 4),
                  Text(
                    '${reply['likes'] ?? 0}',
                    style: TextStyle(
                      fontSize: 12,
                      color: (reply['isLiked'] ?? false)
                          ? AppColors.info
                          : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => Navigator.pop(context, _currentQuestion),
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
          // Question details section
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question card
                  Container(
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
                              _currentQuestion['timeAgo'] ?? '',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text(
                          _currentQuestion['title'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurface,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          _currentQuestion['content'],
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.onSurface,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 16),
                        if (_currentQuestion['tags'] != null &&
                            (_currentQuestion['tags'] as List).isNotEmpty)
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: (_currentQuestion['tags'] as List<String>)
                                .map((tag) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryLight.withOpacity(
                                        0.3,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      tag,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.info,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                })
                                .toList(),
                          ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(
                              Icons.visibility,
                              size: 16,
                              color: AppColors.onSurfaceVariant,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '${_currentQuestion['views']} ${_currentQuestion['views'] == 1 ? 'view' : 'views'}',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.onSurfaceVariant,
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
                      color: AppColors.onSurface,
                    ),
                  ),
                  SizedBox(height: 16),
                  if (_loadingReplies)
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(color: AppColors.info),
                      ),
                    )
                  else if (replies.isEmpty)
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Icon(
                              Icons.comment_outlined,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 12),
                            Text(
                              'No replies yet',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Be the first to reply!',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Column(
                      children: replies
                          .map((reply) => _buildReplyCard(reply))
                          .toList(),
                    ),
                ],
              ),
            ),
          ),
          // Reply input section
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _replyController,
                    decoration: InputDecoration(
                      hintText: 'Write a reply...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    maxLines: null,
                  ),
                ),
                SizedBox(width: 12),
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primaryLight,
                  child: IconButton(
                    icon: Icon(Icons.send, color: AppColors.info),
                    onPressed: () async {
                      if (_replyController.text.trim().isNotEmpty) {
                        try {
                          final questionId =
                              widget.question['questionId'] ??
                              widget.question['id'];

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Text('Posting reply...'),
                                ],
                              ),
                              duration: Duration(seconds: 2),
                              backgroundColor: Colors.green,
                            ),
                          );

                          // Get current user's ID from auth service
                          final int? currentUserId = AuthService.currentUserId;

                          if (currentUserId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: User not logged in'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          final newReply = await ForumAnswerService.createAnswer(
                            questionId: questionId.toString(),
                            userId:
                                currentUserId, // Use actual logged-in user's ID
                            content: _replyController.text.trim(),
                          );

                          if (newReply != null && mounted) {
                            setState(() {
                              replies.insert(0, {
                                'id': newReply['answerId'],
                                'content': newReply['content'],
                                'author': newReply['volunteerName'] ?? 'You',
                                'authorType':
                                    newReply['volunteerRole'] ?? 'Volunteer',
                                'timeAgo': 'Just now',
                                'likes': 0,
                                'isLiked': false,
                              });

                              _currentQuestion['replies'] = replies.length;
                              _currentQuestion['isAnswered'] = true;
                            });

                            _replyController.clear();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 16),
                                    Text('Reply posted successfully!'),
                                  ],
                                ),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        } catch (e) {
                          print('Error posting reply: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to post reply: $e'),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
