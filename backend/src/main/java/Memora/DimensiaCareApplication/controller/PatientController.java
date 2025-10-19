package Memora.DimensiaCareApplication.controller;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import Memora.DimensiaCareApplication.dto.request.PatientRequest;
import Memora.DimensiaCareApplication.dto.response.PatientDetailsResponse;
import Memora.DimensiaCareApplication.model.Patient;
import Memora.DimensiaCareApplication.service.PatientService;

@RestController
@CrossOrigin(origins = "*")
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
        patient.setRelationship(request.getRelationship());
        Patient savedPatient = patientService.addPatient(patient, request.getUserId(), request.getGuardianId());
        return ResponseEntity.ok(savedPatient);
    }

    @GetMapping("/by-guardian/{guardianId}")
    public ResponseEntity<List<PatientDetailsResponse>> getPatientsByGuardian(@PathVariable Long guardianId) {
        List<Patient> patients = patientService.getPatientsByGuardian(guardianId);
        List<PatientDetailsResponse> response = patients.stream()
                .map(PatientDetailsResponse::fromPatient)
                .collect(Collectors.toList());
        return ResponseEntity.ok(response);
    }

    @GetMapping("/{patientId}")
    public ResponseEntity<PatientDetailsResponse> getPatientById(@PathVariable Long patientId) {
        PatientDetailsResponse resp = patientService.getPatientDetailsWithAcceptedDate(patientId);
        if (resp == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(resp);
    }

    @GetMapping
    public ResponseEntity<List<PatientDetailsResponse>> getAllPatients() {
        List<PatientDetailsResponse> patients = patientService.getAllPatients();
        return ResponseEntity.ok(patients);
    }
}