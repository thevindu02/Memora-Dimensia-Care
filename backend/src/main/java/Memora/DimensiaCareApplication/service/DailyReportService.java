package Memora.DimensiaCareApplication.service;

import Memora.DimensiaCareApplication.model.*;
import Memora.DimensiaCareApplication.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.core.JsonProcessingException;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Service
@Transactional
public class DailyReportService {

    @Autowired
    private DailyReportRepository dailyReportRepository;

    @Autowired
    private ScheduleRepository scheduleRepository;

    private final ObjectMapper objectMapper = new ObjectMapper();

    /**
     * Generate a daily report from a completed schedule
     */
    public DailyReport generateReportFromSchedule(Long scheduleId) {
        // Check if report already exists for this schedule
        Optional<DailyReport> existingReport = dailyReportRepository.findByScheduleScheduleId(scheduleId);
        if (existingReport.isPresent()) {
            System.out.println("Report already exists for schedule " + scheduleId);
            return existingReport.get();
        }

        // Get the schedule
        Schedule schedule = scheduleRepository.findById(scheduleId)
            .orElseThrow(() -> new RuntimeException("Schedule not found with ID: " + scheduleId));

        if (!schedule.getIsCompleted()) {
            throw new RuntimeException("Cannot generate report for incomplete schedule");
        }

        // Get all care activities for this schedule and sort by time
        List<CareActivity> careActivities = new ArrayList<>(schedule.getCareActivities());
        careActivities.sort((a, b) -> a.getTime().compareTo(b.getTime()));

        // Organize activities by status
        List<Map<String, Object>> completedActivities = new ArrayList<>();
        List<Map<String, Object>> notCompletedActivities = new ArrayList<>();
        List<Map<String, Object>> skippedActivities = new ArrayList<>();

        int totalActivities = 0;
        int completedCount = 0;

        DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");

        for (CareActivity activity : careActivities) {
            // Collect activity details
            List<String> details = new ArrayList<>();

            // Add daily tasks
            for (DailyTask task : activity.getDailyTasks()) {
                details.add(task.getDailyTaskName());
            }

            // Add game tasks
            for (Task task : activity.getTasks()) {
                details.add("Game: " + task.getGame().getName());
            }

            // Add medication reminders
            for (MedicationReminder reminder : activity.getMedicationReminders()) {
                Medication med = reminder.getMedication();
                details.add("Medication: " + med.getMedicationName() + " (" + med.getDosage() + ")");
            }

            // Add appointments
            for (Appointment appointment : activity.getAppointments()) {
                details.add("Appointment: " + appointment.getTaskName() + " - Dr. " + appointment.getDoctorName());
            }

            // Skip this activity if it has no tasks
            if (details.isEmpty()) {
                continue;
            }

            Map<String, Object> activityInfo = new HashMap<>();
            activityInfo.put("time", activity.getTime().format(timeFormatter));
            activityInfo.put("details", details);

            totalActivities++;

            // Categorize based on status
            if (activity.getStatus() == CareActivityStatus.COMPLETED) {
                completedActivities.add(activityInfo);
                completedCount++;
            } else if (activity.getStatus() == CareActivityStatus.CANCELLED) {
                skippedActivities.add(activityInfo);
            } else {
                notCompletedActivities.add(activityInfo);
            }
        }

        // Calculate completion rate
        int completionRate = totalActivities > 0 ? (completedCount * 100) / totalActivities : 0;

        // Create routine summary JSON
        Map<String, Object> routineSummary = new HashMap<>();
        routineSummary.put("completed", completedActivities);
        routineSummary.put("notCompleted", notCompletedActivities);
        routineSummary.put("skipped", skippedActivities);

        String routineSummaryJson;
        try {
            routineSummaryJson = objectMapper.writeValueAsString(routineSummary);
        } catch (JsonProcessingException e) {
            throw new RuntimeException("Error converting routine summary to JSON", e);
        }

        // Create and save the daily report
        DailyReport report = new DailyReport(
            schedule,
            schedule.getPatient(),
            schedule.getGuardian(),
            schedule.getCaregiver(),
            schedule.getDate(),
            routineSummaryJson,
            completionRate
        );

        DailyReport savedReport = dailyReportRepository.save(report);
        System.out.println("Daily report generated successfully for schedule " + scheduleId);
        
        return savedReport;
    }

    /**
     * Get all reports for a guardian
     */
    public List<DailyReport> getReportsByGuardianId(Long guardianId) {
        return dailyReportRepository.findByGuardianGuardianIdOrderByDateDesc(guardianId);
    }

    /**
     * Get all reports for a patient
     */
    public List<DailyReport> getReportsByPatientId(Long patientId) {
        return dailyReportRepository.findByPatientPatientIdOrderByDateDesc(patientId);
    }

    /**
     * Get report for a specific patient and date
     */
    public Optional<DailyReport> getReportByPatientIdAndDate(Long patientId, LocalDate date) {
        return dailyReportRepository.findByPatientPatientIdAndDate(patientId, date);
    }

    /**
     * Get reports for a patient within a date range
     */
    public List<DailyReport> getReportsByPatientIdAndDateRange(Long patientId, LocalDate startDate, LocalDate endDate) {
        return dailyReportRepository.findByPatientIdAndDateRange(patientId, startDate, endDate);
    }

    /**
     * Get reports for a guardian within a date range
     */
    public List<DailyReport> getReportsByGuardianIdAndDateRange(Long guardianId, LocalDate startDate, LocalDate endDate) {
        return dailyReportRepository.findByGuardianIdAndDateRange(guardianId, startDate, endDate);
    }
}
