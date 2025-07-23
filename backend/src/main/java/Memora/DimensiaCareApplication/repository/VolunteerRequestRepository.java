package Memora.DimensiaCareApplication.repository;


import Memora.DimensiaCareApplication.model.VolunteerRequest;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;


import java.util.Optional;







@Repository
public interface VolunteerRequestRepository extends JpaRepository<VolunteerRequest, Integer> {
    
    List<VolunteerRequest> findByRequestStatus(VolunteerRequest.RequestStatus status);

    Optional<VolunteerRequest> findByEmail(String email);
    
   
    
    boolean existsByEmail(String email);

}