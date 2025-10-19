package Memora.DimensiaCareApplication.service;

import Memora.DimensiaCareApplication.model.Patient;
import Memora.DimensiaCareApplication.model.User;
import Memora.DimensiaCareApplication.model.Guardian;
import Memora.DimensiaCareApplication.model.Caregiver;
import Memora.DimensiaCareApplication.repository.PatientRepository;
import Memora.DimensiaCareApplication.repository.UserRepository;
import Memora.DimensiaCareApplication.repository.GuardianRepository;
import Memora.DimensiaCareApplication.repository.CaregiverRepository;
import Memora.DimensiaCareApplication.repository.GuardianPatientCaregiverConnectionRepository;
import Memora.DimensiaCareApplication.model.GuardianPatientCaregiverConnection;
import Memora.DimensiaCareApplication.dto.response.PatientDetailsResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PatientService {

    @Autowired
    private PatientRepository patientRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private GuardianRepository guardianRepository;

    @Autowired
    private GuardianPatientCaregiverConnectionRepository connectionRepository;
    
    @Autowired
    private CaregiverRepository caregiverRepository;

    public Patient addPatient(Patient patient, Long userId, Long guardianId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found with id: " + userId));
        patient.setUser(user);

        if (guardianId != null) {
            Guardian guardian = guardianRepository.findById(guardianId)
                    .orElseThrow(() -> new RuntimeException("Guardian not found with id: " + guardianId));
            patient.setGuardian(guardian);
        }

        return patientRepository.save(patient);
    }

    public List<Patient> getPatientsByGuardian(Long guardianId) {
        return patientRepository.findByGuardian_GuardianId(guardianId);
    }

    public Patient getPatientById(Long patientId) {
        return patientRepository.findById(patientId).orElse(null);
    }

    // Add a new method to get PatientDetailsResponse with acceptedDate
    public PatientDetailsResponse getPatientDetailsWithAcceptedDate(Long patientId) {
        Patient patient = patientRepository.findById(patientId).orElse(null);
        if (patient == null) return null;
        PatientDetailsResponse resp = PatientDetailsResponse.fromPatient(patient);
        // Fetch connection for this patient
        List<GuardianPatientCaregiverConnection> connections = connectionRepository.findByPatientId(patientId);
        GuardianPatientCaregiverConnection acceptedConn = connections.stream()
            .filter(conn -> conn.getStatus() == GuardianPatientCaregiverConnection.ConnectionStatus.ACTIVE)
            .findFirst().orElse(null);
        if (acceptedConn != null && acceptedConn.getConnectedDateTime() != null) {
            resp.setAcceptedDate(acceptedConn.getConnectedDateTime().toString());
            // Add caregiver information if available
            if (acceptedConn.getCaregiverId() != null) {
                addCaregiverInfo(resp, acceptedConn.getCaregiverId());
            }
        }
        return resp;
    }
    
    // Helper method to add caregiver information to the response
    private void addCaregiverInfo(PatientDetailsResponse resp, Long caregiverId) {
        try {
            // caregiverId is the caregiver's ID, not the user ID
            // We need to fetch the Caregiver entity first, then get the User from it
            Caregiver caregiver = caregiverRepository.findById(caregiverId.intValue()).orElse(null);
            if (caregiver != null && caregiver.getUser() != null) {
                User caregiverUser = caregiver.getUser();
                resp.setCaregiverId(caregiverId);
                resp.setCaregiverName(caregiverUser.getFName() + " " + caregiverUser.getLName());
                resp.setCaregiverEmail(caregiverUser.getEmail());
                resp.setCaregiverPhone(caregiverUser.getPhoneNumber());
                resp.setCaregiverCity(caregiverUser.getCity());
            }
        } catch (Exception e) {
            // Silently fail if caregiver info is not available
            System.err.println("Error fetching caregiver info: " + e.getMessage());
        }
    }
}
