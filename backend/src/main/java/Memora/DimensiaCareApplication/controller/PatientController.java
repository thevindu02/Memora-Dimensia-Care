package Memora.DimensiaCareApplication.controller;

import Memora.DimensiaCareApplication.dto.request.PatientProfileUpdateRequest;
import Memora.DimensiaCareApplication.dto.request.PatientRequest;
import Memora.DimensiaCareApplication.model.Patient;
import Memora.DimensiaCareApplication.model.User;
import Memora.DimensiaCareApplication.repository.PatientRepository;
import Memora.DimensiaCareApplication.repository.UserRepository;
import Memora.DimensiaCareApplication.service.PatientService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

import Memora.DimensiaCareApplication.dto.response.PatientDetailsResponse;

@RestController
@RequestMapping("/api/patients")
public class PatientController {

    @Autowired
    private PatientService patientService;

    @Autowired
    private PatientRepository patientRepository;

    @Autowired
    private UserRepository userRepository;

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
        Patient patient = patientRepository.findById(patientId).orElse(null);
        if (patient == null) {
            return ResponseEntity.notFound().build();
        }
        PatientDetailsResponse resp = PatientDetailsResponse.fromPatient(patient);
        return ResponseEntity.ok(resp);
    }

    @PutMapping("/{patientId}/edit-profile")
    public ResponseEntity<?> editPatientProfile(
        @PathVariable Long patientId,
        @RequestBody PatientProfileUpdateRequest req) {
    try {
        Patient patient = patientRepository.findById(patientId).orElse(null);
        if (patient == null) {
            return ResponseEntity.notFound().build();
        }
        User user = patient.getUser();
        if (user == null) {
            return ResponseEntity.badRequest().body("Patient does not have an associated user.");
        }

        // --- Update user fields ---
        if (req.getFName() != null && !req.getFName().isEmpty()) user.setFName(req.getFName());
        if (req.getLName() != null && !req.getLName().isEmpty()) user.setLName(req.getLName());
        if (req.getBirthdate() != null) user.setBirthdate(req.getBirthdate());
        if (req.getGender() != null) user.setGender(req.getGender());
        if (req.getPhoneNumber() != null) user.setPhoneNumber(req.getPhoneNumber());
        if (req.getStreet() != null) user.setStreet(req.getStreet());
        if (req.getCity() != null) user.setCity(req.getCity());
        if (req.getState() != null) user.setState(req.getState());
        if (req.getEmail() != null) user.setEmail(req.getEmail());
        if (req.getProfilePic() != null) user.setProfilePic(req.getProfilePic());

        userRepository.save(user); // <--- Save user changes

        // --- Update patient fields ---
        if (req.getLabel() != null) patient.setLabel(req.getLabel());
        if (req.getDementiaType() != null) patient.setDementiaType(req.getDementiaType());
        if (req.getDementiaStage() != null) patient.setDementiaStage(req.getDementiaStage());

        patientRepository.save(patient); // <--- Save patient changes

        System.out.println("FName: " + req.getFName());
        System.out.println("LName: " + req.getLName());
        System.out.println("birthdate: " + req.getBirthdate());
        System.out.println("dementiaType: " + req.getDementiaType());
        System.out.println("dementiaStage: " + req.getDementiaStage());

        return ResponseEntity.ok("Patient profile updated successfully");

    } catch (Exception e) {
        e.printStackTrace();
        return ResponseEntity.status(500).body("Error updating patient profile: " + e.getMessage());
    }
}

}
