package Memora.DimensiaCareApplication.controller;

import Memora.DimensiaCareApplication.service.FCMNotificationService;
import Memora.DimensiaCareApplication.service.UserFCMTokenService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/test")
@CrossOrigin(origins = "*")
public class NotificationTestController {

    private static final Logger logger = LoggerFactory.getLogger(NotificationTestController.class);

    @Autowired
    private FCMNotificationService fcmNotificationService;

    @Autowired
    private UserFCMTokenService userFCMTokenService;

    /**
     * Test endpoint to check if FCM tokens are registered for a user
     */
    @GetMapping("/fcm-tokens/{userId}")
    public ResponseEntity<Map<String, Object>> getUserTokens(@PathVariable Integer userId) {
        Map<String, Object> response = new HashMap<>();

        try {
            List<String> tokens = userFCMTokenService.getActiveTokensForUser(userId);

            response.put("success", true);
            response.put("userId", userId);
            response.put("tokenCount", tokens.size());
            response.put("tokens", tokens);

            if (tokens.isEmpty()) {
                response.put("message", "No FCM tokens found for this user. User needs to log in on mobile app.");
            } else {
                response.put("message", "Found " + tokens.size() + " active token(s)");
            }

            logger.info("User {} has {} active FCM token(s)", userId, tokens.size());

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            logger.error("Error getting tokens for user {}: {}", userId, e.getMessage());
            response.put("success", false);
            response.put("error", e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }

    /**
     * Test endpoint to send a test notification to a specific user
     */
    @PostMapping("/send-notification/{userId}")
    public ResponseEntity<Map<String, Object>> sendTestNotification(@PathVariable Integer userId) {
        Map<String, Object> response = new HashMap<>();

        try {
            List<String> tokens = userFCMTokenService.getActiveTokensForUser(userId);

            if (tokens.isEmpty()) {
                response.put("success", false);
                response.put("error", "No FCM tokens found for user " + userId);
                response.put("message", "User needs to log in on mobile app to register FCM token");
                return ResponseEntity.badRequest().body(response);
            }

            logger.info("Sending test notification to user {} with {} token(s)", userId, tokens.size());

            // Prepare test notification
            String title = "Test Notification";
            String body = "This is a test notification from Memora backend";

            Map<String, String> data = new HashMap<>();
            data.put("type", "test");
            data.put("userId", String.valueOf(userId));

            // Send notification
            fcmNotificationService.sendNotificationToMultipleDevices(tokens, title, body, data);

            response.put("success", true);
            response.put("message", "Test notification sent to " + tokens.size() + " device(s)");
            response.put("userId", userId);
            response.put("tokenCount", tokens.size());

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            logger.error("Error sending test notification to user {}: {}", userId, e.getMessage(), e);
            response.put("success", false);
            response.put("error", e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }

    /**
     * Test endpoint to send notification to a specific FCM token
     */
    @PostMapping("/send-to-token")
    public ResponseEntity<Map<String, Object>> sendToToken(@RequestBody Map<String, String> request) {
        Map<String, Object> response = new HashMap<>();

        try {
            String token = request.get("token");

            if (token == null || token.isEmpty()) {
                response.put("success", false);
                response.put("error", "FCM token is required");
                return ResponseEntity.badRequest().body(response);
            }

            logger.info("Sending test notification to specific token");

            String title = "Direct Test Notification";
            String body = "This notification was sent directly to your FCM token";

            Map<String, String> data = new HashMap<>();
            data.put("type", "test");
            data.put("direct", "true");

            fcmNotificationService.sendNotificationToDevice(token, title, body, data);

            response.put("success", true);
            response.put("message", "Test notification sent to token");

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            logger.error("Error sending test notification: {}", e.getMessage(), e);
            response.put("success", false);
            response.put("error", e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }

    /**
     * Health check for notification system
     */
    @GetMapping("/notification-health")
    public ResponseEntity<Map<String, Object>> healthCheck() {
        Map<String, Object> response = new HashMap<>();

        try {
            // Check if Firebase is initialized
            com.google.firebase.FirebaseApp.getInstance();

            response.put("success", true);
            response.put("firebaseInitialized", true);
            response.put("message", "Notification system is healthy");

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            logger.error("Notification system health check failed: {}", e.getMessage());
            response.put("success", false);
            response.put("firebaseInitialized", false);
            response.put("error", e.getMessage());
            response.put("message", "Firebase is not properly initialized");

            return ResponseEntity.status(500).body(response);
        }
    }
}
