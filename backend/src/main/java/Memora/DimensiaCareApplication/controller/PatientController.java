package Memora.DimensiaCareApplication.controller;

import Memora.DimensiaCareApplication.dto.request.PatientRequest;
import Memora.DimensiaCareApplication.model.Patient;
import Memora.DimensiaCareApplication.service.PatientService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/patients")
public class PatientController {

    @Autowired
    private PatientService patientService;

    @PostMapping
    public ResponseEntity<Patient> addPatient(@RequestBody PatientRequest request) {
        Patient patient = new Patient();
        patient.setDementiaStage(request.getDementiaStage());
        patient.setDateOfDiagnosis(request.getDateOfDiagnosis());
        patient.setDementiaType(request.getDementiaType());
        Patient savedPatient = patientService.addPatient(patient, request.getUserId(), request.getGuardianId());
        return ResponseEntity.ok(savedPatient);
    }
}
