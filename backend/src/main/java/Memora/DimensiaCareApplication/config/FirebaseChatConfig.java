package Memora.DimensiaCareApplication.config;

import com.google.firebase.cloud.FirestoreClient;
import com.google.cloud.firestore.Firestore;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class FirebaseChatConfig {

    // Firebase is already initialized in FirebaseConfig.java
    // This class only provides the Firestore bean

    @Bean
    public Firestore firestore() {
        return FirestoreClient.getFirestore();
    }
}
