package Memora.DimensiaCareApplication.controller;

import Memora.DimensiaCareApplication.model.DailyReport;
import Memora.DimensiaCareApplication.service.DailyReportService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.fasterxml.jackson.databind.ObjectMapper;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

@RestController
@RequestMapping("/api/reports")
@CrossOrigin(origins = "*")
public class DailyReportController {

    @Autowired
    private DailyReportService dailyReportService;

    private final ObjectMapper objectMapper = new ObjectMapper();

    /**
     * Get all reports for a guardian
     */
    @GetMapping("/guardian/{guardianId}")
    public ResponseEntity<?> getReportsByGuardianId(@PathVariable Long guardianId) {
        try {
            List<DailyReport> reports = dailyReportService.getReportsByGuardianId(guardianId);
            List<Map<String, Object>> reportList = new ArrayList<>();

            for (DailyReport report : reports) {
                reportList.add(convertReportToMap(report));
            }

            return ResponseEntity.ok(reportList);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                .body(Map.of("success", false, "message", "Error fetching reports: " + e.getMessage()));
        }
    }

    /**
     * Get all reports for a patient
     */
    @GetMapping("/patient/{patientId}")
    public ResponseEntity<?> getReportsByPatientId(@PathVariable Long patientId) {
        try {
            List<DailyReport> reports = dailyReportService.getReportsByPatientId(patientId);
            List<Map<String, Object>> reportList = new ArrayList<>();

            for (DailyReport report : reports) {
                reportList.add(convertReportToMap(report));
            }

            return ResponseEntity.ok(reportList);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                .body(Map.of("success", false, "message", "Error fetching reports: " + e.getMessage()));
        }
    }

    /**
     * Get report for a specific patient and date
     */
    @GetMapping("/patient/{patientId}/date/{date}")
    public ResponseEntity<?> getReportByPatientIdAndDate(
            @PathVariable Long patientId,
            @PathVariable @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
        try {
            Optional<DailyReport> reportOpt = dailyReportService.getReportByPatientIdAndDate(patientId, date);
            
            if (reportOpt.isPresent()) {
                return ResponseEntity.ok(convertReportToMap(reportOpt.get()));
            } else {
                return ResponseEntity.ok(Map.of("success", false, "message", "No report found for the specified date"));
            }
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                .body(Map.of("success", false, "message", "Error fetching report: " + e.getMessage()));
        }
    }

    /**
     * Get reports for a patient within a date range
     */
    @GetMapping("/patient/{patientId}/range")
    public ResponseEntity<?> getReportsByPatientIdAndDateRange(
            @PathVariable Long patientId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate) {
        try {
            List<DailyReport> reports = dailyReportService.getReportsByPatientIdAndDateRange(patientId, startDate, endDate);
            List<Map<String, Object>> reportList = new ArrayList<>();

            for (DailyReport report : reports) {
                reportList.add(convertReportToMap(report));
            }

            return ResponseEntity.ok(reportList);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                .body(Map.of("success", false, "message", "Error fetching reports: " + e.getMessage()));
        }
    }

    /**
     * Get reports for a guardian within a date range
     */
    @GetMapping("/guardian/{guardianId}/range")
    public ResponseEntity<?> getReportsByGuardianIdAndDateRange(
            @PathVariable Long guardianId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate) {
        try {
            List<DailyReport> reports = dailyReportService.getReportsByGuardianIdAndDateRange(guardianId, startDate, endDate);
            List<Map<String, Object>> reportList = new ArrayList<>();

            for (DailyReport report : reports) {
                reportList.add(convertReportToMap(report));
            }

            return ResponseEntity.ok(reportList);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                .body(Map.of("success", false, "message", "Error fetching reports: " + e.getMessage()));
        }
    }

    /**
     * Convert DailyReport entity to a Map for JSON response
     */
    private Map<String, Object> convertReportToMap(DailyReport report) throws Exception {
        Map<String, Object> reportMap = new HashMap<>();
        
        reportMap.put("reportId", report.getReportId());
        reportMap.put("scheduleId", report.getSchedule().getScheduleId());
        reportMap.put("patientId", report.getPatient().getPatientID());
        reportMap.put("patientName", report.getPatient().getUser().getFName() + " " + report.getPatient().getUser().getLName());
        reportMap.put("guardianId", report.getGuardian().getGuardianId());
        reportMap.put("caregiverId", report.getCaregiver().getCaregiverId());
        reportMap.put("date", report.getDate().toString());
        reportMap.put("completionRate", report.getCompletionRate());
        reportMap.put("generatedAt", report.getGeneratedAt().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
        
        // Parse routine summary JSON string back to Map
        @SuppressWarnings("unchecked")
        Map<String, Object> routineSummary = objectMapper.readValue(report.getRoutineSummary(), Map.class);
        reportMap.put("routineSummary", routineSummary);
        
        return reportMap;
    }
}
