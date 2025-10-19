package Memora.DimensiaCareApplication.repository;

import Memora.DimensiaCareApplication.model.Notification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface NotificationRepository extends JpaRepository<Notification, Long> {

    // Find all notifications for a specific caregiver
    List<Notification> findByCaregiverIdOrderByCreatedAtDesc(Long caregiverId);

    // Find unread notifications for a caregiver
    List<Notification> findByCaregiverIdAndIsReadOrderByCreatedAtDesc(Long caregiverId, Boolean isRead);

    // Count unread notifications for a caregiver
    Long countByCaregiverIdAndIsRead(Long caregiverId, Boolean isRead);

    // Find notifications by type for a caregiver
    List<Notification> findByCaregiverIdAndNotificationTypeOrderByCreatedAtDesc(
            Long caregiverId, String notificationType);
}
