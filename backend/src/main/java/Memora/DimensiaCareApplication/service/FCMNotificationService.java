package Memora.DimensiaCareApplication.service;

import com.google.firebase.messaging.*;
import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class FCMNotificationService {

    private static final Logger logger = LoggerFactory.getLogger(FCMNotificationService.class);

    /**
     * Send notification to a single device
     */
    public void sendNotificationToDevice(String fcmToken, String title, String body, Map<String, String> data) {
        try {
            // Build notification
            Notification notification = Notification.builder()
                    .setTitle(title)
                    .setBody(body)
                    .build();

            // Build message
            Message.Builder messageBuilder = Message.builder()
                    .setToken(fcmToken)
                    .setNotification(notification);

            // Add data if provided
            if (data != null && !data.isEmpty()) {
                messageBuilder.putAllData(data);
            }

            // Send message
            String response = FirebaseMessaging.getInstance().send(messageBuilder.build());
            logger.info("Successfully sent message: {}", response);

        } catch (FirebaseMessagingException e) {
            logger.error("Error sending FCM notification to token {}: {}", fcmToken, e.getMessage());
        }
    }

    /**
     * Send notification to multiple devices
     */
    public void sendNotificationToMultipleDevices(List<String> fcmTokens, String title, String body,
            Map<String, String> data) {
        if (fcmTokens == null || fcmTokens.isEmpty()) {
            logger.warn("No FCM tokens provided");
            return;
        }

        try {
            // Build notification
            Notification notification = Notification.builder()
                    .setTitle(title)
                    .setBody(body)
                    .build();

            // Build multicast message
            MulticastMessage.Builder messageBuilder = MulticastMessage.builder()
                    .addAllTokens(fcmTokens)
                    .setNotification(notification);

            // Add data if provided
            if (data != null && !data.isEmpty()) {
                messageBuilder.putAllData(data);
            }

            // Send message
            BatchResponse response = FirebaseMessaging.getInstance().sendEachForMulticast(messageBuilder.build());
            logger.info("Successfully sent {} messages, {} failures",
                    response.getSuccessCount(), response.getFailureCount());

            // Log failures
            if (response.getFailureCount() > 0) {
                List<SendResponse> responses = response.getResponses();
                for (int i = 0; i < responses.size(); i++) {
                    if (!responses.get(i).isSuccessful()) {
                        logger.error("Failed to send to token {}: {}",
                                fcmTokens.get(i), responses.get(i).getException().getMessage());
                    }
                }
            }

        } catch (FirebaseMessagingException e) {
            logger.error("Error sending multicast FCM notification: {}", e.getMessage());
        }
    }

    /**
     * Send task reminder notification
     */
    public void sendTaskReminder(String fcmToken, String taskName, String taskTime, Integer taskId) {
        Map<String, String> data = new HashMap<>();
        data.put("type", "task_reminder");
        data.put("taskId", String.valueOf(taskId));
        data.put("taskName", taskName);
        data.put("taskTime", taskTime);

        String title = "Task Reminder";
        String body = String.format("%s is scheduled at %s", taskName, taskTime);

        sendNotificationToDevice(fcmToken, title, body, data);
    }

    /**
     * Send scheduled session reminder
     */
    public void sendSessionReminder(String fcmToken, String sessionTopic, String sessionDate,
            String sessionTime, Integer sessionId) {
        Map<String, String> data = new HashMap<>();
        data.put("type", "session_reminder");
        data.put("sessionId", String.valueOf(sessionId));
        data.put("sessionTopic", sessionTopic);
        data.put("sessionDate", sessionDate);
        data.put("sessionTime", sessionTime);

        String title = "Session Reminder";
        String body = String.format("%s scheduled for %s at %s", sessionTopic, sessionDate, sessionTime);

        sendNotificationToDevice(fcmToken, title, body, data);
    }

    /**
     * Send notification to topic (for broadcasting)
     */
    public void sendNotificationToTopic(String topic, String title, String body, Map<String, String> data) {
        try {
            Notification notification = Notification.builder()
                    .setTitle(title)
                    .setBody(body)
                    .build();

            Message.Builder messageBuilder = Message.builder()
                    .setTopic(topic)
                    .setNotification(notification);

            if (data != null && !data.isEmpty()) {
                messageBuilder.putAllData(data);
            }

            String response = FirebaseMessaging.getInstance().send(messageBuilder.build());
            logger.info("Successfully sent message to topic {}: {}", topic, response);

        } catch (FirebaseMessagingException e) {
            logger.error("Error sending FCM notification to topic {}: {}", topic, e.getMessage());
        }
    }
}
