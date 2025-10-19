package Memora.DimensiaCareApplication.service;

import Memora.DimensiaCareApplication.model.UserFCMToken;
import Memora.DimensiaCareApplication.repository.UserFCMTokenRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class UserFCMTokenService {

    @Autowired
    private UserFCMTokenRepository tokenRepository;

    /**
     * Save or update FCM token for a user
     */
    @Transactional
    public UserFCMToken saveOrUpdateToken(Integer userId, String fcmToken, String deviceType) {
        // Check if token already exists
        Optional<UserFCMToken> existingToken = tokenRepository.findByFcmToken(fcmToken);

        if (existingToken.isPresent()) {
            // Update existing token
            UserFCMToken token = existingToken.get();
            token.setUserId(userId);
            token.setDeviceType(deviceType);
            token.setIsActive(true);
            token.setUpdatedAt(LocalDateTime.now());
            return tokenRepository.save(token);
        } else {
            // Create new token
            UserFCMToken newToken = new UserFCMToken(userId, fcmToken, deviceType);
            return tokenRepository.save(newToken);
        }
    }

    /**
     * Get all active FCM tokens for a user
     */
    public List<String> getActiveTokensForUser(Integer userId) {
        return tokenRepository.findByUserIdAndIsActive(userId, true)
                .stream()
                .map(UserFCMToken::getFcmToken)
                .collect(Collectors.toList());
    }

    /**
     * Deactivate a token
     */
    @Transactional
    public void deactivateToken(String fcmToken) {
        Optional<UserFCMToken> token = tokenRepository.findByFcmToken(fcmToken);
        token.ifPresent(t -> {
            t.setIsActive(false);
            t.setUpdatedAt(LocalDateTime.now());
            tokenRepository.save(t);
        });
    }

    /**
     * Delete a token
     */
    @Transactional
    public void deleteToken(String fcmToken) {
        tokenRepository.deleteByFcmToken(fcmToken);
    }

    /**
     * Get all tokens for a user (active and inactive)
     */
    public List<UserFCMToken> getAllTokensForUser(Integer userId) {
        return tokenRepository.findByUserId(userId);
    }
}
