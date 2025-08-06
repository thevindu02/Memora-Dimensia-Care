import 'package:flutter/material.dart';
import '../volunteer/volunteer_single_article_screen.dart';

class VolunteerArticlesTabBody extends StatefulWidget {
  const VolunteerArticlesTabBody({Key? key}) : super(key: key);

  @override
  State<VolunteerArticlesTabBody> createState() =>
      _VolunteerArticlesTabBodyState();
}

class _VolunteerArticlesTabBodyState extends State<VolunteerArticlesTabBody> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Mock data for articles
  List<Map<String, dynamic>> allArticles = [
    {
      'id': 1,
      'title': 'Understanding Dementia: A Comprehensive Guide',
      'description':
          'Learn about the different types of dementia, early warning signs, and how to provide effective care.',
      'category': 'Caregiver Tips',
      'author': 'Dr. Sarah Johnson',
      'authorType': 'Volunteer',
      'imageUrl':
          'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=300&h=200&fit=crop',
      'comments': 15,
      'likes': 24,
      'content':
          'Dementia is a complex condition that affects millions of people worldwide. Understanding its symptoms and progression is crucial for providing effective care. This comprehensive guide covers the basics of dementia, including early warning signs, different types, and practical tips for caregivers.',
      'tags': ['dementia', 'symptoms', 'care', 'understanding'],
      'publishDate': '2024-01-15',
      'readTime': '5 min read',
    },
    {
      'id': 2,
      'title': 'Caregiver Support: Building a Strong Foundation',
      'description':
          'Essential strategies for maintaining your well-being while caring for loved ones with dementia.',
      'category': 'Caregiver Tips',
      'author': 'Maria Rodriguez',
      'authorType': 'Volunteer',
      'imageUrl':
          'https://images.unsplash.com/photo-1582750433449-648ed127bb54?w=300&h=200&fit=crop',
      'comments': 8,
      'likes': 18,
      'content':
          'Being a caregiver can be emotionally and physically demanding. This article provides essential strategies for maintaining your well-being while providing the best care for your loved ones.',
      'tags': ['support', 'caregiver', 'well-being', 'self-care'],
      'publishDate': '2024-01-12',
      'readTime': '4 min read',
    },
    {
      'id': 3,
      'title': 'Technology in Dementia Care: Modern Solutions',
      'description':
          'Discover how modern technology can assist in dementia care and improve quality of life.',
      'category': 'Technology',
      'author': 'Tech Support Team',
      'authorType': 'Volunteer',
      'imageUrl': 'https://picsum.photos/300/200?random=3',
      'comments': 12,
      'likes': 31,
      'content':
          'Modern technology offers many tools to assist in dementia care. From medication reminders to GPS tracking, learn about the latest apps and devices that can make caregiving easier and more effective.',
      'tags': ['technology', 'apps', 'care', 'tools', 'assistance'],
      'publishDate': '2024-01-10',
      'readTime': '6 min read',
    },
    {
      'id': 4,
      'title': 'Medication Management: A Complete Guide',
      'description':
          'Learn how to organize and manage medications effectively for dementia patients.',
      'category': 'Medication',
      'author': 'Pharmacist John',
      'authorType': 'Volunteer',
      'imageUrl':
          'https://images.unsplash.com/photo-1471864190281-a93a3070b6de?w=300&h=200&fit=crop',
      'comments': 22,
      'likes': 45,
      'content':
          'Proper medication management is crucial for dementia patients. This guide covers organizing pills, setting reminders, understanding side effects, and working with healthcare providers.',
      'tags': ['medication', 'management', 'pills', 'reminders', 'healthcare'],
      'publishDate': '2024-01-08',
      'readTime': '7 min read',
    },
    {
      'id': 5,
      'title': 'Daily Activities for Dementia Patients',
      'description':
          'Engaging activities and routines that improve quality of life.',
      'category': 'Activities',
      'author': 'Activity Coordinator',
      'authorType': 'Volunteer',
      'imageUrl':
          'https://images.unsplash.com/photo-1511632765486-a01980e01a18?w=300&h=200&fit=crop',
      'comments': 18,
      'likes': 33,
      'content':
          'Keeping dementia patients engaged with meaningful activities can improve their quality of life. Explore various activities, games, and routines that work well for different stages of dementia.',
      'tags': [
        'activities',
        'daily',
        'engagement',
        'routines',
        'quality of life',
      ],
      'publishDate': '2024-01-05',
      'readTime': '5 min read',
    },
    {
      'id': 6,
      'title': 'Nutrition and Dementia: Dietary Guidelines',
      'description':
          'Essential dietary considerations for dementia patients and their caregivers.',
      'category': 'Nutrition',
      'author': 'Nutritionist Lisa',
      'authorType': 'Volunteer',
      'imageUrl':
          'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=300&h=200&fit=crop',
      'comments': 14,
      'likes': 29,
      'content':
          'Proper nutrition plays a vital role in managing dementia symptoms. Learn about dietary considerations, meal planning strategies, and foods that may help or harm cognitive function.',
      'tags': ['nutrition', 'diet', 'meal planning', 'cognitive health'],
      'publishDate': '2024-01-03',
      'readTime': '4 min read',
    },
  ];

  List<Map<String, dynamic>> get filteredArticles {
    if (_searchQuery.isEmpty) {
      return allArticles;
    }
    return allArticles
        .where(
          (article) =>
              article['title'].toString().toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              article['description'].toString().toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              article['tags'].any(
                (tag) => tag.toString().toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ),
              ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Search Bar
          Container(
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
                hintText: 'Search articles...',
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          // Articles List
          Expanded(
            child: ListView.builder(
              itemCount: filteredArticles.length,
              itemBuilder: (context, index) {
                final article = filteredArticles[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 16),
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
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VolunteerSingleArticleScreen(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  article['imageUrl'],
                                  width: 80,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 80,
                                      height: 60,
                                      color: Colors.grey[300],
                                      child: Icon(
                                        Icons.image,
                                        color: Colors.grey[600],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      article['title'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      article['description'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  article['category'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.person,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              SizedBox(width: 4),
                              Text(
                                article['author'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              SizedBox(width: 4),
                              Text(
                                '${article['comments']}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(width: 16),
                              Icon(
                                Icons.favorite_border,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              SizedBox(width: 4),
                              Text(
                                '${article['likes']}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.access_time,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              SizedBox(width: 4),
                              Text(
                                article['readTime'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
