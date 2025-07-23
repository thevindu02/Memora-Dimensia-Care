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
  ];

  List<Map<String, dynamic>> get filteredQuestions {
    switch (_selectedFilter) {
      case 'Unanswered':
        return questions.where((q) => !q['isAnswered']).toList();
      case 'Recent':
        return questions.where((q) => q['timeAgo'].contains('hour')).toList();
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
          if (updatedReplies != null) {
            setState(() {
              question['repliesList'] = updatedReplies;
              question['replies'] = updatedReplies.length;
            });
          }
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
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Your question will be posted anonymously',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
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
                    borderSide: BorderSide(color: Color(0xFFA0C4FD)),
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
                    borderSide: BorderSide(color: Color(0xFFA0C4FD)),
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
                    borderSide: BorderSide(color: Color(0xFFA0C4FD)),
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
                    onPressed: () {
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

                      // Add new question to the list
                      setState(() {
                        questions.insert(0, {
                          'id': questions.length + 1,
                          'title': titleController.text.trim(),
                          'content': contentController.text.trim(),
                          'tags': tagsController.text
                              .trim()
                              .split(',')
                              .map((tag) => tag.trim())
                              .toList(),
                          'askedBy': 'Anonymous Volunteer',
                          'timeAgo': 'Just now',
                          'replies': 0,
                          'views': 0,
                          'isAnswered': false,
                          'repliesList': [],
                        });
                      });

                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Question posted successfully!'),
                          backgroundColor: Colors.green,
                        ),
                      );
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
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: filteredQuestions.length,
            itemBuilder: (context, index) {
              return _buildQuestionCard(filteredQuestions[index]);
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
  late List<Map<String, dynamic>> replies;
  final TextEditingController _replyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    replies = List<Map<String, dynamic>>.from(widget.initialReplies);
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
                        '${reply['likes'] ?? 0}',
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
                                color: widget.question['isAnswered']
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                widget.question['isAnswered']
                                    ? 'Answered'
                                    : 'Unanswered',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: widget.question['isAnswered']
                                      ? Colors.green[700]
                                      : Colors.orange[700],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Spacer(),
                            Text(
                              widget.question['timeAgo'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text(
                          widget.question['title'],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          widget.question['content'],
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
                          children: widget.question['tags'].map<Widget>((tag) {
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
                              '${widget.question['views']} views',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            Spacer(),
                            Text(
                              'Asked by ${widget.question['askedBy']}',
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
                    'Replies ( ${replies.length})',
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
                    onPressed: () {
                      if (_replyController.text.trim().isNotEmpty) {
                        setState(() {
                          replies.add({
                            'id': replies.length + 1,
                            'content': _replyController.text.trim(),
                            'author': 'Current User', // This would be dynamic
                            'authorType': 'Volunteer',
                            'timeAgo': 'Just now',
                            'likes': 0,
                          });
                        });
                        _replyController.clear();
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
