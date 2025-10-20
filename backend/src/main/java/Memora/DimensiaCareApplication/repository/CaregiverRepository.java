package Memora.DimensiaCareApplication.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import Memora.DimensiaCareApplication.model.Caregiver;

public interface CaregiverRepository extends JpaRepository<Caregiver, Integer> {

    @Query("SELECT c FROM Caregiver c WHERE c.user.id = :userId")
    Optional<Caregiver> findByUserId(@Param("userId") Long userId);

    @Query("SELECT c FROM Caregiver c WHERE LOWER(c.user.email) = LOWER(:email)")
    Optional<Caregiver> findByUser_Email(@Param("email") String email);

    @Query("SELECT c FROM Caregiver c WHERE LOWER(c.user.city) = LOWER(:city)")
    List<Caregiver> findByUserCity(@Param("city") String city);

    @Query("SELECT COUNT(c) FROM Caregiver c JOIN c.user u WHERE u.status = 'ACTIVE'")
    Long countActiveCaregivers();

    default Caregiver findByIdOrNull(Integer id) {
        return findById(id).orElse(null);
    }
}
