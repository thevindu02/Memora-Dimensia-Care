package Memora.DimensiaCareApplication.repository;

import Memora.DimensiaCareApplication.model.CaregiverReview;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CaregiverReviewRepository extends JpaRepository<CaregiverReview, Long> {
    List<CaregiverReview> findByCaregiver_CaregiverId(Long caregiverId);
}
