package Memora.DimensiaCareApplication.controller;

import Memora.DimensiaCareApplication.model.Guardian;
import Memora.DimensiaCareApplication.repository.GuardianRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import Memora.DimensiaCareApplication.model.User;
import org.springframework.web.bind.annotation.PathVariable;
import Memora.DimensiaCareApplication.dto.response.GuardianDetailsResponse;
import Memora.DimensiaCareApplication.model.GuardianPatientCaregiverConnection;
import Memora.DimensiaCareApplication.service.GuardianService;
import Memora.DimensiaCareApplication.repository.PatientRepository;
import Memora.DimensiaCareApplication.repository.CaregiverRepository;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;
import java.util.HashMap;
import Memora.DimensiaCareApplication.model.Patient;
import Memora.DimensiaCareApplication.repository.GuardianPatientCaregiverConnectionRepository;
import org.springframework.web.bind.annotation.RequestBody;
import Memora.DimensiaCareApplication.model.Caregiver;

@RestController
@RequestMapping("/api/guardians")
public class GuardianController {

    @Autowired
    private GuardianRepository guardianRepository;

    @Autowired
    private GuardianService guardianService;

    @Autowired
    private PatientRepository patientRepository;
    @Autowired
    private CaregiverRepository caregiverRepository;
    @Autowired
    private GuardianPatientCaregiverConnectionRepository connectionRepository;

    @GetMapping("/by-user/{userId}")
    public ResponseEntity<Long> getGuardianIdByUserId(@PathVariable Long userId) {
        Guardian guardian = guardianRepository.findByUser_Id(userId);
        if (guardian != null) {
            return ResponseEntity.ok(guardian.getGuardianId());
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @GetMapping("/{guardianId}")
    public ResponseEntity<GuardianDetailsResponse> getGuardianById(@PathVariable Long guardianId) {
        Guardian guardian = guardianRepository.findById(guardianId).orElse(null);
        if (guardian != null && guardian.getUser() != null) {
            User user = guardian.getUser();
            GuardianDetailsResponse resp = new GuardianDetailsResponse();
            resp.setGuardianId(guardian.getGuardianId());
            resp.setName(user.getFName() + " " + user.getLName());
            resp.setEmail(user.getEmail());
            resp.setPhone(user.getPhoneNumber());
            resp.setCity(user.getCity());
            return ResponseEntity.ok(resp);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @GetMapping("/{guardianId}/patients-with-request-status")
    public ResponseEntity<List<Map<String, Object>>> getPatientsWithRequestStatus(@PathVariable Long guardianId) {
        List<Patient> patients = patientRepository.findByGuardian_GuardianId(guardianId);
        List<Map<String, Object>> result = new ArrayList<>();
        for (Patient patient : patients) {
            Map<String, Object> map = new HashMap<>();
            map.put("guardianId", patient.getGuardian() != null ? patient.getGuardian().getGuardianId() : null);
            map.put("patientId", patient.getPatientID());
            map.put("name", patient.getUser().getFName() + " " + patient.getUser().getLName());
            map.put("city", patient.getUser().getCity());
            map.put("relationship", patient.getRelationship());
            map.put("dementiaType", patient.getDementiaType() != null ? patient.getDementiaType().name() : "");
            map.put("dementiaStage", patient.getDementiaStage() != null ? patient.getDementiaStage().name() : "");
            // Guardian info
            if (patient.getGuardian() != null && patient.getGuardian().getUser() != null) {
                User gUser = patient.getGuardian().getUser();
                map.put("guardianName", gUser.getFName() + " " + gUser.getLName());
                map.put("guardianEmail", gUser.getEmail());
                map.put("guardianPhone", gUser.getPhoneNumber());
                map.put("guardianCity", gUser.getCity());
            } else {
                map.put("guardianName", "N/A");
                map.put("guardianEmail", "N/A");
                map.put("guardianPhone", "N/A");
                map.put("guardianCity", "N/A");
            }
            // Find latest connection request for this patient (unknown caregiver only)
            List<GuardianPatientCaregiverConnection> connections = connectionRepository.findByPatientId(patient.getPatientID());
            GuardianPatientCaregiverConnection latest = connections.stream()
                .filter(conn -> conn.getCaregiverId() != null) // unknown caregiver
                .max(Comparator.comparing(GuardianPatientCaregiverConnection::getConnectedDateTime, Comparator.nullsLast(Comparator.naturalOrder())))
                .orElse(null);
            if (latest != null) {
                map.put("latestRequestStatus", latest.getStatus().name());
            } else {
                map.put("latestRequestStatus", "NONE");
            }
            result.add(map);
        }
        return ResponseEntity.ok(result);
    }

    @PostMapping("/send-caregiver-connection-request")
    public ResponseEntity<?> sendCaregiverConnectionRequest(@RequestBody Map<String, Object> request) {
        Long guardianId = ((Number) request.get("guardianId")).longValue();
        Long patientId = ((Number) request.get("patientId")).longValue();
        Long caregiverId = ((Number) request.get("caregiverId")).longValue();

        // Check patient existence
        if (!patientRepository.existsById(patientId)) {
            return ResponseEntity.badRequest().body("Patient not found");
        }
        // Check caregiver existence
        if (!caregiverRepository.existsById(caregiverId.intValue())) {
            return ResponseEntity.badRequest().body("Caregiver not found");
        }
        // Check for duplicate pending requests
        boolean exists = guardianService.hasPendingConnectionRequest(
            guardianId, patientId, caregiverId
        );
        if (exists) {
            return ResponseEntity.badRequest().body("A pending request already exists.");
        }
        GuardianPatientCaregiverConnection connection = guardianService.sendCaregiverConnectionRequest(guardianId, patientId, caregiverId);
        return ResponseEntity.ok(connection);
    }
}