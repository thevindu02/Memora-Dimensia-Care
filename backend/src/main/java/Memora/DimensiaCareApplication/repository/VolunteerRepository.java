package Memora.DimensiaCareApplication.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import Memora.DimensiaCareApplication.model.Volunteer;

@Repository
public interface VolunteerRepository extends JpaRepository<Volunteer, Long> {

    Optional<Volunteer> findByUserId(Long userId);

    boolean existsByUserId(Long userId);

    @Query("SELECT COUNT(v) FROM Volunteer v JOIN User u ON v.userId = u.id WHERE u.status = 'ACTIVE'")
    Long countActiveVolunteers();
}

             
             
             
             
             
             
             