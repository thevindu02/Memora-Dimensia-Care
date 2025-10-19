package Memora.DimensiaCareApplication.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import Memora.DimensiaCareApplication.model.Patient;

public interface PatientRepository extends JpaRepository<Patient, Long> {

    List<Patient> findByGuardian_GuardianId(Long guardianId);

    Optional<Patient> findByUser_Id(Long userId);

    @Query("SELECT COUNT(p) FROM Patient p JOIN p.user u WHERE u.status = 'ACTIVE'")
    Long countActivePatients();
}
