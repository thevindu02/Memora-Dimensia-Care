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

        if (user.getPassword() != null && !user.getPassword().isEmpty()) {
            user.setPassword(passwordEncoder.encode(user.getPassword()));
        }

        User savedUser = userRepository.save(user);

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
}
