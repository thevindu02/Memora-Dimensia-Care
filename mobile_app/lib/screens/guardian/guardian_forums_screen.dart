import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class GuardianForumsScreen extends StatefulWidget {
  @override
  _GuardianForumsScreenState createState() => _GuardianForumsScreenState();
}

class _GuardianForumsScreenState extends State<GuardianForumsScreen> {
  int _selectedIndex = 1; // Forums tab is selected
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Mock data for forum discussions
  List<Map<String, dynamic>> allDiscussions = [
    {
      'id': 1,
      'title': 'Understanding Dementia',
      'description': 'Discussion on symptoms and care',
      'category': 'Caregiver Tips',
      'author': 'Dr. Sarah Johnson',
      'authorType': 'Volunteer',
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
      'author': 'Maria Rodriguez',
      'authorType': 'Volunteer',
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
      'author': 'Tech Support Team',
      'authorType': 'Volunteer',
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
      'author': 'Pharmacist John',
      'authorType': 'Volunteer',
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
      'author': 'Activity Coordinator',
      'authorType': 'Volunteer',
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
      'author': 'Nutritionist Emma',
      'authorType': 'Volunteer',
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
    return GestureDetector(
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
    );
  }

  Widget _buildDiscussionCard(Map<String, dynamic> discussion) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.guardianForumArticle,
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
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              discussion['authorType'],
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.green[700],
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
    );
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
      // Small delay to show the visual feedback before navigation
        Future.delayed(Duration(milliseconds: 100), () {
          Navigator.pushNamedAndRemoveUntil(context, AppRoutes.guardianDashboard, (route) => false);
        });
        break;
      case 1:
      // Already on Forums - clear search if any
        _clearSearch();
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.guardianProfile);
        break;
    }
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
        // When going back to dashboard, make sure home icon is selected
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.guardianDashboard,
              (route) => false,
          arguments: {'selectedIndex': 0}, // Pass the home index
        );
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
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            _searchQuery.isNotEmpty ? 'Search: $_searchQuery' : 'Community Forum',
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
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onBottomNavTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFF2B3F99),
          unselectedItemColor: Colors.grey[600],
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.forum),
              label: 'Forums',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}