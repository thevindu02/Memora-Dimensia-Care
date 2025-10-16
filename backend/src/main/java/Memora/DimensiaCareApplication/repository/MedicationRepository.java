package Memora.DimensiaCareApplication.repository;

import Memora.DimensiaCareApplication.model.Medication;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MedicationRepository extends JpaRepository<Medication, Long> {
    // Custom queries if needed
}
