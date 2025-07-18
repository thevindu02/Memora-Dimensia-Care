package Memora.DimensiaCareApplication.repository;

import Memora.DimensiaCareApplication.model.Caregiver;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CaregiverRepository extends JpaRepository<Caregiver, Integer> {
}
