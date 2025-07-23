package Memora.DimensiaCareApplication.repository;

import Memora.DimensiaCareApplication.model.Caregiver;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface CaregiverRepository extends JpaRepository<Caregiver, Integer> {
    @Query("SELECT c FROM Caregiver c WHERE c.user.id = :userId")
    Optional<Caregiver> findByUserId(@Param("userId") Long userId);
    
    @Query("SELECT c FROM Caregiver c WHERE LOWER(c.user.email) = LOWER(:email)")
    Optional<Caregiver> findByUser_Email(@Param("email") String email);
    
    @Query("SELECT c FROM Caregiver c WHERE LOWER(c.user.city) = LOWER(:city)")
    List<Caregiver> findByUserCity(@Param("city") String city);
} 