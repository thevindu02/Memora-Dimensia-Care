package Memora.DimensiaCareApplication.service;

import Memora.DimensiaCareApplication.model.*;
import Memora.DimensiaCareApplication.repository.*;
import Memora.DimensiaCareApplication.dto.DailyActivityRequest;
import Memora.DimensiaCareApplication.dto.DailyActivityResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@Service
@Transactional
public class DailySchedulerService {

    @Autowired
    private ScheduleRepository scheduleRepository;

    @Autowired
    private CareActivityRepository careActivityRepository;

    @Autowired
    private DailyTaskRepository dailyTaskRepository;

    @Autowired
    private PatientRepository patientRepository;

    @Autowired
    private GuardianPatientCaregiverConnectionRepository connectionRepository;

    @Autowired
    private GuardianRepository guardianRepository;

    @Autowired
    private CaregiverRepository caregiverRepository;

    // Runs every day at 12:00 PM for testing purposes
    @Scheduled(cron = "0 48 12 * * *") // Runs at 12:00:00 every day
    public void createDailySchedulesForAllPatients() {
        System.out.println("Creating daily schedules for all patients...");

        LocalDate today = LocalDate.now();

        // Get all active patients
        List<Patient> allPatients = patientRepository.findAll();

        for (Patient patient : allPatients) {
            try {
                createDailyScheduleForPatient(patient, today);
            } catch (Exception e) {
                System.err.println(
                        "Error creating schedule for patient ID " + patient.getPatientID() + ": " + e.getMessage());
            }
        }

        System.out.println("Daily schedule creation completed.");
    }

    // Create daily schedule for a specific patient
    private void createDailyScheduleForPatient(Patient patient, LocalDate date) {
        // Check if schedule already exists for this patient on this date
        if (scheduleRepository.findByPatientPatientIdAndDate(patient.getPatientID(), date).isPresent()) {
            System.out.println("Schedule already exists for patient " + patient.getPatientID() + " on " + date);
            return;
        }

        // Find the active guardian-patient-caregiver connection
        List<GuardianPatientCaregiverConnection> connections = connectionRepository.findByPatientIdAndStatus(
                patient.getPatientID(),
                GuardianPatientCaregiverConnection.ConnectionStatus.ACTIVE);

        if (connections.isEmpty()) {
            System.out.println("No active caregiver connection found for patient " + patient.getPatientID());
            return;
        }

        // Use the first active connection
        GuardianPatientCaregiverConnection activeConnection = connections.get(0);

        // Get guardian and caregiver
        Guardian guardian = guardianRepository.findById(activeConnection.getGuardianId()).orElse(null);
        Caregiver caregiver = caregiverRepository.findById(activeConnection.getCaregiverId().intValue()).orElse(null);

        if (guardian == null || caregiver == null) {
            System.out.println("Guardian or Caregiver not found for patient " + patient.getPatientID());
            return;
        }

        // Create the schedule
        Schedule schedule = new Schedule(patient, guardian, caregiver, date);
        schedule = scheduleRepository.save(schedule);

        // Create default daily routine tasks
        createDefaultDailyTasks(schedule);

        System.out.println("Created daily schedule for patient " + patient.getPatientID() + " on " + date);
    }

    // Create default daily routine tasks for a schedule
    private void createDefaultDailyTasks(Schedule schedule) {
        // Define default daily routine activities with their times (matching the mobile
        // app)
        createCareActivityWithTask(schedule, LocalTime.of(8, 0), "Breakfast Time", "Morning meal");
        createCareActivityWithTask(schedule, LocalTime.of(18, 0), "Dinner Time", "Evening meal");
        createCareActivityWithTask(schedule, LocalTime.of(19, 0), "Bathing Time", "Personal hygiene");
        createCareActivityWithTask(schedule, LocalTime.of(22, 0), "Sleep Time", "Night rest");
    }

    // Helper method to create care activity with daily task
    private void createCareActivityWithTask(Schedule schedule, LocalTime time, String taskName, String description) {
        // Create care activity
        CareActivity careActivity = new CareActivity(schedule, time, CareActivityStatus.PENDING);
        careActivity = careActivityRepository.save(careActivity);

        // Create daily task for the care activity
        DailyTask dailyTask = new DailyTask(careActivity, taskName, description);
        dailyTaskRepository.save(dailyTask);
    }

    // Manual method to create schedules for today (for testing or immediate
    // creation)
    public void createTodaySchedulesManually() {
        createDailySchedulesForAllPatients();
    }

    /**
     * Update a daily activity (task name, description, time) for a given
     * dailyTaskId.
     * Also updates the associated CareActivity time if provided.
     */
    public DailyActivityResponse updateDailyActivity(Long dailyTaskId, DailyActivityRequest request) {
        DailyTask dailyTask = dailyTaskRepository.findById(dailyTaskId).orElse(null);
        if (dailyTask == null) {
            return null;
        }

        // Update task name and description
        dailyTask.setDailyTaskName(request.getTaskName());
        dailyTask.setDescription(request.getDescription());

        // Update time in CareActivity if provided
        if (request.getTime() != null && !request.getTime().isEmpty()) {
            CareActivity careActivity = dailyTask.getCareActivity();
            careActivity.setTime(request.getTimeAsLocalTime());
            careActivityRepository.save(careActivity);
        }

        dailyTaskRepository.save(dailyTask);

        // Build response
        CareActivity careActivity = dailyTask.getCareActivity();
        String status = careActivity.getStatus() != null ? careActivity.getStatus().name() : "PENDING";
        return new DailyActivityResponse(
                careActivity.getCareActivityId(),
                dailyTask.getDailyTaskId(),
                dailyTask.getDailyTaskName(),
                careActivity.getTime() != null ? careActivity.getTime().toString() : null,
                dailyTask.getDescription(),
                status);
    }

    // Method to create schedules for a specific date (useful for testing)
    public void createSchedulesForDate(LocalDate date) {
        List<Patient> allPatients = patientRepository.findAll();

        for (Patient patient : allPatients) {
            try {
                createDailyScheduleForPatient(patient, date);
            } catch (Exception e) {
                System.err.println(
                        "Error creating schedule for patient ID " + patient.getPatientID() + ": " + e.getMessage());
            }
        }
    }
}
