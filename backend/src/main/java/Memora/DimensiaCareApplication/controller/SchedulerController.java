package Memora.DimensiaCareApplication.controller;

import Memora.DimensiaCareApplication.service.DailySchedulerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;

@RestController
@RequestMapping("/api/scheduler")
@CrossOrigin(origins = "*")
public class SchedulerController {

    @Autowired
    private DailySchedulerService dailySchedulerService;

    // Manually trigger schedule creation for today
    @PostMapping("/create-today")
    public ResponseEntity<?> createTodaySchedules() {
        try {
            dailySchedulerService.createTodaySchedulesManually();
            return ResponseEntity.ok(new ApiResponse(true, "Daily schedules created successfully for today"));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(new ApiResponse(false, "Error creating daily schedules: " + e.getMessage()));
        }
    }

    // Manually trigger schedule creation for a specific date
    @PostMapping("/create-for-date")
    public ResponseEntity<?> createSchedulesForDate(@RequestParam String date) {
        try {
            LocalDate targetDate = LocalDate.parse(date);
            dailySchedulerService.createSchedulesForDate(targetDate);
            return ResponseEntity.ok(new ApiResponse(true, "Daily schedules created successfully for " + date));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(new ApiResponse(false, "Error creating daily schedules: " + e.getMessage()));
        }
    }

    // API Response class
    public static class ApiResponse {
        private boolean success;
        private String message;

        public ApiResponse(boolean success, String message) {
            this.success = success;
            this.message = message;
        }

        // Getters and setters
        public boolean isSuccess() {
            return success;
        }

        public void setSuccess(boolean success) {
            this.success = success;
        }

        public String getMessage() {
            return message;
        }

        public void setMessage(String message) {
            this.message = message;
        }
    }
}
