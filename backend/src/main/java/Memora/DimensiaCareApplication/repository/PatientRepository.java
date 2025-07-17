package Memora.DimensiaCareApplication.repository;

import Memora.DimensiaCareApplication.model.Patient;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface PatientRepository extends JpaRepository<Patient, Long> {
    List<Patient> findByGuardian_Id(Long guardianId);
}
