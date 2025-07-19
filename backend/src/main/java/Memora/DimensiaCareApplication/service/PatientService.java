package Memora.DimensiaCareApplication.service;

import Memora.DimensiaCareApplication.model.Patient;
import Memora.DimensiaCareApplication.model.User;
import Memora.DimensiaCareApplication.model.Guardian;
import Memora.DimensiaCareApplication.repository.PatientRepository;
import Memora.DimensiaCareApplication.repository.UserRepository;
import Memora.DimensiaCareApplication.repository.GuardianRepository;
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
}
