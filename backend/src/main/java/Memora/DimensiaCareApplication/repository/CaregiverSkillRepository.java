package Memora.DimensiaCareApplication.repository;

import Memora.DimensiaCareApplication.model.CaregiverSkill;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface CaregiverSkillRepository extends JpaRepository<CaregiverSkill, Integer> {
    List<CaregiverSkill> findByCaregiverId(Integer caregiverId);
    void deleteByCaregiverId(Integer caregiverId);
}