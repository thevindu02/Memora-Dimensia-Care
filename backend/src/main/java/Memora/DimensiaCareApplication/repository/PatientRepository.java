package Memora.DimensiaCareApplication.repository;

import Memora.DimensiaCareApplication.model.Patient;
import Memora.DimensiaCareApplication.model.Guardian;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface PatientRepository extends JpaRepository<Patient, Long> {
    List<Patient> findByGuardian_GuardianId(Long guardianId);
}
