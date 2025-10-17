package Memora.DimensiaCareApplication.controller;

import Memora.DimensiaCareApplication.model.ScheduleSession;
import Memora.DimensiaCareApplication.dto.ScheduleSessionCreateDTO;
import Memora.DimensiaCareApplication.service.ScheduleSessionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/schedule-sessions")
@CrossOrigin(origins = "*")
public class ScheduleSessionController {

    @Autowired
    private ScheduleSessionService scheduleSessionService;

    @PostMapping
    public ResponseEntity<?> createScheduleSession(@RequestBody ScheduleSessionCreateDTO request) {
        try {
            // Validate required fields
            if (request.getSessionDate() == null || request.getSessionDate().trim().isEmpty()) {
                return ResponseEntity.badRequest().body("Session date is required");
            }
            if (request.getSessionTime() == null || request.getSessionTime().trim().isEmpty()) {
                return ResponseEntity.badRequest().body("Session time is required");
            }
            if (request.getSessionTopic() == null || request.getSessionTopic().trim().isEmpty()) {
                return ResponseEntity.badRequest().body("Session topic is required");
            }

            ScheduleSession scheduleSession = scheduleSessionService.createScheduleSession(request);
            return ResponseEntity.status(201).body(scheduleSession);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body("Error creating schedule session: " + e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body("Error creating schedule session: " + e.getMessage());
        }
    }

    @GetMapping
    public ResponseEntity<List<ScheduleSession>> getAllScheduleSessions() {
        try {
            List<ScheduleSession> sessions = scheduleSessionService.getAllScheduleSessions();
            return ResponseEntity.ok(sessions);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getScheduleSessionById(@PathVariable Integer id) {
        try {
            return scheduleSessionService.getScheduleSessionById(id)
                    .map(ResponseEntity::ok)
                    .orElse(ResponseEntity.notFound().build());
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body("Error retrieving schedule session: " + e.getMessage());
        }
    }

    @GetMapping("/date/{date}")
    public ResponseEntity<?> getScheduleSessionsByDate(@PathVariable String date) {
        try {
            LocalDate sessionDate = LocalDate.parse(date);
            List<ScheduleSession> sessions = scheduleSessionService.getScheduleSessionsByDate(sessionDate);
            return ResponseEntity.ok(sessions);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error retrieving schedule sessions: " + e.getMessage());
        }
    }

    @GetMapping("/date-range")
    public ResponseEntity<?> getScheduleSessionsByDateRange(
            @RequestParam String startDate,
            @RequestParam String endDate) {
        try {
            LocalDate start = LocalDate.parse(startDate);
            LocalDate end = LocalDate.parse(endDate);
            List<ScheduleSession> sessions = scheduleSessionService.getScheduleSessionsByDateRange(start, end);
            return ResponseEntity.ok(sessions);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error retrieving schedule sessions: " + e.getMessage());
        }
    }

    @GetMapping("/topic/{topic}")
    public ResponseEntity<?> getScheduleSessionsByTopic(@PathVariable String topic) {
        try {
            List<ScheduleSession> sessions = scheduleSessionService.getScheduleSessionsByTopic(topic);
            return ResponseEntity.ok(sessions);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body("Error retrieving schedule sessions: " + e.getMessage());
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> updateScheduleSession(
            @PathVariable Integer id,
            @RequestBody ScheduleSessionCreateDTO request) {
        try {
            ScheduleSession updatedSession = scheduleSessionService.updateScheduleSession(id, request);
            return ResponseEntity.ok(updatedSession);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body("Error updating schedule session: " + e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body("Error updating schedule session: " + e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteScheduleSession(@PathVariable Integer id) {
        try {
            scheduleSessionService.deleteScheduleSession(id);
            return ResponseEntity.ok().body("Schedule session deleted successfully");
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body("Error deleting schedule session: " + e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body("Error deleting schedule session: " + e.getMessage());
        }
    }
} 