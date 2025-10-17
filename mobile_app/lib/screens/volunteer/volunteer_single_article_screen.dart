import 'package:flutter/material.dart';
import '../../services/article_service.dart';
import '../../services/comment_service.dart';
import '../../services/auth_service.dart';
import 'dart:async';

class VolunteerSingleArticleScreen extends StatefulWidget {
  final String articleId;

  const VolunteerSingleArticleScreen({Key? key, required this.articleId})
    : super(key: key);

  @override
  _VolunteerSingleArticleScreenState createState() =>
      _VolunteerSingleArticleScreenState();
}

class _VolunteerSingleArticleScreenState
    extends State<VolunteerSingleArticleScreen> {
  TextEditingController _commentController = TextEditingController();
  bool _isLiked = false;
  int _likeCount = 0;
  List<Map<String, dynamic>> _comments = [];
  Map<String, List<Map<String, dynamic>>> _replies =
      {}; // Store replies by comment ID

  // Article data
  Map<String, dynamic>? articleData;
  bool isLoading = true;
  String? errorMessage;

  // Article author information
  String articleAuthor = 'Loading...';
  String articleAuthorType = 'Volunteer';
  String articleTitle = '';
  String articleContent = '';
  String articleImage = '';

  // Current user information
  int? currentUserId;
  String currentUserName = 'Loading...';
  String currentUserType = 'Volunteer';

  String? _replyingToCommentId;
  TextEditingController _replyController = TextEditingController();

  // Stream subscriptions
  StreamSubscription? _commentsSubscription;
  Map<String, StreamSubscription> _repliesSubscriptions = {};

  bool isPostingComment = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _loadArticleData();
    _subscribeToComments();
  }

  Future<void> _loadArticleData() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final article = await ArticleService.getArticleDetail(widget.articleId);

      if (article != null) {
        setState(() {
          articleData = article;
          articleTitle = article['title'] ?? 'Untitled';
          articleContent = article['content'] ?? 'No content available';
          articleImage =
              article['articleImg'] ??
              'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=400&h=200&fit=crop';
          articleAuthor = article['authorName'] ?? 'Unknown Author';
          articleAuthorType = 'Volunteer';
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load article';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading article: $e';
        isLoading = false;
      });
      print('Error loading article: $e');
    }
  }

  Future<void> _loadCurrentUser() async {
    try {
      final user = await AuthService.getCurrentUser();
      if (user != null) {
        setState(() {
          currentUserId = user['id'];
          currentUserName = '${user['fName'] ?? ''} ${user['lName'] ?? ''}'
              .trim();
          if (currentUserName.isEmpty) {
            currentUserName = user['email'] ?? 'User';
          }
          // Get user type from role
          String role = user['role']?.toString().toLowerCase() ?? 'volunteer';
          currentUserType =
              role.substring(0, 1).toUpperCase() + role.substring(1);
        });
      }
    } catch (e) {
      print('Error loading current user: $e');
    }
  }

  void _subscribeToComments() {
    // Subscribe to comments stream
    _commentsSubscription = CommentService.getCommentsStream(widget.articleId)
        .listen(
          (comments) {
            setState(() {
              _comments = comments;
            });

            // Subscribe to replies for each comment
            for (var comment in comments) {
              final commentId = comment['id'];
              if (commentId != null &&
                  !_repliesSubscriptions.containsKey(commentId)) {
                _repliesSubscriptions[commentId] =
                    CommentService.getRepliesStream(commentId).listen((
                      replies,
                    ) {
                      setState(() {
                        _replies[commentId] = replies;
                      });
                    });
              }
            }
          },
          onError: (error) {
            print('Error loading comments: $error');
          },
        );
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });
  }

  Future<void> _addComment() async {
    if (_commentController.text.trim().isEmpty) return;
    if (currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please sign in to comment'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isPostingComment = true;
    });

    final result = await CommentService.addComment(
      articleId: widget.articleId,
      userId: currentUserId!,
      userName: currentUserName,
      userType: currentUserType,
      content: _commentController.text.trim(),
    );

    setState(() {
      isPostingComment = false;
    });

    if (result['success']) {
      _commentController.clear();
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Comment added successfully'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Failed to add comment'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _addReply(String commentId, String replyContent) async {
    if (replyContent.trim().isEmpty) return;
    if (currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please sign in to reply'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final result = await CommentService.addReply(
      articleId: widget.articleId,
      parentCommentId: commentId,
      userId: currentUserId!,
      userName: currentUserName,
      userType: currentUserType,
      content: replyContent.trim(),
    );

    if (result['success']) {
      setState(() {
        _replyingToCommentId = null;
        _replyController.clear();
      });
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Reply added successfully'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Failed to add reply'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildReplyInput(String commentId) {
    return Container(
      margin: EdgeInsets.only(top: 12, left: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0x59A0C4FD), // light sky blue with 35% opacity
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0x59A0C4FD)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.reply, size: 18, color: Color(0xFF2B3F99)),
              SizedBox(width: 6),
              Text(
                'Reply as volunteer',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2B3F99),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: _replyController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Write your reply...',
                hintStyle: TextStyle(color: Colors.grey[500]),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(12),
              ),
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _replyingToCommentId = null;
                    _replyController.clear();
                  });
                  FocusScope.of(context).unfocus();
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Color(0xFF2B3F99),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  _addReply(commentId, _replyController.text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(
                    0x59A0C4FD,
                  ), // light sky blue with 35% opacity
                  foregroundColor: Color(0xFF2B3F99),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  textStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
                child: Text(
                  'Reply',
                  style: TextStyle(
                    color: Color(0xFF2B3F99),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommentCard(Map<String, dynamic> comment) {
    final commentId = comment['id'];
    final replies = _replies[commentId] ?? [];

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
                backgroundColor: comment['userType'] == 'Volunteer'
                    ? Colors.green[100]
                    : Color(0xFFA0C4FD).withOpacity(0.35),
                child: Icon(
                  Icons.person,
                  size: 20,
                  color: comment['userType'] == 'Volunteer'
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
                          comment['userName'] ?? 'Anonymous',
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
                            color: comment['userType'] == 'Volunteer'
                                ? Colors.green[100]
                                : Color(0xFFA0C4FD).withOpacity(0.35),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            comment['userType'] ?? 'User',
                            style: TextStyle(
                              fontSize: 10,
                              color: comment['userType'] == 'Volunteer'
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
                      CommentService.formatTimestamp(comment['createdAt']),
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            comment['content'] ?? '',
            style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.4),
          ),
          // Reply button for volunteers
          SizedBox(height: 12),
          TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            ),
            onPressed: () {
              setState(() {
                _replyingToCommentId = commentId;
                _replyController.clear();
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.reply, size: 16, color: Color(0xFF2B3F99)),
                SizedBox(width: 4),
                Text(
                  'Reply',
                  style: TextStyle(
                    color: Color(0xFF2B3F99),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (_replyingToCommentId == commentId) _buildReplyInput(commentId),
          // Replies section
          if (replies.isNotEmpty) ...[
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.only(left: 16),
              child: Column(
                children: replies.map<Widget>((reply) {
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
                              backgroundColor: reply['userType'] == 'Volunteer'
                                  ? Colors.green[100]
                                  : Color(0xFFA0C4FD).withOpacity(0.35),
                              child: Icon(
                                Icons.person,
                                size: 16,
                                color: reply['userType'] == 'Volunteer'
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
                                        reply['userName'] ?? 'Anonymous',
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
                                              reply['userType'] == 'Volunteer'
                                              ? Colors.green[100]
                                              : Color(
                                                  0xFFA0C4FD,
                                                ).withOpacity(0.35),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Text(
                                          reply['userType'] ?? 'User',
                                          style: TextStyle(
                                            fontSize: 8,
                                            color:
                                                reply['userType'] == 'Volunteer'
                                                ? Colors.green[700]
                                                : Color(0xFF2B3F99),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    CommentService.formatTimestamp(
                                      reply['createdAt'],
                                    ),
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
                          reply['content'] ?? '',
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
    _replyController.dispose();
    _commentsSubscription?.cancel();
    for (var subscription in _repliesSubscriptions.values) {
      subscription.cancel();
    }
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                  SizedBox(height: 16),
                  Text(
                    errorMessage!,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadArticleData,
                    child: Text('Retry'),
                  ),
                ],
              ),
            )
          : Column(
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
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
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
                        for (var comment in _comments)
                          _buildCommentCard(comment),
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

  Widget _buildArticleHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              articleImage,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.grey[300],
                  child: Icon(Icons.image, size: 64, color: Colors.grey[600]),
                );
              },
            ),
          ),
          SizedBox(height: 16),
          Text(
            articleTitle,
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
                articleAuthor,
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
                  articleAuthorType,
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
            articleContent,
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
                  style: TextStyle(color: Color(0xFF2B3F99)),
                ),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: isPostingComment ? null : _addComment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFA0C4FD),
                  foregroundColor: Color(0xFF2B3F99),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: isPostingComment
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF2B3F99),
                          ),
                        ),
                      )
                    : Text('Post Comment'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
