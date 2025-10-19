import 'package:flutter/material.dart';

class VolunteerQATabBody extends StatefulWidget {
  const VolunteerQATabBody({Key? key}) : super(key: key);

  @override
  State<VolunteerQATabBody> createState() => _VolunteerQATabBodyState();
}

class _VolunteerQATabBodyState extends State<VolunteerQATabBody> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Unanswered', 'Recent', 'Most Replies'];

  // Mock data for forum questions
  List<Map<String, dynamic>> questions = [
    {
      'id': 1,
      'title': 'How to manage medication schedules for elderly patients?',
      'content':
          'I\'m struggling to keep track of multiple medications for my elderly parent. What are some effective strategies or tools that can help?',
      'tags': ['Medication', 'Elderly Care', 'Scheduling'],
      'askedBy': 'Anonymous Volunteer',
      'timeAgo': '2 hours ago',
      'replies': 5,
      'views': 23,
      'isAnswered': true,
    },
    {
      'id': 2,
      'title': 'Best practices for emergency preparedness?',
      'content':
          'What should I include in an emergency kit for someone with chronic conditions? Are there specific items I should prioritize?',
      'tags': ['Emergency', 'Preparedness', 'Chronic Conditions'],
      'askedBy': 'Anonymous Volunteer',
      'timeAgo': '5 hours ago',
      'replies': 2,
      'views': 15,
      'isAnswered': false,
    },
    {
      'id': 3,
      'title': 'How to encourage physical activity in seniors?',
      'content':
          'My parent is reluctant to exercise. What are some gentle ways to encourage physical activity that won\'t overwhelm them?',
      'tags': ['Exercise', 'Seniors', 'Motivation'],
      'askedBy': 'Anonymous Volunteer',
      'timeAgo': '1 day ago',
      'replies': 8,
      'views': 42,
      'isAnswered': true,
    },
    {
      'id': 4,
      'title': 'Nutrition guidelines for diabetic patients?',
      'content':
          'I need help understanding what foods are safe and beneficial for someone with diabetes. Any meal planning tips?',
      'tags': ['Nutrition', 'Diabetes', 'Meal Planning'],
      'askedBy': 'Anonymous Volunteer',
      'timeAgo': '3 days ago',
      'replies': 0,
      'views': 8,
      'isAnswered': false,
    },
    {
      'id': 5,
      'title': 'Communication strategies for dementia patients?',
      'content':
          'What are the best ways to communicate with someone who has dementia? I want to maintain a good relationship.',
      'tags': ['Communication', 'Dementia', 'Relationships'],
      'askedBy': 'Anonymous Volunteer',
      'timeAgo': '4 days ago',
      'replies': 12,
      'views': 67,
      'isAnswered': true,
    },
    {
      'id': 6,
      'title': 'Sleep management for elderly patients?',
      'content':
          'My elderly parent has trouble sleeping. What are some natural ways to improve sleep quality?',
      'tags': ['Sleep', 'Elderly Care', 'Health'],
      'askedBy': 'Anonymous Volunteer',
      'timeAgo': '1 week ago',
      'replies': 6,
      'views': 34,
      'isAnswered': true,
    },
  ];

  List<Map<String, dynamic>> get filteredQuestions {
    switch (_selectedFilter) {
      case 'Unanswered':
        return questions.where((q) => !q['isAnswered']).toList();
      case 'Recent':
        return questions
            .where(
              (q) =>
                  q['timeAgo'].contains('hour') || q['timeAgo'].contains('day'),
            )
            .toList();
      case 'Most Replies':
        final sorted = List<Map<String, dynamic>>.from(questions);
        sorted.sort((a, b) => b['replies'].compareTo(a['replies']));
        return sorted;
      default:
        return questions;
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
      },
      backgroundColor: Colors.white,
      selectedColor: Color(0xFFA0C4FD),
      checkmarkColor: Color(0xFF2B3F99),
      side: BorderSide(color: Color(0xFF2B3F99)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  void _onQuestionTapped(Map<String, dynamic> question) {
    // Navigate to question detail screen with reply functionality
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuestionDetailScreen(question: question),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Filter Chips
          SingleChildScrollView(
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
          SizedBox(height: 16),
          // Questions List
          Expanded(
            child: ListView.builder(
              itemCount: filteredQuestions.length,
              itemBuilder: (context, index) {
                final question = filteredQuestions[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 16),
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
                  child: InkWell(
                    onTap: () => _onQuestionTapped(question),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  question['title'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (question['isAnswered'])
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 20,
                                ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            question['content'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            children: question['tags'].map<Widget>((tag) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  tag,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue[700],
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
                                Icons.person,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              SizedBox(width: 4),
                              Text(
                                question['askedBy'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.access_time,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              SizedBox(width: 4),
                              Text(
                                question['timeAgo'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              SizedBox(width: 4),
                              Text(
                                '${question['replies']} replies',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(width: 16),
                              Icon(
                                Icons.visibility,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              SizedBox(width: 4),
                              Text(
                                '${question['views']} views',
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
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Question Detail Screen with Reply Functionality
class QuestionDetailScreen extends StatefulWidget {
  final Map<String, dynamic> question;

  const QuestionDetailScreen({Key? key, required this.question})
    : super(key: key);

  @override
  State<QuestionDetailScreen> createState() => _QuestionDetailScreenState();
}

class _QuestionDetailScreenState extends State<QuestionDetailScreen> {
  TextEditingController _replyController = TextEditingController();
  List<Map<String, dynamic>> _replies = [];

  @override
  void initState() {
    super.initState();
    _loadReplies();
  }

  void _loadReplies() {
    _replies = [
      {
        'id': 1,
        'author': 'Dr. Sarah Johnson',
        'authorType': 'Volunteer',
        'content':
            'I recommend using a pill organizer and setting up medication reminders on your phone. There are also apps specifically designed for medication management.',
        'timestamp': '1 hour ago',
        'likes': 3,
      },
      {
        'id': 2,
        'author': 'Nurse Maria',
        'authorType': 'Volunteer',
        'content':
            'Consider working with your parent\'s doctor to simplify the medication schedule if possible. Sometimes medications can be combined or taken at different times.',
        'timestamp': '2 hours ago',
        'likes': 2,
      },
    ];
  }

  void _addReply() {
    if (_replyController.text.trim().isEmpty) return;

    setState(() {
      _replies.insert(0, {
        'id': _replies.length + 1,
        'author': 'You',
        'authorType': 'Volunteer',
        'content': _replyController.text.trim(),
        'timestamp': 'Just now',
        'likes': 0,
      });
    });

    _replyController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Question Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question Header
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
                      Expanded(
                        child: Text(
                          widget.question['title'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      if (widget.question['isAnswered'])
                        Icon(Icons.check_circle, color: Colors.green, size: 24),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    widget.question['content'],
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: widget.question['tags'].map<Widget>((tag) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.person, size: 16, color: Colors.grey[600]),
                      SizedBox(width: 4),
                      Text(
                        widget.question['askedBy'],
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      Spacer(),
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 4),
                      Text(
                        widget.question['timeAgo'],
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Replies Section
            Text(
              'Replies (${_replies.length})',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12),
            // Replies List
            ..._replies
                .map(
                  (reply) => Container(
                    margin: EdgeInsets.only(bottom: 12),
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
                            Icon(
                              Icons.person,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            SizedBox(width: 4),
                            Text(
                              reply['author'],
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                reply['authorType'],
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.blue[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Spacer(),
                            Text(
                              reply['timestamp'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          reply['content'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.thumb_up_outlined,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            SizedBox(width: 4),
                            Text(
                              '${reply['likes']}',
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
                )
                .toList(),
            SizedBox(height: 20),
            // Reply Input Section
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
                  Text(
                    'Add Your Reply',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: _replyController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Type your reply...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Spacer(),
                      ElevatedButton(
                        onPressed: _addReply,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2B3F99),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text('Post Reply'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
