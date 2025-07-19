import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import 'guardian_bottom_nav_bar.dart';

class GuardianArticlesScreen extends StatefulWidget {
  @override
  _GuardianForumsScreenState createState() => _GuardianForumsScreenState();
}

class _GuardianForumsScreenState extends State<GuardianArticlesScreen> {
  int _selectedIndex = 1; // Articles tab is selected (index 1 based on your new nav structure)
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Mock data for forum discussions
  List<Map<String, dynamic>> allDiscussions = [
    {
      'id': 1,
      'title': 'Understanding Dementia',
      'description': 'Discussion on symptoms and care',
      'category': 'Caregiver Tips',
      'author': 'Anonymous Guardian', // Changed to anonymous
      'authorType': 'Guardian',
      'imageUrl': 'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=300&h=200&fit=crop',
      'comments': 15,
      'likes': 24,
      'content': 'Dementia is a complex condition that affects millions of people worldwide. Understanding its symptoms and progression is crucial for providing effective care. This discussion covers the basics of dementia, including early warning signs, different types, and practical tips for caregivers.',
      'tags': ['dementia', 'symptoms', 'care', 'understanding'],
    },
    {
      'id': 2,
      'title': 'Caregiver Support',
      'description': 'Share your experiences',
      'category': 'Caregiver Tips',
      'author': 'Anonymous Guardian', // Changed to anonymous
      'authorType': 'Guardian',
      'imageUrl': 'https://images.unsplash.com/photo-1582750433449-648ed127bb54?w=300&h=200&fit=crop',
      'comments': 8,
      'likes': 18,
      'content': 'Being a caregiver can be emotionally and physically demanding. This space is for sharing experiences, challenges, and solutions. Together, we can support each other through this journey.',
      'tags': ['support', 'caregiver', 'experiences', 'community'],
    },
    {
      'id': 3,
      'title': 'Technology in Care',
      'description': 'Using apps to assist care',
      'category': 'Technology',
      'author': 'Anonymous Guardian', // Changed to anonymous
      'authorType': 'Guardian',
      'imageUrl': 'https://picsum.photos/300/200?random=3',
      'comments': 12,
      'likes': 31,
      'content': 'Modern technology offers many tools to assist in dementia care. From medication reminders to GPS tracking, learn about the latest apps and devices that can make caregiving easier and more effective.',
      'tags': ['technology', 'apps', 'care', 'tools', 'assistance'],
    },
    {
      'id': 4,
      'title': 'Medication Management',
      'description': 'How to organize medications',
      'category': 'Medication',
      'author': 'Anonymous Guardian', // Changed to anonymous
      'authorType': 'Guardian',
      'imageUrl': 'https://images.unsplash.com/photo-1471864190281-a93a3070b6de?w=300&h=200&fit=crop',
      'comments': 22,
      'likes': 45,
      'content': 'Proper medication management is crucial for dementia patients. This guide covers organizing pills, setting reminders, understanding side effects, and working with healthcare providers.',
      'tags': ['medication', 'management', 'pills', 'reminders', 'healthcare'],
    },
    {
      'id': 5,
      'title': 'Daily Activities for Dementia Patients',
      'description': 'Engaging activities and routines',
      'category': 'Activities',
      'author': 'Anonymous Guardian', // Changed to anonymous
      'authorType': 'Guardian',
      'imageUrl': 'https://images.unsplash.com/photo-1511632765486-a01980e01a18?w=300&h=200&fit=crop',
      'comments': 18,
      'likes': 33,
      'content': 'Keeping dementia patients engaged with meaningful activities can improve their quality of life. Explore various activities, games, and routines that work well for different stages of dementia.',
      'tags': ['activities', 'daily', 'engagement', 'routines', 'quality of life'],
    },
    {
      'id': 6,
      'title': 'Nutrition and Dementia',
      'description': 'Dietary considerations and tips',
      'category': 'Health',
      'author': 'Anonymous Guardian', // Changed to anonymous
      'authorType': 'Guardian',
      'imageUrl': 'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=300&h=200&fit=crop',
      'comments': 14,
      'likes': 28,
      'content': 'Proper nutrition plays a vital role in dementia care. Learn about dietary requirements, meal planning, and strategies to encourage eating in dementia patients.',
      'tags': ['nutrition', 'diet', 'health', 'meals', 'eating'],
    },
  ];

  List<Map<String, dynamic>> get filteredDiscussions {
    if (_searchQuery.isEmpty) {
      return allDiscussions;
    }
    return allDiscussions.where((discussion) {
      final title = discussion['title'].toString().toLowerCase();
      final description = discussion['description'].toString().toLowerCase();
      final category = discussion['category'].toString().toLowerCase();
      final tags = discussion['tags'] as List<String>;
      final query = _searchQuery.toLowerCase();

      return title.contains(query) ||
          description.contains(query) ||
          category.contains(query) ||
          tags.any((tag) => tag.toLowerCase().contains(query));
    }).toList();
  }

  List<String> get popularTopics {
    return ['Caregiver Tips', 'Medication', 'Technology', 'Health', 'Activities'];
  }

  // Method to clear search and return to main forums view
  void _clearSearch() {
    setState(() {
      _searchQuery = '';
      _searchController.clear();
    });
  }

  // Method to navigate back to dashboard
  void _navigateBackToDashboard() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.guardianDashboard,
          (route) => false,
      arguments: {'selectedIndex': 0}, // Pass the home index
    );
  }

  Widget _buildSearchBar() {
    return Container(
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
          hintText: 'Search discussions',
          hintStyle: TextStyle(color: Colors.grey[500]),
          prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
            icon: Icon(Icons.clear, color: Colors.grey[500]),
            onPressed: _clearSearch,
          )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildPopularTopics() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Popular Topics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: popularTopics.length,
              itemBuilder: (context, index) {
                final topic = popularTopics[index];
                final relatedDiscussion = allDiscussions.firstWhere(
                      (d) => d['category'] == topic,
                  orElse: () => allDiscussions[0],
                );
                return _buildTopicCard(topic, relatedDiscussion);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicCard(String topic, Map<String, dynamic> discussion) {
    return MouseRegion(
      cursor: SystemMouseCursors.click, // Add proper cursor
      child: GestureDetector(
        onTap: () {
          setState(() {
            _searchQuery = topic;
            _searchController.text = topic;
          });
        },
        child: Container(
          width: 160,
          margin: EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: NetworkImage(discussion['imageUrl']),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topic,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  discussion['description'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDiscussionCard(Map<String, dynamic> discussion) {
    return MouseRegion(
      cursor: SystemMouseCursors.click, // Add proper cursor
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.guardianArticleDetail,
            arguments: discussion,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      discussion['imageUrl'],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          discussion['title'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          discussion['description'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.person, size: 14, color: Colors.grey[500]),
                            SizedBox(width: 4),
                            Text(
                              discussion['author'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: discussion['authorType'] == 'Guardian'
                                    ? Colors.blue[100]
                                    : Colors.green[100],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                discussion['authorType'],
                                style: TextStyle(
                                  fontSize: 10,
                                  color: discussion['authorType'] == 'Guardian'
                                      ? Colors.blue[700]
                                      : Colors.green[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.chat_bubble_outline, size: 16, color: Colors.grey[500]),
                  SizedBox(width: 4),
                  Text(
                    '${discussion['comments']} comments',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                  SizedBox(width: 16),
                  Icon(Icons.thumb_up_outlined, size: 16, color: Colors.grey[500]),
                  SizedBox(width: 4),
                  Text(
                    '${discussion['likes']} likes',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onBottomNavTap(int index) {
    // Update the selected index for visual feedback
    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation using the helper class
    BottomNavHelper.handleNavigation(context, index);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // If we're in search mode, clear search instead of popping
        if (_searchQuery.isNotEmpty) {
          _clearSearch();
          return false; // Don't pop the route
        }
        // Navigate back to dashboard
        _navigateBackToDashboard();
        return false; // We're handling the navigation ourselves
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: _searchQuery.isNotEmpty
              ? IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: _clearSearch,
          )
              : IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: _navigateBackToDashboard,
          ),
          title: Text(
            _searchQuery.isNotEmpty ? 'Search: $_searchQuery' : 'Articles',
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
            _buildSearchBar(),
            if (_searchQuery.isEmpty) ...[
              _buildPopularTopics(),
              SizedBox(height: 24),
            ],
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    _searchQuery.isEmpty ? 'Recent Discussions' : 'Search Results',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  if (_searchQuery.isNotEmpty) ...[
                    Spacer(),
                    Text(
                      '${filteredDiscussions.length} results',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: filteredDiscussions.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 64,
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
                    SizedBox(height: 8),
                    Text(
                      'Try different keywords',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                itemCount: filteredDiscussions.length,
                itemBuilder: (context, index) {
                  return _buildDiscussionCard(filteredDiscussions[index]);
                },
              ),
            ),
          ],
        ),
        // Replace the old BottomNavigationBar with your CustomBottomNavigationBar
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onBottomNavTap,
        ),
      ),
    );
  }
}