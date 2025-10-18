import 'package:flutter/material.dart';
import '../../constants/color_constants.dart';
import '../../routes/app_routes.dart';
import '../../services/forum_question_service.dart';
import '../../services/forum_answer_service.dart';

class ViewArticleScreen extends StatefulWidget {
  @override
  _ViewArticleScreenState createState() => _ViewArticleScreenState();
}

class _ViewArticleScreenState extends State<ViewArticleScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 2; // Set to 2 since this is the Community/Articles tab

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Articles & Q&A Forum',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.primary,
          indicatorColor: AppColors.primary,
          tabs: [
            Tab(text: 'Articles'),
            Tab(text: 'Q&A Forum'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [CaregiverArticlesTab(), CaregiverQATab()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 0) {
            // Home tab
            Navigator.pushReplacementNamed(
              context,
              AppRoutes.caregiverDashboard,
            );
          } else if (index == 1) {
            // Patients tab
            Navigator.pushNamed(context, AppRoutes.caregiverPatients);
          } else if (index == 2) {
            // Community tab - already here, do nothing
            setState(() {
              _currentIndex = index;
            });
          } else if (index == 3) {
            // Profile tab
            Navigator.pushNamed(context, AppRoutes.caregiverProfile);
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF2B3F99),
        unselectedItemColor: Color(0xFF2B3F99),
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        selectedIconTheme: IconThemeData(size: 24),
        unselectedIconTheme: IconThemeData(size: 24),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outlined),
            label: 'Patients',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// --- Articles Tab ---
class CaregiverArticlesTab extends StatefulWidget {
  @override
  _CaregiverArticlesTabState createState() => _CaregiverArticlesTabState();
}

class _CaregiverArticlesTabState extends State<CaregiverArticlesTab> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<Map<String, dynamic>> allArticles = [
    {
      'id': 1,
      'title': 'Understanding Dementia',
      'description': 'Discussion on symptoms and care',
      'category': 'Volunteer',
      'author': 'Mr. Kamali Rathnayaka',
      'imageUrl':
          'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=300&h=200&fit=crop',
      'comments': 15,
      'likes': 24,
      'content':
          'Dementia is a complex condition that affects millions of people worldwide. Understanding its symptoms and progression is crucial for providing effective care...',
      'tags': ['dementia', 'symptoms', 'care', 'understanding'],
    },
    {
      'id': 2,
      'title': 'Caregiver Support',
      'description': 'Share your experiences',
      'category': 'Volunteer',
      'author': 'Mr. Kamali Rathnayaka',
      'imageUrl':
          'https://images.unsplash.com/photo-1582750433449-648ed127bb54?w=300&h=200&fit=crop',
      'comments': 8,
      'likes': 18,
      'content':
          'Being a caregiver can be emotionally and physically demanding. This space is for sharing experiences, challenges, and solutions...',
      'tags': ['support', 'caregiver', 'experiences', 'community'],
    },
  ];

  List<Map<String, dynamic>> get filteredArticles {
    if (_searchQuery.isEmpty) return allArticles;
    final query = _searchQuery.toLowerCase();
    return allArticles.where((article) {
      final title = article['title'].toString().toLowerCase();
      final desc = article['description'].toString().toLowerCase();
      return title.contains(query) || desc.contains(query);
    }).toList();
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = '';
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search articles',
              prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(icon: Icon(Icons.clear), onPressed: _clearSearch)
                  : null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Flexible(
                child: Text(
                  _searchQuery.isEmpty ? 'Recent Articles' : 'Search Results',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Spacer(),
              if (_searchQuery.isNotEmpty)
                Text(
                  '${filteredArticles.length} results',
                  style: TextStyle(color: Colors.black),
                ),
            ],
          ),
        ),
        SizedBox(height: 16),
        Expanded(
          child: filteredArticles.isEmpty
              ? Center(
                  child: Text(
                    'No articles found',
                    style: TextStyle(color: Colors.black),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.only(bottom: 16),
                  itemCount: filteredArticles.length,
                  itemBuilder: (context, index) {
                    return _buildArticleCard(filteredArticles[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildArticleCard(Map<String, dynamic> article) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CaregiverArticleDetailPage(article: article),
          ),
        );
      },
      child: Container(
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
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  article['imageUrl'],
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[300],
                      child: Icon(Icons.image, color: Colors.grey[600]),
                    );
                  },
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      article['title'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      article['description'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(height: 8),
                    Flexible(
                      child: Row(
                        children: [
                          Icon(Icons.person, size: 14, color: Colors.grey[500]),
                          SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              article['author'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8),
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green[100],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                article['category'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green[700],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${article['comments']} comments · ${article['likes']} likes',
                      style: TextStyle(fontSize: 12, color: Colors.black),
                      overflow: TextOverflow.ellipsis,
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

// --- Article Detail Page ---
class CaregiverArticleDetailPage extends StatefulWidget {
  final Map<String, dynamic> article;
  const CaregiverArticleDetailPage({Key? key, required this.article})
    : super(key: key);

  @override
  _CaregiverArticleDetailPageState createState() =>
      _CaregiverArticleDetailPageState();
}

class _CaregiverArticleDetailPageState
    extends State<CaregiverArticleDetailPage> {
  TextEditingController _commentController = TextEditingController();
  bool _isLiked = false;
  int _likeCount = 24;
  List<Map<String, dynamic>> _comments = [];

  @override
  void initState() {
    super.initState();
    _loadComments();
    _likeCount = widget.article['likes'] ?? 0;
  }

  void _loadComments() {
    _comments = [
      {
        'id': 1,
        'author': 'Sarah M.',
        'authorType': 'Guardian',
        'content':
            'This article is very helpful. My mother was recently diagnosed with dementia...',
        'timestamp': '2 hours ago',
      },
      {
        'id': 2,
        'author': 'James T.',
        'authorType': 'Guardian',
        'content':
            'What are the early warning signs I should watch for? My father is 78...',
        'timestamp': '4 hours ago',
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
        'authorType': 'Caregiver',
        'content': _commentController.text.trim(),
        'timestamp': 'Just now',
      });
    });
    _commentController.clear();
    FocusScope.of(context).unfocus();
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
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            widget.article['imageUrl'],
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          widget.article['title'],
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            SizedBox(width: 4),
                            Text(
                              widget.article['author'],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(width: 12),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                widget.article['category'] ?? 'Volunteer',
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
                                    _isLiked
                                        ? Icons.thumb_up
                                        : Icons.thumb_up_outlined,
                                    size: 20,
                                    color: _isLiked
                                        ? AppColors.primary
                                        : Colors.grey[600],
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    '$_likeCount likes',
                                    style: TextStyle(
                                      color: _isLiked
                                          ? AppColors.primary
                                          : Colors.black,
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
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(color: Colors.grey[300]),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Article Content',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          widget.article['content'],
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.6,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: Colors.grey[300]),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Comments (${_comments.length})',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 16),
                        Column(
                          children: _comments.map((comment) {
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
                                        radius: 20,
                                        backgroundColor:
                                            comment['authorType'] == 'Volunteer'
                                            ? Colors.green[100]
                                            : AppColors.primaryLight
                                                  .withOpacity(0.35),
                                        child: Icon(
                                          Icons.person,
                                          size: 20,
                                          color:
                                              comment['authorType'] ==
                                                  'Volunteer'
                                              ? Colors.green[700]
                                              : AppColors.primary,
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                    color:
                                                        comment['authorType'] ==
                                                            'Volunteer'
                                                        ? Colors.green[100]
                                                        : AppColors.primaryLight
                                                              .withOpacity(
                                                                0.35,
                                                              ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    comment['authorType'] ??
                                                        'Caregiver',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color:
                                                          comment['authorType'] ==
                                                              'Volunteer'
                                                          ? Colors.green[700]
                                                          : AppColors.primary,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 2),
                                            Text(
                                              comment['timestamp'],
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    comment['content'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  // Comments section
                  SizedBox(height: 100), // Space for comment input
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Reply to comments...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: AppColors.primaryLight,
                  child: IconButton(
                    icon: Icon(Icons.send, color: AppColors.primary),
                    onPressed: _addComment,
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

// --- Q&A Tab ---
class CaregiverQATab extends StatefulWidget {
  @override
  _CaregiverQATabState createState() => _CaregiverQATabState();
}

class _CaregiverQATabState extends State<CaregiverQATab> {
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
      'id': apiQuestion['questionId'],
      'guardianId': apiQuestion['guardianId'],
      'title': apiQuestion['title'],
      'content': apiQuestion['content'],
      'tags': apiQuestion['tags'] ?? [],
      'askedBy': apiQuestion['askedBy'] ?? 'Anonymous User',
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
          color: isSelected ? AppColors.primary : AppColors.primary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = filter;
        });
        _loadQuestions(); // Reload from database with new filter
      },
      backgroundColor: Colors.white,
      selectedColor: AppColors.primaryLight,
      checkmarkColor: AppColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? AppColors.primaryLight : Colors.grey[300]!,
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

          // Reload questions if view count was updated
          if (result == true) {
            _loadQuestions();
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
                    style: TextStyle(fontSize: 12, color: Colors.black),
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
                  color: Colors.black,
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
                      color: AppColors.primaryLight.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.primary,
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
                    '${question['views']} ${(question['views'] ?? 0) == 1 ? 'view' : 'views'}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  SizedBox(width: 16),
                  Icon(Icons.comment, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Text(
                    '${question['replies']} ${(question['replies'] ?? 0) == 1 ? 'reply' : 'replies'}',
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
                          'askedBy': 'Anonymous Guardian',
                          'timeAgo': 'Just now',
                          'replies': 0,
                          'views': 0,
                          'isAnswered': false,
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
                      backgroundColor: AppColors.primaryLight,
                      foregroundColor: AppColors.primary,
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

  void _showAddQuestionDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    final tagsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: EdgeInsets.all(24),
          child: SingleChildScrollView(
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
                              content: Text(
                                'Please fill in all required fields',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        // Capture the ScaffoldMessenger BEFORE closing dialog
                        final scaffoldMessenger = ScaffoldMessenger.of(context);

                        Navigator.pop(context);

                        // Show loading notification
                        scaffoldMessenger.showSnackBar(
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
                          // Parse tags
                          List<String> tags = tagsController.text
                              .trim()
                              .split(',')
                              .map((tag) => tag.trim())
                              .where((tag) => tag.isNotEmpty)
                              .toList();

                          // Post to database
                          final result = await ForumQuestionService.createQuestion(
                            userId:
                                2, // TODO: Replace with actual caregiver user ID from session
                            title: titleController.text.trim(),
                            content: contentController.text.trim(),
                            tags: tags,
                          );

                          if (result != null) {
                            // Hide loading indicator
                            scaffoldMessenger.hideCurrentSnackBar();

                            // Add the new question to the list immediately
                            setState(() {
                              questions.insert(0, _convertQuestion(result));
                            });

                            // Small delay to ensure the loading snackbar is dismissed
                            await Future.delayed(Duration(milliseconds: 100));

                            // Show success notification
                            scaffoldMessenger.showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 16),
                                    Text(
                                      'Posted successfully',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 3),
                              ),
                            );
                          } else {
                            throw Exception('Failed to create question');
                          }
                        } catch (e) {
                          scaffoldMessenger.hideCurrentSnackBar();
                          scaffoldMessenger.showSnackBar(
                            SnackBar(
                              content: Text('Failed to post question: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryLight,
                        foregroundColor: AppColors.primary,
                      ),
                      child: Text('Post Question'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadQuestions,
      child: Stack(
        children: [
          Column(
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

              // Questions list with loading/error states
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
                              color: Colors.red,
                            ),
                            SizedBox(height: 16),
                            Text(
                              _errorMessage!,
                              style: TextStyle(color: Colors.red),
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
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No questions yet',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Be the first to ask a question!',
                              style: TextStyle(color: Colors.grey[600]),
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
          Positioned(
            bottom: 24,
            right: 24,
            child: FloatingActionButton.extended(
              onPressed: _showAddQuestionDialog,
              backgroundColor: AppColors.primaryLight,
              label: Text(
                'Ask Question',
                style: TextStyle(color: AppColors.primary),
              ),
              tooltip: 'Ask a Question',
            ),
          ),
        ],
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
  final TextEditingController _replyController = TextEditingController();

  List<Map<String, dynamic>> replies = [];
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

        // Call the API which automatically increments the view count
        final updatedQuestion = await ForumQuestionService.getQuestionById(
          questionId.toString(),
        );

        if (updatedQuestion != null) {
          setState(() {
            // Update the local question data with new view count
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

        // For caregivers, pass userId (caregiver ID)
        final loadedReplies = await ForumAnswerService.getAnswersByQuestionId(
          questionId.toString(),
          userId: 2, // Caregiver user ID (different from guardian ID 1)
        );

        setState(() {
          replies = loadedReplies.map((reply) {
            // Transform backend response to UI format
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

  /// Handle like/unlike for a reply
  Future<void> _toggleLike(Map<String, dynamic> reply) async {
    try {
      final answerId = reply['id'].toString();
      final isLiked = reply['isLiked'] ?? false;
      final caregiverId =
          2; // Caregiver user ID (must match the ID used when loading replies)

      bool success;
      if (isLiked) {
        success = await ForumAnswerService.unlikeAnswer(answerId, caregiverId);
      } else {
        success = await ForumAnswerService.likeAnswer(answerId, caregiverId);
      }

      if (success) {
        setState(() {
          reply['isLiked'] = !isLiked;
          reply['likes'] = (reply['likes'] ?? 0) + (isLiked ? -1 : 1);
        });
      }
    } catch (e) {
      print('Error toggling like: $e');
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
                backgroundColor: AppColors.primaryLight,
                child: Text(
                  reply['author'][0],
                  style: TextStyle(
                    color: AppColors.primary,
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
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      reply['authorType'],
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Text(
                reply['timeAgo'],
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            reply['content'],
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
                onTap: () => _toggleLike(reply),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: (reply['isLiked'] ?? false)
                        ? AppColors.primary.withOpacity(0.1)
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
                            ? AppColors.primary
                            : Colors.grey[600],
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${reply['likes']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: (reply['isLiked'] ?? false)
                              ? AppColors.primary
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
    return WillPopScope(
      onWillPop: () async {
        // Always return true to reload questions when going back
        Navigator.pop(context, true);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.pop(context, true),
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
                            children: _currentQuestion['tags'].map<Widget>((
                              tag,
                            ) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLight.withOpacity(
                                    0.2,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  tag,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.primary,
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

                    // Replies list with loading state
                    if (_loadingReplies)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      )
                    else if (replies.isEmpty)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            'No replies yet.',
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

            // Reply input (only for volunteers)
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
            ),
          ],
        ),
      ),
    );
  }
}
