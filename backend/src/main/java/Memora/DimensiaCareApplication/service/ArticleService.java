package Memora.DimensiaCareApplication.service;

import Memora.DimensiaCareApplication.dto.ArticleDTO;
import Memora.DimensiaCareApplication.model.User;
import Memora.DimensiaCareApplication.repository.UserRepository;
import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.*;
import com.google.firebase.cloud.FirestoreClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.concurrent.ExecutionException;

@Service
public class ArticleService {

    private static final String COLLECTION_NAME = "articles";

    @Autowired
    private UserRepository userRepository;

    public String addArticle(ArticleDTO article) throws ExecutionException, InterruptedException {
        // Set default status if not provided
        if (article.getStatus() == null || article.getStatus().isEmpty()) {
            article.setStatus("disapproved");
        }
        Firestore db = FirestoreClient.getFirestore();
        DocumentReference docRef = db.collection("articles").document();
        article.setArticleId(docRef.getId());
        ApiFuture<WriteResult> result = docRef.set(article);
        return result.get().getUpdateTime().toString();
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
}
