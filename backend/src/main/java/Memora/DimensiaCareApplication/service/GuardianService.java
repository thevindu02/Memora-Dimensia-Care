package Memora.DimensiaCareApplication.service;

import Memora.DimensiaCareApplication.model.*;
import Memora.DimensiaCareApplication.model.GuardianPatientCaregiverConnection.ConnectionStatus;
import Memora.DimensiaCareApplication.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.time.LocalDateTime;
import java.util.Optional;

@Service
public class GuardianService {
    @Autowired
    private CaregiverRepository caregiverRepository;
    @Autowired
    private PatientRepository patientRepository;
    @Autowired
    private GuardianPatientCaregiverConnectionRepository connectionRepository;
    @Autowired
    private GuardianRepository guardianRepository;

    public GuardianPatientCaregiverConnection sendCaregiverConnectionRequest(Long guardianId, Long patientId, Long caregiverId) {
        GuardianPatientCaregiverConnection connection = new GuardianPatientCaregiverConnection();
        connection.setGuardianId(guardianId);
        connection.setPatientId(patientId);
        connection.setCaregiverId(caregiverId);
        connection.setStatus(ConnectionStatus.PENDING);
        connection.setConnectedDateTime(LocalDateTime.now());
        return connectionRepository.save(connection);
    }

    public boolean hasPendingConnectionRequest(Long guardianId, Long patientId, Long caregiverId) {
        return connectionRepository.existsByGuardianIdAndPatientIdAndCaregiverIdAndStatus(
            guardianId, patientId, caregiverId, ConnectionStatus.PENDING
        );
    }

    public GuardianPatientCaregiverConnection createDirectConnection(Long guardianId, Long patientId, Long caregiverId, int stageScore) {
        // Create active connection directly
        GuardianPatientCaregiverConnection connection = new GuardianPatientCaregiverConnection();
        connection.setGuardianId(guardianId);
        connection.setPatientId(patientId);
        connection.setCaregiverId(caregiverId);
        connection.setStatus(ConnectionStatus.ACTIVE);
        connection.setConnectedDateTime(LocalDateTime.now());
        
        // Save the connection
        GuardianPatientCaregiverConnection savedConnection = connectionRepository.save(connection);
        
        // Update caregiver severity score immediately
        Caregiver caregiver = caregiverRepository.findById(caregiverId.intValue()).orElse(null);
        if (caregiver != null) {
            Integer currentScore = caregiver.getSeverityScore();
            if (currentScore == null) currentScore = 0;
            int newScore = currentScore + stageScore;
            if (newScore > 4) newScore = 4;
            caregiver.setSeverityScore(newScore);
            caregiverRepository.save(caregiver);
        }
        
        return savedConnection;
    }

    public Guardian createGuardianForUser(User user) {
        Guardian guardian = new Guardian();
        guardian.setUser(user);
        return guardianRepository.save(guardian);
    }
}