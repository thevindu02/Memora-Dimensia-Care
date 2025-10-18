import 'package:flutter/material.dart';
import '../../constants/color_constants.dart';
import '../../models/chat_message.dart';
import '../../services/chat_db.dart';

class ChatConversationScreen extends StatefulWidget {
  @override
  _ChatConversationScreenState createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends State<ChatConversationScreen> {
  List<ChatMessage> messages = [];
  final TextEditingController _controller = TextEditingController();
  late String conversationId;
  String currentUserRole = 'guardian';
  final _db = ChatDb();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final partner = args;
    final partnerId = args?['id']?.toString() ?? 'unknown';
    final partnerName = args?['name'] ?? 'Chat';
    currentUserRole = args?['currentUser'] ?? 'guardian';
    // define conversation id; when launching from caregiver side set currentUser accordingly
    final myRole = currentUserRole;
    conversationId = '${myRole}_with_$partnerId'; // simple unique id per pair+role-origin
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final loaded = await _db.getMessages(conversationId);
    setState(() {
      messages = loaded;
    });
  }

  Future<void> _sendMessage(String text) async {
    final msg = ChatMessage(sender: currentUserRole, text: text, timestamp: DateTime.now());
    await _db.saveMessage(conversationId, msg);
    setState(() {
      messages.add(msg);
    });
    // later: send to backend or websocket
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final partnerName = args?['name'] ?? 'Chat';
    return Scaffold(
      appBar: AppBar(title: Text(partnerName, style: TextStyle(color: AppColors.info))),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, i) {
                final m = messages[i];
                final isMe = m.sender == currentUserRole;
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe ? AppColors.primaryLight : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(m.text, style: TextStyle(color: isMe ? AppColors.info : AppColors.onSurface)),
                        SizedBox(height: 6),
                        Text(
                          '${m.timestamp.hour.toString().padLeft(2,'0')}:${m.timestamp.minute.toString().padLeft(2,'0')}',
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
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
                    decoration: InputDecoration.collapsed(hintText: 'Type a message...'),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    final text = _controller.text.trim();
                    if (text.isEmpty) return;
                    await _sendMessage(text);
                    _controller.clear();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryLight, foregroundColor: AppColors.info),
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