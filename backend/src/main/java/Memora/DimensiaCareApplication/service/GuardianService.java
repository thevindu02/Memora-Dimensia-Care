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
} 