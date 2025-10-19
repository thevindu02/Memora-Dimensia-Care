package Memora.DimensiaCareApplication.service;

import Memora.DimensiaCareApplication.dto.response.CaregiverSummaryResponse;
import Memora.DimensiaCareApplication.model.*;
import Memora.DimensiaCareApplication.model.GuardianPatientCaregiverConnection.ConnectionStatus;
import Memora.DimensiaCareApplication.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.Query;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
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

    @PersistenceContext
    private EntityManager entityManager;

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

    /**
     * Return caregivers that the guardian has a review/relationship with and are inactive/expired.
     */
    public List<CaregiverSummaryResponse> getExpiredCaregiversForGuardian(Long guardianId) {
        // Select caregiver + user fields joined via caregiver_reviews
        String sql = "SELECT c.caregiver_id, u.id, u.f_name, u.l_name, u.email, c.experience, c.qualifications, u.status " +
                     "FROM caregivers c " +
                     "JOIN users u ON c.user_id = u.id " +
                     "JOIN caregiver_reviews cr ON cr.caregiver_id = c.caregiver_id " +
                     "WHERE cr.guardian_id = :gid " +
                     "AND (u.status = 'inactive' OR u.status = 'expired' OR u.status <> 'active') " +
                     "GROUP BY c.caregiver_id, u.id, u.f_name, u.l_name, u.email, c.experience, c.qualifications, u.status";

        Query q = entityManager.createNativeQuery(sql);
        q.setParameter("gid", guardianId);
        @SuppressWarnings("unchecked")
        List<Object[]> rows = q.getResultList();

        List<CaregiverSummaryResponse> result = new ArrayList<>();
        for (Object[] r : rows) {
            Long caregiverId = r[0] != null ? ((Number) r[0]).longValue() : null;
            Long userId = r[1] != null ? ((Number) r[1]).longValue() : null;
            String fName = r[2] != null ? r[2].toString() : "";
            String lName = r[3] != null ? r[3].toString() : "";
            String email = r[4] != null ? r[4].toString() : "";
            String experience = r[5] != null ? r[5].toString() : "";
            String qualifications = r[6] != null ? r[6].toString() : "";
            String status = r[7] != null ? r[7].toString() : "";

            result.add(new CaregiverSummaryResponse(caregiverId, userId, fName, lName, email, experience, qualifications, status));
        }
        return result;
    }

    /**
     * Return all caregivers (active + inactive/expired) that the guardian has worked with
     */
    public List<CaregiverSummaryResponse> getAllCaregiversForGuardian(Long guardianId) {
        String sql = "SELECT DISTINCT c.caregiver_id, u.id, u.f_name, u.l_name, u.email, " +
                     "c.experience, c.qualifications, u.status, conn.status as connection_status " +
                     "FROM caregivers c " +
                     "JOIN users u ON c.user_id = u.id " +
                     "JOIN guardian_patient_caregiver_connection conn ON conn.caregiver_id = c.caregiver_id " +
                     "WHERE conn.guardian_id = :gid " +
                     "AND (conn.status = 'ACTIVE' OR conn.status = 'EXPIRED' OR conn.status = 'REJECTED') " +
                     "ORDER BY u.f_name, u.l_name";

        Query q = entityManager.createNativeQuery(sql);
        q.setParameter("gid", guardianId);
        @SuppressWarnings("unchecked")
        List<Object[]> rows = q.getResultList();

        List<CaregiverSummaryResponse> result = new ArrayList<>();
        for (Object[] r : rows) {
            Long caregiverId = r[0] != null ? ((Number) r[0]).longValue() : null;
            Long userId = r[1] != null ? ((Number) r[1]).longValue() : null;
            String fName = r[2] != null ? r[2].toString().trim() : "";
            String lName = r[3] != null ? r[3].toString().trim() : "";
            String email = r[4] != null ? r[4].toString() : "";
            String experience = r[5] != null ? r[5].toString() : "";
            String qualifications = r[6] != null ? r[6].toString() : "";
            String userStatus = r[7] != null ? r[7].toString() : "";
            String connectionStatus = r[8] != null ? r[8].toString() : "";
            
            String status = "ACTIVE".equals(connectionStatus) ? "active" : "inactive";
            
            result.add(new CaregiverSummaryResponse(caregiverId, userId, fName, lName, email, experience, qualifications, status));
        }
        return result;
    }
}