package Memora.DimensiaCareApplication.repository;

import Memora.DimensiaCareApplication.model.VolunteerRequest;
import Memora.DimensiaCareApplication.dto.VolunteerRequestWithUserDTO;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface VolunteerRequestRepository extends JpaRepository<VolunteerRequest, Integer> {
    
    Optional<VolunteerRequest> findByUserId(Long userId);
    
    List<VolunteerRequest> findByRequestStatus(VolunteerRequest.RequestStatus status);
    
    boolean existsByUserId(Long userId);

    @Query("SELECT new Memora.DimensiaCareApplication.dto.VolunteerRequestWithUserDTO(" +
           "vr.requestId, vr.userId, vr.volunteerIdImage, vr.requestStatus, vr.createdAt, " +
           "u.FName, u.LName, u.email, u.phoneNumber, u.birthdate, u.city, u.state, u.gender, u.profilePic) " +
           "FROM VolunteerRequest vr JOIN User u ON vr.userId = u.id WHERE u.role = 'volunteer'")
    List<VolunteerRequestWithUserDTO> findAllVolunteerRequestsWithUserData();

    @Query("SELECT new Memora.DimensiaCareApplication.dto.VolunteerRequestWithUserDTO(" +
           "vr.requestId, vr.userId, vr.volunteerIdImage, vr.requestStatus, vr.createdAt, " +
           "u.FName, u.LName, u.email, u.phoneNumber, u.birthdate, u.city, u.state, u.gender, u.profilePic) " +
           "FROM VolunteerRequest vr JOIN User u ON vr.userId = u.id WHERE u.role = 'volunteer' AND vr.requestStatus = :status")
    List<VolunteerRequestWithUserDTO> findVolunteerRequestsWithUserDataByStatus(VolunteerRequest.RequestStatus status);
}