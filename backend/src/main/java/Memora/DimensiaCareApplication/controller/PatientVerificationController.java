package Memora.DimensiaCareApplication.controller;

import Memora.DimensiaCareApplication.model.Patient;
import Memora.DimensiaCareApplication.model.User;
import Memora.DimensiaCareApplication.model.VerificationCode;
import Memora.DimensiaCareApplication.repository.PatientRepository;
import Memora.DimensiaCareApplication.repository.UserRepository;
import Memora.DimensiaCareApplication.repository.VerificationCodeRepository;
import Memora.DimensiaCareApplication.service.GmailEmailService;
import Memora.DimensiaCareApplication.security.JwtUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.Random;

@RestController
@RequestMapping("/api/patients")
@CrossOrigin(origins = "*")
public class PatientVerificationController {

    @Autowired
    private VerificationCodeRepository verificationCodeRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PatientRepository patientRepository;

    @Autowired
    private GmailEmailService emailService;

    @Autowired
    private JwtUtils jwtUtils;

    private String generateSixDigitCode() {
        Random random = new Random();
        int code = 100000 + random.nextInt(900000);
        return String.valueOf(code);
    }

    @PostMapping("/send-verification-code")
    @Transactional
    public ResponseEntity<Map<String, Object>> sendVerificationCode(@RequestBody Map<String, String> request) {
        Map<String, Object> response = new HashMap<>();
        String email = request.get("email");

        if (email == null || email.trim().isEmpty()) {
            response.put("success", false);
            response.put("message", "Email is required");
            return ResponseEntity.badRequest().body(response);
        }

        // Check if user exists and is a patient
        Optional<User> userOpt = userRepository.findByEmail(email);
        if (userOpt.isEmpty() || !userOpt.get().getRole().equals(User.UserRole.PATIENT)) {
            response.put("success", false);
            response.put("message", "No patient account found with this email");
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
        }

        // User user = userOpt.get();
        // Optional<Patient> patientOpt = patientRepository.findByUserId(user.getId());
        // if (patientOpt.isEmpty()) {
        //     response.put("success", false);
        //     response.put("message", "Patient profile not found");
        //     return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
        // }

        // Patient patient = patientOpt.get();
        User user = userOpt.get();

        // Check for existing active code
        Optional<VerificationCode> existingCodeOpt = verificationCodeRepository.findByEmailAndIsUsedFalse(email);
        
        if (existingCodeOpt.isPresent()) {
            VerificationCode existingCode = existingCodeOpt.get();
            
            // Check if account is locked
            if (existingCode.isLocked()) {
                long minutesRemaining = Duration.between(LocalDateTime.now(), existingCode.getLockedUntil()).toMinutes();
                response.put("success", false);
                response.put("message", "Too many failed attempts. Please try again in " + minutesRemaining + " minutes");
                response.put("locked", true);
                response.put("minutesRemaining", minutesRemaining);
                return ResponseEntity.status(HttpStatus.TOO_MANY_REQUESTS).body(response);
            }
            
            // Check cooldown period (60 seconds)
            long secondsSinceLastSent = Duration.between(existingCode.getLastSentAt(), LocalDateTime.now()).getSeconds();
            if (secondsSinceLastSent < 60) {
                long secondsRemaining = 60 - secondsSinceLastSent;
                response.put("success", false);
                response.put("message", "Please wait " + secondsRemaining + " seconds before requesting a new code");
                response.put("cooldown", true);
                response.put("secondsRemaining", secondsRemaining);
                return ResponseEntity.status(HttpStatus.TOO_MANY_REQUESTS).body(response);
            }
            
            // Invalidate old code
            verificationCodeRepository.invalidateAllActiveCodesByEmail(email);
        }

        // Generate new 6-digit code
        String code = generateSixDigitCode();
        VerificationCode verificationCode = new VerificationCode(email, code);
        verificationCodeRepository.save(verificationCode);

        // Send email
        String patientName = user.getFName() + " " + user.getLName();
        emailService.sendVerificationCodeEmail(email, code, patientName);

        response.put("success", true);
        response.put("message", "Verification code sent to your email");
        response.put("expiresInMinutes", 15);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/verify-code")
    @Transactional
    public ResponseEntity<Map<String, Object>> verifyCode(@RequestBody Map<String, String> request) {
        Map<String, Object> response = new HashMap<>();
        String email = request.get("email");
        String code = request.get("code");

        if (email == null || code == null) {
            response.put("success", false);
            response.put("message", "Email and code are required");
            return ResponseEntity.badRequest().body(response);
        }

        // Find active verification code
        Optional<VerificationCode> verificationCodeOpt = verificationCodeRepository.findByEmailAndIsUsedFalse(email);
        
        if (verificationCodeOpt.isEmpty()) {
            response.put("success", false);
            response.put("message", "No active verification code found. Please request a new code.");
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
        }

        VerificationCode verificationCode = verificationCodeOpt.get();

        // Check if account is locked
        if (verificationCode.isLocked()) {
            long minutesRemaining = Duration.between(LocalDateTime.now(), verificationCode.getLockedUntil()).toMinutes();
            response.put("success", false);
            response.put("message", "Account locked due to too many failed attempts. Try again in " + minutesRemaining + " minutes");
            response.put("locked", true);
            response.put("minutesRemaining", minutesRemaining);
            return ResponseEntity.status(HttpStatus.TOO_MANY_REQUESTS).body(response);
        }

        // Check if code is expired
        if (verificationCode.isExpired()) {
            response.put("success", false);
            response.put("message", "Verification code has expired. Please request a new code.");
            response.put("expired", true);
            return ResponseEntity.status(HttpStatus.GONE).body(response);
        }

        // Verify code
        if (!verificationCode.getCode().equals(code)) {
            verificationCode.incrementAttemptCount();
            verificationCodeRepository.save(verificationCode);
            
            int attemptsRemaining = 5 - verificationCode.getAttemptCount();
            response.put("success", false);
            response.put("message", "Invalid verification code. " + attemptsRemaining + " attempts remaining.");
            response.put("attemptsRemaining", attemptsRemaining);
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }

        // Code is valid - mark as used
        verificationCode.setIsUsed(true);
        verificationCodeRepository.save(verificationCode);

        // Get user and generate JWT token with 30-day expiry
        Optional<User> userOpt = userRepository.findByEmail(email);
        if (userOpt.isEmpty()) {
            response.put("success", false);
            response.put("message", "User not found");
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
        }

        User user = userOpt.get();
        
        // Generate JWT token with 30-day expiry for patients (30 days * 24 hours * 60 minutes * 60 seconds * 1000 milliseconds)
        long thirtyDaysInMs = 30L * 24 * 60 * 60 * 1000;
        String token = jwtUtils.generateTokenFromEmail(user.getEmail(), thirtyDaysInMs);

        response.put("success", true);
        response.put("message", "Login successful");
        response.put("accessToken", token);
        response.put("tokenType", "Bearer");
        response.put("id", user.getId());
        response.put("email", user.getEmail());
        response.put("role", user.getRole().toString());
        response.put("fname", user.getFName());
        response.put("lname", user.getLName());
        response.put("expiresInDays", 30);

        return ResponseEntity.ok(response);
    }

    @PostMapping("/resend-verification-code")
    public ResponseEntity<Map<String, Object>> resendVerificationCode(@RequestBody Map<String, String> request) {
        // This endpoint calls the same logic as send-verification-code
        return sendVerificationCode(request);
    }
}