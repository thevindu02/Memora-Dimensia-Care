import { getFirestore, collection, addDoc, query, where, orderBy, onSnapshot, Timestamp, serverTimestamp } from 'firebase/firestore';
import { db } from '../config/firebase';

class CommentService {
  constructor() {
    this.collectionName = 'articles_comments';
  }

  /**
   * Add a new comment to an article
   * @param {Object} commentData - Comment data
   * @param {string} commentData.articleId - Article ID
   * @param {number} commentData.userId - User ID
   * @param {string} commentData.userName - User name
   * @param {string} commentData.userType - User type (Volunteer, Caregiver, etc.)
   * @param {string} commentData.content - Comment content
   * @param {string} commentData.parentCommentId - Parent comment ID for replies (optional)
   * @returns {Promise<Object>} Response with success status
   */
  async addComment({ articleId, userId, userName, userType, content, parentCommentId = null }) {
    try {
      if (!db) {
        throw new Error('Firebase not initialized');
      }

      console.log('Adding comment:', { articleId, userId, userName, userType, content, parentCommentId });

      const commentData = {
        articleId,
        userId,
        userName,
        userType,
        content,
        createdAt: serverTimestamp(),
        updatedAt: serverTimestamp(),
        isDeleted: false,
        parentCommentId: parentCommentId || null, // null for top-level comments, ID for replies
      };

      const docRef = await addDoc(collection(db, this.collectionName), commentData);

      console.log('Comment added successfully with ID:', docRef.id);

      return {
        success: true,
        message: parentCommentId ? 'Reply added successfully' : 'Comment added successfully',
        commentId: docRef.id,
      };
    } catch (error) {
      console.error('Error adding comment:', error);
      return {
        success: false,
        message: `Failed to add comment: ${error.message}`,
        error: error.message
      };
    }
  }

  /**
   * Get replies for a specific comment
   * @param {string} parentCommentId - Parent comment ID
   * @param {Function} callback - Callback function to receive replies
   * @returns {Function} Unsubscribe function
   */
  subscribeToReplies(parentCommentId, callback) {
    try {
      if (!db) {
        console.error('Firebase not initialized');
        callback([]);
        return () => {};
      }

      console.log('Subscribing to replies for comment:', parentCommentId);

      const q = query(
        collection(db, this.collectionName),
        where('parentCommentId', '==', parentCommentId),
        where('isDeleted', '==', false)
      );

      const unsubscribe = onSnapshot(q, 
        (snapshot) => {
          console.log('Received', snapshot.docs.length, 'replies from Firestore');
          const replies = snapshot.docs.map((doc) => ({
            id: doc.id,
            ...doc.data()
          }));
          
          // Sort replies by createdAt (oldest first for replies)
          replies.sort((a, b) => {
            const timeA = a.createdAt?.toMillis ? a.createdAt.toMillis() : 0;
            const timeB = b.createdAt?.toMillis ? b.createdAt.toMillis() : 0;
            return timeA - timeB; // Oldest first
          });
          
          callback(replies);
        },
        (error) => {
          console.error('Error subscribing to replies:', error);
          callback([]);
        }
      );

      return unsubscribe;
    } catch (error) {
      console.error('Error setting up reply subscription:', error);
      callback([]);
      return () => {};
    }
  }

  /**
   * Subscribe to comments for an article (real-time updates)
   * @param {string} articleId - Article ID
   * @param {Function} callback - Callback function to receive comments
   * @returns {Function} Unsubscribe function
   */
  subscribeToComments(articleId, callback) {
    try {
      if (!db) {
        console.error('Firebase not initialized');
        callback([]);
        return () => {};
      }

      console.log('Subscribing to comments for article:', articleId);

      // Simpler query - just filter by articleId and isDeleted
      const q = query(
        collection(db, this.collectionName),
        where('articleId', '==', articleId),
        where('isDeleted', '==', false)
      );

      const unsubscribe = onSnapshot(q, 
        (snapshot) => {
          console.log('Received', snapshot.docs.length, 'comments from Firestore');
          const comments = snapshot.docs.map((doc) => ({
            id: doc.id,
            ...doc.data()
          }));
          
          // Filter top-level comments and sort by createdAt on the client side
          const topLevelComments = comments.filter(c => !c.parentCommentId || c.parentCommentId === null);
          
          topLevelComments.sort((a, b) => {
            const timeA = a.createdAt?.toMillis ? a.createdAt.toMillis() : 0;
            const timeB = b.createdAt?.toMillis ? b.createdAt.toMillis() : 0;
            return timeB - timeA; // Newest first
          });
          
          console.log('Filtered top-level comments:', topLevelComments.length);
          callback(topLevelComments);
        },
        (error) => {
          console.error('Error subscribing to comments:', error);
          console.error('Error details:', error.message, error.code);
          callback([]);
        }
      );

      return unsubscribe;
    } catch (error) {
      console.error('Error setting up comment subscription:', error);
      callback([]);
      return () => {};
    }
  }

  /**
   * Get comment count for an article
   * @param {string} articleId - Article ID
   * @returns {Promise<number>} Comment count
   */
  async getCommentCount(articleId) {
    try {
      if (!db) {
        return 0;
      }

      const q = query(
        collection(db, this.collectionName),
        where('articleId', '==', articleId),
        where('isDeleted', '==', false)
      );

      // Note: This is a simplified version
      // For better performance, you might want to maintain a count in the article document
      return 0; // Placeholder - implement count logic as needed
    } catch (error) {
      console.error('Error getting comment count:', error);
      return 0;
    }
  }

  /**
   * Format timestamp for display
   * @param {any} timestamp - Firestore timestamp or Date
   * @returns {string} Formatted time string
   */
  formatTimestamp(timestamp) {
    if (!timestamp) return 'Just now';

    try {
      let date;
      if (timestamp && typeof timestamp.toDate === 'function') {
        // Firestore Timestamp
        date = timestamp.toDate();
      } else if (timestamp instanceof Date) {
        date = timestamp;
      } else if (typeof timestamp === 'number') {
        date = new Date(timestamp);
      } else {
        return 'Just now';
      }

      const now = new Date();
      const diffMs = now - date;
      const diffMins = Math.floor(diffMs / 60000);
      const diffHours = Math.floor(diffMs / 3600000);
      const diffDays = Math.floor(diffMs / 86400000);

      if (diffMins < 1) {
        return 'Just now';
      } else if (diffMins < 60) {
        return `${diffMins} ${diffMins === 1 ? 'minute' : 'minutes'} ago`;
      } else if (diffHours < 24) {
        return `${diffHours} ${diffHours === 1 ? 'hour' : 'hours'} ago`;
      } else if (diffDays < 7) {
        return `${diffDays} ${diffDays === 1 ? 'day' : 'days'} ago`;
      } else {
        return date.toLocaleDateString();
      }
    } catch (error) {
      console.error('Error formatting timestamp:', error);
      return 'Just now';
    }
  }
}

// Create and export a singleton instance
const commentService = new CommentService();
export default commentService;
