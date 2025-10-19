package Memora.DimensiaCareApplication.service;

import Memora.DimensiaCareApplication.dto.request.LoginRequest;
import Memora.DimensiaCareApplication.dto.request.SignupRequest;
import Memora.DimensiaCareApplication.dto.response.JwtResponse;
import Memora.DimensiaCareApplication.model.PasswordResetToken;
import Memora.DimensiaCareApplication.model.User;
import Memora.DimensiaCareApplication.repository.UserRepository;
import Memora.DimensiaCareApplication.security.JwtUtils;
import Memora.DimensiaCareApplication.security.UserPrincipal;
import Memora.DimensiaCareApplication.repository.PasswordResetTokenRepository;
import java.time.LocalDateTime;
import java.util.UUID;
import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.mail.SimpleMailMessage;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder encoder;

    @Autowired
    private JwtUtils jwtUtils;

    @Autowired
    private PasswordResetTokenRepository passwordResetTokenRepository;

    @Autowired
    private ResendEmailService resendEmailService;

    @Autowired
    private GmailEmailService gmailEmailService;

    public JwtResponse authenticateUser(LoginRequest loginRequest) {
        try {
            System.out.println("Starting authentication for email: " + loginRequest.getEmail());

            Authentication authentication = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(loginRequest.getEmail(), loginRequest.getPassword()));

            System.out.println("Authentication successful");

            SecurityContextHolder.getContext().setAuthentication(authentication);
            System.out.println("Security context set");

            String jwt = jwtUtils.generateJwtToken(authentication);
            System.out.println("JWT token generated");

            UserPrincipal userDetails = (UserPrincipal) authentication.getPrincipal();
            System.out.println("UserPrincipal retrieved: " + userDetails.getEmail());

            String roleName = userDetails.getRole().name();
            System.out.println("Role name: " + roleName);

            return new JwtResponse(jwt,
                    userDetails.getId(),
                    userDetails.getEmail(),
                    userDetails.getFName(),
                    userDetails.getLName(),
                    roleName);
        } catch (Exception e) {
            System.err.println("Exception in authenticateUser: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    public User registerUser(SignupRequest signUpRequest) {
        if (userRepository.existsByEmail(signUpRequest.getEmail())) {
            throw new RuntimeException("Error: Email is already taken!");
        }

        // Create new user's account
        User user = new User(signUpRequest.getFName(), signUpRequest.getLName(),
                signUpRequest.getEmail(), encoder.encode(signUpRequest.getPassword()),
                signUpRequest.getRole());
        user.setPhoneNumber(signUpRequest.getPhoneNumber());
        User savedUser = userRepository.save(user);

        // Send welcome email using Gmail SMTP
        gmailEmailService.sendWelcomeEmail(savedUser.getEmail(), savedUser.getFName());

        return savedUser;
    }

    public boolean existsByEmail(String email) {
        return userRepository.existsByEmail(email);
    }

    public User getUserByEmail(String email) {
        return userRepository.findByEmail(email).orElse(null);
    }

    public User updateUser(User user) {
        return userRepository.save(user);
    }

    public String getCurrentUserEmail() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated()) {
            Object principal = authentication.getPrincipal();
            if (principal instanceof UserPrincipal) {
                return ((UserPrincipal) principal).getEmail();
            }
            return authentication.getName(); // Fallback
        }
        return null;
    }

    public User getCurrentUser() {
        String email = getCurrentUserEmail();
        if (email != null) {
            return getUserByEmail(email);
        }
        return null;
    }

    public boolean sendPasswordResetEmail(String email) {
        try {
            User user = userRepository.findByEmail(email).orElse(null);
            if (user == null) {
                return false; // User not found
            }

            // Generate reset token
            String token = UUID.randomUUID().toString();

            // Create and save password reset token
            PasswordResetToken resetToken = new PasswordResetToken();
            resetToken.setToken(token);
            resetToken.setUser(user);
            resetToken.setExpiryDate(LocalDateTime.now().plusHours(24)); // 24 hours expiry

            passwordResetTokenRepository.save(resetToken);

            // Send email using Gmail SMTP (can send to any email)
            gmailEmailService.sendPasswordResetEmail(email, token);
            return true;

        } catch (Exception e) {
            // Log the error in production
            e.printStackTrace();
            return false;
        }
    }

    public boolean resetPassword(String token, String newPassword) {
        try {
            PasswordResetToken resetToken = passwordResetTokenRepository.findByToken(token).orElse(null);
            if (resetToken == null) {
                return false; // Invalid token
            }

            if (resetToken.getExpiryDate().isBefore(LocalDateTime.now())) {
                // Clean up expired token
                passwordResetTokenRepository.delete(resetToken);
                return false; // Token expired
            }

            User user = resetToken.getUser();
            user.setPassword(encoder.encode(newPassword));
            userRepository.save(user);

            // Delete the used token
            passwordResetTokenRepository.delete(resetToken);
            return true;
        } catch (Exception e) {
            // Log the error in production
            return false;
        }
    }
}