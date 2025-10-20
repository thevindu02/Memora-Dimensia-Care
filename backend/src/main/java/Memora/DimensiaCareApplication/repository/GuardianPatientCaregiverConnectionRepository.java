package Memora.DimensiaCareApplication.repository;

import Memora.DimensiaCareApplication.model.GuardianPatientCaregiverConnection;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface GuardianPatientCaregiverConnectionRepository
        extends JpaRepository<GuardianPatientCaregiverConnection, Long> {
    // Custom query methods if needed
    boolean existsByGuardianIdAndPatientIdAndCaregiverIdAndStatus(Long guardianId, Long patientId, Long caregiverId,
            Memora.DimensiaCareApplication.model.GuardianPatientCaregiverConnection.ConnectionStatus status);

    java.util.List<GuardianPatientCaregiverConnection> findByCaregiverIdAndStatus(Long caregiverId,
            Memora.DimensiaCareApplication.model.GuardianPatientCaregiverConnection.ConnectionStatus status);

    List<GuardianPatientCaregiverConnection> findByStatusAndConnectedDateTimeBefore(
            Memora.DimensiaCareApplication.model.GuardianPatientCaregiverConnection.ConnectionStatus status,
            LocalDateTime before);

    List<GuardianPatientCaregiverConnection> findByPatientId(Long patientId);
    
    // Find recent rejections for a specific patient and caregiver within the last 2 days
    List<GuardianPatientCaregiverConnection> findByPatientIdAndCaregiverIdAndStatusAndRejectedDateTimeAfter(
        Long patientId, Long caregiverId, 
        Memora.DimensiaCareApplication.model.GuardianPatientCaregiverConnection.ConnectionStatus status, 
        LocalDateTime after
    );

    List<GuardianPatientCaregiverConnection> findByStatus(
        Memora.DimensiaCareApplication.model.GuardianPatientCaregiverConnection.ConnectionStatus status
    );
    List<GuardianPatientCaregiverConnection> findByPatientIdAndStatus(Long patientId,
            Memora.DimensiaCareApplication.model.GuardianPatientCaregiverConnection.ConnectionStatus status);
}
