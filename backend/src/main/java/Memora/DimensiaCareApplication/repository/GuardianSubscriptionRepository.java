package Memora.DimensiaCareApplication.repository;

import Memora.DimensiaCareApplication.model.GuardianSubscription;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface GuardianSubscriptionRepository extends JpaRepository<GuardianSubscription, Long> {
    
    List<GuardianSubscription> findByGuardianId(Long guardianId);
    
    List<GuardianSubscription> findByPatientId(Long patientId);
    
    Optional<GuardianSubscription> findByGuardianIdAndPatientId(Long guardianId, Long patientId);
    
    List<GuardianSubscription> findByStatus(GuardianSubscription.SubscriptionStatus status);
    
    Optional<GuardianSubscription> findByGuardianIdAndPatientIdAndStatus(
        Long guardianId, 
        Long patientId, 
        GuardianSubscription.SubscriptionStatus status
    );
}
