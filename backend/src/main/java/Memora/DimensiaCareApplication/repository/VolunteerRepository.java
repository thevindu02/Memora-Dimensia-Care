package Memora.DimensiaCareApplication.repository;

import java.util.Optional;
import java.util.List;

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

    @Query("SELECT v.volunteerId, CONCAT(u.FName, ' ', u.LName), u.email, u.phoneNumber, " +
           "COUNT(a), MAX(a.createdAt), v.volunteerIdImage " +
           "FROM Volunteer v " +
           "JOIN User u ON v.userId = u.id " +
           "LEFT JOIN Article a ON v.volunteerId = a.volunteerId AND a.status = 'Published' " +
           "WHERE u.status = 'ACTIVE' " +
           "GROUP BY v.volunteerId, u.FName, u.LName, u.email, u.phoneNumber, v.volunteerIdImage " +
           "ORDER BY COUNT(a) DESC")
    List<Object[]> getVolunteersWithEngagementStats();
}
