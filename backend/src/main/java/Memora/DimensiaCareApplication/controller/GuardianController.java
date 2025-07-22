package Memora.DimensiaCareApplication.controller;

import Memora.DimensiaCareApplication.model.Guardian;
import Memora.DimensiaCareApplication.repository.GuardianRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/guardians")
public class GuardianController {

    @Autowired
    private GuardianRepository guardianRepository;

    @GetMapping("/by-user/{userId}")
    public ResponseEntity<Long> getGuardianIdByUserId(@PathVariable Long userId) {
        Guardian guardian = guardianRepository.findByUser_Id(userId);
        if (guardian != null) {
            return ResponseEntity.ok(guardian.getGuardianId());
        } else {
            return ResponseEntity.notFound().build();
        }
    }
}