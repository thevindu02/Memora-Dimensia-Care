package Memora.DimensiaCareApplication.controller;

import Memora.DimensiaCareApplication.model.User;
import Memora.DimensiaCareApplication.model.Guardian;
import Memora.DimensiaCareApplication.repository.UserRepository;
import Memora.DimensiaCareApplication.repository.GuardianRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.Optional;

@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private GuardianRepository guardianRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @PostMapping
    public ResponseEntity<String> createUser(@RequestBody User user) {
        // Check if a user with the same email already exists
        Optional<User> existingUser = userRepository.findByEmail(user.getEmail());
        if (existingUser.isPresent()) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body("A user with this email already exists.");
        }

        // Encode password only if provided
        // Note: PATIENT role users may have null passwords as they are managed by guardians
        if (user.getPassword() != null && !user.getPassword().isEmpty()) {
            user.setPassword(passwordEncoder.encode(user.getPassword()));
            System.out.println("Password encoded for user: " + user.getEmail());
        } else {
            System.out.println("No password provided for user: " + user.getEmail() + " (Role: " + user.getRole() + ")");
        }

        User savedUser = userRepository.save(user);
        System.out.println("User created successfully with ID: " + savedUser.getId());

        // Debug logging
        System.out.println("User saved with role: " + user.getRole());
        System.out.println(
                "Role class: " + (user.getRole() != null ? user.getRole().getClass().getSimpleName() : "null"));

        // If the user role is GUARDIAN, automatically create a guardian record
        if (user.getRole() == User.UserRole.GUARDIAN) {
            System.out.println("Creating guardian record for user ID: " + savedUser.getId());
            Guardian guardian = new Guardian();
            guardian.setUser(savedUser);
            Guardian savedGuardian = guardianRepository.save(guardian);
            System.out.println("Guardian record created with ID: " + savedGuardian.getGuardianId());
        } else {
            System.out.println("Not creating guardian record - role is: " + user.getRole());
        }

        // Return JSON response with user ID
        return ResponseEntity.ok()
                .header("Content-Type", "application/json")
                .body("{\"message\":\"User created successfully!\",\"id\":" + savedUser.getId() + "}");
    }

    @GetMapping("/{id}")
    public ResponseEntity<User> getUserById(@PathVariable Long id) {
        Optional<User> user = userRepository.findById(id);
        if (user.isPresent()) {
            return ResponseEntity.ok(user.get());
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<String> updateUser(@PathVariable Long id, @RequestBody User updatedUser) {
        Optional<User> existingUserOptional = userRepository.findById(id);
        
        if (!existingUserOptional.isPresent()) {
            return ResponseEntity.notFound().build();
        }

        User existingUser = existingUserOptional.get();

        // Update only provided fields
        if (updatedUser.getFName() != null) {
            existingUser.setFName(updatedUser.getFName());
        }
        if (updatedUser.getLName() != null) {
            existingUser.setLName(updatedUser.getLName());
        }
        if (updatedUser.getEmail() != null && !updatedUser.getEmail().equals(existingUser.getEmail())) {
            // Check if new email is already taken by another user
            Optional<User> userWithEmail = userRepository.findByEmail(updatedUser.getEmail());
            if (userWithEmail.isPresent() && !userWithEmail.get().getId().equals(id)) {
                return ResponseEntity.status(HttpStatus.CONFLICT)
                    .body("{\"message\":\"Email already in use by another account\"}");
            }
            existingUser.setEmail(updatedUser.getEmail());
        }
        if (updatedUser.getPhoneNumber() != null) {
            existingUser.setPhoneNumber(updatedUser.getPhoneNumber());
        }
        if (updatedUser.getGender() != null) {
            existingUser.setGender(updatedUser.getGender());
        }
        if (updatedUser.getBirthdate() != null) {
            existingUser.setBirthdate(updatedUser.getBirthdate());
        }
        if (updatedUser.getStreet() != null) {
            existingUser.setStreet(updatedUser.getStreet());
        }
        if (updatedUser.getCity() != null) {
            existingUser.setCity(updatedUser.getCity());
        }
        if (updatedUser.getState() != null) {
            existingUser.setState(updatedUser.getState());
        }
        if (updatedUser.getProfilePic() != null) {
            existingUser.setProfilePic(updatedUser.getProfilePic());
        }

        // Don't update password here - use separate endpoint for password changes
        // Don't update role or status through this endpoint

        User savedUser = userRepository.save(existingUser);
        System.out.println("User updated successfully with ID: " + savedUser.getId());

        return ResponseEntity.ok()
            .header("Content-Type", "application/json")
            .body("{\"message\":\"User updated successfully\",\"id\":" + savedUser.getId() + "}");
    }

    @PutMapping("/{id}/change-password")
    public ResponseEntity<String> changePassword(
            @PathVariable Long id, 
            @RequestBody ChangePasswordRequest request) {
        
        Optional<User> existingUserOptional = userRepository.findById(id);
        
        if (!existingUserOptional.isPresent()) {
            return ResponseEntity.notFound().build();
        }

        User existingUser = existingUserOptional.get();

        // Verify current password
        if (!passwordEncoder.matches(request.getCurrentPassword(), existingUser.getPassword())) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body("{\"message\":\"Current password is incorrect\"}");
        }

        // Validate new password
        if (request.getNewPassword() == null || request.getNewPassword().length() < 6) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body("{\"message\":\"New password must be at least 6 characters\"}");
        }

        // Update password
        existingUser.setPassword(passwordEncoder.encode(request.getNewPassword()));
        userRepository.save(existingUser);
        
        System.out.println("Password changed successfully for user ID: " + id);

        return ResponseEntity.ok()
            .header("Content-Type", "application/json")
            .body("{\"message\":\"Password changed successfully\"}");
    }

    // Inner class for change password request
    public static class ChangePasswordRequest {
        private String currentPassword;
        private String newPassword;

        public String getCurrentPassword() {
            return currentPassword;
        }

        public void setCurrentPassword(String currentPassword) {
            this.currentPassword = currentPassword;
        }

        public String getNewPassword() {
            return newPassword;
        }

        public void setNewPassword(String newPassword) {
            this.newPassword = newPassword;
        }
    }
}
