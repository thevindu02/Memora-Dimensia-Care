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

Understanding Dementia
Dementia is not a single disease but rather a term used to describe a group of symptoms that affect memory, thinking, and social abilities severely enough to interfere with daily life. The most common form is Alzheimer's disease, which accounts for 60-80% of all dementia cases.

Key symptoms include:
- Memory loss that disrupts daily life
- Challenges in planning or solving problems
- Difficulty completing familiar tasks
- Confusion with time or place
- Changes in mood and personality

Compassionate Care Strategies
1. Person-Centered Approach: Always remember that behind the diagnosis is a person with a unique history, preferences, and emotions. Take time to learn about their life story, interests, and what brings them comfort.

2. Communication Techniques:
- Speak slowly and clearly
- Use simple, concrete language
- Maintain eye contact
- Be patient and allow extra time for responses
- Validate their emotions, even if the facts are confused

3. Creating a Supportive Environment:
- Maintain familiar routines
- Reduce environmental stressors
- Ensure adequate lighting
- Remove potential hazards
- Create calm, comfortable spaces

4. Managing Behavioral Changes:
- Look for triggers that may cause agitation
- Redirect rather than correct
- Use distraction techniques
- Maintain your own calm demeanor
- Seek professional help when needed

Self-Care for Caregivers
Caring for someone with dementia can be emotionally and physically demanding. Remember that taking care of yourself is not selfish—it's essential for providing the best care possible.

- Take regular breaks
- Seek support from family, friends, or support groups
- Consider respite care services
- Practice stress-reduction techniques
- Don't hesitate to ask for help

Remember, every person with dementia is unique, and what works for one may not work for another. The key is to approach each situation with patience, understanding, and love. Your compassionate care makes a significant difference in their quality of life.''',
      category: 'Elderly Care',
      author: 'Sarah',
      date: '2025-06-21',
      imageUrl: 'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400',
      comments: [
        Comment(
          author: 'Anonymous User',
          content: 'This article really helped me understand my grandmother\'s condition better. Thank you for sharing.',
          date: '2025-06-22',
          likes: 12,
        ),
        Comment(
          author: 'Anonymous User',
          content: 'Very informative and well-written. The tips on communication are especially helpful.',
          date: '2025-06-21',
          likes: 8,
        ),
        Comment(
          author: 'Anonymous User',
          content: 'As a caregiver, I appreciate articles like this. It makes the journey less lonely.',
          date: '2025-06-21',
          likes: 15,
        ),
      ],
    ),
    Article(
      title: 'Managing Chronic Pain in Seniors',
      description: 'Chronic pain affects millions of older adults worldwide, impacting their quality of life...',
      fullContent: '''Chronic pain affects millions of older adults worldwide, impacting their quality of life and daily functioning. As we age, our bodies undergo various changes that can contribute to persistent pain conditions. Understanding how to effectively manage chronic pain in seniors is essential for maintaining independence and well-being.

Understanding Chronic Pain in Seniors
Chronic pain is defined as pain that persists for more than 3-6 months, often continuing beyond the expected healing time. In older adults, chronic pain can result from:

- Arthritis and joint degeneration
- Back problems and spinal conditions
- Previous injuries or surgeries
- Nerve damage (neuropathy)
- Chronic conditions like fibromyalgia
- Cancer-related pain

The Impact of Chronic Pain
Chronic pain in seniors can lead to:
- Reduced mobility and independence
- Sleep disturbances
- Depression and anxiety
- Social isolation
- Decreased quality of life
- Increased risk of falls

Comprehensive Pain Management Strategies

1. Medical Management:
- Regular consultations with healthcare providers
- Appropriate medication management
- Physical therapy and rehabilitation
- Minimally invasive procedures when appropriate

2. Non-Pharmacological Approaches:
- Heat and cold therapy
- Gentle exercise and stretching
- Massage therapy
- Acupuncture
- Mindfulness and relaxation techniques

3. Lifestyle Modifications:
- Maintaining a healthy weight
- Regular, appropriate exercise
- Proper nutrition
- Adequate sleep
- Stress management

4. Psychological Support:
- Counseling and therapy
- Support groups
- Cognitive-behavioral therapy
- Mindfulness-based stress reduction

Creating a Pain Management Plan
Work with healthcare providers to develop a comprehensive plan that includes:
- Clear pain assessment and monitoring
- Realistic goals and expectations
- Multiple treatment modalities
- Regular evaluation and adjustment
- Emergency protocols for severe pain episodes

The Role of Caregivers
Caregivers play a crucial role in supporting seniors with chronic pain:
- Advocate for appropriate pain management
- Help with daily activities and mobility
- Provide emotional support
- Monitor medication compliance
- Encourage participation in pain management strategies

Remember, chronic pain management is not about eliminating all pain but about improving function and quality of life. With the right approach, seniors can learn to manage their pain effectively and maintain their independence and dignity.''',
      category: 'Pain Management',
      author: 'Dr. Johnson',
      date: '2025-06-20',
      imageUrl: 'https://images.unsplash.com/photo-1576091160399-112ba8d25d1f?w=400',
      comments: [
        Comment(
          author: 'Anonymous User',
          content: 'Great insights on pain management. The holistic approach mentioned here is very effective.',
          date: '2025-06-20',
          likes: 6,
        ),
        Comment(
          author: 'Anonymous User',
          content: 'Thank you for addressing this important topic. More awareness is needed.',
          date: '2025-06-20',
          likes: 4,
        ),
      ],
    ),
    Article(
      title: 'Nutrition Guidelines for Elderly',
      description: 'Proper nutrition plays a crucial role in maintaining health and independence in older adults...',
      fullContent: '''Proper nutrition plays a crucial role in maintaining health and independence in older adults. As we age, our nutritional needs change, and it becomes increasingly important to focus on nutrient-dense foods that support overall health and well-being.

Age-Related Nutritional Changes
As we age, several factors can affect nutrition:
- Decreased appetite and sense of taste/smell
- Dental problems affecting chewing
- Reduced stomach acid production
- Slower metabolism
- Medication interactions
- Chronic health conditions
- Social and economic factors

Essential Nutrients for Seniors

1. Protein:
- Helps maintain muscle mass and strength
- Sources: lean meats, fish, eggs, dairy, legumes, nuts
- Aim for 1.0-1.2 grams per kilogram of body weight daily

2. Calcium and Vitamin D:
- Essential for bone health
- Sources: dairy products, fortified foods, leafy greens
- Consider supplements if dietary intake is insufficient

3. Vitamin B12:
- Important for nerve function and red blood cell formation
- Sources: meat, fish, dairy, fortified cereals
- Absorption decreases with age, supplements may be needed

4. Fiber:
- Supports digestive health
- Sources: fruits, vegetables, whole grains, legumes
- Aim for 21-30 grams daily

5. Healthy Fats:
- Support brain and heart health
- Sources: olive oil, nuts, seeds, fatty fish
- Focus on omega-3 fatty acids

Meal Planning Strategies

1. Plan Balanced Meals:
- Include protein, healthy fats, and complex carbohydrates
- Aim for colorful plates with variety
- Consider smaller, more frequent meals

2. Hydration:
- Drink plenty of water throughout the day
- Monitor urine color as a hydration indicator
- Include hydrating foods like soups and fruits

3. Food Safety:
- Practice proper food handling and storage
- Check expiration dates regularly
- Be aware of foodborne illness risks

4. Budget-Friendly Options:
- Buy seasonal produce
- Use frozen fruits and vegetables
- Consider generic brands
- Plan meals around sales and coupons

Addressing Common Challenges

1. Decreased Appetite:
- Eat smaller, more frequent meals
- Use herbs and spices to enhance flavor
- Make meals social when possible
- Consider nutritional supplements if needed

2. Dental Issues:
- Choose softer foods that are easier to chew
- Cut food into smaller pieces
- Consider smoothies and soups
- Maintain good oral hygiene

3. Limited Mobility:
- Utilize grocery delivery services
- Ask family/friends for help with shopping
- Keep non-perishable nutritious foods on hand
- Consider meal delivery services

4. Medication Interactions:
- Consult healthcare providers about food-drug interactions
- Take medications as directed in relation to meals
- Monitor for side effects that affect appetite

Creating a Sustainable Nutrition Plan
- Work with healthcare providers and dietitians
- Set realistic goals
- Make gradual changes
- Focus on foods you enjoy
- Stay flexible and adjust as needed

Remember, good nutrition is an investment in your health and independence. Small, consistent changes can lead to significant improvements in overall well-being and quality of life.''',
      category: 'Nutrition',
      author: 'Emily',
      date: '2025-06-19',
      imageUrl: 'https://images.unsplash.com/photo-1505576399279-565b52d4ac71?w=400',
      comments: [
        Comment(
          author: 'Anonymous User',
          content: 'The meal planning tips are practical and easy to follow. Shared with my elderly parents.',
          date: '2025-06-19',
          likes: 9,
        ),
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
            icon: Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {},
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
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Container(
              height: 180,
              width: double.infinity,
              color: Colors.grey[200],
              child: const Icon(
                Icons.image,
                size: 50,
                color: Colors.grey,
              ),
            ),
          ),

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
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
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

// New Article Detail Page
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
            // Article Image
            Container(
              height: 250,
              width: double.infinity,
              color: Colors.grey[200],
              child: const Icon(
                Icons.image,
                size: 80,
                color: Colors.grey,
              ),
            ),

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