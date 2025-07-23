package Memora.DimensiaCareApplication.repository;

import Memora.DimensiaCareApplication.model.Skill;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface SkillRepository extends JpaRepository<Skill, Integer> {
    Optional<Skill> findBySkillName(String skillName);
} 