package Memora.DimensiaCareApplication.controller;

import Memora.DimensiaCareApplication.model.*;
import Memora.DimensiaCareApplication.dto.DailyActivityRequest;
import Memora.DimensiaCareApplication.dto.DailyActivityResponse;
import Memora.DimensiaCareApplication.service.ScheduleService;
import Memora.DimensiaCareApplication.repository.PatientRepository;
import Memora.DimensiaCareApplication.repository.GuardianRepository;
import Memora.DimensiaCareApplication.repository.CaregiverRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/schedules")
@CrossOrigin(origins = "*")
public class ScheduleController {

    @Autowired
    private ScheduleService scheduleService;

    @Autowired
    private PatientRepository patientRepository;

    @Autowired
    private GuardianRepository guardianRepository;

    @Autowired
    private CaregiverRepository caregiverRepository;

    // Create a new schedule with default daily tasks
    @PostMapping("/create")
    public ResponseEntity<?> createSchedule(@RequestBody ScheduleRequest request) {
        try {
            // Check if schedule already exists for this patient on this date
            if (scheduleService.scheduleExistsForPatientOnDate(request.getPatientId(), request.getDate())) {
                return ResponseEntity.badRequest()
                        .body(new ApiResponse(false,
                                "Schedule already exists for this patient on " + request.getDate()));
            }

            // Get the required entities
            Patient patient = patientRepository.findById(request.getPatientId()).orElse(null);
            Guardian guardian = guardianRepository.findById(request.getGuardianId()).orElse(null);
            Caregiver caregiver = caregiverRepository.findById(request.getCaregiverId()).orElse(null);

            if (patient == null) {
                return ResponseEntity.badRequest()
                        .body(new ApiResponse(false, "Patient not found"));
            }
            if (guardian == null) {
                return ResponseEntity.badRequest()
                        .body(new ApiResponse(false, "Guardian not found"));
            }
            if (caregiver == null) {
                return ResponseEntity.badRequest()
                        .body(new ApiResponse(false, "Caregiver not found"));
            }

            // Create schedule with default daily tasks
            Schedule schedule = scheduleService.createScheduleWithDefaultTasks(
                    patient, guardian, caregiver, request.getDate());

            return ResponseEntity
                    .ok(new ScheduleResponse(true, "Schedule created successfully with default daily tasks", schedule));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(new ApiResponse(false, "Error creating schedule: " + e.getMessage()));
        }
    }

    // Get all schedules
    @GetMapping
    public ResponseEntity<List<Schedule>> getAllSchedules() {
        List<Schedule> schedules = scheduleService.getAllSchedules();
        return ResponseEntity.ok(schedules);
    }

    // Get schedule by ID
    @GetMapping("/{id}")
    public ResponseEntity<?> getScheduleById(@PathVariable Long id) {
        Optional<Schedule> schedule = scheduleService.getScheduleById(id);
        if (schedule.isPresent()) {
            return ResponseEntity.ok(schedule.get());
        }
        return ResponseEntity.notFound().build();
    }

    // Get schedules by patient ID
    @GetMapping("/patient/{patientId}")
    public ResponseEntity<List<Schedule>> getSchedulesByPatientId(@PathVariable Long patientId) {
        List<Schedule> schedules = scheduleService.getSchedulesByPatientId(patientId);
        return ResponseEntity.ok(schedules);
    }

    // Get schedules by caregiver ID
    @GetMapping("/caregiver/{caregiverId}")
    public ResponseEntity<List<Schedule>> getSchedulesByCaregiverId(@PathVariable Integer caregiverId) {
        List<Schedule> schedules = scheduleService.getSchedulesByCaregiverId(caregiverId);
        return ResponseEntity.ok(schedules);
    }

    // Get schedules by guardian ID
    @GetMapping("/guardian/{guardianId}")
    public ResponseEntity<List<Schedule>> getSchedulesByGuardianId(@PathVariable Long guardianId) {
        List<Schedule> schedules = scheduleService.getSchedulesByGuardianId(guardianId);
        return ResponseEntity.ok(schedules);
    }

    // Update schedule completion status
    @PutMapping("/{id}/completion")
    public ResponseEntity<?> updateScheduleCompletion(@PathVariable Long id, @RequestParam boolean isCompleted) {
        try {
            Schedule updatedSchedule = scheduleService.updateScheduleCompletion(id, isCompleted);
            return ResponseEntity.ok(new ScheduleResponse(true, "Schedule completion status updated", updatedSchedule));
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    // Delete schedule
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteSchedule(@PathVariable Long id) {
        try {
            scheduleService.deleteSchedule(id);
            return ResponseEntity.ok(new ApiResponse(true, "Schedule deleted successfully"));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(new ApiResponse(false, "Error deleting schedule: " + e.getMessage()));
        }
    }

    // Get incomplete schedules
    @GetMapping("/incomplete")
    public ResponseEntity<List<Schedule>> getIncompleteSchedules() {
        List<Schedule> schedules = scheduleService.getIncompleteSchedules();
        return ResponseEntity.ok(schedules);
    }

    // Get completed schedules
    @GetMapping("/completed")
    public ResponseEntity<List<Schedule>> getCompletedSchedules() {
        List<Schedule> schedules = scheduleService.getCompletedSchedules();
        return ResponseEntity.ok(schedules);
    }

    // ===== DAILY ACTIVITIES ENDPOINTS =====

    // Add daily activity to schedule
    @PostMapping("/{scheduleId}/daily-activities")
    public ResponseEntity<?> addDailyActivity(@PathVariable Long scheduleId,
            @RequestBody DailyActivityRequest request) {
        try {
            DailyActivityResponse response = scheduleService.addDailyActivity(scheduleId, request);
            return ResponseEntity.ok(new ApiResponse(true, "Daily activity added successfully", response));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest()
                    .body(new ApiResponse(false, "Error adding daily activity: " + e.getMessage()));
        }
    }

    // Get daily activities by schedule ID
    @GetMapping("/{scheduleId}/daily-activities")
    public ResponseEntity<?> getDailyActivitiesBySchedule(@PathVariable Long scheduleId) {
        try {
            List<DailyActivityResponse> activities = scheduleService.getDailyActivitiesBySchedule(scheduleId);
            return ResponseEntity.ok(new ApiResponse(true, "Daily activities retrieved successfully", activities));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest()
                    .body(new ApiResponse(false, "Error retrieving daily activities: " + e.getMessage()));
        }
    }

    // Update daily activity
    @PutMapping("/daily-activities/{careActivityId}")
    public ResponseEntity<?> updateDailyActivity(@PathVariable Long careActivityId,
            @RequestBody DailyActivityRequest request) {
        try {
            DailyActivityResponse response = scheduleService.updateDailyActivity(careActivityId, request);
            return ResponseEntity.ok(new ApiResponse(true, "Daily activity updated successfully", response));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest()
                    .body(new ApiResponse(false, "Error updating daily activity: " + e.getMessage()));
        }
    }

    // Delete daily activity
    @DeleteMapping("/daily-activities/{careActivityId}")
    public ResponseEntity<?> deleteDailyActivity(@PathVariable Long careActivityId) {
        try {
            scheduleService.deleteDailyActivity(careActivityId);
            return ResponseEntity.ok(new ApiResponse(true, "Daily activity deleted successfully"));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest()
                    .body(new ApiResponse(false, "Error deleting daily activity: " + e.getMessage()));
        }
    }

    // Request DTO
    public static class ScheduleRequest {
        private Long patientId;
        private Long guardianId;
        private Integer caregiverId;
        private LocalDate date;

        // Getters and setters
        public Long getPatientId() {
            return patientId;
        }

        public void setPatientId(Long patientId) {
            this.patientId = patientId;
        }

        public Long getGuardianId() {
            return guardianId;
        }

        public void setGuardianId(Long guardianId) {
            this.guardianId = guardianId;
        }

        public Integer getCaregiverId() {
            return caregiverId;
        }

        public void setCaregiverId(Integer caregiverId) {
            this.caregiverId = caregiverId;
        }

        public LocalDate getDate() {
            return date;
        }

        public void setDate(LocalDate date) {
            this.date = date;
        }
    }

    // Response DTOs
    public static class ApiResponse {
        private boolean success;
        private String message;
        private Object data;

        public ApiResponse(boolean success, String message) {
            this.success = success;
            this.message = message;
        }

        public ApiResponse(boolean success, String message, Object data) {
            this.success = success;
            this.message = message;
            this.data = data;
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

        public Object getData() {
            return data;
        }

        public void setData(Object data) {
            this.data = data;
        }
    }

    public static class ScheduleResponse extends ApiResponse {
        private Schedule schedule;

        public ScheduleResponse(boolean success, String message, Schedule schedule) {
            super(success, message);
            this.schedule = schedule;
        }

        public Schedule getSchedule() {
            return schedule;
        }

        public void setSchedule(Schedule schedule) {
            this.schedule = schedule;
        }
    }
}
