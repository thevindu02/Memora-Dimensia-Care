package Memora.DimensiaCareApplication.controller;

import Memora.DimensiaCareApplication.dto.response.CaregiverDetailsResponse;
import Memora.DimensiaCareApplication.service.CaregiverService;
import Memora.DimensiaCareApplication.model.GuardianPatientCaregiverConnection;
import Memora.DimensiaCareApplication.repository.GuardianPatientCaregiverConnectionRepository;
import Memora.DimensiaCareApplication.repository.GuardianRepository;
import Memora.DimensiaCareApplication.repository.PatientRepository;
import Memora.DimensiaCareApplication.model.Guardian;
import Memora.DimensiaCareApplication.model.Patient;
import Memora.DimensiaCareApplication.model.User;
import Memora.DimensiaCareApplication.dto.response.ConnectedCaregiverRequestDTO;
import Memora.DimensiaCareApplication.repository.CaregiverRepository;
import Memora.DimensiaCareApplication.model.Caregiver;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import java.time.LocalDate;
import java.time.Period;
import java.util.List;
import java.util.stream.Collectors;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PathVariable;
import Memora.DimensiaCareApplication.repository.CaregiverSkillRepository;
import Memora.DimensiaCareApplication.repository.SkillRepository;
import Memora.DimensiaCareApplication.model.Skill;
import Memora.DimensiaCareApplication.dto.response.PendingConnectionRequestDetailsDTO;

@RestController
@RequestMapping("/api/caregivers")
public class CaregiverController {
    @Autowired
    private CaregiverService caregiverService;

    @Autowired
    private GuardianPatientCaregiverConnectionRepository connectionRepository;

    @Autowired
    private GuardianRepository guardianRepository;
    @Autowired
    private PatientRepository patientRepository;
    @Autowired
    private CaregiverRepository caregiverRepository;
    @Autowired
    private CaregiverSkillRepository caregiverSkillRepository;
    @Autowired
    private SkillRepository skillRepository;

    @GetMapping("/all")
    public ResponseEntity<List<CaregiverDetailsResponse>> getAllCaregivers() {
        List<CaregiverDetailsResponse> caregivers = caregiverService.getAllCaregivers();
        return ResponseEntity.ok(caregivers);
    }

    @GetMapping("/by-user/{userId}")
    public ResponseEntity<Long> getCaregiverIdByUserId(@org.springframework.web.bind.annotation.PathVariable Long userId) {
        Caregiver caregiver = caregiverRepository.findByUserId(userId).orElse(null);
        if (caregiver == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(caregiver.getCaregiverId().longValue());
    }

    @GetMapping("/{caregiverId}/pending-requests")
    public ResponseEntity<List<PendingConnectionRequestDetailsDTO>> getPendingRequests(@org.springframework.web.bind.annotation.PathVariable Long caregiverId) {
        List<GuardianPatientCaregiverConnection> pendingRequests = connectionRepository.findByCaregiverIdAndStatus(
            caregiverId, GuardianPatientCaregiverConnection.ConnectionStatus.PENDING
        );
        List<PendingConnectionRequestDetailsDTO> dtos = pendingRequests.stream().map(conn -> {
            PendingConnectionRequestDetailsDTO dto = new PendingConnectionRequestDetailsDTO();
            dto.setConnectionId(conn.getConnectionId());
            // Guardian details
            Guardian guardian = guardianRepository.findById(conn.getGuardianId()).orElse(null);
            if (guardian != null && guardian.getUser() != null) {
                User gUser = guardian.getUser();
                dto.setGuardianName(gUser.getFName() + " " + gUser.getLName());
                dto.setGuardianEmail(gUser.getEmail());
                dto.setGuardianPhone(gUser.getPhoneNumber());
            }
            // Patient details
            Patient patient = patientRepository.findById(conn.getPatientId()).orElse(null);
            if (patient != null && patient.getUser() != null) {
                User pUser = patient.getUser();
                dto.setPatientName(pUser.getFName() + " " + pUser.getLName());
                if (pUser.getBirthdate() != null) {
                    dto.setPatientAge(Period.between(pUser.getBirthdate(), LocalDate.now()).getYears());
                }
                dto.setDementiaType(patient.getDementiaType() != null ? patient.getDementiaType().name() : null);
                dto.setDementiaStage(patient.getDementiaStage() != null ? patient.getDementiaStage().name() : null);
                dto.setRelationship(patient.getRelationship());
            }
            dto.setDiagnosis(patient != null && patient.getDementiaType() != null ? patient.getDementiaType().name() : "");
            dto.setStatus(conn.getStatus().name());
            dto.setConnectedDateTime(conn.getConnectedDateTime() != null ? conn.getConnectedDateTime().toString() : "");
            return dto;
        }).collect(Collectors.toList());
        return ResponseEntity.ok(dtos);
    }

    @GetMapping("/{caregiverId}/connected-requests")
    public ResponseEntity<List<ConnectedCaregiverRequestDTO>> getConnectedRequests(@org.springframework.web.bind.annotation.PathVariable Long caregiverId) {
        List<GuardianPatientCaregiverConnection> connectedRequests = connectionRepository.findByCaregiverIdAndStatus(
            caregiverId, GuardianPatientCaregiverConnection.ConnectionStatus.ACTIVE
        );
        List<ConnectedCaregiverRequestDTO> dtos = connectedRequests.stream().map(conn -> {
            ConnectedCaregiverRequestDTO dto = new ConnectedCaregiverRequestDTO();
            dto.setConnectionId(conn.getConnectionId());
            // Guardian details
            Guardian guardian = guardianRepository.findById(conn.getGuardianId()).orElse(null);
            if (guardian != null && guardian.getUser() != null) {
                User gUser = guardian.getUser();
                dto.setGuardianName(gUser.getFName() + " " + gUser.getLName());
                dto.setGuardianEmail(gUser.getEmail());
            }
            // Patient details
            Patient patient = patientRepository.findById(conn.getPatientId()).orElse(null);
            if (patient != null && patient.getUser() != null) {
                dto.setPatientId(patient.getPatientID());
                User pUser = patient.getUser();
                dto.setPatientName(pUser.getFName() + " " + pUser.getLName());
                if (pUser.getBirthdate() != null) {
                    dto.setPatientAge(java.time.Period.between(pUser.getBirthdate(), java.time.LocalDate.now()).getYears());
                }
                // Set dementia type and stage
                dto.setDementiaType(patient.getDementiaType() != null ? patient.getDementiaType().name() : null);
                dto.setDementiaStage(patient.getDementiaStage() != null ? patient.getDementiaStage().name() : null);
            }
            dto.setDiagnosis(patient != null && patient.getDementiaType() != null ? patient.getDementiaType().name() : "");
            dto.setRelationship(patient != null ? patient.getRelationship() : "");
            dto.setStatus(conn.getStatus().name());
            dto.setConnectedDateTime(conn.getConnectedDateTime() != null ? conn.getConnectedDateTime().toString() : "");
            return dto;
        }).collect(java.util.stream.Collectors.toList());
        return ResponseEntity.ok(dtos);
    }

    @GetMapping("/available-for-patient/{patientId}")
    public ResponseEntity<List<CaregiverDetailsResponse>> getAvailableCaregiversForPatient(@PathVariable Long patientId) {
        System.out.println("[API] getAvailableCaregiversForPatient called with patientId: " + patientId);
        Patient patient = patientRepository.findById(patientId).orElse(null);
        if (patient == null) {
            return ResponseEntity.badRequest().build();
        }
        final int stageScore;
        switch (patient.getDementiaStage()) {
            case MILD: stageScore = 1; break;
            case MODERATE: stageScore = 2; break;
            case SEVERE: stageScore = 3; break;
            case VERY_SEVERE: stageScore = 4; break;
            default: stageScore = 0;
        }
        List<Caregiver> caregivers = caregiverRepository.findAll();
        List<CaregiverDetailsResponse> available = caregivers.stream()
            .filter(cg -> {
                Integer score = cg.getSeverityScore();
                if (score == null) score = 0;
                boolean eligible = score < 4 && score + stageScore <= 4;
                System.out.println("Caregiver ID: " + cg.getCaregiverId() + ", severityScore: " + score + ", eligible: " + eligible);
                return eligible;
            })
            .map(cg -> {
                User user = cg.getUser();
                CaregiverDetailsResponse resp = new CaregiverDetailsResponse();
                resp.setCaregiverId(cg.getCaregiverId().longValue());
                resp.setUserId(user.getId());
                resp.setFName(user.getFName());
                resp.setLName(user.getLName());
                resp.setEmail(user.getEmail());
                resp.setPhoneNumber(user.getPhoneNumber());
                resp.setCity(user.getCity());
                resp.setState(user.getState());
                resp.setProfilePic(user.getProfilePic());
                resp.setExperience(cg.getExperience());
                resp.setQualifications(cg.getQualifications());
                // Add skills if needed
                List<String> skills = caregiverSkillRepository.findByCaregiverId(cg.getCaregiverId()).stream()
                    .map(cs -> skillRepository.findById(cs.getSkillId()).map(Skill::getSkillName).orElse(""))
                    .collect(Collectors.toList());
                resp.setSkills(skills);
                return resp;
            })
            .collect(Collectors.toList());
        return ResponseEntity.ok(available);
    }

    @PostMapping("/connection-request/{connectionId}/accept")
    public ResponseEntity<?> acceptConnectionRequest(@PathVariable Long connectionId) {
        GuardianPatientCaregiverConnection conn = connectionRepository.findById(connectionId).orElse(null);
        if (conn == null || conn.getStatus() != GuardianPatientCaregiverConnection.ConnectionStatus.PENDING) {
            return ResponseEntity.badRequest().body("Invalid or already processed request");
        }
        conn.setStatus(GuardianPatientCaregiverConnection.ConnectionStatus.ACTIVE);
        connectionRepository.save(conn);

        // Update caregiver severity_score
        Long caregiverId = conn.getCaregiverId();
        Long patientId = conn.getPatientId();
        Caregiver caregiver = caregiverRepository.findById(caregiverId.intValue()).orElse(null);
        Patient patient = patientRepository.findById(patientId).orElse(null);
        if (caregiver != null && patient != null) {
            int stageScore = 0;
            switch (patient.getDementiaStage()) {
                case MILD: stageScore = 1; break;
                case MODERATE: stageScore = 2; break;
                case SEVERE: stageScore = 3; break;
                case VERY_SEVERE: stageScore = 4; break;
                default: stageScore = 0;
            }
            Integer currentScore = caregiver.getSeverityScore();
            if (currentScore == null) currentScore = 0;
            int newScore = currentScore + stageScore;
            if (newScore > 4) newScore = 4;
            System.out.println("Updating caregiver " + caregiver.getCaregiverId() + " severity score from " + currentScore + " to " + newScore);
            caregiver.setSeverityScore(newScore);
            caregiverRepository.save(caregiver);
        }
        return ResponseEntity.ok().build();
    }

    @PostMapping("/connection-request/{connectionId}/reject")
    public ResponseEntity<?> rejectConnectionRequest(@PathVariable Long connectionId) {
        GuardianPatientCaregiverConnection conn = connectionRepository.findById(connectionId).orElse(null);
        if (conn == null || conn.getStatus() != GuardianPatientCaregiverConnection.ConnectionStatus.PENDING) {
            return ResponseEntity.badRequest().body("Invalid or already processed request");
        }
        conn.setStatus(GuardianPatientCaregiverConnection.ConnectionStatus.REJECTED);
        connectionRepository.save(conn);
        return ResponseEntity.ok().build();
    }
} 