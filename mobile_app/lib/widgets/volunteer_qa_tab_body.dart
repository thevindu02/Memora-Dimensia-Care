import 'package:flutter/material.dart';
import '../services/forum_question_service.dart';
import '../services/forum_answer_service.dart';

class VolunteerQATabBody extends StatefulWidget {
  const VolunteerQATabBody({Key? key}) : super(key: key);

  @override
  State<VolunteerQATabBody> createState() => _VolunteerQATabBodyState();
}

class _VolunteerQATabBodyState extends State<VolunteerQATabBody> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Unanswered', 'Recent', 'Most Replies'];

  // Questions list - will be fetched from API
  List<Map<String, dynamic>> questions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  /// Load questions from database based on selected filter
  Future<void> _loadQuestions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Map<String, dynamic>> loadedQuestions;

      switch (_selectedFilter) {
        case 'Unanswered':
          loadedQuestions = await ForumQuestionService.getUnansweredQuestions();
          break;
        case 'Recent':
          loadedQuestions = await ForumQuestionService.getRecentQuestions();
          break;
        case 'Most Replies':
          loadedQuestions =
              await ForumQuestionService.getMostRepliedQuestions();
          break;
        default:
          loadedQuestions = await ForumQuestionService.getAllQuestions();
      }

      setState(() {
        questions = loadedQuestions.map((question) {
          return {
            ...question,
            'timeAgo': _formatTimeAgo(question['createdAt']),
            'repliesList': [], // Will be loaded when detail screen opens
          };
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading questions: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Format timestamp to "time ago" format
  String _formatTimeAgo(dynamic timestamp) {
    if (timestamp == null) return 'Unknown time';

    try {
      DateTime dateTime;
      if (timestamp is int) {
        dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      } else if (timestamp is String) {
        dateTime = DateTime.parse(timestamp);
      } else {
        return 'Unknown time';
      }

      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 365) {
        final years = (difference.inDays / 365).floor();
        return '$years ${years == 1 ? 'year' : 'years'} ago';
      } else if (difference.inDays > 30) {
        final months = (difference.inDays / 30).floor();
        return '$months ${months == 1 ? 'month' : 'months'} ago';
      } else if (difference.inDays > 0) {
        return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Unknown time';
    }
  }

  Widget _buildFilterChip(String filter) {
    final isSelected = _selectedFilter == filter;
    return FilterChip(
      label: Text(
        filter,
        style: TextStyle(
          color: Color(0xFF2B3F99),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = filter;
        });
        _loadQuestions(); // Reload questions with new filter
      },
      backgroundColor: Colors.white,
      selectedColor: Color(0xFFA0C4FD),
      checkmarkColor: Color(0xFF2B3F99),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? Color(0xFFA0C4FD) : Colors.grey[300]!,
        ),
      ),
    );
  }

  Widget _buildQuestionCard(Map<String, dynamic> question) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          final updatedReplies = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VolunteerQuestionDetailScreen(
                question: question,
                initialReplies: List<Map<String, dynamic>>.from(
                  question['repliesList'] ?? [],
                ),
              ),
            ),
          );

          // Update local question with fresh data from detail screen
          if (updatedReplies != null) {
            setState(() {
              question['repliesList'] = updatedReplies;
              question['replies'] = updatedReplies.length;
            });
          }

          // Reload questions to refresh view counts and other data
          _loadQuestions();
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
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
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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
                  color: Colors.black87,
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
                    '${question['views']} ${question['views'] == 1 ? 'view' : 'views'}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  SizedBox(width: 16),
                  Icon(Icons.comment, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Text(
                    '${question['replies']} ${question['replies'] == 1 ? 'reply' : 'replies'}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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
        // Filter section
        Container(
          padding: EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter Questions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
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
                  child: CircularProgressIndicator(color: Color(0xFF2B3F99)),
                )
              : questions.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.question_answer_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No questions yet',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    return _buildQuestionCard(questions[index]);
                  },
                ),
        ),
        // Floating action button is not included here; should be added in parent if needed.
      ],
    );
  }
}

// VolunteerQuestionDetailScreen for showing question details and replies
class VolunteerQuestionDetailScreen extends StatefulWidget {
  final Map<String, dynamic> question;
  final List<Map<String, dynamic>> initialReplies;
  const VolunteerQuestionDetailScreen({
    Key? key,
    required this.question,
    required this.initialReplies,
  }) : super(key: key);

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

  /// Increment view count when question is opened
  Future<void> _incrementViewCount() async {
    try {
      final questionId = widget.question['questionId'] ?? widget.question['id'];
      if (questionId != null) {
        print('Incrementing view count for question: $questionId');

        final updatedQuestion = await ForumQuestionService.getQuestionById(
          questionId.toString(),
        );

        if (updatedQuestion != null) {
          setState(() {
            _currentQuestion['views'] =
                updatedQuestion['views'] ?? _currentQuestion['views'];
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

  /// Load replies from database
  Future<void> _loadReplies() async {
    try {
      final questionId = widget.question['questionId'] ?? widget.question['id'];
      if (questionId != null) {
        print('Loading replies for question: $questionId');

        // Note: userId can be guardian, volunteer, or caregiver
        // TODO: Replace with actual user session ID
        final loadedReplies = await ForumAnswerService.getAnswersByQuestionId(
          questionId.toString(),
          userId: 13, // Using same ID as in like/unlike operations
        );

        setState(() {
          replies = loadedReplies.map((reply) {
            return {
              'id': reply['answerId'],
              'content': reply['content'],
              'author': reply['volunteerName'] ?? 'Unknown Volunteer',
              'authorType': reply['volunteerRole'] ?? 'Volunteer',
              'timeAgo': _formatTimeAgo(reply['createdAt']),
              'likes': reply['likes'] ?? 0,
              'isLiked': reply['isLikedByCurrentUser'] ?? false,
            };
          }).toList();
          _loadingReplies = false;
        });

        print('Loaded ${replies.length} replies successfully');
      }
    } catch (e) {
      print('Error loading replies: $e');
      setState(() {
        _loadingReplies = false;
      });
    }
  }

  /// Format timestamp to "time ago" format
  String _formatTimeAgo(dynamic timestamp) {
    if (timestamp == null) return 'Unknown time';

    try {
      DateTime dateTime;
      if (timestamp is int) {
        dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      } else if (timestamp is String) {
        dateTime = DateTime.parse(timestamp);
      } else {
        return 'Unknown time';
      }

      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 365) {
        final years = (difference.inDays / 365).floor();
        return '$years ${years == 1 ? 'year' : 'years'} ago';
      } else if (difference.inDays > 30) {
        final months = (difference.inDays / 30).floor();
        return '$months ${months == 1 ? 'month' : 'months'} ago';
      } else if (difference.inDays > 0) {
        return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Unknown time';
    }
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
                  reply['author'] != null && reply['author'].isNotEmpty
                      ? reply['author'][0]
                      : '?',
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
                      reply['author'] ?? 'Anonymous',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      reply['authorType'] ?? '',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Text(
                reply['timeAgo'] ?? '',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            reply['content'] ?? '',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              InkWell(
                onTap: () async {
                  try {
                    final answerId = reply['id'];
                    final isLiked = reply['isLiked'] ?? false;
                    final currentLikes = reply['likes'] ?? 0;

                    bool success;
                    if (isLiked) {
                      // Unlike - decrement like count
                      success = await ForumAnswerService.unlikeAnswer(
                        answerId.toString(),
                        13, // TODO: Replace with actual volunteer ID from session
                      );

                      if (success) {
                        setState(() {
                          reply['isLiked'] = false;
                          reply['likes'] = currentLikes > 0
                              ? currentLikes - 1
                              : 0;
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Like removed'),
                            backgroundColor: Colors.grey[700],
                            duration: Duration(seconds: 1),
                          ),
                        );
                      }
                    } else {
                      // Like - increment like count
                      success = await ForumAnswerService.likeAnswer(
                        answerId.toString(),
                        13, // TODO: Replace with actual volunteer ID from session
                      );

                      if (success) {
                        setState(() {
                          reply['isLiked'] = true;
                          reply['likes'] = currentLikes + 1;
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Liked successfully!'),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 1),
                          ),
                        );
                      }
                    }

                    if (!success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to update like'),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                        ),
                      );
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
                        ? Color(0xFF2B3F99).withOpacity(0.1)
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
                            ? Color(0xFF2B3F99)
                            : Colors.grey[600],
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${reply['likes'] ?? 0}',
                        style: TextStyle(
                          fontSize: 12,
                          color: (reply['isLiked'] ?? false)
                              ? Color(0xFF2B3F99)
                              : Colors.grey[600],
                        ),
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
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context, replies),
        ),
        title: Text(
          'Question Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
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
                          children: _currentQuestion['tags'].map<Widget>((tag) {
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
                          }).toList(),
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
                              '${_currentQuestion['views']} ${_currentQuestion['views'] == 1 ? 'view' : 'views'}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
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

                  // Replies list with loading state
                  if (_loadingReplies)
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(
                          color: Color(0xFF2B3F99),
                        ),
                      ),
                    )
                  else if (replies.isEmpty)
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'No replies yet. Be the first to reply!',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    )
                  else
                    for (var reply in replies) _buildReplyCard(reply),
                ],
              ),
            ),
          ),

          // Reply input
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
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
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Write your reply...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Color(0xFFA0C4FD)),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Color(0xFFA0C4FD),
                  child: IconButton(
                    icon: Icon(Icons.send, color: Color(0xFF2B3F99)),
                    onPressed: () async {
                      if (_replyController.text.trim().isNotEmpty) {
                        try {
                          final questionId =
                              widget.question['questionId'] ??
                              widget.question['id'];

                          // Show loading indicator
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
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 2),
                            ),
                          );

                          // Post reply to backend
                          final newReply = await ForumAnswerService.createAnswer(
                            questionId: questionId.toString(),
                            volunteerId:
                                13, // TODO: Replace with actual volunteer ID from session
                            content: _replyController.text.trim(),
                          );

                          // Add to local list if reply was created successfully
                          if (newReply != null) {
                            setState(() {
                              replies.insert(0, {
                                'id': newReply['answerId'],
                                'content': newReply['content'],
                                'author':
                                    newReply['volunteerName'] ?? 'Current User',
                                'authorType':
                                    newReply['volunteerRole'] ?? 'Volunteer',
                                'timeAgo': 'Just now',
                                'likes': newReply['likes'] ?? 0,
                                'isLiked': false,
                              });

                              // Update question reply count and mark as answered
                              final previousReplyCount =
                                  _currentQuestion['replies'] ?? 0;
                              _currentQuestion['replies'] =
                                  previousReplyCount + 1;

                              // Mark as answered when first reply is added
                              if (previousReplyCount == 0) {
                                _currentQuestion['isAnswered'] = true;
                              }
                            });

                            _replyController.clear();

                            // Show success message
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
