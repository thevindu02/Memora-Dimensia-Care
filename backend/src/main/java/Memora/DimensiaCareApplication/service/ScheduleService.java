package Memora.DimensiaCareApplication.service;

import Memora.DimensiaCareApplication.model.*;
import Memora.DimensiaCareApplication.dto.DailyActivityRequest;
import Memora.DimensiaCareApplication.dto.DailyActivityResponse;
import Memora.DimensiaCareApplication.repository.ScheduleRepository;
import Memora.DimensiaCareApplication.repository.CareActivityRepository;
import Memora.DimensiaCareApplication.repository.DailyTaskRepository;
import Memora.DimensiaCareApplication.repository.PatientRepository;
import Memora.DimensiaCareApplication.repository.GuardianRepository;
import Memora.DimensiaCareApplication.repository.CaregiverRepository;
import Memora.DimensiaCareApplication.repository.GuardianPatientCaregiverConnectionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class ScheduleService {

    @Autowired
    private ScheduleRepository scheduleRepository;

    @Autowired
    private CareActivityRepository careActivityRepository;

    @Autowired
    private DailyTaskRepository dailyTaskRepository;

    @Autowired
    private PatientRepository patientRepository;

    @Autowired
    private GuardianRepository guardianRepository;

    @Autowired
    private CaregiverRepository caregiverRepository;

    @Autowired
    private GuardianPatientCaregiverConnectionRepository connectionRepository;

    @Autowired
    private DailyReportService dailyReportService;

    // Create a new schedule with default daily routine tasks
    public Schedule createScheduleWithDefaultTasks(Patient patient, Guardian guardian, Caregiver caregiver,
            LocalDate date) {
        // Create the schedule first
        Schedule schedule = new Schedule(patient, guardian, caregiver, date);
        schedule = scheduleRepository.save(schedule);

        // Create default daily routine tasks
        createDefaultDailyTasks(schedule);

        return schedule;
    }

    // Create default daily routine tasks for a schedule
    private void createDefaultDailyTasks(Schedule schedule) {
        // Define default daily routine activities with their times
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

    // Get all schedules
    public List<Schedule> getAllSchedules() {
        return scheduleRepository.findAll();
    }

    // Get schedule by ID
    public Optional<Schedule> getScheduleById(Long id) {
        return scheduleRepository.findById(id);
    }

    // Get schedules by patient ID
    public List<Schedule> getSchedulesByPatientId(Long patientId) {
        return scheduleRepository.findByPatientPatientId(patientId);
    }

    // Get schedules by caregiver ID
    public List<Schedule> getSchedulesByCaregiverId(Integer caregiverId) {
        return scheduleRepository.findByCaregiverCaregiverId(caregiverId);
    }

    // Get schedules by guardian ID
    public List<Schedule> getSchedulesByGuardianId(Long guardianId) {
        return scheduleRepository.findByGuardianGuardianId(guardianId);
    }

    // Get schedule by patient and date
    public Optional<Schedule> getScheduleByPatientAndDate(Long patientId, LocalDate date) {
        return scheduleRepository.findByPatientPatientIdAndDate(patientId, date);
    }

    // Update schedule completion status
    public Schedule updateScheduleCompletion(Long scheduleId, boolean isCompleted) {
        Optional<Schedule> optionalSchedule = scheduleRepository.findById(scheduleId);
        if (optionalSchedule.isPresent()) {
            Schedule schedule = optionalSchedule.get();
            schedule.setIsCompleted(isCompleted);
            Schedule savedSchedule = scheduleRepository.save(schedule);
            
            // Generate daily report when schedule is marked as complete
            if (isCompleted) {
                try {
                    dailyReportService.generateReportFromSchedule(scheduleId);
                    System.out.println("Daily report generated successfully for schedule " + scheduleId);
                } catch (Exception e) {
                    System.err.println("Error generating daily report for schedule " + scheduleId + ": " + e.getMessage());
                    e.printStackTrace();
                }
            }
            
            return savedSchedule;
        }
        throw new RuntimeException("Schedule not found with ID: " + scheduleId);
    }

    // Delete schedule
    public void deleteSchedule(Long scheduleId) {
        scheduleRepository.deleteById(scheduleId);
    }

    // Check if schedule exists for patient on specific date
    public boolean scheduleExistsForPatientOnDate(Long patientId, LocalDate date) {
        return scheduleRepository.findByPatientPatientIdAndDate(patientId, date).isPresent();
    }

    // Get incomplete schedules
    public List<Schedule> getIncompleteSchedules() {
        return scheduleRepository.findByIsCompletedFalse();
    }

    // Get completed schedules
    public List<Schedule> getCompletedSchedules() {
        return scheduleRepository.findByIsCompletedTrue();
    }

    // Get or create schedule for a patient on a specific date
    public Schedule getOrCreateScheduleForPatientAndDate(Long patientId, LocalDate date) {
        // First try to find existing schedule
        Optional<Schedule> existingSchedule = scheduleRepository.findByPatientPatientIdAndDate(patientId, date);
        if (existingSchedule.isPresent()) {
            return existingSchedule.get();
        }

        // Schedule doesn't exist, create a new empty one
        Patient patient = patientRepository.findById(patientId).orElse(null);
        if (patient == null) {
            throw new RuntimeException("Patient not found with ID: " + patientId);
        }

        // Find the active guardian-patient-caregiver connection
        List<GuardianPatientCaregiverConnection> connections = connectionRepository.findByPatientIdAndStatus(
                patientId,
                GuardianPatientCaregiverConnection.ConnectionStatus.ACTIVE);

        if (connections.isEmpty()) {
            System.out.println("No active caregiver connection found for patient " + patientId);
            return null;
        }

        // Use the first active connection
        GuardianPatientCaregiverConnection activeConnection = connections.get(0);

        // Get guardian and caregiver
        Guardian guardian = guardianRepository.findById(activeConnection.getGuardianId()).orElse(null);
        Caregiver caregiver = caregiverRepository.findById(activeConnection.getCaregiverId().intValue()).orElse(null);

        if (guardian == null || caregiver == null) {
            System.out.println("Guardian or Caregiver not found for patient " + patientId);
            return null;
        }

        // Create empty schedule (no default tasks)
        Schedule schedule = new Schedule(patient, guardian, caregiver, date);
        schedule = scheduleRepository.save(schedule);

        System.out.println("Created empty schedule for patient " + patientId + " on " + date);
        return schedule;
    }

    // ===== DAILY ACTIVITIES METHODS =====

    // Add daily activity to schedule
    public DailyActivityResponse addDailyActivity(Long scheduleId, DailyActivityRequest request) {
        // Check if schedule exists
        Schedule schedule = scheduleRepository.findById(scheduleId)
                .orElseThrow(() -> new RuntimeException("Schedule not found with ID: " + scheduleId));

        // Create CareActivity
        CareActivity careActivity = new CareActivity();
        careActivity.setSchedule(schedule);
        careActivity.setTime(request.getTimeAsLocalTime());
        careActivity.setStatus(CareActivityStatus.PENDING);
        careActivity = careActivityRepository.save(careActivity);

        // Create DailyTask
        DailyTask dailyTask = new DailyTask();
        dailyTask.setCareActivity(careActivity);
        dailyTask.setDailyTaskName(request.getTaskName());
        dailyTask.setDescription(request.getDescription());
        dailyTask = dailyTaskRepository.save(dailyTask);

        // Return response
        return new DailyActivityResponse(
                careActivity.getCareActivityId(),
                dailyTask.getDailyTaskId(),
                dailyTask.getDailyTaskName(),
                careActivity.getTime().toString(),
                dailyTask.getDescription(),
                careActivity.getStatus().toString());
    }

    // Get daily activities by schedule ID
    public List<DailyActivityResponse> getDailyActivitiesBySchedule(Long scheduleId) {
        // Check if schedule exists
        Schedule schedule = scheduleRepository.findById(scheduleId)
                .orElseThrow(() -> new RuntimeException("Schedule not found with ID: " + scheduleId));

        // If schedule is completed, return empty list
        if (schedule.getIsCompleted() != null && schedule.getIsCompleted()) {
            return List.of();
        }

        // Get all care activities for the schedule
        List<CareActivity> careActivities = careActivityRepository.findByScheduleScheduleIdOrderByTime(scheduleId);

        // Convert to response DTOs
        return careActivities.stream()
                .filter(ca -> ca.getDailyTasks() != null && !ca.getDailyTasks().isEmpty())
                .map(careActivity -> {
                    DailyTask dailyTask = careActivity.getDailyTasks().iterator().next(); // Get first daily task
                    return new DailyActivityResponse(
                            careActivity.getCareActivityId(),
                            dailyTask.getDailyTaskId(),
                            dailyTask.getDailyTaskName(),
                            careActivity.getTime().toString(),
                            dailyTask.getDescription(),
                            careActivity.getStatus().toString());
                })
                .toList();
    }

    // Update daily activity
    public DailyActivityResponse updateDailyActivity(Long careActivityId, DailyActivityRequest request) {
        // Find care activity
        CareActivity careActivity = careActivityRepository.findById(careActivityId)
                .orElseThrow(() -> new RuntimeException("Care activity not found with ID: " + careActivityId));

        // Update care activity
        careActivity.setTime(request.getTimeAsLocalTime());
        careActivity = careActivityRepository.save(careActivity);

        // Update daily task
        if (careActivity.getDailyTasks() != null && !careActivity.getDailyTasks().isEmpty()) {
            DailyTask dailyTask = careActivity.getDailyTasks().iterator().next();
            dailyTask.setDailyTaskName(request.getTaskName());
            dailyTask.setDescription(request.getDescription());
            dailyTask = dailyTaskRepository.save(dailyTask);

            return new DailyActivityResponse(
                    careActivity.getCareActivityId(),
                    dailyTask.getDailyTaskId(),
                    dailyTask.getDailyTaskName(),
                    careActivity.getTime().toString(),
                    dailyTask.getDescription(),
                    careActivity.getStatus().toString());
        }

        throw new RuntimeException("No daily task found for care activity: " + careActivityId);
    }

    // Delete daily activity
    public void deleteDailyActivity(Long careActivityId) {
        // Find care activity
        CareActivity careActivity = careActivityRepository.findById(careActivityId)
                .orElseThrow(() -> new RuntimeException("Care activity not found with ID: " + careActivityId));

        // Delete associated daily tasks first
        if (careActivity.getDailyTasks() != null) {
            dailyTaskRepository.deleteAll(careActivity.getDailyTasks());
        }

        // Delete care activity
        careActivityRepository.delete(careActivity);
    }
}
