package Memora.DimensiaCareApplication.controller;

import Memora.DimensiaCareApplication.dto.response.JwtResponse;
import Memora.DimensiaCareApplication.dto.request.LoginRequest;
import Memora.DimensiaCareApplication.dto.response.MessageResponse;
import Memora.DimensiaCareApplication.dto.request.SignupRequest;
import Memora.DimensiaCareApplication.dto.request.ForgotPasswordRequest;
import Memora.DimensiaCareApplication.dto.request.ResetPasswordRequest;
import Memora.DimensiaCareApplication.model.User;
import Memora.DimensiaCareApplication.model.Guardian;
import Memora.DimensiaCareApplication.service.AuthService;
import Memora.DimensiaCareApplication.repository.GuardianRepository;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/auth")
public class AuthController {
    @Autowired
    AuthService authService;

    @Autowired
    private GuardianRepository guardianRepository;

    @PostMapping("/login")
    public ResponseEntity<?> authenticateUser(@Valid @RequestBody LoginRequest loginRequest) {
        try {
            System.out.println("Login attempt for email: " + loginRequest.getEmail());
            JwtResponse jwtResponse = authService.authenticateUser(loginRequest);
            if ("GUARDIAN".equalsIgnoreCase(jwtResponse.getRole())) {
                Guardian guardian = guardianRepository.findByUser_Id(jwtResponse.getId());
                if (guardian != null) {
                    jwtResponse.setGuardianId(guardian.getGuardianId());
                }
            }
            System.out.println("Login successful for user: " + jwtResponse.getEmail());
            return ResponseEntity.ok(jwtResponse);
        } catch (Exception e) {
            System.err.println("Login failed with exception: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.badRequest()
                    .body(new MessageResponse("Error: Invalid credentials!"));
        }
    }

    @PostMapping("/signup")
    public ResponseEntity<?> registerUser(@Valid @RequestBody SignupRequest signUpRequest) {
        try {
            if (authService.existsByEmail(signUpRequest.getEmail())) {
                return ResponseEntity.badRequest()
                        .body(new MessageResponse("Error: Email is already taken!"));
            }

            User user = authService.registerUser(signUpRequest);
            return ResponseEntity.ok(new MessageResponse("User registered successfully!"));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(new MessageResponse("Error: " + e.getMessage()));
        }
    }

    @GetMapping("/validate")
    public ResponseEntity<?> validateToken() {
        return ResponseEntity.ok(new MessageResponse("Token is valid"));
    }

    @PostMapping("/forgot-password")
    public ResponseEntity<?> forgotPassword(@Valid @RequestBody ForgotPasswordRequest forgotPasswordRequest) {
        try {
            boolean emailSent = authService.sendPasswordResetEmail(forgotPasswordRequest.getEmail());

            if (emailSent) {
                return ResponseEntity.ok(new MessageResponse("Password reset link sent to your email"));
            } else {
                return ResponseEntity.badRequest()
                        .body(new MessageResponse("Error: No account found with this email address"));
            }
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(new MessageResponse("Error: Failed to send password reset email"));
        }
    }

    @PostMapping("/reset-password")
    public ResponseEntity<?> resetPassword(@Valid @RequestBody ResetPasswordRequest resetPasswordRequest) {
        try {
            boolean passwordReset = authService.resetPassword(
                    resetPasswordRequest.getToken(),
                    resetPasswordRequest.getNewPassword());

            if (passwordReset) {
                return ResponseEntity.ok(new MessageResponse("Password reset successfully"));
            } else {
                return ResponseEntity.badRequest()
                        .body(new MessageResponse("Error: Invalid or expired reset token"));
            }
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(new MessageResponse("Error: Failed to reset password"));
        }
    }

    @PostMapping("/logout")
    public ResponseEntity<?> logout() {
        // In a stateless JWT setup, logout is typically handled client-side
        // by removing the token. The server doesn't need to do anything.
        return ResponseEntity.ok(new MessageResponse("Logged out successfully"));
    }
}