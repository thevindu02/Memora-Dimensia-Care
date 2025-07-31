import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class DiscussionForumScreen extends StatefulWidget {
  const DiscussionForumScreen({Key? key}) : super(key: key);

  @override
  State<DiscussionForumScreen> createState() => _DiscussionForumScreenState();
}

class _DiscussionForumScreenState extends State<DiscussionForumScreen> {
  final TextEditingController _questionController = TextEditingController();
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What are some effective ways to manage daily stress as a dementia caregiver?',
      'answers': [
        {'sender': 'Alice', 'answer': 'Try to keep a daily routine, it helps a lot.'},
        {'sender': 'Bob', 'answer': 'Patience is key. Take breaks when needed.'},
      ],
    },
    {
      'question': 'How do you handle sleep disturbances in dementia patients?',
      'answers': [
        {'sender': 'Carol', 'answer': 'Keep a consistent bedtime and avoid caffeine.'},
      ],
    },
  ];

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  void _addQuestion() {
    final text = _questionController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _questions.insert(0, {
          'question': text,
          'answers': [],
        });
        _questionController.clear();
      });
    }
  }

  void _showAnswers(BuildContext context, Map<String, dynamic> question) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final List answers = question['answers'] ?? [];
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Answers',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 12),
              if (answers.isEmpty)
                const Text('No answers yet.'),
              for (final answer in answers)
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.deepPurple),
                  title: Text(answer['answer'] ?? ''),
                  subtitle: Text('by ${answer['sender'] ?? 'Unknown'}'),
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  int _currentIndex = 0;

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
        title: const Text(
          'Discussion Forum',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.caregiverNotification);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.grey[100],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ask a Question (Anonymous)',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _questionController,
                            decoration: const InputDecoration(
                              hintText: 'Type your question...',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _addQuestion,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFA0C6FD),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                          child: const Icon(Icons.send, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Questions',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _questions.isEmpty
                  ? const Center(child: Text('No questions yet.'))
                  : ListView.separated(
                      itemCount: _questions.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final question = _questions[index];
                        return ListTile(
                          leading: const Icon(Icons.help_outline, color: Colors.deepPurple),
                          title: Text(question['question'] ?? ''),
                          subtitle: Text('Anonymous'),
                          onTap: () => _showAnswers(context, question),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 0) { // Patients tab
            // Navigate to detailed patients screen
            Navigator.pushNamed(context, AppRoutes.caregiverDashboard);
          }else if(index==3){
            Navigator.pushNamed(context, AppRoutes.caregiverProfile);
          }
          else if(index==2){
            Navigator.pushNamed(context, AppRoutes.viewArticleList);
          }
          else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF2B3F99),
        unselectedItemColor: Color(0xFF2B3F99),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Patients'),
          BottomNavigationBarItem(icon: Icon(Icons.article_outlined), label: 'Community'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}
