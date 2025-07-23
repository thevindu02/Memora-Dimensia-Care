package Memora.DimensiaCareApplication.repository;

import Memora.DimensiaCareApplication.model.VolunteerRequest;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface VolunteerRequestRepository extends JpaRepository<VolunteerRequest, Integer> {
    
    List<VolunteerRequest> findByRequestStatus(VolunteerRequest.RequestStatus status);
}