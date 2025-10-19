package Memora.DimensiaCareApplication.controller;

import Memora.DimensiaCareApplication.model.Medication;
import Memora.DimensiaCareApplication.service.MedicationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/medications")
public class MedicationController {

    @Autowired
    private MedicationService medicationService;

    @PostMapping
    public ResponseEntity<?> addMedication(@RequestBody Medication medication) {
        try {
            Medication savedMedication = medicationService.addMedication(medication);
            return ResponseEntity.ok(savedMedication);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(400).body(e.getMessage());
        }
    }
}
