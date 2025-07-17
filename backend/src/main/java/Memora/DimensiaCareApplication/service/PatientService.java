package Memora.DimensiaCareApplication.service;

import Memora.DimensiaCareApplication.model.Patient;
import Memora.DimensiaCareApplication.model.User;
import Memora.DimensiaCareApplication.repository.PatientRepository;
import Memora.DimensiaCareApplication.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class PatientService {

    @Autowired
    private PatientRepository patientRepository;

    @Autowired
    private UserRepository userRepository;

    public Patient addPatient(Patient patient, Long userId, Long guardianId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found with id: " + userId));
        patient.setUser(user);

        if (guardianId != null) {
            User guardian = userRepository.findById(guardianId)
                    .orElseThrow(() -> new RuntimeException("Guardian not found with id: " + guardianId));
            patient.setGuardian(guardian);
        }

        return patientRepository.save(patient);
    }
}
