package Memora.DimensiaCareApplication.repository;

import Memora.DimensiaCareApplication.model.UserFCMToken;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserFCMTokenRepository extends JpaRepository<UserFCMToken, Integer> {

    List<UserFCMToken> findByUserId(Integer userId);

    List<UserFCMToken> findByUserIdAndIsActive(Integer userId, Boolean isActive);

    Optional<UserFCMToken> findByFcmToken(String fcmToken);

    void deleteByFcmToken(String fcmToken);
}
