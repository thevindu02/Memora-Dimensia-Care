import 'package:flutter/material.dart';
import '../../constants/color_constants.dart';

// --- Articles Tab ---
class VolunteerArticlesTab extends StatefulWidget {
  @override
  _VolunteerArticlesTabState createState() => _VolunteerArticlesTabState();
}

class _VolunteerArticlesTabState extends State<VolunteerArticlesTab> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<Map<String, dynamic>> allArticles = [
    {
      'id': 1,
      'title': 'Understanding Dementia',
      'description': 'Discussion on symptoms and care',
      'category': 'Caregiver Tips',
      'author': 'Mr. Adam',
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
      'author': 'Mr. Adam',
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
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
          'Articles',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
      body: Column(
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
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: _clearSearch,
                      )
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
                      color: AppColors.onSurface,
                    ),
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
      ),
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
                      article['title'] ?? 'No Title',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      article['description'] ?? 'No description',
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
                              article['author'] ?? 'Unknown Author',
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
                                article['category'] ?? 'General',
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
                      '${article['comments'] ?? 0} comments · ${article['likes'] ?? 0} likes',
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
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: double.infinity,
                                  height: 200,
                                  color: Colors.grey[300],
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.image,
                                        size: 48,
                                        color: Colors.grey[600],
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Image not available',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            widget.article['title'] ?? 'No Title',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.onSurface,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.person,
                                size: 16,
                                color: AppColors.info,
                              ),
                              SizedBox(width: 4),
                              Text(
                                widget.article['author'] ?? 'Unknown Author',
                                style: TextStyle(
                                  color: AppColors.info,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
                                  widget.article['category'] ?? 'General',
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
                              fontWeight: FontWeight.bold,
                              color: AppColors.onSurface,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            widget.article['content'] ??
                                'No content available.',
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.6,
                              color: AppColors.onSurface,
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
                              fontWeight: FontWeight.bold,
                              color: AppColors.onSurface,
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
                                              AppColors.primaryLight,
                                          child: Icon(
                                            Icons.person,
                                            size: 20,
                                            color: AppColors.info,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              comment['author'] ?? 'Anonymous',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.info,
                                              ),
                                            ),
                                            Text(
                                              comment['timestamp'] ??
                                                  'Unknown time',
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
                                    Text(
                                      comment['content'] ?? 'No content',
                                      style: TextStyle(
                                        color: AppColors.onSurface,
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
                      icon: Icon(Icons.send, color: AppColors.info),
                      onPressed: _addComment,
                    ),
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
