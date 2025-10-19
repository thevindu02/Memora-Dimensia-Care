package Memora.DimensiaCareApplication.controller;

import Memora.DimensiaCareApplication.service.TaskReminderScheduler;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/test")
@CrossOrigin(origins = "*")
public class TestReminderController {

    @Autowired
    private TaskReminderScheduler taskReminderScheduler;

    @Autowired
    private Memora.DimensiaCareApplication.repository.CareActivityRepository careActivityRepository;

    /**
     * Manually trigger the scheduler to check for upcoming tasks
     * Useful for testing without waiting 5 minutes
     */
    @PostMapping("/check-reminders")
    public ResponseEntity<Map<String, String>> triggerReminderCheck() {
        try {
            // Manually trigger the scheduler
            taskReminderScheduler.checkUpcomingTasks();

            Map<String, String> response = new HashMap<>();
            response.put("status", "success");
            response.put("message", "Reminder check triggered successfully. Check backend logs for details.");

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, String> response = new HashMap<>();
            response.put("status", "error");
            response.put("message", "Error triggering reminder check: " + e.getMessage());

            return ResponseEntity.internalServerError().body(response);
        }
    }

    /**
     * Send a test reminder for a specific activity ID
     */
    @PostMapping("/send-reminder/{activityId}")
    public ResponseEntity<Map<String, String>> sendTestReminder(@PathVariable Long activityId) {
        try {
            taskReminderScheduler.sendTestReminder(activityId);

            Map<String, String> response = new HashMap<>();
            response.put("status", "success");
            response.put("message", "Test reminder sent for activity ID: " + activityId);

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, String> response = new HashMap<>();
            response.put("status", "error");
            response.put("message", "Error sending test reminder: " + e.getMessage());

            return ResponseEntity.internalServerError().body(response);
        }
    }

    /**
     * Get scheduler status
     */
    @GetMapping("/scheduler-status")
    public ResponseEntity<Map<String, String>> getSchedulerStatus() {
        Map<String, String> response = new HashMap<>();
        response.put("status", "active");
        response.put("message", "Task Reminder Scheduler is running. Checks every 5 minutes.");
        response.put("reminderWindow", "4 minutes before task");

        return ResponseEntity.ok(response);
    }

    /**
     * Get current time and recommended task time for testing
     */
    @GetMapping("/test-time-info")
    public ResponseEntity<Map<String, String>> getTestTimeInfo() {
        java.time.LocalDateTime now = java.time.LocalDateTime.now();
        java.time.LocalDateTime recommended = now.plusMinutes(4);

        Map<String, String> response = new HashMap<>();
        response.put("currentTime", now.toString());
        response.put("recommendedTaskTime", recommended.toString());
        response.put("instructions",
                "Create a task with time: " + recommended.toLocalTime() + " to test notifications");
        response.put("windowStart", now.toString());
        response.put("windowEnd", recommended.toString());

        return ResponseEntity.ok(response);
    }

    /**
     * Debug: Show all tasks for today and their times
     */
    @GetMapping("/debug-todays-tasks")
    public ResponseEntity<?> debugTodaysTasks() {
        try {
            java.time.LocalDateTime now = java.time.LocalDateTime.now();
            java.time.LocalDateTime windowEnd = now.plusMinutes(4);

            Map<String, Object> response = new HashMap<>();
            response.put("currentTime", now.toString());
            response.put("reminderWindowStart", now.toString());
            response.put("reminderWindowEnd", windowEnd.toString());
            response.put("reminderMinutes", 4);

            // Get today's activities
            java.util.List<Memora.DimensiaCareApplication.model.CareActivity> activities = careActivityRepository
                    .findActivitiesForToday(java.time.LocalDate.now());

            java.util.List<Map<String, Object>> taskList = new java.util.ArrayList<>();
            for (Memora.DimensiaCareApplication.model.CareActivity activity : activities) {
                Map<String, Object> taskInfo = new HashMap<>();
                java.time.LocalDateTime taskDateTime = java.time.LocalDateTime.of(
                        activity.getSchedule().getDate(),
                        activity.getTime());

                taskInfo.put("activityId", activity.getCareActivityId());
                taskInfo.put("scheduledTime", taskDateTime.toString());
                taskInfo.put("status", activity.getStatus().toString());
                taskInfo.put("isInWindow", taskDateTime.isAfter(now) && taskDateTime.isBefore(windowEnd));
                taskInfo.put("minutesUntilTask", java.time.Duration.between(now, taskDateTime).toMinutes());

                // Try to get task name
                try {
                    if (!activity.getDailyTasks().isEmpty()) {
                        taskInfo.put("taskName", activity.getDailyTasks().iterator().next().getDailyTaskName());
                        taskInfo.put("taskType", "DailyTask");
                    } else if (!activity.getTasks().isEmpty()) {
                        taskInfo.put("taskName", activity.getTasks().iterator().next().getGame().getName());
                        taskInfo.put("taskType", "GameTask");
                    } else {
                        taskInfo.put("taskName", "Unknown");
                        taskInfo.put("taskType", "Unknown");
                    }
                } catch (Exception e) {
                    taskInfo.put("taskName", "Error: " + e.getMessage());
                }

                taskList.add(taskInfo);
            }

            response.put("totalTasksToday", activities.size());
            response.put("tasks", taskList);

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return ResponseEntity.internalServerError().body(error);
        }
    }
}
