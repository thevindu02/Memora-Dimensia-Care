package Memora.DimensiaCareApplication.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import Memora.DimensiaCareApplication.repository.ArticleRepository;
import Memora.DimensiaCareApplication.repository.CaregiverRepository;
import Memora.DimensiaCareApplication.repository.PatientRepository;
import Memora.DimensiaCareApplication.repository.VolunteerRepository;

@RestController
@RequestMapping("/api/dashboard")
@CrossOrigin(origins = "*")
public class DashboardController {

    @Autowired
    private PatientRepository patientRepository;

    @Autowired
    private CaregiverRepository caregiverRepository;

    @Autowired
    private VolunteerRepository volunteerRepository;

    @Autowired
    private ArticleRepository articleRepository;

    @GetMapping("/stats")
    public ResponseEntity<Map<String, Object>> getDashboardStats() {
        try {
            Map<String, Object> stats = new HashMap<>();

            // Count active patients (join with users table to check status)
            Long patientsCount = patientRepository.countActivePatients();

            // Count active caregivers (join with users table to check status)
            Long caregiversCount = caregiverRepository.countActiveCaregivers();

            // Count active volunteers (join with users table to check status)
            Long volunteersCount = volunteerRepository.countActiveVolunteers();

            // Count published articles (status = 'Published')
            Long articlesCount = articleRepository.countByStatus("Published");

            stats.put("patients", patientsCount != null ? patientsCount : 0);
            stats.put("caregivers", caregiversCount != null ? caregiversCount : 0);
            stats.put("volunteers", volunteersCount != null ? volunteersCount : 0);
            stats.put("articles", articlesCount != null ? articlesCount : 0);

            return ResponseEntity.ok(stats);
        } catch (Exception e) {
            System.err.println("Error fetching dashboard stats: " + e.getMessage());
            e.printStackTrace();

            // Return default values in case of error
            Map<String, Object> defaultStats = new HashMap<>();
            defaultStats.put("patients", 0);
            defaultStats.put("caregivers", 0);
            defaultStats.put("volunteers", 0);
            defaultStats.put("articles", 0);

            return ResponseEntity.ok(defaultStats);
        }
    }
}
