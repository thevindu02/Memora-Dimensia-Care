import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/chat_service.dart';
import '../../services/auth_service.dart';
import '../../services/guardian_service.dart';
import '../../routes/app_routes.dart';

class GuardianChatHistoryScreen extends StatefulWidget {
  const GuardianChatHistoryScreen({Key? key}) : super(key: key);

  @override
  State<GuardianChatHistoryScreen> createState() =>
      _GuardianChatHistoryScreenState();
}

class _GuardianChatHistoryScreenState extends State<GuardianChatHistoryScreen> {
  late Future<List<Map<String, dynamic>>> _conversationsFuture;
  int? _guardianId;

  @override
  void initState() {
    super.initState();
    _conversationsFuture = _loadConversations();
  }

  Future<int?> _resolveGuardianId() async {
    if (_guardianId != null) return _guardianId;

    // 1) Try SharedPreferences (most apps store guardianId there)
    try {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getInt('guardianId');
      if (id != null) {
        _guardianId = id;
        return id;
      }
    } catch (_) {}

    // 2) Fallback: get current user id from AuthService, then resolve guardian id via GuardianService
    try {
      final userId = await AuthService.getCurrentUserId(); // existing method
      if (userId != null) {
        final gid = await GuardianService.getGuardianIdByUserId(userId);
        if (gid != null) {
          _guardianId = gid;
          // persist for future
          try {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setInt('guardianId', gid);
          } catch (_) {}
          return gid;
        }
      }
    } catch (_) {}

    return null;
  }

  Future<List<Map<String, dynamic>>> _loadConversations() async {
    final gid = await _resolveGuardianId();
    if (gid == null) throw Exception('Guardian not logged in');
    return await ChatService.getConversationsForGuardian(gid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _conversationsFuture,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Failed to load messages: ${snap.error}'));
          }
          final conversations = snap.data ?? [];
          if (conversations.isEmpty) {
            return const Center(child: Text('No conversations yet'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: conversations.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final c = conversations[index];
              // normalize fields from backend
              final otherName = c['otherName'] ?? c['participantName'] ?? c['name'] ?? 'Contact';
              final otherId = c['otherId'] ?? c['participantId'] ?? c['user_id'];
              final lastMsg = (c['lastMessage'] ?? c['last_message'] ?? c['message'] ?? '').toString();
              final createdAt = c['lastMessageAt'] ?? c['last_message_at'] ?? c['updated_at'] ?? '';
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, color: Colors.grey[700]),
                ),
                title: Text(otherName.toString()),
                subtitle: Text(
                  lastMsg.isNotEmpty ? lastMsg : 'No messages yet',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  createdAt.toString(),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                onTap: () {
                  // Navigate to conversation screen with guardian context
                  Navigator.pushNamed(
                    context,
                    AppRoutes.chatConversation,
                    arguments: {
                      'id': otherId,
                      'name': otherName,
                      'currentUser': 'guardian',
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}