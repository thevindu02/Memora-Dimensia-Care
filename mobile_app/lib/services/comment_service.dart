import 'package:cloud_firestore/cloud_firestore.dart';

class CommentService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionName = 'articles_comments';

  /// Add a new comment to an article
  static Future<Map<String, dynamic>> addComment({
    required String articleId,
    required int userId,
    required String userName,
    required String userType,
    required String content,
  }) async {
    try {
      print('=== Adding Comment ===');
      print('Article ID: $articleId');
      print('User: $userName ($userType)');
      print('Content: $content');

      final commentData = {
        'articleId': articleId,
        'userId': userId,
        'userName': userName,
        'userType': userType,
        'content': content,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isDeleted': false,
        'parentCommentId': null, // null for top-level comments
      };

      final docRef = await _firestore
          .collection(_collectionName)
          .add(commentData);

      print('Comment added successfully with ID: ${docRef.id}');

      return {
        'success': true,
        'message': 'Comment added successfully',
        'commentId': docRef.id,
      };
    } catch (e) {
      print('Error adding comment: $e');
      return {'success': false, 'message': 'Failed to add comment: $e'};
    }
  }

  /// Add a reply to an existing comment
  static Future<Map<String, dynamic>> addReply({
    required String articleId,
    required String parentCommentId,
    required int userId,
    required String userName,
    required String userType,
    required String content,
  }) async {
    try {
      print('=== Adding Reply ===');
      print('Article ID: $articleId');
      print('Parent Comment ID: $parentCommentId');
      print('User: $userName ($userType)');
      print('Content: $content');

      final replyData = {
        'articleId': articleId,
        'userId': userId,
        'userName': userName,
        'userType': userType,
        'content': content,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isDeleted': false,
        'parentCommentId': parentCommentId, // Set parent comment ID for replies
      };

      final docRef = await _firestore
          .collection(_collectionName)
          .add(replyData);

      print('Reply added successfully with ID: ${docRef.id}');

      return {
        'success': true,
        'message': 'Reply added successfully',
        'commentId': docRef.id,
      };
    } catch (e) {
      print('Error adding reply: $e');
      return {'success': false, 'message': 'Failed to add reply: $e'};
    }
  }

  /// Get all comments for an article (top-level only)
  static Stream<List<Map<String, dynamic>>> getCommentsStream(
    String articleId,
  ) {
    print('=== Subscribing to comments for article: $articleId ===');
    return _firestore
        .collection(_collectionName)
        .where('articleId', isEqualTo: articleId)
        .where('parentCommentId', isEqualTo: null) // Only top-level comments
        .where('isDeleted', isEqualTo: false)
        .orderBy('createdAt', descending: true) // Newest first
        .snapshots()
        .map((snapshot) {
          print('Received ${snapshot.docs.length} comments from Firestore');
          for (var doc in snapshot.docs) {
            print(
              'Comment ${doc.id}: parentCommentId = ${doc.data()['parentCommentId']}',
            );
          }
          return snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id; // Add document ID to data
            return data;
          }).toList();
        });
  }

  /// Get replies for a specific comment
  static Stream<List<Map<String, dynamic>>> getRepliesStream(String commentId) {
    print('=== Subscribing to replies for comment: $commentId ===');
    return _firestore
        .collection(_collectionName)
        .where('parentCommentId', isEqualTo: commentId)
        .where('isDeleted', isEqualTo: false)
        .orderBy('createdAt', descending: false) // Oldest first for replies
        .snapshots()
        .map((snapshot) {
          print('Received ${snapshot.docs.length} replies from Firestore');
          return snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id; // Add document ID to data
            return data;
          }).toList();
        });
  }

  /// Get comment count for an article (including replies)
  static Future<int> getCommentCount(String articleId) async {
    try {
      final snapshot = await _firestore
          .collection(_collectionName)
          .where('articleId', isEqualTo: articleId)
          .where('isDeleted', isEqualTo: false)
          .get();

      return snapshot.docs.length;
    } catch (e) {
      print('Error getting comment count: $e');
      return 0;
    }
  }

  /// Soft delete a comment
  static Future<Map<String, dynamic>> deleteComment(String commentId) async {
    try {
      await _firestore.collection(_collectionName).doc(commentId).update({
        'isDeleted': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return {'success': true, 'message': 'Comment deleted successfully'};
    } catch (e) {
      print('Error deleting comment: $e');
      return {'success': false, 'message': 'Failed to delete comment: $e'};
    }
  }

  /// Update a comment (edit)
  static Future<Map<String, dynamic>> updateComment({
    required String commentId,
    required String content,
  }) async {
    try {
      await _firestore.collection(_collectionName).doc(commentId).update({
        'content': content,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return {'success': true, 'message': 'Comment updated successfully'};
    } catch (e) {
      print('Error updating comment: $e');
      return {'success': false, 'message': 'Failed to update comment: $e'};
    }
  }

  /// Format timestamp for display
  static String formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'Just now';

    try {
      DateTime date;
      if (timestamp is Timestamp) {
        date = timestamp.toDate();
      } else if (timestamp is int) {
        date = DateTime.fromMillisecondsSinceEpoch(timestamp);
      } else {
        return 'Just now';
      }

      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return 'Just now';
    }
  }
}
