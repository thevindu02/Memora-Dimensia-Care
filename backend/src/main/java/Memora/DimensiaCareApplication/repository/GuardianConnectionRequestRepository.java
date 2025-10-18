package Memora.DimensiaCareApplication.repository;

import Memora.DimensiaCareApplication.model.GuardianConnectionRequest;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface GuardianConnectionRequestRepository extends JpaRepository<GuardianConnectionRequest, Long> {

    Optional<GuardianConnectionRequest> findByConnectionToken(String connectionToken);

    List<GuardianConnectionRequest> findByPatientEmailAndStatus(String patientEmail,
            GuardianConnectionRequest.RequestStatus status);

    List<GuardianConnectionRequest> findByGuardianEmailAndStatus(String guardianEmail,
            GuardianConnectionRequest.RequestStatus status);

    List<GuardianConnectionRequest> findByStatusAndExpiresAtBefore(GuardianConnectionRequest.RequestStatus status,
            LocalDateTime dateTime);
}
