package Memora.DimensiaCareApplication.controller;

import java.util.List;
import java.util.stream.Collectors;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import Memora.DimensiaCareApplication.dto.request.PatientRequest;
import Memora.DimensiaCareApplication.dto.response.PatientDetailsResponse;
import Memora.DimensiaCareApplication.model.Patient;
import Memora.DimensiaCareApplication.service.PatientService;
import Memora.DimensiaCareApplication.service.SubscriptionService;

@RestController
@CrossOrigin(origins = "*")
@RequestMapping("/api/patients")
public class PatientController {

    @Autowired
    private PatientService patientService;

    @Autowired
    private SubscriptionService subscriptionService;

    @PostMapping
    public ResponseEntity<Patient> addPatient(@RequestBody PatientRequest request) {
        Patient patient = new Patient();
        patient.setDementiaStage(request.getDementiaStage());
        patient.setDateOfDiagnosis(request.getDateOfDiagnosis());
        patient.setDementiaType(request.getDementiaType());
        patient.setRelationship(request.getRelationship());
        Patient savedPatient = patientService.addPatient(patient, request.getUserId(), request.getGuardianId());

        // Create pending subscription for new patient
        try {
            subscriptionService.createPendingSubscription(request.getGuardianId(), savedPatient.getPatientID());
            System.out.println("Created pending subscription for patient " + savedPatient.getPatientID());
        } catch (Exception e) {
            System.err.println("Failed to create subscription for patient: " + e.getMessage());
            // Don't fail patient creation if subscription creation fails
        }

        return ResponseEntity.ok(savedPatient);
    }

    @GetMapping("/by-guardian/{guardianId}")
    public ResponseEntity<List<PatientDetailsResponse>> getPatientsByGuardian(@PathVariable Long guardianId) {
        List<Patient> patients = patientService.getPatientsByGuardian(guardianId);
        List<PatientDetailsResponse> response = patients.stream()
                .map(patient -> patientService.getPatientDetailsWithAcceptedDate(patient.getPatientID()))
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

    @GetMapping
    public ResponseEntity<List<PatientDetailsResponse>> getAllPatients() {
        List<PatientDetailsResponse> patients = patientService.getAllPatients();
        return ResponseEntity.ok(patients);
    }
}