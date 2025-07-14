import 'package:flutter/material.dart';
import 'dart:async';
import 'volunteer_bottom_navigation_screen.dart';

class VolunteerForumScreen extends StatefulWidget {
  const VolunteerForumScreen({Key? key}) : super(key: key);

  @override
  State<VolunteerForumScreen> createState() => _VolunteerForumScreenState();
}

class _VolunteerForumScreenState extends State<VolunteerForumScreen> {
  final TextEditingController _searchController = TextEditingController();
  final PageController _pageController = PageController();
  Timer? _autoScrollTimer;
  int _currentPage = 0;

  final List<Map<String, dynamic>> _trendingTopics = [
    {
      'title': 'COMMUNITY\nMANAGEMENT',
      'color': Colors.orange[100],
      'textColor': Colors.orange[800],
      'id': 'community_management',
    },
    {
      'title': 'CONTENT\nSTRATEGY',
      'color': Colors.blue[100],
      'textColor': Colors.blue[800],
      'id': 'content_strategy',
    },
    {
      'title': 'VOLUNTEER\nTRAINING',
      'color': Colors.green[100],
      'textColor': Colors.green[800],
      'id': 'volunteer_training',
    },
    {
      'title': 'EVENT\nPLANNING',
      'color': Colors.purple[100],
      'textColor': Colors.purple[800],
      'id': 'event_planning',
    },
    {
      'title': 'SOCIAL\nIMPACT',
      'color': Colors.red[100],
      'textColor': Colors.red[800],
      'id': 'social_impact',
    },
  ];

  final List<Map<String, dynamic>> _discussions = [
    {
      'id': 'intro_1',
      'title': 'New Member Introductions',
      'subtitle': 'Welcome new members and introduce yourself to the community.',
      'type': 'discussion',
      'replies': 24,
      'lastActivity': '2 hours ago',
    },
    {
      'id': 'project_1',
      'title': 'Project Ideas',
      'subtitle': 'Share your project ideas and get feedback from the community.',
      'type': 'discussion',
      'replies': 15,
      'lastActivity': '5 hours ago',
    },
    {
      'id': 'feedback_1',
      'title': 'Feedback & Suggestions',
      'subtitle': 'Give us your feedback and suggestions for improvement.',
      'type': 'discussion',
      'replies': 8,
      'lastActivity': '1 day ago',
    },
    {
      'id': 'draft_1',
      'title': 'Environmental Conservation Draft',
      'subtitle': 'Draft article about local environmental initiatives.',
      'type': 'draft',
      'replies': 0,
      'lastActivity': 'Draft saved 3 hours ago',
    },
    {
      'id': 'draft_2',
      'title': 'Community Outreach Program',
      'subtitle': 'Planning document for upcoming outreach activities.',
      'type': 'draft',
      'replies': 0,
      'lastActivity': 'Draft saved yesterday',
    },
  ];

  List<Map<String, dynamic>> _filteredDiscussions = [];
  bool _isSearchActive = false;

  @override
  void initState() {
    super.initState();
    _filteredDiscussions = _discussions;
    _startAutoScroll();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pageController.dispose();
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        _currentPage = (_currentPage + 1) % _trendingTopics.length;
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _isSearchActive = query.isNotEmpty;
      if (query.isEmpty) {
        _filteredDiscussions = _discussions;
      } else {
        _filteredDiscussions = _discussions.where((discussion) {
          return discussion['title'].toLowerCase().contains(query.toLowerCase()) ||
                 discussion['subtitle'].toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _onTrendingTopicTapped(String topicId) {
    // This will be connected to backend later
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening topic: $topicId'),
        duration: Duration(seconds: 1),
      ),
    );
    
    // TODO: Navigate to topic-specific screen
    // Navigator.push(context, MaterialPageRoute(
    //   builder: (context) => TopicScreen(topicId: topicId),
    // ));
  }

  void _onDiscussionTapped(Map<String, dynamic> discussion) {
    // This will be connected to backend later
    String message = discussion['type'] == 'draft' 
        ? 'Opening draft: ${discussion['title']}'
        : 'Opening discussion: ${discussion['title']}';
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 1),
      ),
    );
    
    // TODO: Navigate to discussion/draft screen
    // if (discussion['type'] == 'draft') {
    //   Navigator.push(context, MaterialPageRoute(
    //     builder: (context) => DraftScreen(draftId: discussion['id']),
    //   ));
    // } else {
    //   Navigator.push(context, MaterialPageRoute(
    //     builder: (context) => DiscussionScreen(discussionId: discussion['id']),
    //   ));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Community Forum',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 16),
                
                // Active Search Bar
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(25),
                    border: _isSearchActive ? Border.all(color: Colors.blue, width: 2) : null,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search, 
                        color: _isSearchActive ? Colors.blue : Colors.grey[600], 
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: _onSearchChanged,
                          decoration: InputDecoration(
                            hintText: 'Search discussions...',
                            hintStyle: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                      if (_isSearchActive)
                        GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            _onSearchChanged('');
                          },
                          child: Icon(
                            Icons.close,
                            color: Colors.grey[600],
                            size: 20,
                          ),
                        ),
                    ],
                  ),
                ),
                
                SizedBox(height: 24),
                
                // Trending Topics Section
                Text(
                  'Trending Topics',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 16),
                
                // Auto-scrolling Horizontal Trending Topics
                Container(
                  height: 80,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: _trendingTopics.length,
                    itemBuilder: (context, index) {
                      final topic = _trendingTopics[index];
                      return Container(
                        margin: EdgeInsets.only(right: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _onTrendingTopicTapped(topic['id']),
                                child: Container(
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: topic['color'],
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        bottom: 8,
                                        left: 8,
                                        child: Text(
                                          topic['title'],
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: topic['textColor'],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          color: topic['textColor'],
                                          size: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            if (index < _trendingTopics.length - 1)
                              SizedBox(width: 12),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                
                // Page Indicator
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _trendingTopics.length,
                    (index) => Container(
                      width: 8,
                      height: 8,
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index ? Colors.blue : Colors.grey[300],
                      ),
                    ),
                  ),
                ),
                
                SizedBox(height: 24),
                
                // Section Header with Results Count
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _isSearchActive ? 'Search Results' : 'Recent Discussions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    if (_isSearchActive)
                      Text(
                        '${_filteredDiscussions.length} results',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 16),
                
                // Discussion List - Fixed height container to prevent overflow
                Container(
                  height: 400, // Fixed height to prevent overflow
                  child: _filteredDiscussions.isEmpty && _isSearchActive
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No discussions found',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                'Try adjusting your search terms',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: _filteredDiscussions.length,
                          itemBuilder: (context, index) {
                            final discussion = _filteredDiscussions[index];
                            return Column(
                              children: [
                                _buildDiscussionItem(discussion),
                                if (index < _filteredDiscussions.length - 1)
                                  SizedBox(height: 12),
                              ],
                            );
                          },
                        ),
                ),
                
                SizedBox(height: 20), // Bottom padding
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: VolunteerBottomNavigation(currentPage: 'forum'),
    );
  }

  Widget _buildDiscussionItem(Map<String, dynamic> discussion) {
    final bool isDraft = discussion['type'] == 'draft';
    
    return GestureDetector(
      onTap: () => _onDiscussionTapped(discussion),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            width: MediaQuery.of(context).size.width - 64, // Account for padding
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDraft ? Colors.orange[100] : Colors.blue[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isDraft ? Icons.insert_drive_file : Icons.chat_bubble_outline,
                    color: isDraft ? Colors.orange[800] : Colors.blue[800],
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              discussion['title'],
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          if (isDraft)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.orange[100],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'DRAFT',
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange[800],
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        discussion['subtitle'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          if (!isDraft) ...[
                            Icon(Icons.chat_bubble_outline, size: 12, color: Colors.grey[500]),
                            SizedBox(width: 4),
                            Text(
                              '${discussion['replies']} replies',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[500],
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.schedule, size: 12, color: Colors.grey[500]),
                            SizedBox(width: 4),
                          ],
                          Text(
                            discussion['lastActivity'],
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}