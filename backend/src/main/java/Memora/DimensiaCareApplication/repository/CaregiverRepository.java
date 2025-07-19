package Memora.DimensiaCareApplication.repository;

import Memora.DimensiaCareApplication.model.Caregiver;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CaregiverRepository extends JpaRepository<Caregiver, Integer> {

    @Query("SELECT c FROM Caregiver c JOIN c.user u WHERE u.city = :city AND u.role = 'CAREGIVER' AND u.status = 'ACTIVE'")
    List<Caregiver> findByUserCity(@Param("city") String city);

    @Query("SELECT c FROM Caregiver c JOIN c.user u WHERE u.role = 'CAREGIVER' AND u.status = 'ACTIVE'")
    List<Caregiver> findAllActiveCaregivers();

    @Query("SELECT c FROM Caregiver c JOIN c.user u WHERE u.id = :userId")
    Caregiver findByUserId(@Param("userId") Long userId);
} 