package Memora.DimensiaCareApplication.service;

import Memora.DimensiaCareApplication.model.Patient;
import Memora.DimensiaCareApplication.model.User;
import Memora.DimensiaCareApplication.model.Guardian;
import Memora.DimensiaCareApplication.repository.PatientRepository;
import Memora.DimensiaCareApplication.repository.UserRepository;
import Memora.DimensiaCareApplication.repository.GuardianRepository;
import Memora.DimensiaCareApplication.model.GuardianPatientCaregiverConnection;
import Memora.DimensiaCareApplication.repository.GuardianPatientCaregiverConnectionRepository;
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

    // Add a new method to get PatientDetailsResponse with acceptedDate and guardian info
    public PatientDetailsResponse getPatientDetailsWithAcceptedDate(Long patientId) {
        Patient patient = patientRepository.findById(patientId).orElse(null);
        if (patient == null) return null;
        PatientDetailsResponse resp = PatientDetailsResponse.fromPatient(patient);
        // Fetch connection for this patient and find active connection
        List<GuardianPatientCaregiverConnection> connections = connectionRepository.findByPatientId(patientId);
        GuardianPatientCaregiverConnection acceptedConn = connections.stream()
            .filter(conn -> conn.getStatus() == GuardianPatientCaregiverConnection.ConnectionStatus.ACTIVE)
            .findFirst().orElse(null);
        if (acceptedConn != null && acceptedConn.getConnectedDateTime() != null) {
            resp.setAcceptedDate(acceptedConn.getConnectedDateTime().toString());
            // populate guardian info if available
            Long gid = acceptedConn.getGuardianId();
            if (gid != null) {
                resp.setGuardianId(gid);
                Guardian g = guardianRepository.findById(gid).orElse(null);
                if (g != null && g.getUser() != null) {
                    resp.setGuardianName(g.getUser().getFName() + " " + g.getUser().getLName());
                    resp.setGuardianEmail(g.getUser().getEmail());
                    resp.setGuardianPhone(g.getUser().getPhoneNumber());
                }
            }
        } else {
            // if no active connection, try to set guardian info if patient has a guardian reference
            if (patient.getGuardian() != null && patient.getGuardian().getUser() != null) {
                resp.setGuardianId(patient.getGuardian().getGuardianId());
                resp.setGuardianName(patient.getGuardian().getUser().getFName() + " " + patient.getGuardian().getUser().getLName());
                resp.setGuardianEmail(patient.getGuardian().getUser().getEmail());
                resp.setGuardianPhone(patient.getGuardian().getUser().getPhoneNumber());
            }
        }
        return resp;
    }
}
