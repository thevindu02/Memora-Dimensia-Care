package Memora.DimensiaCareApplication.service;

import Memora.DimensiaCareApplication.model.ScheduleSession;
import Memora.DimensiaCareApplication.repository.ScheduleSessionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class TaskNotificationScheduler {

    private static final Logger logger = LoggerFactory.getLogger(TaskNotificationScheduler.class);

    @Autowired
    private ScheduleSessionRepository scheduleSessionRepository;

    @Autowired
    private FCMNotificationService fcmNotificationService;

    @Autowired
    private UserFCMTokenService userFCMTokenService;

    // This map should be replaced with actual user-session mapping from your
    // database
    // Key: sessionId, Value: userId
    private Map<Integer, Integer> sessionUserMapping = new HashMap<>();

    /**
     * Check for upcoming tasks every 5 minutes
     * This will send notifications 15 minutes before the scheduled time
     */
    @Scheduled(fixedRate = 300000) // 5 minutes in milliseconds
    public void checkUpcomingTasks() {
        try {
            logger.info("Checking for upcoming tasks...");

            LocalDateTime now = LocalDateTime.now();
            LocalDateTime notificationWindow = now.plusMinutes(15);

            // Get all sessions scheduled for today
            List<ScheduleSession> todaySessions = scheduleSessionRepository
                    .findBySessionDate(LocalDate.now());

            for (ScheduleSession session : todaySessions) {
                LocalDateTime sessionDateTime = LocalDateTime.of(
                        session.getSessionDate(),
                        session.getSessionTime());

                // Check if session is within the notification window (15 minutes ahead)
                if (sessionDateTime.isAfter(now) && sessionDateTime.isBefore(notificationWindow)) {
                    sendSessionNotification(session);
                }
            }

        } catch (Exception e) {
            logger.error("Error in task notification scheduler: {}", e.getMessage());
        }
    }

    /**
     * Send notification for a specific session
     */
    private void sendSessionNotification(ScheduleSession session) {
        try {
            // Get the user ID associated with this session
            // You need to implement this based on your database schema
            Integer userId = getUserIdForSession(session.getId());

            if (userId == null) {
                logger.warn("No user found for session ID: {}", session.getId());
                return;
            }

            // Get all active FCM tokens for the user
            List<String> fcmTokens = userFCMTokenService.getActiveTokensForUser(userId);

            if (fcmTokens.isEmpty()) {
                logger.warn("No active FCM tokens found for user ID: {}", userId);
                return;
            }

            // Prepare notification data
            String title = "Upcoming Session Reminder";
            String body = String.format("%s is scheduled at %s",
                    session.getSessionTopic(),
                    session.getSessionTime().toString());

            Map<String, String> data = new HashMap<>();
            data.put("type", "session_reminder");
            data.put("sessionId", String.valueOf(session.getId()));
            data.put("sessionTopic", session.getSessionTopic());
            data.put("sessionDate", session.getSessionDate().toString());
            data.put("sessionTime", session.getSessionTime().toString());

            if (session.getMeetingLink() != null) {
                data.put("meetingLink", session.getMeetingLink());
            }

            // Send notification to all user's devices
            fcmNotificationService.sendNotificationToMultipleDevices(fcmTokens, title, body, data);

            logger.info("Sent notification for session ID: {} to user ID: {}",
                    session.getId(), userId);

        } catch (Exception e) {
            logger.error("Error sending session notification for session ID {}: {}",
                    session.getId(), e.getMessage());
        }
    }

    /**
     * Get user ID for a session
     * TODO: Implement this method based on your database schema
     * This is a placeholder - you need to implement the actual logic
     */
    private Integer getUserIdForSession(Integer sessionId) {
        // Option 1: If you have a user_id column in schedule_sessions table
        // return scheduleSessionRepository.findById(sessionId)
        // .map(ScheduleSession::getUserId)
        // .orElse(null);

        // Option 2: If you have a separate mapping table
        // return sessionUserRepository.findUserIdBySessionId(sessionId);

        // Placeholder implementation
        return sessionUserMapping.get(sessionId);
    }

    /**
     * Send immediate notification for a specific session
     * This can be called when a task is created or updated
     */
    public void sendImmediateNotification(Integer sessionId, Integer userId) {
        try {
            ScheduleSession session = scheduleSessionRepository.findById(sessionId)
                    .orElseThrow(() -> new RuntimeException("Session not found"));

            List<String> fcmTokens = userFCMTokenService.getActiveTokensForUser(userId);

            if (fcmTokens.isEmpty()) {
                logger.warn("No active FCM tokens found for user ID: {}", userId);
                return;
            }

            String title = "New Session Scheduled";
            String body = String.format("%s is scheduled for %s at %s",
                    session.getSessionTopic(),
                    session.getSessionDate().toString(),
                    session.getSessionTime().toString());

            Map<String, String> data = new HashMap<>();
            data.put("type", "session_created");
            data.put("sessionId", String.valueOf(session.getId()));
            data.put("sessionTopic", session.getSessionTopic());
            data.put("sessionDate", session.getSessionDate().toString());
            data.put("sessionTime", session.getSessionTime().toString());

            fcmNotificationService.sendNotificationToMultipleDevices(fcmTokens, title, body, data);

            logger.info("Sent immediate notification for session ID: {} to user ID: {}",
                    sessionId, userId);

        } catch (Exception e) {
            logger.error("Error sending immediate notification: {}", e.getMessage());
        }
    }
}
