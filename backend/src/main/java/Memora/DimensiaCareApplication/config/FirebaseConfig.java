package Memora.DimensiaCareApplication.config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.cloud.firestore.Firestore;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.cloud.FirestoreClient;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.File;

@Configuration
public class FirebaseConfig {

    private static final Logger logger = LoggerFactory.getLogger(FirebaseConfig.class);
    private static boolean initialized = false;
    private static Firestore firestoreInstance = null;

    @PostConstruct
    public void initialize() {
        if (initialized) {
            logger.info("✅ Firebase already initialized, skipping...");
            return;
        }

        try {
            String keyFileName = "memora-2025-firebase-adminsdk-fbsvc-c45cc799ae.json";
            File keyFile = new File(keyFileName);

            logger.info("===========================================");
            logger.info("🔥 FIREBASE INITIALIZATION");
            logger.info("Looking for Firebase key file: {}", keyFile.getAbsolutePath());
            logger.info("File exists: {}", keyFile.exists());
            logger.info("===========================================");

            if (!keyFile.exists()) {
                logger.error("❌ Firebase service account key file NOT FOUND at: {}", keyFile.getAbsolutePath());
                logger.error("Please ensure the file is in the correct location");
                throw new IOException("Firebase service account key file not found");
            }

            FileInputStream serviceAccount = new FileInputStream(keyFile);

            FirebaseOptions options = FirebaseOptions.builder()
                    .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                    .build();

            if (FirebaseApp.getApps().isEmpty()) {
                FirebaseApp.initializeApp(options);
                logger.info("✅ Firebase successfully initialized!");
                initialized = true;
            } else {
                logger.info("✅ Firebase already initialized");
                initialized = true;
            }
        } catch (IOException e) {
            logger.error("❌ FATAL: Failed to initialize Firebase!", e);
            logger.error("Error message: {}", e.getMessage());
            logger.error("Stack trace:", e);
            // Throw runtime exception to prevent app from starting with broken Firebase
            throw new RuntimeException("Firebase initialization failed. Notifications will not work!", e);
        }
    }

    /**
     * Provides a singleton Firestore bean that can be injected into services.
     * This prevents the "Firestore client has already been closed" error.
     */
    @Bean
    public Firestore firestore() {
        if (firestoreInstance != null) {
            logger.info("✅ Returning existing Firestore instance");
            return firestoreInstance;
        }

        try {
            if (!initialized) {
                initialize();
            }

            // Get Firestore instance and cache it
            synchronized (FirebaseConfig.class) {
                if (firestoreInstance == null) {
                    firestoreInstance = FirestoreClient.getFirestore();
                    logger.info("✅ Firestore singleton bean created successfully");
                }
            }
            return firestoreInstance;
        } catch (Exception e) {
            logger.error("❌ Failed to create Firestore bean", e);
            throw new RuntimeException("Failed to create Firestore bean", e);
        }
    }

    @PreDestroy
    public void cleanup() {
        logger.info("🔥 Firebase cleanup - keeping Firestore instance alive for graceful shutdown");
        // Don't close Firestore or set firestoreInstance to null
        // This prevents "Firestore client has already been closed" errors
    }
}
