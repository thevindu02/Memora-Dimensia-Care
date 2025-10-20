package Memora.DimensiaCareApplication.service;

import Memora.DimensiaCareApplication.dto.ArticleDTO;
import Memora.DimensiaCareApplication.dto.ArticleDetailDTO;
import Memora.DimensiaCareApplication.model.Article;
import Memora.DimensiaCareApplication.model.ArticleCategory;
import Memora.DimensiaCareApplication.model.User;
import Memora.DimensiaCareApplication.model.Volunteer;
import Memora.DimensiaCareApplication.repository.ArticleRepository;
import Memora.DimensiaCareApplication.repository.ArticleCategoryRepository;
import Memora.DimensiaCareApplication.repository.VolunteerRepository;
import Memora.DimensiaCareApplication.repository.UserRepository;
import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.*;
import com.google.firebase.cloud.FirestoreClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ExecutionException;
import java.util.Optional;

@Service
public class ArticleService {

    private static final String COLLECTION_NAME = "articles";
    private static final String ARTICLE_LIKES_COLLECTION = "article_likes";

    @Autowired
    private ArticleRepository articleRepository;

    @Autowired
    private VolunteerRepository volunteerRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ArticleCategoryRepository articleCategoryRepository;

    public String addArticle(ArticleDTO article) throws ExecutionException, InterruptedException {
        // Set default status if not provided
        if (article.getStatus() == null || article.getStatus().isEmpty()) {
            article.setStatus("disapproved");
        }
        
        System.out.println("=== Starting article creation process ===");
        System.out.println("Article DTO received: " + 
                          "Title: " + article.getTitle() + 
                          ", Volunteer ID: " + article.getVolunteerId() + 
                          ", Category ID: " + article.getCategoryId() + 
                          ", Draft: " + article.getDraft());
        
        try {
            // 1. Save content to Firestore
            System.out.println("Step 1: Saving to Firestore...");
            Firestore db = FirestoreClient.getFirestore();
            DocumentReference docRef = db.collection("articles").document();
            String firebaseDocId = docRef.getId();
            
            // Prepare data for Firestore
            Map<String, Object> firestoreData = new HashMap<>();
            firestoreData.put("title", article.getTitle());
            firestoreData.put("volunteerId", article.getVolunteerId());
            firestoreData.put("categoryId", article.getCategoryId());
            firestoreData.put("content", article.getContent());
            firestoreData.put("status", article.getStatus());
            firestoreData.put("draft", article.getDraft());
            firestoreData.put("summary", article.getSummary());
            firestoreData.put("articleImg", article.getArticleImg()); // Add article image
            firestoreData.put("created_at", System.currentTimeMillis());
            
            System.out.println("Firestore data prepared (including articleImg: " + article.getArticleImg() + "): " + firestoreData);
            
            // Save to Firestore
            ApiFuture<WriteResult> firestoreResult = docRef.set(firestoreData);
            System.out.println("Firestore save initiated with document ID: " + firebaseDocId);
            
            // 2. Save metadata to PostgreSQL
            System.out.println("Step 2: Saving to PostgreSQL...");
            Article articleEntity = new Article();
            articleEntity.setVolunteerId(article.getVolunteerId().intValue());
            articleEntity.setCategoryId(article.getCategoryId());
            articleEntity.setTitle(article.getTitle());
            articleEntity.setStatus(article.getStatus());
            articleEntity.setDraft(article.getDraft());
            articleEntity.setFirebaseDocId(firebaseDocId);
            
            // Handle article image
            if (article.getArticleImg() != null && !article.getArticleImg().trim().isEmpty()) {
                articleEntity.setImg(article.getArticleImg());
            }
            
            System.out.println("PostgreSQL entity prepared: " + 
                             "Title: " + articleEntity.getTitle() + 
                             ", Firebase Doc ID: " + articleEntity.getFirebaseDocId() + 
                             ", Volunteer ID: " + articleEntity.getVolunteerId() + 
                             ", Category ID: " + articleEntity.getCategoryId() + 
                             ", Status: " + articleEntity.getStatus() + 
                             ", Draft: " + articleEntity.getDraft());
            
            // Save to PostgreSQL
            Article savedArticle = articleRepository.save(articleEntity);
            System.out.println("SUCCESS: Article saved to PostgreSQL with ID: " + savedArticle.getArticleId());
            
            // Wait for Firestore operation to complete
            String updateTime = firestoreResult.get().getUpdateTime().toString();
            System.out.println("SUCCESS: Firestore save completed at: " + updateTime);
            System.out.println("=== Article creation process completed successfully ===");
            
            return updateTime;
            
        } catch (Exception e) {
            System.err.println("ERROR: Failed to save article");
            System.err.println("Error message: " + e.getMessage());
            System.err.println("Error type: " + e.getClass().getSimpleName());
            e.printStackTrace();
            throw new RuntimeException("Failed to save article: " + e.getMessage(), e);
        }
    }

    public Article saveArticle(Article article, String content) throws Exception {
        // 1. Save content to Firestore
        Firestore db = FirestoreClient.getFirestore();
        Map<String, Object> data = new HashMap<>();
        data.put("title", article.getTitle());
        data.put("volunteerId", article.getVolunteerId());
        data.put("categoryId", article.getCategoryId()); // <-- Make sure this line exists
        data.put("content", content);
        data.put("created_at", System.currentTimeMillis());
        System.out.println("Firestore data: " + data);
        var docRef = db.collection("articles").document();
        docRef.set(data).get();

        // 2. Save metadata to PostgreSQL
        article.setFirebaseDocId(docRef.getId());
        return articleRepository.save(article);
    }

    public ArticleDTO getArticle(String id) throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        DocumentReference docRef = db.collection(COLLECTION_NAME).document(id);
        ApiFuture<DocumentSnapshot> future = docRef.get();
        DocumentSnapshot document = future.get();
        if (document.exists()) {
            return document.toObject(ArticleDTO.class);
        } else {
            return null;
        }
    }

    public String getArticleContent(String firebaseDocId) throws Exception {
        Firestore db = FirestoreClient.getFirestore();
        var doc = db.collection("articles").document(firebaseDocId).get().get();
        return doc.getString("content");
    }

    public ArticleDetailDTO getArticleDetail(String firebaseDocId) throws ExecutionException, InterruptedException {
        try {
            System.out.println("=== Getting article detail for firebase doc ID: " + firebaseDocId + " ===");
            
            // 1. Get article content from Firebase
            Firestore db = FirestoreClient.getFirestore();
            DocumentReference docRef = db.collection(COLLECTION_NAME).document(firebaseDocId);
            ApiFuture<DocumentSnapshot> future = docRef.get();
            DocumentSnapshot document = future.get();
            
            if (!document.exists()) {
                System.err.println("Article not found in Firebase with ID: " + firebaseDocId);
                return null;
            }
            
            // 2. Map Firebase data to ArticleDetailDTO
            ArticleDetailDTO articleDetail = new ArticleDetailDTO();
            articleDetail.setArticleId(document.getId());
            articleDetail.setTitle(document.getString("title"));
            articleDetail.setContent(document.getString("content"));
            articleDetail.setSummary(document.getString("summary"));
            articleDetail.setStatus(document.getString("status"));
            
            String articleImg = document.getString("articleImg");
            System.out.println("Article image from Firebase: " + articleImg);
            articleDetail.setArticleImg(articleImg);
            
            // Handle volunteerId
            Object volIdObj = document.get("volunteerId");
            Long volunteerId = null;
            if (volIdObj != null) {
                if (volIdObj instanceof Long) {
                    volunteerId = (Long) volIdObj;
                } else if (volIdObj instanceof Integer) {
                    volunteerId = ((Integer) volIdObj).longValue();
                }
                articleDetail.setVolunteerId(volunteerId);
            }
            
            // Handle categoryId
            Object catIdObj = document.get("categoryId");
            Integer categoryId = null;
            if (catIdObj != null) {
                if (catIdObj instanceof Integer) {
                    categoryId = (Integer) catIdObj;
                } else if (catIdObj instanceof Long) {
                    categoryId = ((Long) catIdObj).intValue();
                }
                articleDetail.setCategoryId(categoryId);
            }
            
            // Handle draft
            Object draftObj = document.get("draft");
            if (draftObj instanceof Boolean) {
                articleDetail.setDraft((Boolean) draftObj);
            }
            
            // Handle created_at
            Object createdAtObj = document.get("created_at");
            if (createdAtObj instanceof Long) {
                articleDetail.setCreated_at((Long) createdAtObj);
            }
            
            // 3. Get author information
            // volunteer_id in articles table directly maps to user_id in users table
            if (volunteerId != null) {
                System.out.println("Looking up author with user ID (volunteer_id): " + volunteerId);
                
                Optional<User> userOpt = userRepository.findById(volunteerId);
                if (userOpt.isPresent()) {
                    User user = userOpt.get();
                    String authorName = user.getFName() + " " + user.getLName();
                    System.out.println("Found user: " + authorName + " (Email: " + user.getEmail() + ")");
                    articleDetail.setAuthorName(authorName);
                    articleDetail.setAuthorEmail(user.getEmail());
                    articleDetail.setAuthorProfilePic(user.getProfilePic());
                } else {
                    System.err.println("User not found with ID: " + volunteerId);
                    articleDetail.setAuthorName("Unknown Author");
                }
            } else {
                System.err.println("Volunteer ID is null in article");
                articleDetail.setAuthorName("Unknown Author");
            }
            
            // 4. Get category information
            if (categoryId != null) {
                Optional<ArticleCategory> categoryOpt = articleCategoryRepository.findById(categoryId);
                if (categoryOpt.isPresent()) {
                    articleDetail.setCategoryName(categoryOpt.get().getCategoryName());
                } else {
                    articleDetail.setCategoryName("Uncategorized");
                }
            }
            
            System.out.println("Article detail retrieved successfully: " + articleDetail.getTitle());
            return articleDetail;
            
        } catch (Exception e) {
            System.err.println("ERROR: Failed to get article detail for " + firebaseDocId);
            System.err.println("Error message: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to get article detail: " + e.getMessage(), e);
        }
    }

    public java.util.List<ArticleDetailDTO> getDraftArticles(Long volunteerId)
            throws ExecutionException, InterruptedException {
        try {
            System.out.println("=== Getting draft articles for volunteer ID: " + volunteerId + " ===");
            
            Firestore db = FirestoreClient.getFirestore();
            
            // First, try with simple query to get all articles
            // Then filter in Java to avoid Firestore index issues
            Query query = db.collection(COLLECTION_NAME)
                    .whereEqualTo("volunteerId", volunteerId)
                    .whereEqualTo("draft", true);

            ApiFuture<QuerySnapshot> future = query.get();
            QuerySnapshot documents = future.get();

            java.util.List<ArticleDetailDTO> drafts = new java.util.ArrayList<>();
            for (DocumentSnapshot document : documents) {
                if (document.exists()) {
                    try {
                        ArticleDetailDTO article = new ArticleDetailDTO();
                        
                        // Manually map fields from document to avoid deserialization issues
                        article.setArticleId(document.getId());
                        article.setTitle(document.getString("title"));
                        article.setContent(document.getString("content"));
                        article.setSummary(document.getString("summary"));
                        article.setStatus(document.getString("status"));
                        article.setArticleImg(document.getString("articleImg"));
                        
                        // Handle Long/Integer conversion for volunteerId
                        Object volIdObj = document.get("volunteerId");
                        if (volIdObj != null) {
                            if (volIdObj instanceof Long) {
                                article.setVolunteerId((Long) volIdObj);
                            } else if (volIdObj instanceof Integer) {
                                article.setVolunteerId(((Integer) volIdObj).longValue());
                            }
                        }
                        
                        // Handle categoryId
                        Object catIdObj = document.get("categoryId");
                        if (catIdObj != null) {
                            if (catIdObj instanceof Integer) {
                                article.setCategoryId((Integer) catIdObj);
                            } else if (catIdObj instanceof Long) {
                                article.setCategoryId(((Long) catIdObj).intValue());
                            }
                        }
                        
                        // Handle draft field
                        Object draftObj = document.get("draft");
                        if (draftObj instanceof Boolean) {
                            article.setDraft((Boolean) draftObj);
                        }
                        
                        // Handle created_at timestamp
                        Object createdAtObj = document.get("created_at");
                        if (createdAtObj instanceof Long) {
                            article.setCreated_at((Long) createdAtObj);
                        }
                        
                        // Generate thumbnail from content if no articleImg is set
                        if (article.getArticleImg() == null || article.getArticleImg().trim().isEmpty()) {
                            article.setArticleImg("https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=64&h=64&fit=crop");
                        }
                        
                        // Get author information from User table
                        if (article.getVolunteerId() != null) {
                            try {
                                User author = userRepository.findById(article.getVolunteerId()).orElse(null);
                                if (author != null) {
                                    article.setAuthorName(author.getFName() + " " + author.getLName());
                                    article.setAuthorEmail(author.getEmail());
                                } else {
                                    article.setAuthorName("Unknown Author");
                                }
                            } catch (Exception userError) {
                                System.err.println("Error fetching author for volunteer ID " + article.getVolunteerId());
                                article.setAuthorName("Unknown Author");
                            }
                        }
                        
                        // Get category information
                        if (article.getCategoryId() != null) {
                            try {
                                ArticleCategory category = articleCategoryRepository.findById(article.getCategoryId()).orElse(null);
                                if (category != null) {
                                    article.setCategoryName(category.getCategoryName());
                                } else {
                                    article.setCategoryName("Uncategorized");
                                }
                            } catch (Exception catError) {
                                System.err.println("Error fetching category for ID " + article.getCategoryId());
                                article.setCategoryName("Uncategorized");
                            }
                        }
                        
                        System.out.println("Found draft: " + article.getTitle() + " (ID: " + article.getArticleId() + ") - Category: " + article.getCategoryName());
                        drafts.add(article);
                        
                    } catch (Exception docError) {
                        System.err.println("Error processing document " + document.getId() + ": " + docError.getMessage());
                        docError.printStackTrace();
                        // Continue to next document
                    }
                }
            }
            
            // Sort by created_at descending (most recent first)
            drafts.sort((a, b) -> {
                Long timeA = a.getCreated_at() != null ? a.getCreated_at() : 0L;
                Long timeB = b.getCreated_at() != null ? b.getCreated_at() : 0L;
                return timeB.compareTo(timeA);
            });
            
            System.out.println("Total drafts found: " + drafts.size());
            return drafts;
            
        } catch (Exception e) {
            System.err.println("ERROR: Failed to get draft articles for volunteer " + volunteerId);
            System.err.println("Error message: " + e.getMessage());
            System.err.println("Error type: " + e.getClass().getName());
            e.printStackTrace();
            
            // Return empty list instead of throwing exception
            return new java.util.ArrayList<>();
        }
    }

    public java.util.List<ArticleDetailDTO> getPublishedArticles(Long volunteerId)
            throws ExecutionException, InterruptedException {
        try {
            System.out.println("=== Getting published articles for volunteer ID: " + volunteerId + " ===");
            
            Firestore db = FirestoreClient.getFirestore();
            
            // Query for non-draft, approved articles by the volunteer
            Query query = db.collection(COLLECTION_NAME)
                    .whereEqualTo("volunteerId", volunteerId)
                    .whereEqualTo("draft", false)
                    .whereEqualTo("status", "approved");

            ApiFuture<QuerySnapshot> future = query.get();
            QuerySnapshot documents = future.get();

            java.util.List<ArticleDetailDTO> publishedArticles = new java.util.ArrayList<>();
            for (DocumentSnapshot document : documents) {
                if (document.exists()) {
                    try {
                        ArticleDetailDTO article = new ArticleDetailDTO();
                        
                        // Manually map fields from document
                        article.setArticleId(document.getId());
                        article.setTitle(document.getString("title"));
                        article.setContent(document.getString("content"));
                        article.setSummary(document.getString("summary"));
                        article.setStatus(document.getString("status"));
                        article.setArticleImg(document.getString("articleImg"));
                        
                        // Handle Long/Integer conversion for volunteerId
                        Object volIdObj = document.get("volunteerId");
                        if (volIdObj != null) {
                            if (volIdObj instanceof Long) {
                                article.setVolunteerId((Long) volIdObj);
                            } else if (volIdObj instanceof Integer) {
                                article.setVolunteerId(((Integer) volIdObj).longValue());
                            }
                        }
                        
                        // Handle categoryId
                        Object catIdObj = document.get("categoryId");
                        if (catIdObj != null) {
                            if (catIdObj instanceof Integer) {
                                article.setCategoryId((Integer) catIdObj);
                            } else if (catIdObj instanceof Long) {
                                article.setCategoryId(((Long) catIdObj).intValue());
                            }
                        }
                        
                        // Handle draft field
                        Object draftObj = document.get("draft");
                        if (draftObj instanceof Boolean) {
                            article.setDraft((Boolean) draftObj);
                        }
                        
                        // Handle created_at timestamp
                        Object createdAtObj = document.get("created_at");
                        if (createdAtObj instanceof Long) {
                            article.setCreated_at((Long) createdAtObj);
                        }
                        
                        // Generate thumbnail from content if no articleImg is set
                        if (article.getArticleImg() == null || article.getArticleImg().trim().isEmpty()) {
                            article.setArticleImg("https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=64&h=64&fit=crop");
                        }
                        
                        // Get author information from User table
                        if (article.getVolunteerId() != null) {
                            try {
                                User author = userRepository.findById(article.getVolunteerId()).orElse(null);
                                if (author != null) {
                                    article.setAuthorName(author.getFName() + " " + author.getLName());
                                    article.setAuthorEmail(author.getEmail());
                                } else {
                                    article.setAuthorName("Unknown Author");
                                }
                            } catch (Exception userError) {
                                System.err.println("Error fetching author for volunteer ID " + article.getVolunteerId());
                                article.setAuthorName("Unknown Author");
                            }
                        }
                        
                        // Get category information
                        if (article.getCategoryId() != null) {
                            try {
                                ArticleCategory category = articleCategoryRepository.findById(article.getCategoryId()).orElse(null);
                                if (category != null) {
                                    article.setCategoryName(category.getCategoryName());
                                } else {
                                    article.setCategoryName("Uncategorized");
                                }
                            } catch (Exception catError) {
                                System.err.println("Error fetching category for ID " + article.getCategoryId());
                                article.setCategoryName("Uncategorized");
                            }
                        }
                        
                        // Get like count for this article
                        try {
                            Query likeQuery = db.collection(ARTICLE_LIKES_COLLECTION)
                                    .whereEqualTo("articleId", article.getArticleId());
                            ApiFuture<QuerySnapshot> likeFuture = likeQuery.get();
                            QuerySnapshot likeSnapshot = likeFuture.get();
                            article.setLikeCount(likeSnapshot.size());
                        } catch (Exception likeError) {
                            System.err.println("Error fetching like count for article " + article.getArticleId());
                            article.setLikeCount(0);
                        }
                        
                        // Get comment count for this article
                        try {
                            Query commentQuery = db.collection("articles_comments")
                                    .whereEqualTo("articleId", article.getArticleId())
                                    .whereEqualTo("isDeleted", false);
                            ApiFuture<QuerySnapshot> commentFuture = commentQuery.get();
                            QuerySnapshot commentSnapshot = commentFuture.get();
                            article.setCommentCount(commentSnapshot.size());
                        } catch (Exception commentError) {
                            System.err.println("Error fetching comment count for article " + article.getArticleId());
                            article.setCommentCount(0);
                        }
                        
                        System.out.println("Found published article: " + article.getTitle() + " (ID: " + article.getArticleId() + ") by " + article.getAuthorName() + " - " + article.getLikeCount() + " likes, " + article.getCommentCount() + " comments");
                        publishedArticles.add(article);
                        
                    } catch (Exception docError) {
                        System.err.println("Error processing document " + document.getId() + ": " + docError.getMessage());
                        docError.printStackTrace();
                        // Continue to next document
                    }
                }
            }
            
            // Sort by created_at descending (most recent first)
            publishedArticles.sort((a, b) -> {
                Long timeA = a.getCreated_at() != null ? a.getCreated_at() : 0L;
                Long timeB = b.getCreated_at() != null ? b.getCreated_at() : 0L;
                return timeB.compareTo(timeA);
            });
            
            System.out.println("Total published articles found: " + publishedArticles.size());
            return publishedArticles;
            
        } catch (Exception e) {
            System.err.println("ERROR: Failed to get published articles for volunteer " + volunteerId);
            System.err.println("Error message: " + e.getMessage());
            System.err.println("Error type: " + e.getClass().getName());
            e.printStackTrace();
            
            // Return empty list instead of throwing exception
            return new java.util.ArrayList<>();
        }
    }

    public java.util.List<ArticleDetailDTO> getAllPublishedArticles()
            throws ExecutionException, InterruptedException {
        try {
            System.out.println("=== Getting ALL published articles from ALL volunteers ===");
            
            Firestore db = FirestoreClient.getFirestore();
            
            // Query for non-draft, approved articles from ALL volunteers
            Query query = db.collection(COLLECTION_NAME)
                    .whereEqualTo("draft", false)
                    .whereEqualTo("status", "approved");

            ApiFuture<QuerySnapshot> future = query.get();
            QuerySnapshot documents = future.get();
            
            System.out.println("📊 Total documents found with draft=false and status=approved: " + documents.size());

            java.util.List<ArticleDetailDTO> publishedArticles = new java.util.ArrayList<>();
            java.util.Set<Long> uniqueVolunteerIds = new java.util.HashSet<>();
            
            for (DocumentSnapshot document : documents) {
                if (document.exists()) {
                    try {
                        ArticleDetailDTO article = new ArticleDetailDTO();
                        
                        // Manually map fields from document
                        article.setArticleId(document.getId());
                        article.setTitle(document.getString("title"));
                        article.setContent(document.getString("content"));
                        article.setSummary(document.getString("summary"));
                        article.setStatus(document.getString("status"));
                        article.setArticleImg(document.getString("articleImg"));
                        
                        // Handle Long/Integer conversion for volunteerId
                        Object volIdObj = document.get("volunteerId");
                        if (volIdObj != null) {
                            if (volIdObj instanceof Long) {
                                article.setVolunteerId((Long) volIdObj);
                                uniqueVolunteerIds.add((Long) volIdObj);
                            } else if (volIdObj instanceof Integer) {
                                article.setVolunteerId(((Integer) volIdObj).longValue());
                                uniqueVolunteerIds.add(((Integer) volIdObj).longValue());
                            }
                        }
                        
                        // Handle categoryId
                        Object catIdObj = document.get("categoryId");
                        if (catIdObj != null) {
                            if (catIdObj instanceof Integer) {
                                article.setCategoryId((Integer) catIdObj);
                            } else if (catIdObj instanceof Long) {
                                article.setCategoryId(((Long) catIdObj).intValue());
                            }
                        }
                        
                        // Handle created_at timestamp
                        Object createdAtObj = document.get("created_at");
                        if (createdAtObj != null) {
                            if (createdAtObj instanceof Long) {
                                article.setCreated_at((Long) createdAtObj);
                            } else if (createdAtObj instanceof Integer) {
                                article.setCreated_at(((Integer) createdAtObj).longValue());
                            }
                        }
                        
                        // Handle draft flag
                        Object draftObj = document.get("draft");
                        if (draftObj instanceof Boolean) {
                            article.setDraft((Boolean) draftObj);
                        }
                        
                        // Generate thumbnail from content if no articleImg is set
                        if (article.getArticleImg() == null || article.getArticleImg().trim().isEmpty()) {
                            article.setArticleImg("https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=64&h=64&fit=crop");
                        }
                        
                        // Get author information from User table
                        if (article.getVolunteerId() != null) {
                            try {
                                User author = userRepository.findById(article.getVolunteerId()).orElse(null);
                                if (author != null) {
                                    article.setAuthorName(author.getFName() + " " + author.getLName());
                                    article.setAuthorEmail(author.getEmail());
                                } else {
                                    article.setAuthorName("Unknown Author");
                                }
                            } catch (Exception userError) {
                                System.err.println("Error fetching author for volunteer ID " + article.getVolunteerId());
                                article.setAuthorName("Unknown Author");
                            }
                        }
                        
                        // Get category information
                        if (article.getCategoryId() != null) {
                            try {
                                ArticleCategory category = articleCategoryRepository.findById(article.getCategoryId()).orElse(null);
                                if (category != null) {
                                    article.setCategoryName(category.getCategoryName());
                                } else {
                                    article.setCategoryName("Uncategorized");
                                }
                            } catch (Exception catError) {
                                System.err.println("Error fetching category for ID " + article.getCategoryId());
                                article.setCategoryName("Uncategorized");
                            }
                        }
                        
                        // Get like count for this article
                        try {
                            Query likeQuery = db.collection(ARTICLE_LIKES_COLLECTION)
                                    .whereEqualTo("articleId", article.getArticleId());
                            ApiFuture<QuerySnapshot> likeFuture = likeQuery.get();
                            QuerySnapshot likeSnapshot = likeFuture.get();
                            article.setLikeCount(likeSnapshot.size());
                        } catch (Exception likeError) {
                            System.err.println("Error fetching like count for article " + article.getArticleId());
                            article.setLikeCount(0);
                        }
                        
                        // Get comment count for this article
                        try {
                            Query commentQuery = db.collection("articles_comments")
                                    .whereEqualTo("articleId", article.getArticleId())
                                    .whereEqualTo("isDeleted", false);
                            ApiFuture<QuerySnapshot> commentFuture = commentQuery.get();
                            QuerySnapshot commentSnapshot = commentFuture.get();
                            article.setCommentCount(commentSnapshot.size());
                        } catch (Exception commentError) {
                            System.err.println("Error fetching comment count for article " + article.getArticleId());
                            article.setCommentCount(0);
                        }
                        
                        System.out.println("Found published article: " + article.getTitle() + " (ID: " + article.getArticleId() + ") by " + article.getAuthorName() + " - " + article.getLikeCount() + " likes, " + article.getCommentCount() + " comments");
                        publishedArticles.add(article);
                        
                    } catch (Exception docError) {
                        System.err.println("Error processing document " + document.getId() + ": " + docError.getMessage());
                        docError.printStackTrace();
                        // Continue to next document
                    }
                }
            }
            
            // Sort by created_at descending (most recent first)
            publishedArticles.sort((a, b) -> {
                Long timeA = a.getCreated_at() != null ? a.getCreated_at() : 0L;
                Long timeB = b.getCreated_at() != null ? b.getCreated_at() : 0L;
                return timeB.compareTo(timeA);
            });
            
            System.out.println("📊 SUMMARY:");
            System.out.println("Total published articles found from all volunteers: " + publishedArticles.size());
            System.out.println("Unique volunteers with published articles: " + uniqueVolunteerIds.size());
            System.out.println("Volunteer IDs: " + uniqueVolunteerIds);
            return publishedArticles;
            
        } catch (Exception e) {
            System.err.println("ERROR: Failed to get all published articles");
            System.err.println("Error message: " + e.getMessage());
            System.err.println("Error type: " + e.getClass().getName());
            e.printStackTrace();
            
            // Return empty list instead of throwing exception
            return new java.util.ArrayList<>();
        }
    }

    public String updateArticle(String articleId, ArticleDTO articleDTO)
            throws ExecutionException, InterruptedException {
        try {
            System.out.println("=== Updating article with ID: " + articleId + " ===");
            System.out.println("Update data: " + "Title: " + articleDTO.getTitle() + 
                             ", Draft: " + articleDTO.getDraft() + 
                             ", Status: " + articleDTO.getStatus());
            
            Firestore db = FirestoreClient.getFirestore();
            DocumentReference docRef = db.collection(COLLECTION_NAME).document(articleId);
            
            // Check if document exists
            DocumentSnapshot doc = docRef.get().get();
            if (!doc.exists()) {
                throw new RuntimeException("Article not found with ID: " + articleId);
            }
            
            // Prepare updated data for Firestore
            Map<String, Object> firestoreData = new HashMap<>();
            firestoreData.put("title", articleDTO.getTitle());
            firestoreData.put("volunteerId", articleDTO.getVolunteerId());
            firestoreData.put("categoryId", articleDTO.getCategoryId());
            firestoreData.put("content", articleDTO.getContent());
            firestoreData.put("status", articleDTO.getStatus());
            firestoreData.put("draft", articleDTO.getDraft());
            firestoreData.put("summary", articleDTO.getSummary());
            firestoreData.put("articleImg", articleDTO.getArticleImg());
            firestoreData.put("updated_at", System.currentTimeMillis());
            
            // Update in Firestore
            ApiFuture<WriteResult> firestoreResult = docRef.update(firestoreData);
            System.out.println("Firestore update initiated for document ID: " + articleId);
            
            // Update metadata in PostgreSQL
            Article articleEntity = articleRepository.findByFirebaseDocId(articleId);
            if (articleEntity != null) {
                articleEntity.setTitle(articleDTO.getTitle());
                articleEntity.setStatus(articleDTO.getStatus());
                articleEntity.setDraft(articleDTO.getDraft());
                articleEntity.setCategoryId(articleDTO.getCategoryId());
                
                if (articleDTO.getArticleImg() != null && !articleDTO.getArticleImg().trim().isEmpty()) {
                    articleEntity.setImg(articleDTO.getArticleImg());
                }
                
                articleRepository.save(articleEntity);
                System.out.println("PostgreSQL metadata updated for article ID: " + articleEntity.getArticleId());
            } else {
                System.out.println("WARNING: No PostgreSQL record found for Firebase doc ID: " + articleId);
            }
            
            // Wait for Firestore operation to complete
            String updateTime = firestoreResult.get().getUpdateTime().toString();
            System.out.println("SUCCESS: Article updated at: " + updateTime);
            System.out.println("=== Article update process completed successfully ===");
            
            return updateTime;
            
        } catch (Exception e) {
            System.err.println("ERROR: Failed to update article " + articleId);
            System.err.println("Error message: " + e.getMessage());
            System.err.println("Error type: " + e.getClass().getName());
            e.printStackTrace();
            throw new RuntimeException("Failed to update article: " + e.getMessage(), e);
        }
    }

    public int syncArticleImagesToFirebase() throws ExecutionException, InterruptedException {
        try {
            System.out.println("=== Starting sync of article images to Firebase ===");
            
            // Get all articles from PostgreSQL that have images
            java.util.List<Article> articlesWithImages = articleRepository.findAll().stream()
                    .filter(article -> article.getImg() != null && !article.getImg().trim().isEmpty())
                    .toList();
            
            System.out.println("Found " + articlesWithImages.size() + " articles with images in PostgreSQL");
            
            Firestore db = FirestoreClient.getFirestore();
            int syncedCount = 0;
            
            for (Article article : articlesWithImages) {
                try {
                    String firebaseDocId = article.getFirebaseDocId();
                    String imageUrl = article.getImg();
                    
                    if (firebaseDocId != null && !firebaseDocId.trim().isEmpty()) {
                        // Update the articleImg field in Firebase
                        DocumentReference docRef = db.collection(COLLECTION_NAME).document(firebaseDocId);
                        Map<String, Object> updates = new HashMap<>();
                        updates.put("articleImg", imageUrl);
                        
                        docRef.update(updates).get();
                        
                        System.out.println("Synced image for article: " + article.getTitle() + " (Firebase ID: " + firebaseDocId + ")");
                        syncedCount++;
                    } else {
                        System.out.println("WARNING: Article " + article.getArticleId() + " has no Firebase doc ID");
                    }
                } catch (Exception e) {
                    System.err.println("Error syncing image for article " + article.getArticleId() + ": " + e.getMessage());
                }
            }
            
            System.out.println("=== Sync completed. Synced " + syncedCount + " images ===");
            return syncedCount;
            
        } catch (Exception e) {
            System.err.println("ERROR: Failed to sync article images");
            System.err.println("Error message: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to sync article images: " + e.getMessage(), e);
        }
    }

    /**
     * Like an article
     */
    public boolean likeArticle(String articleId, Long userId) throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        
        // Check if already liked
        Query query = db.collection(ARTICLE_LIKES_COLLECTION)
                .whereEqualTo("articleId", articleId)
                .whereEqualTo("userId", userId);
        
        ApiFuture<QuerySnapshot> future = query.get();
        QuerySnapshot documents = future.get();
        
        if (!documents.isEmpty()) {
            // Already liked
            return false;
        }
        
        // Create like document
        DocumentReference likeRef = db.collection(ARTICLE_LIKES_COLLECTION).document();
        Map<String, Object> likeData = new HashMap<>();
        likeData.put("likeId", likeRef.getId());
        likeData.put("articleId", articleId);
        likeData.put("userId", userId);
        likeData.put("createdAt", com.google.cloud.Timestamp.now());
        
        ApiFuture<WriteResult> likeResult = likeRef.set(likeData);
        likeResult.get();
        
        // Increment likes count in article
        DocumentReference articleRef = db.collection(COLLECTION_NAME).document(articleId);
        db.runTransaction(txn -> {
            DocumentSnapshot snapshot = txn.get(articleRef).get();
            Long currentLikes = snapshot.getLong("likes");
            if (currentLikes == null) {
                currentLikes = 0L;
            }
            txn.update(articleRef, "likes", currentLikes + 1);
            txn.update(articleRef, "updated_at", System.currentTimeMillis());
            return null;
        }).get();
        
        return true;
    }

    /**
     * Unlike an article
     */
    public boolean unlikeArticle(String articleId, Long userId) throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        
        // Find the like document
        Query query = db.collection(ARTICLE_LIKES_COLLECTION)
                .whereEqualTo("articleId", articleId)
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
        
        // Decrement likes count in article
        DocumentReference articleRef = db.collection(COLLECTION_NAME).document(articleId);
        db.runTransaction(txn -> {
            DocumentSnapshot snapshot = txn.get(articleRef).get();
            Long currentLikes = snapshot.getLong("likes");
            if (currentLikes == null || currentLikes <= 0) {
                currentLikes = 0L;
            } else {
                currentLikes--;
            }
            txn.update(articleRef, "likes", currentLikes);
            txn.update(articleRef, "updated_at", System.currentTimeMillis());
            return null;
        }).get();
        
        return true;
    }

    /**
     * Check if a user has liked a specific article
     */
    public boolean hasLikedArticle(String articleId, Long userId) throws ExecutionException, InterruptedException {
        if (userId == null) {
            return false;
        }
        
        Firestore db = FirestoreClient.getFirestore();
        Query query = db.collection(ARTICLE_LIKES_COLLECTION)
                .whereEqualTo("articleId", articleId)
                .whereEqualTo("userId", userId);
        
        ApiFuture<QuerySnapshot> future = query.get();
        QuerySnapshot documents = future.get();
        
        return !documents.isEmpty();
    }

    /**
     * Get like count for an article
     */
    public long getArticleLikeCount(String articleId) throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        DocumentReference articleRef = db.collection(COLLECTION_NAME).document(articleId);
        
        ApiFuture<DocumentSnapshot> future = articleRef.get();
        DocumentSnapshot document = future.get();
        
        if (document.exists()) {
            Long likes = document.getLong("likes");
            return likes != null ? likes : 0L;
        }
        
        return 0L;
    }

    /**
     * Delete an article (only by the author/volunteer)
     * @param articleId The ID of the article to delete
     * @param volunteerId The ID of the volunteer attempting to delete
     * @return true if deleted successfully, false otherwise
     */
    public boolean deleteArticle(String articleId, Long volunteerId) {
        try {
            System.out.println("=== Deleting Article ===");
            System.out.println("Article ID: " + articleId);
            System.out.println("Volunteer ID: " + volunteerId);
            
            Firestore db = FirestoreClient.getFirestore();
            DocumentReference articleRef = db.collection(COLLECTION_NAME).document(articleId);
            
            // First, verify the article exists and belongs to this volunteer
            ApiFuture<DocumentSnapshot> future = articleRef.get();
            DocumentSnapshot document = future.get();
            
            if (!document.exists()) {
                System.err.println("Article not found: " + articleId);
                return false;
            }
            
            // Check if the volunteer is the author
            Object volIdObj = document.get("volunteerId");
            Long articleVolunteerId = null;
            
            if (volIdObj instanceof Long) {
                articleVolunteerId = (Long) volIdObj;
            } else if (volIdObj instanceof Integer) {
                articleVolunteerId = ((Integer) volIdObj).longValue();
            }
            
            if (articleVolunteerId == null || !articleVolunteerId.equals(volunteerId)) {
                System.err.println("Permission denied. Article belongs to volunteer " + articleVolunteerId + 
                                 ", but delete requested by volunteer " + volunteerId);
                return false;
            }
            
            // Delete the article
            ApiFuture<WriteResult> deleteResult = articleRef.delete();
            WriteResult result = deleteResult.get();
            
            System.out.println("Article deleted successfully at: " + result.getUpdateTime());
            
            // Optional: Also delete associated likes and comments
            // Delete likes
            Query likesQuery = db.collection(ARTICLE_LIKES_COLLECTION)
                    .whereEqualTo("articleId", articleId);
            ApiFuture<QuerySnapshot> likesFuture = likesQuery.get();
            QuerySnapshot likesSnapshot = likesFuture.get();
            
            for (DocumentSnapshot likeDoc : likesSnapshot.getDocuments()) {
                likeDoc.getReference().delete();
            }
            System.out.println("Deleted " + likesSnapshot.size() + " likes for article " + articleId);
            
            // Delete comments
            Query commentsQuery = db.collection("articles_comments")
                    .whereEqualTo("articleId", articleId);
            ApiFuture<QuerySnapshot> commentsFuture = commentsQuery.get();
            QuerySnapshot commentsSnapshot = commentsFuture.get();
            
            for (DocumentSnapshot commentDoc : commentsSnapshot.getDocuments()) {
                commentDoc.getReference().delete();
            }
            System.out.println("Deleted " + commentsSnapshot.size() + " comments for article " + articleId);
            
            return true;
            
        } catch (Exception e) {
            System.err.println("Error deleting article: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}

