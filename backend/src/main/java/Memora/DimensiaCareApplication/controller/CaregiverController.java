package Memora.DimensiaCareApplication.controller;

import Memora.DimensiaCareApplication.dto.response.CaregiverDetailsResponse;
import Memora.DimensiaCareApplication.dto.response.ExpiredCaregiverResponse;
import Memora.DimensiaCareApplication.model.CaregiverReview;
import Memora.DimensiaCareApplication.service.CaregiverReviewService;
import Memora.DimensiaCareApplication.service.CaregiverService;
import Memora.DimensiaCareApplication.service.SubscriptionService;
import Memora.DimensiaCareApplication.model.GuardianPatientCaregiverConnection;
import Memora.DimensiaCareApplication.repository.GuardianPatientCaregiverConnectionRepository;
import Memora.DimensiaCareApplication.repository.GuardianRepository;
import Memora.DimensiaCareApplication.repository.PatientRepository;
import Memora.DimensiaCareApplication.model.Guardian;
import Memora.DimensiaCareApplication.model.Patient;
import Memora.DimensiaCareApplication.model.User;
import Memora.DimensiaCareApplication.model.Caregiver;
import Memora.DimensiaCareApplication.dto.response.ConnectedCaregiverRequestDTO;
import Memora.DimensiaCareApplication.repository.CaregiverRepository;
import Memora.DimensiaCareApplication.dto.request.CaregiverRegistrationRequest;
import Memora.DimensiaCareApplication.dto.request.CaregiverProfileUpdateRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestBody;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.Period;
import java.util.List;
import java.util.stream.Collectors;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PathVariable;
import Memora.DimensiaCareApplication.repository.CaregiverSkillRepository;
import Memora.DimensiaCareApplication.repository.SkillRepository;
import Memora.DimensiaCareApplication.model.Skill;
import Memora.DimensiaCareApplication.dto.response.PendingConnectionRequestDetailsDTO;
import Memora.DimensiaCareApplication.dto.response.CaregiverReviewResponse;

@RestController
@RequestMapping("/api/caregivers")
@CrossOrigin(origins = "*")
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

    @Autowired
    private CaregiverReviewService caregiverReviewService;

    @Autowired
    private SubscriptionService subscriptionService;

    @GetMapping("/all")
    public ResponseEntity<List<CaregiverDetailsResponse>> getAllCaregivers() {
        List<CaregiverDetailsResponse> caregivers = caregiverService.getAllCaregivers();
        return ResponseEntity.ok(caregivers);
    }

    @GetMapping("/{caregiverId}")
    public ResponseEntity<CaregiverDetailsResponse> getCaregiverById(@PathVariable Long caregiverId) {
        Caregiver caregiver = caregiverRepository.findById(caregiverId.intValue()).orElse(null);
        if (caregiver == null) {
            return ResponseEntity.notFound().build();
        }
        User user = caregiver.getUser();
        CaregiverDetailsResponse resp = new CaregiverDetailsResponse();
        resp.setCaregiverId(caregiver.getCaregiverId().longValue());
        resp.setUserId(user.getId());
        resp.setFName(user.getFName());
        resp.setLName(user.getLName());
        resp.setEmail(user.getEmail());
        resp.setPhoneNumber(user.getPhoneNumber());
        resp.setCity(user.getCity());
        resp.setState(user.getState());
        resp.setProfilePic(user.getProfilePic());
        resp.setExperience(caregiver.getExperience());
        resp.setQualifications(caregiver.getQualifications());
        resp.setGender(user.getGender());
        resp.setBirthdate(user.getBirthdate() != null ? user.getBirthdate().toString() : null);
        String address = "";
        if (user.getStreet() != null && !user.getStreet().isEmpty())
            address += user.getStreet();
        if (user.getCity() != null && !user.getCity().isEmpty())
            address += (address.isEmpty() ? "" : ", ") + user.getCity();
        if (user.getState() != null && !user.getState().isEmpty())
            address += (address.isEmpty() ? "" : ", ") + user.getState();
        resp.setAddress(address);
        List<String> skills = caregiverSkillRepository.findByCaregiverId(caregiver.getCaregiverId()).stream()
                .map(cs -> skillRepository.findById(cs.getSkillId()).map(Skill::getSkillName).orElse(""))
                .collect(Collectors.toList());
        resp.setSkills(skills);
        return ResponseEntity.ok(resp);
    }

    @GetMapping("/by-user/{userId}")
    public ResponseEntity<Long> getCaregiverIdByUserId(@PathVariable Long userId) {
        Caregiver caregiver = caregiverRepository.findByUserId(userId).orElse(null);
        if (caregiver == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(caregiver.getCaregiverId().longValue());
    }

    @GetMapping("/{caregiverId}/pending-requests")
    public ResponseEntity<List<PendingConnectionRequestDetailsDTO>> getPendingRequests(@PathVariable Long caregiverId) {
        List<GuardianPatientCaregiverConnection> pendingRequests = connectionRepository.findByCaregiverIdAndStatus(
                caregiverId, GuardianPatientCaregiverConnection.ConnectionStatus.PENDING);
        List<PendingConnectionRequestDetailsDTO> dtos = pendingRequests.stream().map(conn -> {
            PendingConnectionRequestDetailsDTO dto = new PendingConnectionRequestDetailsDTO();
            dto.setConnectionId(conn.getConnectionId());
            Guardian guardian = guardianRepository.findById(conn.getGuardianId()).orElse(null);
            if (guardian != null && guardian.getUser() != null) {
                User gUser = guardian.getUser();
                dto.setGuardianName(gUser.getFName() + " " + gUser.getLName());
                dto.setGuardianEmail(gUser.getEmail());
                dto.setGuardianPhone(gUser.getPhoneNumber());
                dto.setGuardianUserId(gUser.getId());
            }
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
            dto.setDiagnosis(
                    patient != null && patient.getDementiaType() != null ? patient.getDementiaType().name() : "");
            dto.setStatus(conn.getStatus().name());
            dto.setConnectedDateTime(conn.getConnectedDateTime() != null ? conn.getConnectedDateTime().toString() : "");
            return dto;
        }).collect(Collectors.toList());
        return ResponseEntity.ok(dtos);
    }

    @GetMapping("/{caregiverId}/connected-requests")
    public ResponseEntity<List<ConnectedCaregiverRequestDTO>> getConnectedRequests(@PathVariable Long caregiverId) {
        List<GuardianPatientCaregiverConnection> connectedRequests = connectionRepository.findByCaregiverIdAndStatus(
                caregiverId, GuardianPatientCaregiverConnection.ConnectionStatus.ACTIVE);
        List<ConnectedCaregiverRequestDTO> dtos = connectedRequests.stream().map(conn -> {
            ConnectedCaregiverRequestDTO dto = new ConnectedCaregiverRequestDTO();
            dto.setConnectionId(conn.getConnectionId());
            Guardian guardian = guardianRepository.findById(conn.getGuardianId()).orElse(null);
            if (guardian != null && guardian.getUser() != null) {
                User gUser = guardian.getUser();
                dto.setGuardianName(gUser.getFName() + " " + gUser.getLName());
                dto.setGuardianEmail(gUser.getEmail());
            }
            Patient patient = patientRepository.findById(conn.getPatientId()).orElse(null);
            if (patient != null && patient.getUser() != null) {
                dto.setPatientId(patient.getPatientID());
                User pUser = patient.getUser();
                dto.setPatientName(pUser.getFName() + " " + pUser.getLName());
                if (pUser.getBirthdate() != null) {
                    dto.setPatientAge(Period.between(pUser.getBirthdate(), LocalDate.now()).getYears());
                }
                dto.setDementiaType(patient.getDementiaType() != null ? patient.getDementiaType().name() : null);
                dto.setDementiaStage(patient.getDementiaStage() != null ? patient.getDementiaStage().name() : null);
            }
            dto.setDiagnosis(
                    patient != null && patient.getDementiaType() != null ? patient.getDementiaType().name() : "");
            dto.setRelationship(patient != null ? patient.getRelationship() : "");
            dto.setStatus(conn.getStatus().name());
            dto.setConnectedDateTime(conn.getConnectedDateTime() != null ? conn.getConnectedDateTime().toString() : "");
            return dto;
        }).collect(Collectors.toList());
        return ResponseEntity.ok(dtos);
    }

    @GetMapping("/available-for-patient/{patientId}")
    public ResponseEntity<List<CaregiverDetailsResponse>> getAvailableCaregiversForPatient(
            @PathVariable Long patientId) {
        System.out.println("[API] getAvailableCaregiversForPatient called with patientId: " + patientId);
        Patient patient = patientRepository.findById(patientId).orElse(null);
        if (patient == null) {
            return ResponseEntity.badRequest().build();
        }
        final int stageScore;
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
        LocalDateTime twoDaysAgo = LocalDateTime.now().minusDays(2);
        List<Caregiver> caregivers = caregiverRepository.findAll();
        List<CaregiverDetailsResponse> available = caregivers.stream()
                .filter(cg -> {
                    Integer score = cg.getSeverityScore();
                    if (score == null)
                        score = 0;
                    boolean eligible = score < 4 && score + stageScore <= 4;
                    List<GuardianPatientCaregiverConnection> recentRejections = connectionRepository
                            .findByPatientIdAndCaregiverIdAndStatusAndRejectedDateTimeAfter(
                                    patientId,
                                    cg.getCaregiverId().longValue(),
                                    GuardianPatientCaregiverConnection.ConnectionStatus.REJECTED,
                                    twoDaysAgo);
                    boolean notRecentlyRejected = recentRejections.isEmpty();
                    System.out.println("Caregiver ID: " + cg.getCaregiverId() + ", severityScore: " + score
                            + ", eligible: " + eligible + ", notRecentlyRejected: " + notRecentlyRejected);
                    return eligible && notRecentlyRejected;
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
                    List<String> skills = caregiverSkillRepository.findByCaregiverId(cg.getCaregiverId()).stream()
                            .map(cs -> skillRepository.findById(cs.getSkillId()).map(Skill::getSkillName).orElse(""))
                            .collect(Collectors.toList());
                    resp.setSkills(skills);
                    return resp;
                })
                .collect(Collectors.toList());
        return ResponseEntity.ok(available);
    }

    @PostMapping("/register")
    public ResponseEntity<?> registerCaregiver(@RequestBody CaregiverRegistrationRequest request) {
        try {
            System.out.println("=== Caregiver Registration Request ===");
            System.out.println("First Name: " + request.getFName());
            System.out.println("Last Name: " + request.getLName());
            System.out.println("Email: " + request.getEmail());
            System.out.println("Phone: " + request.getPhoneNumber());
            System.out.println("Gender: " + request.getGender());
            System.out.println("City: " + request.getCity());
            System.out.println("State: " + request.getState());
            System.out.println("Experience: " + request.getExperience());
            System.out.println("Qualifications: " + request.getQualifications());
            System.out.println("Skills: " + request.getSkills());
            System.out.println("=====================================");

            if (request.getFName() == null || request.getFName().trim().isEmpty()) {
                return ResponseEntity.badRequest().body("First name is required");
            }
            if (request.getLName() == null || request.getLName().trim().isEmpty()) {
                return ResponseEntity.badRequest().body("Last name is required");
            }
            if (request.getEmail() == null || request.getEmail().trim().isEmpty()) {
                return ResponseEntity.badRequest().body("Email is required");
            }
            if (request.getPassword() == null || request.getPassword().trim().isEmpty()) {
                return ResponseEntity.badRequest().body("Password is required");
            }

            User user = new User();
            user.setFName(request.getFName());
            user.setLName(request.getLName());
            user.setEmail(request.getEmail());
            user.setPassword(request.getPassword());
            user.setPhoneNumber(request.getPhoneNumber());
            user.setGender(request.getGender());
            user.setStreet(request.getStreet());
            user.setCity(request.getCity());
            user.setState(request.getState());
            user.setProfilePic(request.getProfilePic());
            user.setRole(User.UserRole.CAREGIVER);
            user.setStatus(User.UserStatus.ACTIVE);

            if (request.getBirthdate() != null && !request.getBirthdate().trim().isEmpty()) {
                try {
                    user.setBirthdate(java.time.LocalDate.parse(request.getBirthdate()));
                } catch (Exception e) {
                    System.out.println("Failed to parse birthdate: " + request.getBirthdate());
                }
            }

            Caregiver caregiver = new Caregiver();
            caregiver.setExperience(request.getExperience());
            caregiver.setQualifications(request.getQualifications());
            caregiver.setSeverityScore(0);

            caregiverService.registerCaregiver(user, caregiver, request.getSkills());

            return ResponseEntity.ok().body("Caregiver registered successfully");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Registration failed: " + e.getMessage());
        }
    }

    @PostMapping("/connection-request/{connectionId}/accept")
    public ResponseEntity<?> acceptConnectionRequest(@PathVariable Long connectionId) {
        GuardianPatientCaregiverConnection conn = connectionRepository.findById(connectionId).orElse(null);
        if (conn == null || conn.getStatus() != GuardianPatientCaregiverConnection.ConnectionStatus.PENDING) {
            return ResponseEntity.badRequest().body("Invalid or already processed request");
        }
        conn.setStatus(GuardianPatientCaregiverConnection.ConnectionStatus.ACTIVE);
        connectionRepository.save(conn);

        Long caregiverId = conn.getCaregiverId();
        Long patientId = conn.getPatientId();
        Caregiver caregiver = caregiverRepository.findById(caregiverId.intValue()).orElse(null);
        Patient patient = patientRepository.findById(patientId).orElse(null);
        if (caregiver != null && patient != null) {
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
            if (currentScore == null)
                currentScore = 0;
            int newScore = currentScore + stageScore;
            if (newScore > 4)
                newScore = 4;
            System.out.println("Updating caregiver " + caregiver.getCaregiverId() + " severity score from "
                    + currentScore + " to " + newScore);
            caregiver.setSeverityScore(newScore);
            caregiverRepository.save(caregiver);

            // Start 3-month free trial when caregiver accepts
            try {
                subscriptionService.startTrial(patientId);
                System.out.println("Started 3-month trial for patient " + patientId);
            } catch (Exception e) {
                System.err.println("Failed to start trial for patient " + patientId + ": " + e.getMessage());
                // Don't fail the acceptance if trial start fails - log and continue
            }
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
        conn.setRejectedDateTime(java.time.LocalDateTime.now());
        connectionRepository.save(conn);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/{caregiverId}/edit-profile")
    public ResponseEntity<?> editCaregiverProfile(@PathVariable Long caregiverId,
            @RequestBody CaregiverProfileUpdateRequest req) {
        try {
            Caregiver caregiver = caregiverRepository.findById(caregiverId.intValue()).orElse(null);
            if (caregiver == null) {
                return ResponseEntity.notFound().build();
            }
            User user = caregiver.getUser();
            if (user == null) {
                return ResponseEntity.badRequest().body("Caregiver does not have an associated user.");
            }
            user.setFName(req.fName);
            user.setLName(req.lName);
            user.setEmail(req.email);
            user.setPhoneNumber(req.phoneNumber);
            user.setGender(req.gender);
            user.setStreet(req.street);
            user.setCity(req.city);
            user.setState(req.state);
            user.setProfilePic(req.profilePic);
            if (req.birthdate != null && !req.birthdate.isEmpty()) {
                user.setBirthdate(LocalDate.parse(req.birthdate));
            }
            caregiver.setExperience(req.experience);
            caregiver.setQualifications(req.qualifications);
            if (req.skills != null) {
                List<Skill> skillEntities = req.skills.stream()
                        .map(skillName -> skillRepository.findBySkillName(skillName).orElse(null))
                        .filter(s -> s != null)
                        .collect(Collectors.toList());
                caregiver.setSkills(new java.util.HashSet<>(skillEntities));
            }
            caregiverRepository.save(caregiver);
            return ResponseEntity.ok("Profile updated successfully");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Profile update failed: " + e.getMessage());
        }
    }

    @GetMapping("/expired-inactive")
    public ResponseEntity<List<ExpiredCaregiverResponse>> getExpiredInactiveCaregivers() {
        List<ExpiredCaregiverResponse> caregivers = caregiverService.getExpiredCaregiversWithInactiveUsers();
        return ResponseEntity.ok(caregivers);
    }

    @GetMapping("/{caregiverId}/reviews")
    public ResponseEntity<List<CaregiverReviewResponse>> getCaregiverReviews(@PathVariable Long caregiverId) {
        List<CaregiverReviewResponse> reviews = caregiverReviewService.getReviewResponsesForCaregiver(caregiverId);
        return ResponseEntity.ok(reviews);
    }
}