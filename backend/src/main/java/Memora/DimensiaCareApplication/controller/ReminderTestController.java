package Memora.DimensiaCareApplication.controller;

import Memora.DimensiaCareApplication.service.TaskReminderScheduler;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/test/reminders")
@CrossOrigin(origins = "*")
public class ReminderTestController {

    @Autowired
    private TaskReminderScheduler taskReminderScheduler;

    /**
     * Clear all reminder cache
     * POST /api/test/reminders/clear
     */
    @PostMapping("/clear")
    public ResponseEntity<Map<String, String>> clearAllReminders() {
        taskReminderScheduler.clearReminderCache();

        Map<String, String> response = new HashMap<>();
        response.put("message", "All reminder cache cleared successfully");
        response.put("status", "success");

        return ResponseEntity.ok(response);
    }

    /**
     * Clear specific reminder cache for an activity
     * POST /api/test/reminders/clear/{activityId}
     */
    @PostMapping("/clear/{activityId}")
    public ResponseEntity<Map<String, String>> clearSpecificReminder(@PathVariable Long activityId) {
        taskReminderScheduler.clearSpecificReminder(activityId);

        Map<String, String> response = new HashMap<>();
        response.put("message", "Reminder cache cleared for activity ID: " + activityId);
        response.put("status", "success");

        return ResponseEntity.ok(response);
    }

    /**
     * Send test reminder for an activity
     * POST /api/test/reminders/send/{activityId}
     */
    @PostMapping("/send/{activityId}")
    public ResponseEntity<Map<String, String>> sendTestReminder(@PathVariable Long activityId) {
        taskReminderScheduler.sendTestReminder(activityId);

        Map<String, String> response = new HashMap<>();
        response.put("message", "Test reminder sent for activity ID: " + activityId);
        response.put("status", "success");

        return ResponseEntity.ok(response);
    }

    /**
     * Clear cache and send reminder for an activity
     * POST /api/test/reminders/resend/{activityId}
     */
    @PostMapping("/resend/{activityId}")
    public ResponseEntity<Map<String, String>> resendReminder(@PathVariable Long activityId) {
        taskReminderScheduler.clearSpecificReminder(activityId);
        taskReminderScheduler.sendTestReminder(activityId);

        Map<String, String> response = new HashMap<>();
        response.put("message", "Cache cleared and reminder sent for activity ID: " + activityId);
        response.put("status", "success");

        return ResponseEntity.ok(response);
    }
}
