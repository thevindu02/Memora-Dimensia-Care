package Memora.DimensiaCareApplication.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import Memora.DimensiaCareApplication.model.VolunteerRequest;

@Repository
public interface VolunteerRequestRepository extends JpaRepository<VolunteerRequest, Integer> {
    
    Optional<VolunteerRequest> findByEmail(String email);
    
    List<VolunteerRequest> findByRequestStatus(VolunteerRequest.RequestStatus status);
    
    boolean existsByEmail(String email);
}