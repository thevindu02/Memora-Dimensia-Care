package Memora.DimensiaCareApplication.config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import org.springframework.context.annotation.Configuration;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.annotation.PostConstruct;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.File;

@Configuration
public class FirebaseConfig {

    private static final Logger logger = LoggerFactory.getLogger(FirebaseConfig.class);

    @PostConstruct
    public void initialize() {
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
            } else {
                logger.info("✅ Firebase already initialized");
            }
        } catch (IOException e) {
            logger.error("❌ FATAL: Failed to initialize Firebase!", e);
            logger.error("Error message: {}", e.getMessage());
            logger.error("Stack trace:", e);
            // Throw runtime exception to prevent app from starting with broken Firebase
            throw new RuntimeException("Firebase initialization failed. Notifications will not work!", e);
        }
    }
}
