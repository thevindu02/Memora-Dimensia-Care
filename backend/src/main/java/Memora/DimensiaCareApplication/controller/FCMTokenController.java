package Memora.DimensiaCareApplication.controller;

import Memora.DimensiaCareApplication.model.UserFCMToken;
import Memora.DimensiaCareApplication.service.UserFCMTokenService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/fcm")
@CrossOrigin(origins = "*")
public class FCMTokenController {

    @Autowired
    private UserFCMTokenService tokenService;

    /**
     * Register or update FCM token for a user
     */
    @PostMapping("/token")
    public ResponseEntity<?> registerToken(@RequestBody Map<String, Object> payload) {
        try {
            Integer userId = Integer.parseInt(payload.get("userId").toString());
            String fcmToken = payload.get("fcmToken").toString();
            String deviceType = payload.getOrDefault("deviceType", "android").toString();

            UserFCMToken token = tokenService.saveOrUpdateToken(userId, fcmToken, deviceType);

            return ResponseEntity.ok(Map.of(
                    "message", "FCM token registered successfully",
                    "tokenId", token.getId()));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of(
                    "error", "Failed to register FCM token",
                    "message", e.getMessage()));
        }
    }

    /**
     * Deactivate FCM token
     */
    @PostMapping("/token/deactivate")
    public ResponseEntity<?> deactivateToken(@RequestBody Map<String, String> payload) {
        try {
            String fcmToken = payload.get("fcmToken");
            tokenService.deactivateToken(fcmToken);

            return ResponseEntity.ok(Map.of(
                    "message", "FCM token deactivated successfully"));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of(
                    "error", "Failed to deactivate FCM token",
                    "message", e.getMessage()));
        }
    }

    /**
     * Delete FCM token
     */
    @DeleteMapping("/token")
    public ResponseEntity<?> deleteToken(@RequestParam String fcmToken) {
        try {
            tokenService.deleteToken(fcmToken);

            return ResponseEntity.ok(Map.of(
                    "message", "FCM token deleted successfully"));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of(
                    "error", "Failed to delete FCM token",
                    "message", e.getMessage()));
        }
    }
}
