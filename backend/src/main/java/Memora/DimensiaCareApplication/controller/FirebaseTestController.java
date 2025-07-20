package Memora.DimensiaCareApplication.controller;

import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.CollectionReference;
import com.google.firebase.cloud.FirestoreClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class FirebaseTestController {

    @GetMapping("/api/firebase/test")
    public String testFirebaseConnection() {
        try {
            Firestore db = FirestoreClient.getFirestore();
            Iterable<CollectionReference> collections = db.listCollections();
            StringBuilder sb = new StringBuilder("Collections: ");
            for (CollectionReference col : collections) {
                sb.append(col.getId()).append(" ");
            }
            return sb.toString();
        } catch (Exception e) {
            return "Firebase connection failed: " + e.getMessage();
        }
    }
}
