package Memora.DimensiaCareApplication.repository;

import Memora.DimensiaCareApplication.model.VerificationCode;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.Optional;

@Repository
public interface VerificationCodeRepository extends JpaRepository<VerificationCode, Integer> {
    
    Optional<VerificationCode> findByEmailAndIsUsedFalse(String email);
    
    @Modifying
    @Query("UPDATE VerificationCode v SET v.isUsed = true WHERE v.email = :email AND v.isUsed = false")
    void invalidateAllActiveCodesByEmail(@Param("email") String email);
    
    @Modifying
    @Query("DELETE FROM VerificationCode v WHERE v.createdAt < :cutoffDate")
    void deleteOldCodes(@Param("cutoffDate") LocalDateTime cutoffDate);
}