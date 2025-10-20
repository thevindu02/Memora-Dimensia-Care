package Memora.DimensiaCareApplication.controller;

import Memora.DimensiaCareApplication.model.Notification;
import Memora.DimensiaCareApplication.service.NotificationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/notifications")
@CrossOrigin(origins = "*")
public class NotificationController {

    @Autowired
    private NotificationService notificationService;

    /**
     * Get all notifications for a caregiver
     * GET /api/notifications/caregiver/{caregiverId}
     */
    @GetMapping("/caregiver/{caregiverId}")
    public ResponseEntity<List<Notification>> getCaregiverNotifications(@PathVariable Long caregiverId) {
        try {
            List<Notification> notifications = notificationService.getCaregiverNotifications(caregiverId);
            return ResponseEntity.ok(notifications);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * Get unread notifications for a caregiver
     * GET /api/notifications/caregiver/{caregiverId}/unread
     */
    @GetMapping("/caregiver/{caregiverId}/unread")
    public ResponseEntity<List<Notification>> getUnreadNotifications(@PathVariable Long caregiverId) {
        try {
            List<Notification> notifications = notificationService.getUnreadNotifications(caregiverId);
            return ResponseEntity.ok(notifications);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * Get read notifications for a caregiver
     * GET /api/notifications/caregiver/{caregiverId}/read
     */
    @GetMapping("/caregiver/{caregiverId}/read")
    public ResponseEntity<List<Notification>> getReadNotifications(@PathVariable Long caregiverId) {
        try {
            List<Notification> notifications = notificationService.getReadNotifications(caregiverId);
            return ResponseEntity.ok(notifications);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * Count unread notifications
     * GET /api/notifications/caregiver/{caregiverId}/count
     */
    @GetMapping("/caregiver/{caregiverId}/count")
    public ResponseEntity<Map<String, Long>> getUnreadCount(@PathVariable Long caregiverId) {
        try {
            Long count = notificationService.countUnreadNotifications(caregiverId);
            return ResponseEntity.ok(Map.of("count", count));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * Mark notification as read
     * PUT /api/notifications/{id}/read
     */
    @PutMapping("/{id}/read")
    public ResponseEntity<Notification> markAsRead(@PathVariable Long id) {
        try {
            Notification notification = notificationService.markAsRead(id);
            return ResponseEntity.ok(notification);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * Mark all notifications as read for a caregiver
     * PUT /api/notifications/caregiver/{caregiverId}/read-all
     */
    @PutMapping("/caregiver/{caregiverId}/read-all")
    public ResponseEntity<Map<String, String>> markAllAsRead(@PathVariable Long caregiverId) {
        try {
            notificationService.markAllAsRead(caregiverId);
            return ResponseEntity.ok(Map.of("message", "All notifications marked as read"));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * Delete notification
     * DELETE /api/notifications/{id}
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, String>> deleteNotification(@PathVariable Long id) {
        try {
            notificationService.deleteNotification(id);
            return ResponseEntity.ok(Map.of("message", "Notification deleted successfully"));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * Delete all notifications for a caregiver
     * DELETE /api/notifications/caregiver/{caregiverId}
     */
    @DeleteMapping("/caregiver/{caregiverId}")
    public ResponseEntity<Map<String, String>> deleteAllCaregiverNotifications(@PathVariable Long caregiverId) {
        try {
            notificationService.deleteAllCaregiverNotifications(caregiverId);
            return ResponseEntity.ok(Map.of("message", "All notifications deleted successfully"));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    // ========== PATIENT NOTIFICATION ENDPOINTS ==========

    /**
     * Get all notifications for a patient
     * GET /api/notifications/patient/{patientId}
     */
    @GetMapping("/patient/{patientId}")
    public ResponseEntity<List<Notification>> getPatientNotifications(@PathVariable Long patientId) {
        try {
            List<Notification> notifications = notificationService.getPatientNotifications(patientId);
            return ResponseEntity.ok(notifications);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * Get unread notifications for a patient
     * GET /api/notifications/patient/{patientId}/unread
     */
    @GetMapping("/patient/{patientId}/unread")
    public ResponseEntity<List<Notification>> getPatientUnreadNotifications(@PathVariable Long patientId) {
        try {
            List<Notification> notifications = notificationService.getPatientUnreadNotifications(patientId);
            return ResponseEntity.ok(notifications);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * Get read notifications for a patient
     * GET /api/notifications/patient/{patientId}/read
     */
    @GetMapping("/patient/{patientId}/read")
    public ResponseEntity<List<Notification>> getPatientReadNotifications(@PathVariable Long patientId) {
        try {
            List<Notification> notifications = notificationService.getPatientReadNotifications(patientId);
            return ResponseEntity.ok(notifications);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * Count unread notifications for a patient
     * GET /api/notifications/patient/{patientId}/count
     */
    @GetMapping("/patient/{patientId}/count")
    public ResponseEntity<Map<String, Long>> getPatientUnreadCount(@PathVariable Long patientId) {
        try {
            Long count = notificationService.countPatientUnreadNotifications(patientId);
            return ResponseEntity.ok(Map.of("count", count));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * Mark all notifications as read for a patient
     * PUT /api/notifications/patient/{patientId}/read-all
     */
    @PutMapping("/patient/{patientId}/read-all")
    public ResponseEntity<Map<String, String>> markAllPatientNotificationsAsRead(@PathVariable Long patientId) {
        try {
            notificationService.markAllPatientNotificationsAsRead(patientId);
            return ResponseEntity.ok(Map.of("message", "All notifications marked as read"));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * Delete all notifications for a patient
     * DELETE /api/notifications/patient/{patientId}
     */
    @DeleteMapping("/patient/{patientId}")
    public ResponseEntity<Map<String, String>> deleteAllPatientNotifications(@PathVariable Long patientId) {
        try {
            notificationService.deleteAllPatientNotifications(patientId);
            return ResponseEntity.ok(Map.of("message", "All notifications deleted successfully"));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
}
