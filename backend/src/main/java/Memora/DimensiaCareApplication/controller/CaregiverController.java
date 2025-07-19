package Memora.DimensiaCareApplication.controller;

import Memora.DimensiaCareApplication.dto.response.CaregiverResponse;
import Memora.DimensiaCareApplication.service.CaregiverService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/caregivers")
@CrossOrigin(origins = "*", maxAge = 3600)
public class CaregiverController {

    @Autowired
    private CaregiverService caregiverService;

    @GetMapping("/by-city/{city}")
    public ResponseEntity<List<CaregiverResponse>> getCaregiversByCity(@PathVariable String city) {
        try {
            List<CaregiverResponse> caregivers = caregiverService.getCaregiversByCity(city);
            return ResponseEntity.ok(caregivers);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    @GetMapping("/all")
    public ResponseEntity<List<CaregiverResponse>> getAllActiveCaregivers() {
        try {
            List<CaregiverResponse> caregivers = caregiverService.getAllActiveCaregivers();
            return ResponseEntity.ok(caregivers);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    @GetMapping("/{caregiverId}")
    public ResponseEntity<CaregiverResponse> getCaregiverById(@PathVariable Integer caregiverId) {
        try {
            CaregiverResponse caregiver = caregiverService.getCaregiverById(caregiverId);
            return ResponseEntity.ok(caregiver);
        } catch (Exception e) {
            return ResponseEntity.notFound().build();
        }
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<CaregiverResponse> getCaregiverByUserId(@PathVariable Long userId) {
        try {
            CaregiverResponse caregiver = caregiverService.getCaregiverByUserId(userId);
            return ResponseEntity.ok(caregiver);
        } catch (Exception e) {
            return ResponseEntity.notFound().build();
        }
    }
} 