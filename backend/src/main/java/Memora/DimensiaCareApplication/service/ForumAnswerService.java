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
        // Validate volunteer exists
        Optional<User> volunteerOpt = userRepository.findById(request.getVolunteerId());
        if (!volunteerOpt.isPresent()) {
            throw new IllegalArgumentException("Volunteer not found");
        }

        User volunteer = volunteerOpt.get();
        
        // Validate that the user is actually a volunteer (you may need to add role checking)
        // For now, we'll assume anyone in the users table can be a volunteer
        
        Firestore db = FirestoreClient.getFirestore();
        
        // Create a new document reference with auto-generated ID
        DocumentReference docRef = db.collection(ANSWERS_COLLECTION).document();
        String answerId = docRef.getId();
        
        // Prepare data
        Map<String, Object> data = new HashMap<>();
        data.put("answerId", answerId);
        data.put("questionId", request.getQuestionId());
        data.put("volunteerId", request.getVolunteerId());
        data.put("content", request.getContent());
        data.put("likes", 0L);
        data.put("createdAt", Timestamp.now());
        data.put("updatedAt", Timestamp.now());
        
        // Save to Firestore
        ApiFuture<WriteResult> result = docRef.set(data);
        result.get(); // Wait for completion
        
        // Increment replies count in the question
        incrementQuestionReplies(request.getQuestionId());
        
        // Return the created answer with volunteer details
        ForumAnswerDTO answerDTO = new ForumAnswerDTO();
        answerDTO.setAnswerId(answerId);
        answerDTO.setQuestionId(request.getQuestionId());
        answerDTO.setVolunteerId(request.getVolunteerId());
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
    public List<ForumAnswerDTO> getAnswersByQuestionId(String questionId, Long currentGuardianId) throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        
        Query query = db.collection(ANSWERS_COLLECTION)
                .whereEqualTo("questionId", questionId);
        
        ApiFuture<QuerySnapshot> future = query.get();
        QuerySnapshot documents = future.get();
        
        List<ForumAnswerDTO> answers = new ArrayList<>();
        for (DocumentSnapshot document : documents) {
            if (document.exists()) {
                ForumAnswerDTO answer = documentToDTO(document, currentGuardianId);
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
    public boolean likeAnswer(String answerId, Long guardianId) throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        
        // Check if already liked
        Query query = db.collection(LIKES_COLLECTION)
                .whereEqualTo("answerId", answerId)
                .whereEqualTo("guardianId", guardianId);
        
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
        likeData.put("guardianId", guardianId);
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
    public boolean unlikeAnswer(String answerId, Long guardianId) throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        
        // Find the like document
        Query query = db.collection(LIKES_COLLECTION)
                .whereEqualTo("answerId", answerId)
                .whereEqualTo("guardianId", guardianId);
        
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
     * Check if a guardian has liked a specific answer
     */
    private boolean hasLiked(String answerId, Long guardianId) throws ExecutionException, InterruptedException {
        if (guardianId == null) {
            return false;
        }
        
        Firestore db = FirestoreClient.getFirestore();
        Query query = db.collection(LIKES_COLLECTION)
                .whereEqualTo("answerId", answerId)
                .whereEqualTo("guardianId", guardianId);
        
        ApiFuture<QuerySnapshot> future = query.get();
        QuerySnapshot documents = future.get();
        
        return !documents.isEmpty();
    }

    /**
     * Increment replies count in question
     */
    private void incrementQuestionReplies(String questionId) {
        Firestore db = FirestoreClient.getFirestore();
        DocumentReference questionRef = db.collection(QUESTIONS_COLLECTION).document(questionId);
        
        db.runTransaction(txn -> {
            try {
                DocumentSnapshot snapshot = txn.get(questionRef).get();
                Long currentReplies = snapshot.getLong("replies");
                if (currentReplies == null) {
                    currentReplies = 0L;
                }
                txn.update(questionRef, "replies", currentReplies + 1);
                txn.update(questionRef, "updatedAt", Timestamp.now());
            } catch (Exception e) {
                System.err.println("Error incrementing replies: " + e.getMessage());
            }
            return null;
        });
    }

    /**
     * Helper method to convert Firestore document to DTO
     */
    private ForumAnswerDTO documentToDTO(DocumentSnapshot document, Long currentGuardianId) throws ExecutionException, InterruptedException {
        ForumAnswerDTO dto = new ForumAnswerDTO();
        dto.setAnswerId(document.getId());
        dto.setQuestionId(document.getString("questionId"));
        
        // Handle volunteerId
        Object volunteerIdObj = document.get("volunteerId");
        Long volunteerId = null;
        if (volunteerIdObj instanceof Long) {
            volunteerId = (Long) volunteerIdObj;
        } else if (volunteerIdObj instanceof Integer) {
            volunteerId = ((Integer) volunteerIdObj).longValue();
        } else if (volunteerIdObj instanceof String) {
            volunteerId = Long.parseLong((String) volunteerIdObj);
        }
        dto.setVolunteerId(volunteerId);
        
        // Fetch volunteer details from MySQL
        if (volunteerId != null) {
            Optional<User> volunteerOpt = userRepository.findById(volunteerId);
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
        
        // Check if current guardian has liked this answer
        dto.setIsLikedByCurrentUser(hasLiked(document.getId(), currentGuardianId));
        
        return dto;
    }

    /**
     * Get display name for user role
     */
    private String getRoleDisplayName(User.UserRole role) {
        if (role == null) return "Volunteer";
        
        switch (role) {
            case VOLUNTEER:
                return "Volunteer Caregiver";
            case ADMIN:
                return "Medical Professional";
            case CAREGIVER:
                return "Healthcare Worker";
            default:
                return "Volunteer";
        }
    }
}
