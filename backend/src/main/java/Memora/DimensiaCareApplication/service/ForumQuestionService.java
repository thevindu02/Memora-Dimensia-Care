package Memora.DimensiaCareApplication.service;

import Memora.DimensiaCareApplication.dto.request.CreateForumQuestionDTO;
import Memora.DimensiaCareApplication.dto.response.ForumQuestionDTO;
import com.google.api.core.ApiFuture;
import com.google.cloud.Timestamp;
import com.google.cloud.firestore.*;
import com.google.firebase.cloud.FirestoreClient;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.concurrent.ExecutionException;

@Service
public class ForumQuestionService {

    private static final String COLLECTION_NAME = "forum_questions";
    private static final String GUARDIAN_NAME = "Anonymous Guardian";

    /**
     * Create a new forum question
     */
    public ForumQuestionDTO createQuestion(CreateForumQuestionDTO request) throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        
        // Create a new document reference with auto-generated ID
        DocumentReference docRef = db.collection(COLLECTION_NAME).document();
        String questionId = docRef.getId();
        
        // Prepare data
        Map<String, Object> data = new HashMap<>();
        data.put("questionId", questionId);
        data.put("guardianId", request.getGuardianId());
        data.put("guardianName", GUARDIAN_NAME); // Always anonymous
        data.put("title", request.getTitle());
        data.put("content", request.getContent());
        data.put("tags", request.getTags() != null ? request.getTags() : new ArrayList<>());
        data.put("views", 0L);
        data.put("replies", 0L);
        data.put("isAnswered", false);
        data.put("createdAt", Timestamp.now());
        data.put("updatedAt", Timestamp.now());
        
        // Save to Firestore
        ApiFuture<WriteResult> result = docRef.set(data);
        result.get(); // Wait for completion
        
        // Return the created question
        ForumQuestionDTO questionDTO = new ForumQuestionDTO();
        questionDTO.setQuestionId(questionId);
        questionDTO.setGuardianId(request.getGuardianId());
        questionDTO.setGuardianName(GUARDIAN_NAME);
        questionDTO.setTitle(request.getTitle());
        questionDTO.setContent(request.getContent());
        questionDTO.setTags(request.getTags());
        questionDTO.setViews(0L);
        questionDTO.setReplies(0L);
        questionDTO.setIsAnswered(false);
        questionDTO.setCreatedAt((Timestamp) data.get("createdAt"));
        questionDTO.setUpdatedAt((Timestamp) data.get("updatedAt"));
        
        return questionDTO;
    }

    /**
     * Get all forum questions ordered by creation date (newest first)
     */
    public List<ForumQuestionDTO> getAllQuestions() throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        
        // Query all questions ordered by createdAt descending
        Query query = db.collection(COLLECTION_NAME)
                .orderBy("createdAt", Query.Direction.DESCENDING);
        
        ApiFuture<QuerySnapshot> future = query.get();
        QuerySnapshot documents = future.get();
        
        List<ForumQuestionDTO> questions = new ArrayList<>();
        for (DocumentSnapshot document : documents) {
            if (document.exists()) {
                ForumQuestionDTO question = documentToDTO(document);
                questions.add(question);
            }
        }
        
        return questions;
    }

    /**
     * Get a single question by ID and increment view count
     */
    public ForumQuestionDTO getQuestionById(String questionId) throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        DocumentReference docRef = db.collection(COLLECTION_NAME).document(questionId);
        
        ApiFuture<DocumentSnapshot> future = docRef.get();
        DocumentSnapshot document = future.get();
        
        if (!document.exists()) {
            return null;
        }
        
        // Increment view count
        incrementViews(questionId);
        
        // Convert to DTO
        ForumQuestionDTO question = documentToDTO(document);
        
        // Increment views in the returned object as well
        question.setViews(question.getViews() + 1);
        
        return question;
    }

    /**
     * Increment the view count for a question
     */
    private void incrementViews(String questionId) {
        Firestore db = FirestoreClient.getFirestore();
        DocumentReference docRef = db.collection(COLLECTION_NAME).document(questionId);
        
        // Use Firestore transaction to safely increment the counter
        db.runTransaction(txn -> {
            DocumentSnapshot snapshot = txn.get(docRef).get();
            Long currentViews = snapshot.getLong("views");
            if (currentViews == null) {
                currentViews = 0L;
            }
            txn.update(docRef, "views", currentViews + 1);
            txn.update(docRef, "updatedAt", Timestamp.now());
            return null;
        });
        
        // Execute async - we don't need to wait for this
    }

    /**
     * Get questions by guardian ID
     */
    public List<ForumQuestionDTO> getQuestionsByGuardianId(Long guardianId) throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        
        Query query = db.collection(COLLECTION_NAME)
                .whereEqualTo("guardianId", guardianId)
                .orderBy("createdAt", Query.Direction.DESCENDING);
        
        ApiFuture<QuerySnapshot> future = query.get();
        QuerySnapshot documents = future.get();
        
        List<ForumQuestionDTO> questions = new ArrayList<>();
        for (DocumentSnapshot document : documents) {
            if (document.exists()) {
                ForumQuestionDTO question = documentToDTO(document);
                questions.add(question);
            }
        }
        
        return questions;
    }

    /**
     * Get unanswered questions
     */
    public List<ForumQuestionDTO> getUnansweredQuestions() throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        
        // Query without orderBy to avoid index requirement
        Query query = db.collection(COLLECTION_NAME)
                .whereEqualTo("isAnswered", false);
        
        ApiFuture<QuerySnapshot> future = query.get();
        QuerySnapshot documents = future.get();
        
        System.out.println("Unanswered query returned " + documents.size() + " documents");
        
        List<ForumQuestionDTO> questions = new ArrayList<>();
        for (DocumentSnapshot document : documents) {
            if (document.exists()) {
                System.out.println("Document ID: " + document.getId() + ", isAnswered: " + document.get("isAnswered"));
                ForumQuestionDTO question = documentToDTO(document);
                questions.add(question);
            }
        }
        
        System.out.println("Total unanswered questions: " + questions.size());
        
        // Sort by createdAt in Java
        questions.sort((a, b) -> {
            if (b.getCreatedAt() == null) return -1;
            if (a.getCreatedAt() == null) return 1;
            return b.getCreatedAt().compareTo(a.getCreatedAt());
        });
        
        return questions;
    }

    /**
     * Helper method to convert Firestore document to DTO
     */
    private ForumQuestionDTO documentToDTO(DocumentSnapshot document) {
        ForumQuestionDTO dto = new ForumQuestionDTO();
        dto.setQuestionId(document.getId());
        
        // Handle guardianId as Long
        Object guardianIdObj = document.get("guardianId");
        if (guardianIdObj != null) {
            if (guardianIdObj instanceof Long) {
                dto.setGuardianId((Long) guardianIdObj);
            } else if (guardianIdObj instanceof Integer) {
                dto.setGuardianId(((Integer) guardianIdObj).longValue());
            } else if (guardianIdObj instanceof String) {
                dto.setGuardianId(Long.parseLong((String) guardianIdObj));
            }
        }
        
        dto.setGuardianName(document.getString("guardianName"));
        dto.setTitle(document.getString("title"));
        dto.setContent(document.getString("content"));
        
        // Handle tags
        Object tagsObj = document.get("tags");
        if (tagsObj instanceof List<?>) {
            @SuppressWarnings("unchecked")
            List<String> tags = (List<String>) tagsObj;
            dto.setTags(tags);
        } else {
            dto.setTags(new ArrayList<>());
        }
        
        dto.setViews(document.getLong("views"));
        dto.setReplies(document.getLong("replies"));
        
        // Handle isAnswered - default to false if null
        Boolean isAnswered = document.getBoolean("isAnswered");
        dto.setIsAnswered(isAnswered != null ? isAnswered : false);
        
        dto.setCreatedAt(document.getTimestamp("createdAt"));
        dto.setUpdatedAt(document.getTimestamp("updatedAt"));
        
        return dto;
    }

    /**
     * Delete a question (only by the owner)
     */
    public boolean deleteQuestion(String questionId, Long guardianId) throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        DocumentReference docRef = db.collection(COLLECTION_NAME).document(questionId);
        
        // First, verify the guardian owns this question
        ApiFuture<DocumentSnapshot> future = docRef.get();
        DocumentSnapshot document = future.get();
        
        if (!document.exists()) {
            return false;
        }
        
        Object ownerIdObj = document.get("guardianId");
        Long ownerId = null;
        if (ownerIdObj instanceof Long) {
            ownerId = (Long) ownerIdObj;
        } else if (ownerIdObj instanceof Integer) {
            ownerId = ((Integer) ownerIdObj).longValue();
        }
        
        if (!guardianId.equals(ownerId)) {
            return false; // Not the owner
        }
        
        // Delete the document
        ApiFuture<WriteResult> deleteResult = docRef.delete();
        deleteResult.get();
        
        return true;
    }

    /**
     * Get recent questions (posted within the last 24 hours)
     */
    public List<ForumQuestionDTO> getRecentQuestions() throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        
        // Calculate timestamp for 24 hours ago
        long twentyFourHoursAgo = System.currentTimeMillis() - (24 * 60 * 60 * 1000);
        Timestamp cutoffTime = Timestamp.ofTimeMicroseconds(twentyFourHoursAgo * 1000);
        
        Query query = db.collection(COLLECTION_NAME)
                .whereGreaterThan("createdAt", cutoffTime)
                .orderBy("createdAt", Query.Direction.DESCENDING);
        
        ApiFuture<QuerySnapshot> future = query.get();
        QuerySnapshot documents = future.get();
        
        List<ForumQuestionDTO> questions = new ArrayList<>();
        for (DocumentSnapshot document : documents) {
            if (document.exists()) {
                ForumQuestionDTO question = documentToDTO(document);
                questions.add(question);
            }
        }
        
        return questions;
    }

    /**
     * Get questions sorted by most replies (highest to lowest)
     */
    public List<ForumQuestionDTO> getMostRepliedQuestions() throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        
        Query query = db.collection(COLLECTION_NAME)
                .orderBy("replies", Query.Direction.DESCENDING)
                .orderBy("createdAt", Query.Direction.DESCENDING);
        
        ApiFuture<QuerySnapshot> future = query.get();
        QuerySnapshot documents = future.get();
        
        List<ForumQuestionDTO> questions = new ArrayList<>();
        for (DocumentSnapshot document : documents) {
            if (document.exists()) {
                ForumQuestionDTO question = documentToDTO(document);
                questions.add(question);
            }
        }
        
        return questions;
    }

    /**
     * Get filtered questions based on filter type
     * @param filterType: "all", "unanswered", "recent", "most_replies"
     */
    public List<ForumQuestionDTO> getFilteredQuestions(String filterType) throws ExecutionException, InterruptedException {
        if (filterType == null || filterType.isEmpty()) {
            filterType = "all";
        }
        
        switch (filterType.toLowerCase()) {
            case "unanswered":
                return getUnansweredQuestions();
            case "recent":
                return getRecentQuestions();
            case "most_replies":
            case "mostreplies":
                return getMostRepliedQuestions();
            case "all":
            default:
                return getAllQuestions();
        }
    }
}
