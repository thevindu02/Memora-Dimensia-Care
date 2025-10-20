package Memora.DimensiaCareApplication.service;

import Memora.DimensiaCareApplication.model.Notification;
import Memora.DimensiaCareApplication.repository.NotificationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class NotificationService {

    private static final Logger logger = LoggerFactory.getLogger(NotificationService.class);

    @Autowired
    private NotificationRepository notificationRepository;

    /**
     * Save a notification to database
     */
    public Notification saveNotification(Notification notification) {
        try {
            Notification saved = notificationRepository.save(notification);
            logger.info("✅ Notification saved to database: ID={}, Type={}, Caregiver={}",
                    saved.getNotificationId(), saved.getNotificationType(), saved.getCaregiverId());
            return saved;
        } catch (Exception e) {
            logger.error("❌ Error saving notification to database: {}", e.getMessage(), e);
            throw e;
        }
    }

    /**
     * Create and save a task reminder notification
     */
    public Notification createTaskReminderNotification(
            Long caregiverId, Long patientId, String patientName,
            String taskName, Long taskId, String notificationType) {

        String title = "Task Reminder";
        String message = taskName + " for " + patientName + " is starting in 4 minutes";

        Notification notification = new Notification(
                caregiverId, patientId, patientName,
                title, message, notificationType, taskId, taskName);

        return saveNotification(notification);
    }

    /**
     * Get all notifications for a caregiver
     */
    public List<Notification> getCaregiverNotifications(Long caregiverId) {
        return notificationRepository.findByCaregiverIdOrderByCreatedAtDesc(caregiverId);
    }

    /**
     * Get unread notifications for a caregiver
     */
    public List<Notification> getUnreadNotifications(Long caregiverId) {
        return notificationRepository.findByCaregiverIdAndIsReadOrderByCreatedAtDesc(caregiverId, false);
    }

    /**
     * Get read notifications for a caregiver
     */
    public List<Notification> getReadNotifications(Long caregiverId) {
        return notificationRepository.findByCaregiverIdAndIsReadOrderByCreatedAtDesc(caregiverId, true);
    }

    /**
     * Count unread notifications
     */
    public Long countUnreadNotifications(Long caregiverId) {
        return notificationRepository.countByCaregiverIdAndIsRead(caregiverId, false);
    }

    /**
     * Mark notification as read
     */
    public Notification markAsRead(Long notificationId) {
        Optional<Notification> notificationOpt = notificationRepository.findById(notificationId);
        if (notificationOpt.isPresent()) {
            Notification notification = notificationOpt.get();
            notification.setIsRead(true);
            Notification updated = notificationRepository.save(notification);
            logger.info("✅ Notification marked as read: ID={}", notificationId);
            return updated;
        }
        throw new RuntimeException("Notification not found: " + notificationId);
    }

    /**
     * Delete notification
     */
    public void deleteNotification(Long notificationId) {
        if (notificationRepository.existsById(notificationId)) {
            notificationRepository.deleteById(notificationId);
            logger.info("✅ Notification deleted: ID={}", notificationId);
        } else {
            throw new RuntimeException("Notification not found: " + notificationId);
        }
    }

    /**
     * Delete all notifications for a caregiver
     */
    public void deleteAllCaregiverNotifications(Long caregiverId) {
        List<Notification> notifications = notificationRepository.findByCaregiverIdOrderByCreatedAtDesc(caregiverId);
        notificationRepository.deleteAll(notifications);
        logger.info("✅ Deleted {} notifications for caregiver ID: {}", notifications.size(), caregiverId);
    }

    /**
     * Mark all notifications as read for a caregiver
     */
    public void markAllAsRead(Long caregiverId) {
        List<Notification> unreadNotifications = getUnreadNotifications(caregiverId);
        for (Notification notification : unreadNotifications) {
            notification.setIsRead(true);
        }
        notificationRepository.saveAll(unreadNotifications);
        logger.info("✅ Marked {} notifications as read for caregiver ID: {}",
                unreadNotifications.size(), caregiverId);
    }

    // ========== PATIENT NOTIFICATION METHODS ==========

    /**
     * Get all notifications for a patient
     */
    public List<Notification> getPatientNotifications(Long patientId) {
        return notificationRepository.findByPatientIdOrderByCreatedAtDesc(patientId);
    }

    /**
     * Get unread notifications for a patient
     */
    public List<Notification> getPatientUnreadNotifications(Long patientId) {
        return notificationRepository.findByPatientIdAndIsReadOrderByCreatedAtDesc(patientId, false);
    }

    /**
     * Get read notifications for a patient
     */
    public List<Notification> getPatientReadNotifications(Long patientId) {
        return notificationRepository.findByPatientIdAndIsReadOrderByCreatedAtDesc(patientId, true);
    }

    /**
     * Count unread notifications for a patient
     */
    public Long countPatientUnreadNotifications(Long patientId) {
        return notificationRepository.countByPatientIdAndIsRead(patientId, false);
    }

    /**
     * Mark all notifications as read for a patient
     */
    public void markAllPatientNotificationsAsRead(Long patientId) {
        List<Notification> unreadNotifications = getPatientUnreadNotifications(patientId);
        for (Notification notification : unreadNotifications) {
            notification.setIsRead(true);
        }
        notificationRepository.saveAll(unreadNotifications);
        logger.info("✅ Marked {} notifications as read for patient ID: {}",
                unreadNotifications.size(), patientId);
    }

    /**
     * Delete all notifications for a patient
     */
    public void deleteAllPatientNotifications(Long patientId) {
        List<Notification> notifications = notificationRepository.findByPatientIdOrderByCreatedAtDesc(patientId);
        notificationRepository.deleteAll(notifications);
        logger.info("✅ Deleted {} notifications for patient ID: {}", notifications.size(), patientId);
    }
}
