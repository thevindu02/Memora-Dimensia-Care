import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class ArticleList extends StatelessWidget {
  const ArticleList({super.key});

  @override
  Widget build(BuildContext context) {
    return const MScreen();
  }
}

class MScreen extends StatefulWidget {
  const MScreen({super.key});

  @override
  State<MScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MScreen> {
  int _currentIndex = 2; // Set to Articles tab since this is the articles screen

  final List<Widget> _screens = [
    const ArticlesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[0], // Always show ArticlesScreen since this is the articles page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 0) { // Home tab
            Navigator.pushNamed(context, AppRoutes.caregiverDashboard);
          } else if (index == 1) { // Patients tab
            Navigator.pushNamed(context, AppRoutes.caregiverPatients);
          } else if (index == 2) { // Articles tab - current screen
            // Already on articles screen, do nothing or refresh
            setState(() {
              _currentIndex = index;
            });
          } else if (index == 3) { // Profile tab
            Navigator.pushNamed(context, AppRoutes.caregiverProfile);
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Patients'),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Articles'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class ArticlesScreen extends StatefulWidget {
  const ArticlesScreen({super.key});

  @override
  State<ArticlesScreen> createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  String selectedCategory = 'All Categories';
  final TextEditingController _searchController = TextEditingController();

  final List<Article> articles = [
    Article(
      title: 'Compassionate Dementia Care',
      description: 'Dementia is more than memory loss—it\'s a life-changing condition that affects how a person thinks...',
      fullContent: '''Dementia is more than memory loss—it's a life-changing condition that affects how a person thinks, feels, and behaves. As caregivers, understanding the complexities of dementia is crucial for providing compassionate care that honors the dignity and individuality of each person.

[Full article content remains the same...]''',
      category: 'Elderly Care',
      author: 'Sarah',
      date: '2025-06-21',
      imageUrl: 'assets/images/blog1.jpg', // Local asset
      comments: [
        Comment(
          author: 'Anonymous User',
          content: 'This article really helped me understand my grandmother\'s condition better. Thank you for sharing.',
          date: '2025-06-22',
          likes: 12,
        ),
        // Other comments...
      ],
    ),
    Article(
      title: 'Managing Chronic Pain in Seniors',
      description: 'Chronic pain affects millions of older adults worldwide, impacting their quality of life...',
      fullContent: '''Chronic pain affects millions of older adults worldwide, impacting their quality of life and daily functioning...

[Full article content remains the same...]''',
      category: 'Pain Management',
      author: 'Dr. Johnson',
      date: '2025-06-20',
      imageUrl: 'assets/images/blog2.jpg', // Network image
      comments: [
        // Comments...
      ],
    ),
    Article(
      title: 'Nutrition Guidelines for Elderly',
      description: 'Proper nutrition plays a crucial role in maintaining health and independence in older adults...',
      fullContent: '''Proper nutrition plays a crucial role in maintaining health and independence in older adults...

[Full article content remains the same...]''',
      category: 'Nutrition',
      author: 'Emily',
      date: '2025-06-19',
      imageUrl: 'https://images.unsplash.com/photo-1505576399279-565b52d4ac71?w=400', // Network image
      comments: [
        // Comments...
      ],
    ),
  ];

  List<Article> get filteredArticles {
    List<Article> filtered = articles;

    if (selectedCategory != 'All Categories') {
      filtered = filtered.where((article) => article.category == selectedCategory).toList();
    }

    if (_searchController.text.isNotEmpty) {
      filtered = filtered.where((article) =>
      article.title.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          article.description.toLowerCase().contains(_searchController.text.toLowerCase())
      ).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Articles',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.caregiverNotification);
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {});
                      },
                      decoration: const InputDecoration(
                        hintText: 'Search articles...',
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Category Filter
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedCategory,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: ['All Categories', 'Elderly Care', 'Pain Management', 'Nutrition']
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedCategory = newValue!;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Articles List
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final article = filteredArticles[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ArticleCard(article: article),
                );
              },
              childCount: filteredArticles.length,
            ),
          ),
        ],
      ),
    );
  }
}

class ArticleCard extends StatefulWidget {
  final Article article;

  const ArticleCard({super.key, required this.article});

  @override
  State<ArticleCard> createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard> {
  bool showComments = false;
  final TextEditingController _commentController = TextEditingController();

  void _addComment() {
    if (_commentController.text.trim().isNotEmpty) {
      setState(() {
        widget.article.comments.add(
          Comment(
            author: 'Anonymous User',
            content: _commentController.text.trim(),
            date: '2025-07-02',
            likes: 0,
          ),
        );
        _commentController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image - Updated to properly display images
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: widget.article.imageUrl.startsWith('http')
                ? Image.network(
              widget.article.imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 180,
                  color: Colors.grey[200],
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 180,
                  color: Colors.grey[200],
                  child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                );
              },
            )
                : Image.asset(
              widget.article.imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 180,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image, size: 50, color: Colors.grey),
                );
              },
            ),
          ),

          // Rest of the ArticleCard widget remains the same...
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  widget.article.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),

                // Description
                Text(
                  widget.article.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),

                // Category and View Button
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.pink[50],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        widget.article.category,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.pink[400],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArticleDetailPage(article: widget.article),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF9FC3FC),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      ),
                      child: const Text('View'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Author and Date
                Row(
                  children: [
                    Icon(Icons.person, size: 16, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      widget.article.author,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      widget.article.date,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Comments Section Toggle
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showComments = !showComments;
                        });
                      },
                      child: Row(
                        children: [
                          Icon(
                            showComments ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                            color: Colors.blue,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Comments (${widget.article.comments.length})',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Comments Section
                if (showComments) ...[
                  const SizedBox(height: 16),

                  // Add Comment Input
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _commentController,
                          decoration: const InputDecoration(
                            hintText: 'Add a comment as Anonymous User...',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: _addComment,
                              child: const Text('Post Comment'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Comments List
                  ...widget.article.comments.map((comment) => CommentWidget(comment: comment)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Updated ArticleDetailPage with proper image display
class ArticleDetailPage extends StatefulWidget {
  final Article article;

  const ArticleDetailPage({super.key, required this.article});

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  bool isBookmarked = false;
  final TextEditingController _commentController = TextEditingController();

  void _addComment() {
    if (_commentController.text.trim().isNotEmpty) {
      setState(() {
        widget.article.comments.add(
          Comment(
            author: 'Anonymous User',
            content: _commentController.text.trim(),
            date: '2025-07-02',
            likes: 0,
          ),
        );
        _commentController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Article Details',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: isBookmarked ? Colors.blue : Colors.black87,
            ),
            onPressed: () {
              setState(() {
                isBookmarked = !isBookmarked;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isBookmarked ? 'Article bookmarked' : 'Bookmark removed',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black87),
            onPressed: () {
              // Share functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Share functionality would be implemented here'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Article Image - Updated to properly display images
            widget.article.imageUrl.startsWith('http')
                ? Image.network(
              widget.article.imageUrl,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 250,
                  color: Colors.grey[200],
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 250,
                  color: Colors.grey[200],
                  child: const Icon(Icons.broken_image, size: 80, color: Colors.grey),
                );
              },
            )
                : Image.asset(
              widget.article.imageUrl,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 250,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image, size: 80, color: Colors.grey),
                );
              },
            ),

            // Rest of the ArticleDetailPage remains the same...
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Tag
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.pink[50],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      widget.article.category,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.pink[400],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title
                  Text(
                    widget.article.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Author and Date
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.blue[100],
                        child: Text(
                          widget.article.author[0],
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.article.author,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            widget.article.date,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Article Content
                  Text(
                    widget.article.fullContent,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Comments Section
                  const Text(
                    'Comments',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Add Comment Input
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _commentController,
                          decoration: const InputDecoration(
                            hintText: 'Write your comment as Anonymous User...',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: _addComment,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text('Post Comment'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Comments List
                  ...widget.article.comments.map((comment) => CommentWidget(comment: comment)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// CommentWidget remains the same...
class CommentWidget extends StatefulWidget {
  final Comment comment;

  const CommentWidget({super.key, required this.comment});

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
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
                backgroundColor: Colors.blue[100],
                child: Text(
                  widget.comment.author[0],
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.comment.author,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      widget.comment.date,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.comment.content,
            style: const TextStyle(
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (isLiked) {
                      widget.comment.likes--;
                      isLiked = false;
                    } else {
                      widget.comment.likes++;
                      isLiked = true;
                    }
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                      size: 16,
                      color: isLiked ? Colors.blue : Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.comment.likes}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notification',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 80,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No notifications yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Article {
  final String title;
  final String description;
  final String fullContent;
  final String category;
  final String author;
  final String date;
  final String imageUrl;
  final List<Comment> comments;

  Article({
    required this.title,
    required this.description,
    required this.fullContent,
    required this.category,
    required this.author,
    required this.date,
    required this.imageUrl,
    required this.comments,
  });
}

class Comment {
  final String author;
  final String content;
  final String date;
  int likes;

  Comment({
    required this.author,
    required this.content,
    required this.date,
    required this.likes,
  });
}