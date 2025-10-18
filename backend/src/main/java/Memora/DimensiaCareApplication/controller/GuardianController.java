package Memora.DimensiaCareApplication.controller;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import Memora.DimensiaCareApplication.dto.request.GuardianProfileUpdateRequest;
import Memora.DimensiaCareApplication.dto.response.GuardianDetailsResponse;
import Memora.DimensiaCareApplication.model.Caregiver;
import Memora.DimensiaCareApplication.model.Guardian;
import Memora.DimensiaCareApplication.model.GuardianPatientCaregiverConnection;
import Memora.DimensiaCareApplication.model.Patient;
import Memora.DimensiaCareApplication.model.User;
import Memora.DimensiaCareApplication.repository.CaregiverRepository;
import Memora.DimensiaCareApplication.repository.GuardianPatientCaregiverConnectionRepository;
import Memora.DimensiaCareApplication.repository.GuardianRepository;
import Memora.DimensiaCareApplication.repository.PatientRepository;
import Memora.DimensiaCareApplication.repository.UserRepository;
import Memora.DimensiaCareApplication.service.GuardianService;

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

    @Autowired
    private UserRepository userRepository;

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
            resp.setStreet(user.getStreet());
            resp.setState(user.getState());
            resp.setGender(user.getGender());
            resp.setBirthday(user.getBirthdate() != null ? user.getBirthdate().toString() : null);
            return ResponseEntity.ok(resp);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @PutMapping("/{guardianId}/edit-profile")
    public ResponseEntity<?> editGuardianProfile(
            @PathVariable Long guardianId,
            @RequestBody GuardianProfileUpdateRequest req) {
        Guardian guardian = guardianRepository.findById(guardianId).orElse(null);
        if (guardian == null) {
            return ResponseEntity.notFound().build();
        }
        User user = guardian.getUser();
        if (user == null) {
            return ResponseEntity.badRequest().body("Guardian does not have an associated user.");
        }

        // Update only editable fields
        user.setFName(req.fName);
        user.setLName(req.lName);
        user.setEmail(req.email);
        user.setPhoneNumber(req.phoneNumber);
        user.setGender(req.gender);
        user.setBirthdate(req.birthdate != null ? LocalDate.parse(req.birthdate) : null);
        user.setStreet(req.street);
        user.setCity(req.city);
        user.setState(req.state);
        user.setProfilePic(req.profilePic);

        userRepository.save(user);

        return ResponseEntity.ok(user);
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
            // Find latest connection request for this patient (unknown caregiver only, excluding cancelled)
            List<GuardianPatientCaregiverConnection> connections = connectionRepository.findByPatientId(patient.getPatientID());
            GuardianPatientCaregiverConnection latest = connections.stream()
                .filter(conn -> conn.getCaregiverId() != null) // unknown caregiver
                .filter(conn -> conn.getStatus() != GuardianPatientCaregiverConnection.ConnectionStatus.CANCELLED) // exclude cancelled
                .max(Comparator.comparing(GuardianPatientCaregiverConnection::getConnectedDateTime, Comparator.nullsLast(Comparator.naturalOrder())))
                .orElse(null);
            if (latest != null) {
                map.put("latestRequestStatus", latest.getStatus().name());
                // Include connection ID and request time for pending requests (needed for cancel functionality)
                if (latest.getStatus() == GuardianPatientCaregiverConnection.ConnectionStatus.PENDING) {
                    map.put("connectionId", latest.getConnectionId());
                    map.put("requestDateTime", latest.getConnectedDateTime() != null ? 
                        latest.getConnectedDateTime().toString() : null);
                }
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

    @PostMapping("/cancel-connection-request/{connectionId}")
    public ResponseEntity<?> cancelConnectionRequest(@PathVariable Long connectionId) {
        try {
            GuardianPatientCaregiverConnection conn = connectionRepository.findById(connectionId).orElse(null);
            if (conn == null) {
                return ResponseEntity.badRequest().body("Connection request not found");
            }
            
            if (conn.getStatus() != GuardianPatientCaregiverConnection.ConnectionStatus.PENDING) {
                return ResponseEntity.badRequest().body("Can only cancel pending requests");
            }
            
            // Check if request is within 24 hours
            if (conn.getConnectedDateTime() != null) {
                java.time.LocalDateTime now = java.time.LocalDateTime.now();
                java.time.LocalDateTime requestTime = conn.getConnectedDateTime();
                long hoursElapsed = java.time.Duration.between(requestTime, now).toHours();
                
                if (hoursElapsed >= 24) {
                    return ResponseEntity.badRequest().body("Cannot cancel request after 24 hours");
                }
            }
            
            // Set status to CANCELLED and record cancellation time
            conn.setStatus(GuardianPatientCaregiverConnection.ConnectionStatus.CANCELLED);
            conn.setCancelledDateTime(java.time.LocalDateTime.now());
            connectionRepository.save(conn);
            return ResponseEntity.ok().body("Connection request cancelled successfully");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error cancelling request: " + e.getMessage());
        }
    }

    @PostMapping("/add-known-caregiver")
    public ResponseEntity<?> addKnownCaregiver(@RequestBody Map<String, Object> request) {
        try {
            Long guardianId = ((Number) request.get("guardianId")).longValue();
            Long patientId = ((Number) request.get("patientId")).longValue();
            String caregiverEmail = (String) request.get("caregiverEmail");

            // Check patient existence
            if (!patientRepository.existsById(patientId)) {
                return ResponseEntity.badRequest().body("Patient not found");
            }

            // Find caregiver by email
            Optional<Caregiver> caregiverOpt = caregiverRepository.findByUser_Email(caregiverEmail);
            if (!caregiverOpt.isPresent()) {
                return ResponseEntity.badRequest().body("No caregiver found with this email address");
            }

            Caregiver caregiver = caregiverOpt.get();
            Long caregiverId = caregiver.getCaregiverId().longValue();

            // Check for duplicate pending requests
            boolean exists = guardianService.hasPendingConnectionRequest(
                guardianId, patientId, caregiverId
            );
            if (exists) {
                return ResponseEntity.badRequest().body("A pending request already exists with this caregiver");
            }
            
            // Check for existing active connections
            boolean activeExists = connectionRepository.existsByGuardianIdAndPatientIdAndCaregiverIdAndStatus(
                guardianId, patientId, caregiverId, GuardianPatientCaregiverConnection.ConnectionStatus.ACTIVE
            );
            if (activeExists) {
                return ResponseEntity.badRequest().body("This caregiver is already connected to this patient");
            }

            // Check severity score logic
            Patient patient = patientRepository.findById(patientId).orElse(null);
            if (patient == null) {
                return ResponseEntity.badRequest().body("Patient not found");
            }

            // Calculate stage score
            int stageScore = 0;
            switch (patient.getDementiaStage()) {
                case MILD:
                    stageScore = 1;
                    break;
                case MODERATE:
                    stageScore = 2;
                    break;
                case SEVERE:
                    stageScore = 3;
                    break;
                case VERY_SEVERE:
                    stageScore = 4;
                    break;
                default:
                    stageScore = 0;
            }

            Integer currentScore = caregiver.getSeverityScore();
            if (currentScore == null) currentScore = 0;

            // Check if caregiver can handle this patient
            if (currentScore + stageScore > 4) {
                return ResponseEntity.badRequest().body("This caregiver has reached their maximum patient capacity and cannot take on additional patients with this severity level");
            }

            // Create direct active connection and update severity score
            guardianService.createDirectConnection(guardianId, patientId, caregiverId, stageScore);
            
            // Get caregiver name for response
            String caregiverName = caregiver.getUser().getFName() + " " + caregiver.getUser().getLName();
            
            return ResponseEntity.ok("Patient successfully connected to " + caregiverName);
            
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error processing request: " + e.getMessage());
        }
    }
}