import 'package:flutter/material.dart';

class GuardianForumArticleScreen extends StatefulWidget {
  @override
  _GuardianForumArticleScreenState createState() =>
      _GuardianForumArticleScreenState();
}

class _GuardianForumArticleScreenState
    extends State<GuardianForumArticleScreen> {
  TextEditingController _commentController = TextEditingController();
  bool _isLiked = false;
  int _likeCount = 24;
  List<Map<String, dynamic>> _comments = [];

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  void _loadComments() {
    // Hardcoded comments data - can be replaced with DB calls later
    _comments = [
      {
        'id': 1,
        'author': 'Sarah M.',
        'authorType': 'Guardian',
        'content':
            'This article is very helpful. My mother was recently diagnosed with dementia and I\'ve been struggling to understand the condition. The explanations here are clear and practical.',
        'timestamp': '2 hours ago',
        'replies': [
          {
            'id': 101,
            'author': 'Dr. Sarah Johnson',
            'authorType': 'Volunteer',
            'content':
                'I\'m glad you found it helpful, Sarah. Remember that early intervention and understanding can make a significant difference in care quality. Feel free to ask if you have specific questions.',
            'timestamp': '1 hour ago',
          },
          {
            'id': 102,
            'author': 'Maria Rodriguez',
            'authorType': 'Volunteer',
            'content':
                'Sarah, you\'re not alone in this journey. Many of us have been where you are now. The community here is very supportive, so don\'t hesitate to reach out.',
            'timestamp': '45 minutes ago',
          },
        ],
      },
      {
        'id': 2,
        'author': 'James T.',
        'authorType': 'Guardian',
        'content':
            'What are the early warning signs I should watch for? My father is 78 and sometimes seems confused about recent events.',
        'timestamp': '4 hours ago',
        'replies': [
          {
            'id': 201,
            'author': 'Dr. Sarah Johnson',
            'authorType': 'Volunteer',
            'content':
                'Great question, James. Early signs include memory loss that disrupts daily life, difficulty with familiar tasks, confusion with time or place, and changes in mood or personality. I recommend consulting with his doctor for a proper assessment.',
            'timestamp': '3 hours ago',
          },
        ],
      },
      {
        'id': 3,
        'author': 'Linda K.',
        'authorType': 'Guardian',
        'content':
            'Thank you for sharing this information. The section about different types of dementia was particularly enlightening.',
        'timestamp': '6 hours ago',
        'replies': [],
      },
    ];
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });
  }

  void _addComment() {
    if (_commentController.text.trim().isEmpty) return;

    setState(() {
      _comments.insert(0, {
        'id': DateTime.now().millisecondsSinceEpoch,
        'author': 'You',
        'authorType': 'Guardian',
        'content': _commentController.text.trim(),
        'timestamp': 'Just now',
        'replies': [],
      });
    });

    _commentController.clear();
    FocusScope.of(context).unfocus();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Comment added successfully'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget _buildArticleHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400&h=200&fit=crop',
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Understanding Dementia',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.person, size: 16, color: Colors.grey[600]),
              SizedBox(width: 4),
              Text(
                'Dr. Sarah Johnson',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              SizedBox(width: 12),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Volunteer',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              GestureDetector(
                onTap: _toggleLike,
                child: Row(
                  children: [
                    Icon(
                      _isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                      size: 20,
                      color: _isLiked ? Color(0xFF2B3F99) : Colors.grey[600],
                    ),
                    SizedBox(width: 4),
                    Text(
                      '$_likeCount likes',
                      style: TextStyle(
                        fontSize: 14,
                        color: _isLiked ? Color(0xFF2B3F99) : Colors.grey[600],
                        fontWeight: _isLiked
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20),
              Icon(
                Icons.chat_bubble_outline,
                size: 20,
                color: Colors.grey[600],
              ),
              SizedBox(width: 4),
              Text(
                '${_comments.length} comments',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildArticleContent() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: Colors.grey[300]),
          SizedBox(height: 16),
          Text(
            'Article Content',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Dementia is a complex condition that affects millions of people worldwide. Understanding its symptoms and progression is crucial for providing effective care.\n\nThis comprehensive guide covers the basics of dementia, including early warning signs, different types, and practical tips for caregivers. By educating ourselves about this condition, we can better support our loved ones and improve their quality of life.\n\nEarly signs of dementia include:\n• Memory loss that disrupts daily life\n• Difficulty completing familiar tasks\n• Confusion with time or place\n• Trouble understanding visual images\n• Problems with words in speaking or writing\n• Misplacing things and losing the ability to retrace steps\n• Decreased or poor judgment\n• Withdrawal from work or social activities\n• Changes in mood and personality\n\nIt\'s important to note that experiencing one or more of these signs doesn\'t necessarily mean someone has dementia. However, if you notice several of these symptoms, it\'s recommended to consult with a healthcare professional for proper evaluation.\n\nRemember, early detection and intervention can make a significant difference in managing the condition and maintaining quality of life.',
            style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.6),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add a comment',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _commentController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Share your thoughts or ask a question...',
                hintStyle: TextStyle(color: Colors.grey[500]),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
              ),
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  _commentController.clear();
                  FocusScope.of(context).unfocus();
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Color(0xFF2B3F99),
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: _addComment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFA0C4FD),
                  foregroundColor: Color(0xFF2B3F99),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Post Comment',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommentCard(Map<String, dynamic> comment) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
                radius: 20,
                backgroundColor: comment['authorType'] == 'Volunteer'
                    ? Colors.green[100]
                    : Color(0xFFA0C4FD).withOpacity(0.35),
                child: Icon(
                  Icons.person,
                  size: 20,
                  color: comment['authorType'] == 'Volunteer'
                      ? Colors.green[700]
                      : Color(0xFF2B3F99),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          comment['author'],
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
                            color: comment['authorType'] == 'Volunteer'
                                ? Colors.green[100]
                                : Color(0xFFA0C4FD).withOpacity(0.35),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            comment['authorType'],
                            style: TextStyle(
                              fontSize: 10,
                              color: comment['authorType'] == 'Volunteer'
                                  ? Colors.green[700]
                                  : Color(0xFF2B3F99),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2),
                    Text(
                      comment['timestamp'],
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            comment['content'],
            style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.4),
          ),

          // Replies section
          if (comment['replies'] != null && comment['replies'].isNotEmpty) ...[
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.only(left: 16),
              child: Column(
                children: comment['replies'].map<Widget>((reply) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 12),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor:
                                  reply['authorType'] == 'Volunteer'
                                  ? Colors.green[100]
                                  : Color(0xFFA0C4FD).withOpacity(0.35),
                              child: Icon(
                                Icons.person,
                                size: 16,
                                color: reply['authorType'] == 'Volunteer'
                                    ? Colors.green[700]
                                    : Color(0xFF2B3F99),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        reply['author'],
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 4,
                                          vertical: 1,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              reply['authorType'] == 'Volunteer'
                                              ? Colors.green[100]
                                              : Color(
                                                  0xFFA0C4FD,
                                                ).withOpacity(0.35),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Text(
                                          reply['authorType'],
                                          style: TextStyle(
                                            fontSize: 8,
                                            color:
                                                reply['authorType'] ==
                                                    'Volunteer'
                                                ? Colors.green[700]
                                                : Color(0xFF2B3F99),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    reply['timestamp'],
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          reply['content'],
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Article',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildArticleHeader(),
                  _buildArticleContent(),

                  // Comments section
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Text(
                      'Comments (${_comments.length})',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  // Comments list
                  for (var comment in _comments) _buildCommentCard(comment),

                  SizedBox(height: 100), // Space for comment input
                ],
              ),
            ),
          ),
          _buildCommentInput(),
        ],
      ),
    );
  }
}
