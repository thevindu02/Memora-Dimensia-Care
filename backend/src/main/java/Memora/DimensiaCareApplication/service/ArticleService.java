package Memora.DimensiaCareApplication.service;

import Memora.DimensiaCareApplication.dto.ArticleDTO;
import Memora.DimensiaCareApplication.model.Article;
import Memora.DimensiaCareApplication.repository.ArticleRepository;
import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.*;
import com.google.firebase.cloud.FirestoreClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ExecutionException;

@Service
public class ArticleService {

    private static final String COLLECTION_NAME = "articles";

    @Autowired
    private ArticleRepository articleRepository;

    public String addArticle(ArticleDTO article) throws ExecutionException, InterruptedException {
        // Set default status if not provided
        if (article.getStatus() == null || article.getStatus().isEmpty()) {
            article.setStatus("disapproved");
        }
        // Print fields being sent to Firestore
        Map<String, Object> data = new HashMap<>();
        data.put("title", article.getTitle());
        data.put("volunteerId", article.getVolunteerId());
        data.put("categoryId", article.getCategoryId());
        data.put("content", article.getContent()); // if exists in DTO
        data.put("status", article.getStatus());
        data.put("draft", article.getDraft());
        data.put("created_at", System.currentTimeMillis());
        System.out.println("Firestore DTO data: " + data);
        Firestore db = FirestoreClient.getFirestore();
        DocumentReference docRef = db.collection("articles").document();
        article.setArticleId(docRef.getId());
        ApiFuture<WriteResult> result = docRef.set(article);
        return result.get().getUpdateTime().toString();
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

    public java.util.List<ArticleDTO> getDraftArticles(Long volunteerId)
            throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        Query query = db.collection(COLLECTION_NAME)
                .whereEqualTo("volunteerId", volunteerId)
                .whereEqualTo("draft", true);

        ApiFuture<QuerySnapshot> future = query.get();
        QuerySnapshot documents = future.get();

        java.util.List<ArticleDTO> drafts = new java.util.ArrayList<>();
        for (DocumentSnapshot document : documents) {
            if (document.exists()) {
                ArticleDTO article = document.toObject(ArticleDTO.class);
                drafts.add(article);
            }
        }
        return drafts;
    }
}
