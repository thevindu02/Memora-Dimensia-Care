package Memora.DimensiaCareApplication.service;

import Memora.DimensiaCareApplication.dto.ArticleDTO;
import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.*;
import com.google.firebase.cloud.FirestoreClient;
import org.springframework.stereotype.Service;

import java.util.concurrent.ExecutionException;

@Service
public class ArticleService {

    private static final String COLLECTION_NAME = "articles";

    public String addArticle(ArticleDTO article) throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        DocumentReference docRef = db.collection(COLLECTION_NAME).document();
        article.setId(docRef.getId());
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
