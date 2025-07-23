package Memora.DimensiaCareApplication.controller;

import Memora.DimensiaCareApplication.model.User;
import Memora.DimensiaCareApplication.model.VolunteerRequest;
import Memora.DimensiaCareApplication.service.UserService;
import Memora.DimensiaCareApplication.service.VolunteerRequestService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.Map;

@RestController
@RequestMapping("/api/users")
public class UserController {
    
    @Autowired
    private UserService userService;

    @Autowired
    private VolunteerRequestService volunteerRequestService;

    @PostMapping
    public ResponseEntity<?> createUser(@RequestBody User user) {
        try {
            User savedUser = userService.createUser(user);
            return ResponseEntity.ok(savedUser);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body("Error: " + e.getMessage());
        }
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

    @GetMapping("/{userId}")
    public ResponseEntity<?> getUserById(@PathVariable Long userId) {
        return userService.findById(userId)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
}
