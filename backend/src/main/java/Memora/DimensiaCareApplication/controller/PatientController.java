package Memora.DimensiaCareApplication.controller;

import Memora.DimensiaCareApplication.dto.request.PatientRequest;
import Memora.DimensiaCareApplication.model.Patient;
import Memora.DimensiaCareApplication.service.PatientService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import Memora.DimensiaCareApplication.dto.response.PatientDetailsResponse;

@RestController
@RequestMapping("/api/patients")
public class PatientController {

    @Autowired
    private PatientService patientService;

    @PostMapping
    public ResponseEntity<Patient> addPatient(@RequestBody PatientRequest request) {
        Patient patient = new Patient();
        patient.setDementiaStage(request.getDementiaStage());
        patient.setDateOfDiagnosis(request.getDateOfDiagnosis());
        patient.setDementiaType(request.getDementiaType());
        patient.setRelationship(request.getRelationship());
        Patient savedPatient = patientService.addPatient(patient, request.getUserId(), request.getGuardianId());
        return ResponseEntity.ok(savedPatient);
    }

    @GetMapping("/by-guardian/{guardianId}")
    public ResponseEntity<List<PatientDetailsResponse>> getPatientsByGuardian(@PathVariable Long guardianId) {
        List<Patient> patients = patientService.getPatientsByGuardian(guardianId);
        List<PatientDetailsResponse> response = patients.stream()
                .map(PatientDetailsResponse::fromPatient)
                .collect(Collectors.toList());
        return ResponseEntity.ok(response);
    }

    @GetMapping("/{patientId}")
    public ResponseEntity<PatientDetailsResponse> getPatientById(@PathVariable Long patientId) {
        PatientDetailsResponse resp = patientService.getPatientDetailsWithAcceptedDate(patientId);
        if (resp == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(resp);
    }

    // New endpoints for patient dashboard
    @GetMapping("/{patientId}/profile")
    public ResponseEntity<?> getPatientProfile(@PathVariable Long patientId) {
        try {
            var profile = patientService.getPatientProfile(patientId);
            return ResponseEntity.ok(profile);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error fetching patient profile: " + e.getMessage());
        }
    }

    @GetMapping("/{patientId}/schedule")
    public ResponseEntity<?> getPatientSchedule(
            @PathVariable Long patientId,
            @RequestParam String date) {
        try {
            var tasks = patientService.getScheduleForDate(patientId, date);
            return ResponseEntity.ok(tasks);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error fetching schedule: " + e.getMessage());
        }
    }

    @PostMapping("/{patientId}/tasks")
    public ResponseEntity<?> createTask(
            @PathVariable Long patientId,
            @RequestBody Memora.DimensiaCareApplication.dto.CreateTaskRequestDTO request) {
        try {
            var task = patientService.createTask(patientId, request);
            return ResponseEntity.ok(task);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error creating task: " + e.getMessage());
        }
    }

    @PutMapping("/tasks/{careActivityId}/status")
    public ResponseEntity<?> updateTaskStatus(
            @PathVariable Long careActivityId,
            @RequestBody Memora.DimensiaCareApplication.dto.UpdateTaskStatusDTO request) {
        try {
            patientService.updateTaskStatus(careActivityId, request);
            return ResponseEntity.ok("Task status updated successfully");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error updating task status: " + e.getMessage());
        }
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<?> getPatientByUserId(@PathVariable Long userId) {
        try {
            var patient = patientService.getPatientByUserId(userId);
            if (patient != null) {
                return ResponseEntity.ok(Map.of("patientId", patient.getPatientID()));
            } else {
                return ResponseEntity.status(404).body("Patient not found for user ID: " + userId);
            }
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error fetching patient: " + e.getMessage());
        }
    }
}
