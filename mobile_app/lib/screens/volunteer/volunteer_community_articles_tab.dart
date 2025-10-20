import 'package:flutter/material.dart';
import '../volunteer/volunteer_single_article_screen.dart';
import '../../services/article_service.dart';

class VolunteerCommunityArticlesTab extends StatefulWidget {
  const VolunteerCommunityArticlesTab({Key? key}) : super(key: key);

  @override
  State<VolunteerCommunityArticlesTab> createState() =>
      _VolunteerCommunityArticlesTabState();
}

class _VolunteerCommunityArticlesTabState
    extends State<VolunteerCommunityArticlesTab> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Map<String, dynamic>> allArticles = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchAllPublishedArticles();
  }

  Future<void> fetchAllPublishedArticles() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      // Get ALL published articles from ALL volunteers
      final articles = await ArticleService.getPublishedArticles();

      print('========================================');
      print('🌍 FETCHED COMMUNITY ARTICLES');
      print('Total articles: ${articles.length}');
      if (articles.isNotEmpty) {
        print('First article: ${articles[0]}');
        print(
          'Article authors: ${articles.map((a) => a['authorName']).toSet().toList()}',
        );
        print(
          'Volunteer IDs: ${articles.map((a) => a['volunteerId']).toSet().toList()}',
        );
      }
      print('========================================');

      setState(() {
        allArticles = articles;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load articles. Please try again.';
        isLoading = false;
      });
      print('Error fetching articles: $e');
    }
  }

  List<Map<String, dynamic>> get filteredArticles {
    if (_searchQuery.isEmpty) {
      return allArticles;
    }
    return allArticles
        .where(
          (article) =>
              (article['title']?.toString() ?? '').toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              (article['summary']?.toString() ?? '').toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              (article['content']?.toString() ?? '').toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              (article['authorName']?.toString() ?? '').toLowerCase().contains(
                _searchQuery.toLowerCase(),
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
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search articles...',
              prefixIcon: Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          SizedBox(height: 16),

          // Articles List
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 48, color: Colors.red),
                        SizedBox(height: 16),
                        Text(
                          errorMessage!,
                          style: TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: fetchAllPublishedArticles,
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : filteredArticles.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.article_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty
                              ? 'No articles available yet'
                              : 'No articles found matching your search',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: fetchAllPublishedArticles,
                    child: ListView.builder(
                      itemCount: filteredArticles.length,
                      itemBuilder: (context, index) {
                        final article = filteredArticles[index];
                        return _buildArticleCard(article);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleCard(Map<String, dynamic> article) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VolunteerSingleArticleScreen(
                articleId: article['articleId'].toString(),
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category and Author Badge Row
              Row(
                children: [
                  // Category Badge
                  if (article['categoryName'] != null)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        article['categoryName'],
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  SizedBox(width: 8),
                  // Author Badge
                  if (article['authorName'] != null)
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              article['authorName'],
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              SizedBox(height: 12),

              // Image and Content Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Article Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      article['headerImageUrl'] ??
                          article['articleImg'] ??
                          'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=300&h=200&fit=crop',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey[600],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 12),

                  // Title and Summary Column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Article Title
                        Text(
                          article['title'] ?? 'Untitled',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8),

                        // Article Summary
                        if (article['summary'] != null &&
                            article['summary'].isNotEmpty)
                          Text(
                            article['summary'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                              height: 1.4,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),

              // Footer with likes and comments
              Row(
                children: [
                  Icon(Icons.favorite_border, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    '${article['likeCount'] ?? 0}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  SizedBox(width: 16),
                  Icon(Icons.comment_outlined, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    '${article['commentCount'] ?? 0}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
