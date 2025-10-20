import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../constants/color_constants.dart';
import '../../services/firebase_chat_service.dart';

class ChatConversationScreen extends StatefulWidget {
  @override
  _ChatConversationScreenState createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends State<ChatConversationScreen> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseChatService _chatService = FirebaseChatService();
  
  String? conversationId;
  String? currentUserId;
  String? currentUserRole;
  String partnerName = 'Chat';
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    if (_isInitialized) return;
    
    _isInitialized = true; // Mark as initialized immediately to prevent re-runs
    
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    
    final partnerId = args?['id']?.toString();
    partnerName = args?['name'] ?? 'Chat';
    currentUserRole = args?['currentUser'] ?? 'guardian';
    currentUserId = args?['currentUserId']?.toString();
    
    // Validate required parameters
    if (currentUserId == null || currentUserId!.isEmpty || partnerId == null || partnerId == 'unknown' || partnerId.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid chat parameters. Please try again.')),
        );
        Navigator.pop(context);
      });
      return;
    }
    
    // Generate conversation ID
    if (currentUserRole == 'guardian') {
      conversationId = 'guardian_${currentUserId}_caregiver_$partnerId';
    } else {
      conversationId = 'guardian_${partnerId}_caregiver_$currentUserId';
    }
    
    print('=== CHAT DEBUG ===');
    print('Current User Role: $currentUserRole');
    print('Current User ID: $currentUserId');
    print('Partner ID: $partnerId');
    print('Generated Conversation ID: $conversationId');
    print('==================');
    
    // Ensure conversation exists
    _chatService.createOrGetConversation(
      currentUserRole == 'guardian' ? currentUserId! : partnerId,
      currentUserRole == 'caregiver' ? currentUserId! : partnerId,
    );
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty || conversationId == null || currentUserId == null || currentUserRole == null) return;
    
    await _chatService.sendMessage(
      conversationId!,
      currentUserId!,
      currentUserRole!,
      text,
    );
    
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    // If not initialized properly, show loading or error screen
    if (!_isInitialized || conversationId == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Chat', style: TextStyle(color: AppColors.info)),
          backgroundColor: AppColors.surface,
          iconTheme: IconThemeData(color: AppColors.info),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text(partnerName, style: TextStyle(color: AppColors.info)),
        backgroundColor: AppColors.surface,
        iconTheme: IconThemeData(color: AppColors.info),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _chatService.getMessagesStream(conversationId!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No messages yet'));
                }
                
                final messages = snapshot.data!.docs;
                
                return ListView.builder(
                  padding: EdgeInsets.all(12),
                  itemCount: messages.length,
                  itemBuilder: (context, i) {
                    final msg = messages[i].data() as Map<String, dynamic>;
                    final isMe = msg['senderRole'] == currentUserRole;
                    final timestamp = (msg['timestamp'] as Timestamp?)?.toDate();
                    
                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 4),
                        padding: EdgeInsets.all(12),
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                        decoration: BoxDecoration(
                          color: isMe ? AppColors.primaryLight : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: isMe ? null : Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              msg['text'] ?? '',
                              style: TextStyle(
                                color: isMe ? AppColors.info : AppColors.onSurface,
                                fontSize: 15,
                              ),
                            ),
                            if (timestamp != null) ...[
                              SizedBox(height: 6),
                              Text(
                                '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}',
                                style: TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: AppColors.surface,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration.collapsed(
                      hintText: 'Type a message...',
                    ),
                    maxLines: null,
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    await _sendMessage(_controller.text.trim());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryLight,
                    foregroundColor: AppColors.info,
                  ),
                  child: Text('Send'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}