import 'package:flutter/material.dart';

class ViewArticleScreen extends StatefulWidget {
  @override
  _ViewArticleScreenState createState() => _ViewArticleScreenState();
}

class _ViewArticleScreenState extends State<ViewArticleScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Color(0xFF2B3F99),
          unselectedLabelColor: Colors.grey,
          indicatorColor: Color(0xFF2B3F99),
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
      'category': 'Caregiver Tips',
      'author': 'Anonymous Guardian',
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
      'category': 'Caregiver Tips',
      'author': 'Anonymous Guardian',
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Spacer(),
              if (_searchQuery.isNotEmpty)
                Text(
                  '${filteredArticles.length} results',
                  style: TextStyle(color: Colors.grey[600]),
                ),
            ],
          ),
        ),
        SizedBox(height: 16),
        Expanded(
          child: filteredArticles.isEmpty
              ? Center(child: Text('No articles found'))
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
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      article['description'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey[600]),
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
                                color: Colors.grey[500],
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
                                color: Color(0xFFA0C4FD),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                article['category'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF2B3F99),
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
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
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
        'content':
            'This article is very helpful. My mother was recently diagnosed with dementia...',
        'timestamp': '2 hours ago',
      },
      {
        'id': 2,
        'author': 'James T.',
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
        'content': _commentController.text.trim(),
        'timestamp': 'Just now',
      });
    });
    _commentController.clear();
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
                            Text(widget.article['author']),
                            SizedBox(width: 12),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                widget.article['category'],
                                style: TextStyle(
                                  color: Colors.blue[900],
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
                                        ? Color(0xFF2B3F99)
                                        : Colors.grey[600],
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    '$_likeCount likes',
                                    style: TextStyle(
                                      color: _isLiked
                                          ? Color(0xFF2B3F99)
                                          : Colors.grey[600],
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
                              style: TextStyle(color: Colors.grey[600]),
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
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          widget.article['content'],
                          style: TextStyle(fontSize: 16, height: 1.6),
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
                                        backgroundColor: Colors.blue[100],
                                        child: Icon(
                                          Icons.person,
                                          size: 20,
                                          color: Colors.blue[800],
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            comment['author'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            comment['timestamp'],
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  Text(comment['content']),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
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
                        hintText: 'Add a comment...',
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
                  backgroundColor: Color(0xFF2B3F99),
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
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

  List<Map<String, dynamic>> questions = [
    {
      'id': 1,
      'title': 'How to manage medication schedules for elderly patients?',
      'content':
          'I\'m struggling to keep track of multiple medications for my elderly parent...',
      'tags': ['Medication', 'Elderly Care', 'Scheduling'],
      'askedBy': 'Anonymous Guardian',
      'timeAgo': '2 hours ago',
      'replies': 5,
      'views': 23,
      'isAnswered': true,
    },
    {
      'id': 2,
      'title': 'Best practices for emergency preparedness?',
      'content':
          'What should I include in an emergency kit for someone with chronic conditions...',
      'tags': ['Emergency', 'Preparedness', 'Chronic Conditions'],
      'askedBy': 'Anonymous Guardian',
      'timeAgo': '5 hours ago',
      'replies': 2,
      'views': 15,
      'isAnswered': false,
    },
    {
      'id': 3,
      'title': 'How to encourage physical activity in seniors?',
      'content':
          'My parent is reluctant to exercise. What are some gentle ways to encourage physical activity...',
      'tags': ['Exercise', 'Seniors', 'Motivation'],
      'askedBy': 'Anonymous Guardian',
      'timeAgo': '1 day ago',
      'replies': 8,
      'views': 42,
      'isAnswered': true,
    },
  ];

  List<Map<String, dynamic>> get filteredQuestions {
    switch (_selectedFilter) {
      case 'Unanswered':
        return questions.where((q) => !q['isAnswered']).toList();
      case 'Recent':
        return questions.where((q) => q['timeAgo'].contains('hour')).toList();
      case 'Most Replies':
        List<Map<String, dynamic>> sorted = List.from(questions);
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
          color: isSelected ? Color(0xFF2B3F99) : Color(0xFF2B3F99),
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
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuestionDetailScreen(question: question),
            ),
          );
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
                              content: Text(
                                'Please fill in all required fields',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
          ],
        ),
        Positioned(
          bottom: 24,
          right: 24,
          child: FloatingActionButton(
            onPressed: _showAddQuestionDialog,
            backgroundColor: Color(0xFFA0C4FD),
            child: Icon(Icons.add, color: Color(0xFF2B3F99)),
            tooltip: 'Ask a Question',
          ),
        ),
      ],
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

  // Mock replies data
  List<Map<String, dynamic>> replies = [
    {
      'id': 1,
      'content':
          'I recommend using a pill organizer with multiple compartments...',
      'author': 'Dr. Sarah Johnson',
      'authorType': 'Medical Professional',
      'timeAgo': '1 hour ago',
      'likes': 5,
    },
    {
      'id': 2,
      'content':
          'We use a medication app that sends notifications. It has been a game changer...',
      'author': 'Mike Chen',
      'authorType': 'Volunteer Caregiver',
      'timeAgo': '3 hours ago',
      'likes': 3,
    },
  ];

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
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
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
    );
  }
}
