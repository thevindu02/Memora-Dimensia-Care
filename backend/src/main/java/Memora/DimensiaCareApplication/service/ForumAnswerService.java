package Memora.DimensiaCareApplication.service;

import Memora.DimensiaCareApplication.dto.request.CreateForumAnswerDTO;
import Memora.DimensiaCareApplication.dto.response.ForumAnswerDTO;
import Memora.DimensiaCareApplication.model.User;
import Memora.DimensiaCareApplication.repository.UserRepository;
import com.google.api.core.ApiFuture;
import com.google.cloud.Timestamp;
import com.google.cloud.firestore.*;
import com.google.firebase.cloud.FirestoreClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.concurrent.ExecutionException;

@Service
public class ForumAnswerService {

    private static final String ANSWERS_COLLECTION = "forum_answers";
    private static final String LIKES_COLLECTION = "forum_answer_likes";
    private static final String QUESTIONS_COLLECTION = "forum_questions";

    @Autowired
    private UserRepository userRepository;

    /**
     * Create a new answer to a question
     */
    public ForumAnswerDTO createAnswer(CreateForumAnswerDTO request) throws ExecutionException, InterruptedException {
        // Get userId directly from request (should come from authenticated session)
        Long userId = request.getUserId();
        
        if (userId == null) {
            throw new IllegalArgumentException("User ID is required");
        }
        
        // Validate user exists
        Optional<User> userOpt = userRepository.findById(userId);
        if (!userOpt.isPresent()) {
            throw new IllegalArgumentException("User not found");
        }

        User volunteer = userOpt.get();
        
        Firestore db = FirestoreClient.getFirestore();
        
        // Create a new document reference with auto-generated ID
        DocumentReference docRef = db.collection(ANSWERS_COLLECTION).document();
        String answerId = docRef.getId();
        
        // Prepare data - store userId from authenticated session
        Map<String, Object> data = new HashMap<>();
        data.put("answerId", answerId);
        data.put("questionId", request.getQuestionId());
        data.put("userId", userId); // Store userId from session
        data.put("content", request.getContent());
        data.put("likes", 0L);
        data.put("createdAt", Timestamp.now());
        data.put("updatedAt", Timestamp.now());
        
        // Save to Firestore
        ApiFuture<WriteResult> result = docRef.set(data);
        result.get(); // Wait for completion
        
        // Increment replies count in the question and mark as answered
        incrementQuestionReplies(request.getQuestionId());
        
        // Return the created answer with volunteer details
        ForumAnswerDTO answerDTO = new ForumAnswerDTO();
        answerDTO.setAnswerId(answerId);
        answerDTO.setQuestionId(request.getQuestionId());
        answerDTO.setVolunteerId(userId); // Return userId in volunteerId field for compatibility
        answerDTO.setVolunteerName(volunteer.getFName() + " " + volunteer.getLName());
        answerDTO.setVolunteerRole(getRoleDisplayName(volunteer.getRole()));
        answerDTO.setContent(request.getContent());
        answerDTO.setLikes(0L);
        answerDTO.setIsLikedByCurrentUser(false);
        answerDTO.setCreatedAt(Timestamp.now());
        answerDTO.setUpdatedAt(Timestamp.now());
        
        return answerDTO;
    }

    /**
     * Get all answers for a specific question
     */
    public List<ForumAnswerDTO> getAnswersByQuestionId(String questionId, Long currentUserId) throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        
        Query query = db.collection(ANSWERS_COLLECTION)
                .whereEqualTo("questionId", questionId);
        
        ApiFuture<QuerySnapshot> future = query.get();
        QuerySnapshot documents = future.get();
        
        List<ForumAnswerDTO> answers = new ArrayList<>();
        for (DocumentSnapshot document : documents) {
            if (document.exists()) {
                ForumAnswerDTO answer = documentToDTO(document, currentUserId);
                answers.add(answer);
            }
        }
        
        // Sort by createdAt descending (newest first)
        answers.sort((a, b) -> {
            if (b.getCreatedAt() == null) return -1;
            if (a.getCreatedAt() == null) return 1;
            return b.getCreatedAt().compareTo(a.getCreatedAt());
        });
        
        return answers;
    }

    /**
     * Like an answer
     */
    public boolean likeAnswer(String answerId, Long userId) throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        
        // Check if already liked
        Query query = db.collection(LIKES_COLLECTION)
                .whereEqualTo("answerId", answerId)
                .whereEqualTo("userId", userId);
        
        ApiFuture<QuerySnapshot> future = query.get();
        QuerySnapshot documents = future.get();
        
        if (!documents.isEmpty()) {
            // Already liked
            return false;
        }
        
        // Create like document
        DocumentReference likeRef = db.collection(LIKES_COLLECTION).document();
        Map<String, Object> likeData = new HashMap<>();
        likeData.put("likeId", likeRef.getId());
        likeData.put("answerId", answerId);
        likeData.put("userId", userId);
        likeData.put("createdAt", Timestamp.now());
        
        ApiFuture<WriteResult> likeResult = likeRef.set(likeData);
        likeResult.get();
        
        // Increment likes count in answer
        DocumentReference answerRef = db.collection(ANSWERS_COLLECTION).document(answerId);
        db.runTransaction(txn -> {
            DocumentSnapshot snapshot = txn.get(answerRef).get();
            Long currentLikes = snapshot.getLong("likes");
            if (currentLikes == null) {
                currentLikes = 0L;
            }
            txn.update(answerRef, "likes", currentLikes + 1);
            txn.update(answerRef, "updatedAt", Timestamp.now());
            return null;
        }).get();
        
        return true;
    }

    /**
     * Unlike an answer
     */
    public boolean unlikeAnswer(String answerId, Long userId) throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        
        // Find the like document
        Query query = db.collection(LIKES_COLLECTION)
                .whereEqualTo("answerId", answerId)
                .whereEqualTo("userId", userId);
        
        ApiFuture<QuerySnapshot> future = query.get();
        QuerySnapshot documents = future.get();
        
        if (documents.isEmpty()) {
            // Not liked
            return false;
        }
        
        // Delete the like document
        DocumentSnapshot likeDoc = documents.getDocuments().get(0);
        ApiFuture<WriteResult> deleteResult = likeDoc.getReference().delete();
        deleteResult.get();
        
        // Decrement likes count in answer
        DocumentReference answerRef = db.collection(ANSWERS_COLLECTION).document(answerId);
        db.runTransaction(txn -> {
            DocumentSnapshot snapshot = txn.get(answerRef).get();
            Long currentLikes = snapshot.getLong("likes");
            if (currentLikes == null || currentLikes <= 0) {
                currentLikes = 0L;
            } else {
                currentLikes--;
            }
            txn.update(answerRef, "likes", currentLikes);
            txn.update(answerRef, "updatedAt", Timestamp.now());
            return null;
        }).get();
        
        return true;
    }

    /**
     * Check if a user (guardian or volunteer) has liked a specific answer
     */
    private boolean hasLiked(String answerId, Long userId) throws ExecutionException, InterruptedException {
        if (userId == null) {
            return false;
        }
        
        Firestore db = FirestoreClient.getFirestore();
        Query query = db.collection(LIKES_COLLECTION)
                .whereEqualTo("answerId", answerId)
                .whereEqualTo("userId", userId);
        
        ApiFuture<QuerySnapshot> future = query.get();
        QuerySnapshot documents = future.get();
        
        return !documents.isEmpty();
    }

    /**
     * Increment replies count in question
     */
    private void incrementQuestionReplies(String questionId) {
        try {
            Firestore db = FirestoreClient.getFirestore();
            DocumentReference questionRef = db.collection(QUESTIONS_COLLECTION).document(questionId);
            
            db.runTransaction(txn -> {
                try {
                    DocumentSnapshot snapshot = txn.get(questionRef).get();
                    Long currentReplies = snapshot.getLong("replies");
                    if (currentReplies == null) {
                        currentReplies = 0L;
                    }
                    
                    System.out.println("Current replies for question " + questionId + ": " + currentReplies);
                    
                    txn.update(questionRef, "replies", currentReplies + 1);
                    txn.update(questionRef, "updatedAt", Timestamp.now());
                    
                    // Mark question as answered when first reply is added
                    if (currentReplies == 0) {
                        txn.update(questionRef, "isAnswered", true);
                        System.out.println("Marking question " + questionId + " as ANSWERED");
                    }
                } catch (Exception e) {
                    System.err.println("Error incrementing replies: " + e.getMessage());
                    e.printStackTrace();
                }
                return null;
            }).get();
            
            System.out.println("Successfully incremented replies for question: " + questionId);
        } catch (Exception e) {
            System.err.println("Error in incrementQuestionReplies: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Helper method to convert Firestore document to DTO
     */
    private ForumAnswerDTO documentToDTO(DocumentSnapshot document, Long currentUserId) throws ExecutionException, InterruptedException {
        ForumAnswerDTO dto = new ForumAnswerDTO();
        dto.setAnswerId(document.getId());
        dto.setQuestionId(document.getString("questionId"));
        
        // Handle userId (new field) or volunteerId (legacy field for backward compatibility)
        Object userIdObj = document.get("userId");
        if (userIdObj == null) {
            // Fallback to volunteerId for backward compatibility with old data
            userIdObj = document.get("volunteerId");
        }
        
        Long userId = null;
        if (userIdObj instanceof Long) {
            userId = (Long) userIdObj;
        } else if (userIdObj instanceof Integer) {
            userId = ((Integer) userIdObj).longValue();
        } else if (userIdObj instanceof String) {
            userId = Long.parseLong((String) userIdObj);
        }
        dto.setVolunteerId(userId); // Still using volunteerId field in DTO for compatibility
        
        // Fetch volunteer details from MySQL using userId
        if (userId != null) {
            Optional<User> volunteerOpt = userRepository.findById(userId);
            if (volunteerOpt.isPresent()) {
                User volunteer = volunteerOpt.get();
                dto.setVolunteerName(volunteer.getFName() + " " + volunteer.getLName());
                dto.setVolunteerRole(getRoleDisplayName(volunteer.getRole()));
            } else {
                dto.setVolunteerName("Unknown Volunteer");
                dto.setVolunteerRole("Volunteer");
            }
        }
        
        dto.setContent(document.getString("content"));
        dto.setLikes(document.getLong("likes"));
        dto.setCreatedAt(document.getTimestamp("createdAt"));
        dto.setUpdatedAt(document.getTimestamp("updatedAt"));
        
        // Check if current user has liked this answer
        dto.setIsLikedByCurrentUser(hasLiked(document.getId(), currentUserId));
        
        return dto;
    }

    /**
     * Get display name for user role
     */
    private String getRoleDisplayName(User.UserRole role) {
        if (role == null) return "Volunteer";
        
        switch (role) {
            case VOLUNTEER:
                return "Volunteer";
            case ADMIN:
                return "Medical Professional";
            case CAREGIVER:
                return "Healthcare Worker";
            default:
                return "Volunteer";
        }
    }
}
