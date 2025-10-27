package Memora.DimensiaCareApplication.service;

import Memora.DimensiaCareApplication.dto.request.CreateForumQuestionDTO;
import Memora.DimensiaCareApplication.dto.response.ForumQuestionDTO;
import Memora.DimensiaCareApplication.model.User;
import Memora.DimensiaCareApplication.model.User.UserRole;
import Memora.DimensiaCareApplication.repository.UserRepository;
import com.google.api.core.ApiFuture;
import com.google.cloud.Timestamp;
import com.google.cloud.firestore.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.concurrent.ExecutionException;

@Service
public class ForumQuestionService {

    private static final String COLLECTION_NAME = "forum_questions";

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private Firestore firestore; // Inject Firestore bean

    /**
     * Get anonymous name based on user role from database
     */
    private String getAnonymousNameFromRole(Long userId) {
        if (userId == null) {
            System.out.println("WARNING: userId is null, returning default anonymous name");
            return "Anonymous User";
        }

        System.out.println("Looking up user role for userId: " + userId);
        Optional<User> userOptional = userRepository.findById(userId);

        if (userOptional.isPresent()) {
            User user = userOptional.get();
            UserRole role = user.getRole();
            System.out.println("Found user with role: " + role);

            if (role == UserRole.CAREGIVER) {
                return "Anonymous Caregiver";
            } else if (role == UserRole.GUARDIAN) {
                return "Anonymous Guardian";
            } else if (role == UserRole.VOLUNTEER) {
                return "Anonymous Volunteer";
            } else if (role == UserRole.ADMIN) {
                return "Anonymous Admin";
            } else {
                System.out.println("WARNING: Unrecognized role: " + role);
                return "Anonymous User";
            }
        } else {
            System.out.println("WARNING: User not found in database for userId: " + userId);
        }

        // Default fallback
        return "Anonymous User";
    }

    /**
     * Create a new forum question
     */
    public ForumQuestionDTO createQuestion(CreateForumQuestionDTO request)
            throws ExecutionException, InterruptedException {
        Firestore db = this.firestore;

        // Create a new document reference with auto-generated ID
        DocumentReference docRef = db.collection(COLLECTION_NAME).document();
        String questionId = docRef.getId();

        // Determine anonymous name based on user role from database
        String anonymousName = getAnonymousNameFromRole(request.getUserId());

        // Prepare data
        Map<String, Object> data = new HashMap<>();
        data.put("questionId", questionId);
        data.put("userId", request.getUserId()); // Changed from guardianId
        data.put("guardianName", anonymousName); // Set based on user role
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
        questionDTO.setUserId(request.getUserId());
        questionDTO.setGuardianName(anonymousName);
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
        Firestore db = this.firestore;

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
        Firestore db = this.firestore;
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
        Firestore db = this.firestore;
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
     * Get questions by user ID (guardian or caregiver)
     */
    public List<ForumQuestionDTO> getQuestionsByUserId(Long userId) throws ExecutionException, InterruptedException {
        Firestore db = this.firestore;

        // Try querying with new userId field first
        Query query = db.collection(COLLECTION_NAME)
                .whereEqualTo("userId", userId)
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

        // If no results, try old guardianId field for backward compatibility
        if (questions.isEmpty()) {
            query = db.collection(COLLECTION_NAME)
                    .whereEqualTo("guardianId", userId)
                    .orderBy("createdAt", Query.Direction.DESCENDING);

            future = query.get();
            documents = future.get();

            for (DocumentSnapshot document : documents) {
                if (document.exists()) {
                    ForumQuestionDTO question = documentToDTO(document);
                    questions.add(question);
                }
            }
        }

        return questions;
    }

    /**
     * Get questions by guardian ID
     * 
     * @deprecated Use getQuestionsByUserId instead
     */
    @Deprecated
    public List<ForumQuestionDTO> getQuestionsByGuardianId(Long guardianId)
            throws ExecutionException, InterruptedException {
        return getQuestionsByUserId(guardianId);
    }

    /**
     * Get unanswered questions
     */
    public List<ForumQuestionDTO> getUnansweredQuestions() throws ExecutionException, InterruptedException {
        Firestore db = this.firestore;

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
            if (b.getCreatedAt() == null)
                return -1;
            if (a.getCreatedAt() == null)
                return 1;
            return b.getCreatedAt().compareTo(a.getCreatedAt());
        });

        return questions;
    }

    /**
     * Helper method to update question's answered status in Firestore
     */
    private void updateQuestionAnsweredStatus(String questionId, boolean isAnswered) {
        try {
            Firestore db = this.firestore;
            DocumentReference docRef = db.collection(COLLECTION_NAME).document(questionId);

            Map<String, Object> updates = new HashMap<>();
            updates.put("isAnswered", isAnswered);
            updates.put("updatedAt", Timestamp.now());

            docRef.update(updates);
            System.out.println("Updated question " + questionId + " isAnswered status to: " + isAnswered);
        } catch (Exception e) {
            System.err.println("Error updating question answered status: " + e.getMessage());
        }
    }

    /**
     * Helper method to convert Firestore document to DTO
     */
    private ForumQuestionDTO documentToDTO(DocumentSnapshot document) {
        ForumQuestionDTO dto = new ForumQuestionDTO();
        dto.setQuestionId(document.getId());

        // Handle userId (changed from guardianId) as Long
        Object userIdObj = document.get("userId");
        if (userIdObj != null) {
            if (userIdObj instanceof Long) {
                dto.setUserId((Long) userIdObj);
            } else if (userIdObj instanceof Integer) {
                dto.setUserId(((Integer) userIdObj).longValue());
            } else if (userIdObj instanceof String) {
                dto.setUserId(Long.parseLong((String) userIdObj));
            }
        } else {
            // Fallback: try to get old guardianId field for backward compatibility
            Object guardianIdObj = document.get("guardianId");
            if (guardianIdObj != null) {
                if (guardianIdObj instanceof Long) {
                    dto.setUserId((Long) guardianIdObj);
                } else if (guardianIdObj instanceof Integer) {
                    dto.setUserId(((Integer) guardianIdObj).longValue());
                } else if (guardianIdObj instanceof String) {
                    dto.setUserId(Long.parseLong((String) guardianIdObj));
                }
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

        // Get actual reply count from forum_answers collection
        Long actualReplyCount = getActualReplyCount(document.getId());
        dto.setReplies(actualReplyCount);

        // Handle isAnswered - if question has replies, it should be marked as answered
        Boolean isAnswered = document.getBoolean("isAnswered");
        if (isAnswered == null || !isAnswered) {
            // If isAnswered is null/false but question has replies, mark as answered
            if (actualReplyCount != null && actualReplyCount > 0) {
                dto.setIsAnswered(true);
                // Also update Firestore to fix the data
                updateQuestionAnsweredStatus(document.getId(), true);
            } else {
                dto.setIsAnswered(false);
            }
        } else {
            dto.setIsAnswered(true);
        }

        dto.setCreatedAt(document.getTimestamp("createdAt"));
        dto.setUpdatedAt(document.getTimestamp("updatedAt"));

        return dto;
    }

    /**
     * Get actual reply count from forum_answers collection
     */
    private Long getActualReplyCount(String questionId) {
        try {
            Firestore db = this.firestore;
            Query query = db.collection("forum_answers")
                    .whereEqualTo("questionId", questionId);

            ApiFuture<QuerySnapshot> future = query.get();
            QuerySnapshot snapshot = future.get();

            return (long) snapshot.size();
        } catch (Exception e) {
            System.err.println("Error getting reply count for question " + questionId + ": " + e.getMessage());
            return 0L;
        }
    }

    /**
     * Delete a question (only by the owner)
     */
    public boolean deleteQuestion(String questionId, Long guardianId) throws ExecutionException, InterruptedException {
        Firestore db = this.firestore;
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
     * Get recent questions (posted within the last 1 hour)
     */
    public List<ForumQuestionDTO> getRecentQuestions() throws ExecutionException, InterruptedException {
        Firestore db = this.firestore;

        // Calculate timestamp for 1 hour ago
        long oneHourAgo = System.currentTimeMillis() - (60 * 60 * 1000);
        Timestamp cutoffTime = Timestamp.ofTimeMicroseconds(oneHourAgo * 1000);

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
     * Get top 5 questions sorted by most replies (highest to lowest)
     */
    public List<ForumQuestionDTO> getMostRepliedQuestions() throws ExecutionException, InterruptedException {
        Firestore db = this.firestore;

        // Fetch all questions first
        Query query = db.collection(COLLECTION_NAME);

        ApiFuture<QuerySnapshot> future = query.get();
        QuerySnapshot documents = future.get();

        List<ForumQuestionDTO> questions = new ArrayList<>();
        for (DocumentSnapshot document : documents) {
            if (document.exists()) {
                ForumQuestionDTO question = documentToDTO(document);
                questions.add(question);

                // Debug logging
                System.out.println("Question: " + question.getTitle() +
                        " | Replies: " + question.getReplies() +
                        " | Created: " + question.getCreatedAt());
            }
        }

        System.out.println("Total questions fetched: " + questions.size());

        // Sort by replies (descending) in Java
        questions.sort((a, b) -> {
            Long repliesA = a.getReplies() != null ? a.getReplies() : 0L;
            Long repliesB = b.getReplies() != null ? b.getReplies() : 0L;

            // First compare by reply count (descending)
            int replyComparison = repliesB.compareTo(repliesA);
            if (replyComparison != 0) {
                return replyComparison;
            }

            // If same reply count, sort by creation date (newest first)
            if (b.getCreatedAt() == null)
                return -1;
            if (a.getCreatedAt() == null)
                return 1;
            return b.getCreatedAt().compareTo(a.getCreatedAt());
        });

        // Return top 5
        List<ForumQuestionDTO> topQuestions = questions.stream()
                .limit(5)
                .collect(java.util.stream.Collectors.toList());

        System.out.println("Returning top " + topQuestions.size() + " questions with most replies");
        for (ForumQuestionDTO q : topQuestions) {
            System.out.println("  - " + q.getTitle() + " (" + q.getReplies() + " replies)");
        }

        return topQuestions;
    }

    /**
     * Get filtered questions based on filter type
     * 
     * @param filterType: "all", "unanswered", "recent", "most_replies"
     */
    public List<ForumQuestionDTO> getFilteredQuestions(String filterType)
            throws ExecutionException, InterruptedException {
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

    /**
     * Migration utility: Update all existing questions to use userId and
     * recalculate guardianName
     * This should be called once to fix old questions
     */
    public String migrateExistingQuestions() throws ExecutionException, InterruptedException {
        Firestore db = this.firestore;

        // Get all questions
        Query query = db.collection(COLLECTION_NAME);
        ApiFuture<QuerySnapshot> future = query.get();
        QuerySnapshot documents = future.get();

        int updated = 0;
        int skipped = 0;
        int failed = 0;

        for (DocumentSnapshot document : documents) {
            if (!document.exists())
                continue;

            try {
                // Check if userId already exists
                Object userIdObj = document.get("userId");
                Long userId = null;

                if (userIdObj != null) {
                    // userId exists, just update guardianName
                    if (userIdObj instanceof Long) {
                        userId = (Long) userIdObj;
                    } else if (userIdObj instanceof Integer) {
                        userId = ((Integer) userIdObj).longValue();
                    }
                } else {
                    // Try to get userId from old guardianId field
                    Object guardianIdObj = document.get("guardianId");
                    if (guardianIdObj != null) {
                        if (guardianIdObj instanceof Long) {
                            userId = (Long) guardianIdObj;
                        } else if (guardianIdObj instanceof Integer) {
                            userId = ((Integer) guardianIdObj).longValue();
                        }
                    }
                }

                if (userId != null) {
                    // Get the correct anonymous name from database
                    String correctName = getAnonymousNameFromRole(userId);

                    // Update the document
                    Map<String, Object> updates = new HashMap<>();
                    updates.put("userId", userId);
                    updates.put("guardianName", correctName);
                    updates.put("updatedAt", Timestamp.now());

                    ApiFuture<WriteResult> updateFuture = document.getReference().update(updates);
                    updateFuture.get();

                    updated++;
                    System.out.println("Updated question " + document.getId() + " with userId=" + userId + ", name="
                            + correctName);
                } else {
                    skipped++;
                    System.out.println("Skipped question " + document.getId() + " - no userId or guardianId found");
                }
            } catch (Exception e) {
                failed++;
                System.err.println("Failed to update question " + document.getId() + ": " + e.getMessage());
            }
        }

        String result = String.format(
                "Migration complete: %d updated, %d skipped, %d failed",
                updated, skipped, failed);
        System.out.println(result);
        return result;
    }
}
