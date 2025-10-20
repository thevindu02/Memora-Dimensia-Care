import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Create or get conversation between guardian and caregiver
  Future<String> createOrGetConversation(String guardianId, String caregiverId) async {
    String conversationId = 'guardian_${guardianId}_caregiver_$caregiverId';
    
    DocumentSnapshot doc = await _firestore.collection('conversations').doc(conversationId).get();
    
    if (!doc.exists) {
      await _firestore.collection('conversations').doc(conversationId).set({
        'participantIds': [guardianId, caregiverId],
        'participantRoles': {'$guardianId': 'guardian', '$caregiverId': 'caregiver'},
        'createdAt': FieldValue.serverTimestamp(),
        'lastMessage': '',
        'lastMessageTimestamp': 0,
      });
    }
    
    return conversationId;
  }

  /// Send a message
  Future<void> sendMessage(String conversationId, String senderId, String senderRole, String text) async {
    await _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .add({
      'senderId': senderId,
      'senderRole': senderRole,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
      'read': false,
    });

    // Update last message
    await _firestore.collection('conversations').doc(conversationId).update({
      'lastMessage': text,
      'lastMessageTimestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// Stream messages in real-time
  Stream<QuerySnapshot> getMessagesStream(String conversationId) {
    return _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  /// Get user conversations
  Future<List<Map<String, dynamic>>> getUserConversations(String userId) async {
    QuerySnapshot snapshot = await _firestore
        .collection('conversations')
        .where('participantIds', arrayContains: userId)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['conversationId'] = doc.id;
      return data;
    }).toList();
  }
}