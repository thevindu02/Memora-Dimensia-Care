package Memora.DimensiaCareApplication.repository;

import Memora.DimensiaCareApplication.model.Guardian;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface GuardianRepository extends JpaRepository<Guardian, Long> {
    Guardian findByUser_Id(Long userId);
}