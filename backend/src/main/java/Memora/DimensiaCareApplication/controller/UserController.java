package Memora.DimensiaCareApplication.controller;

import Memora.DimensiaCareApplication.model.User;
import Memora.DimensiaCareApplication.model.VolunteerRequest;
import Memora.DimensiaCareApplication.repository.UserRepository;
import Memora.DimensiaCareApplication.service.VolunteerRequestService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.crypto.password.PasswordEncoder;
import java.util.Map;

@RestController
@RequestMapping("/api/users")
public class UserController {
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private VolunteerRequestService volunteerRequestService;

    @PostMapping
    public ResponseEntity<?> createUser(@RequestBody User user) {
        if (userRepository.existsByEmail(user.getEmail())) {
            return ResponseEntity.badRequest().body("Error: Email is already taken!");
        }
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        User savedUser = userRepository.save(user);
        return ResponseEntity.ok(savedUser);
    }

    @PostMapping("/volunteer-request")
    public ResponseEntity<?> createVolunteerRequest(@RequestBody Map<String, Object> request) {
        try {
            Long userId = Long.parseLong(request.get("userId").toString());
            String volunteerIdImage = request.get("volunteerIdImage").toString();
            
            VolunteerRequest volunteerRequest = volunteerRequestService.createVolunteerRequest(userId, volunteerIdImage);
            return ResponseEntity.ok(volunteerRequest);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error creating volunteer request: " + e.getMessage());
        }
    }
}
