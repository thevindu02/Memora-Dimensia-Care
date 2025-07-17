package Memora.DimensiaCareApplication.repository;

import Memora.DimensiaCareApplication.model.Patient;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PatientRepository extends JpaRepository<Patient, Long> {
}
