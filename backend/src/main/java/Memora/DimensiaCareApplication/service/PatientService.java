package Memora.DimensiaCareApplication.service;

import Memora.DimensiaCareApplication.model.Patient;
import Memora.DimensiaCareApplication.model.User;
import Memora.DimensiaCareApplication.model.Guardian;
import Memora.DimensiaCareApplication.model.Caregiver;
import Memora.DimensiaCareApplication.repository.PatientRepository;
import Memora.DimensiaCareApplication.repository.UserRepository;
import Memora.DimensiaCareApplication.repository.GuardianRepository;
import Memora.DimensiaCareApplication.repository.CaregiverRepository;
import Memora.DimensiaCareApplication.repository.GuardianPatientCaregiverConnectionRepository;
import Memora.DimensiaCareApplication.model.GuardianPatientCaregiverConnection;
import Memora.DimensiaCareApplication.dto.response.PatientDetailsResponse;
import Memora.DimensiaCareApplication.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;


import Memora.DimensiaCareApplication.dto.CreateTaskRequestDTO;
import Memora.DimensiaCareApplication.dto.PatientProfileDTO;
import Memora.DimensiaCareApplication.dto.ScheduleTaskDTO;
import Memora.DimensiaCareApplication.dto.UpdateTaskStatusDTO;
import Memora.DimensiaCareApplication.model.Appointment;
import Memora.DimensiaCareApplication.model.CareActivity;
import Memora.DimensiaCareApplication.model.CareActivityStatus;
import Memora.DimensiaCareApplication.model.DailyTask;
import Memora.DimensiaCareApplication.model.Game;
import Memora.DimensiaCareApplication.model.MedicationReminder;
import Memora.DimensiaCareApplication.model.Medication;
import Memora.DimensiaCareApplication.model.Schedule;
import Memora.DimensiaCareApplication.model.Task;
import Memora.DimensiaCareApplication.repository.AppointmentRepository;
import Memora.DimensiaCareApplication.repository.CareActivityRepository;
import Memora.DimensiaCareApplication.repository.DailyTaskRepository;
import Memora.DimensiaCareApplication.repository.GameRepository;
import Memora.DimensiaCareApplication.repository.MedicationRepository;
import Memora.DimensiaCareApplication.repository.ScheduleRepository;
import Memora.DimensiaCareApplication.repository.TaskRepository;

@Service
public class PatientService {

    @Autowired
    private PatientRepository patientRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private GuardianRepository guardianRepository;

    @Autowired
    private GuardianPatientCaregiverConnectionRepository connectionRepository;
    
    @Autowired
    private CaregiverRepository caregiverRepository;

    @Autowired
    private ScheduleRepository scheduleRepository;

    @Autowired
    private CareActivityRepository careActivityRepository;

    @Autowired
    private DailyTaskRepository dailyTaskRepository;

    @Autowired
    private TaskRepository taskRepository;

    @Autowired
    private MedicationReminderRepository medicationReminderRepository;

    @Autowired
    private AppointmentRepository appointmentRepository;

    @Autowired
    private GameRepository gameRepository;

    @Autowired
    private MedicationRepository medicationRepository;

    public Patient addPatient(Patient patient, Long userId, Long guardianId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found with id: " + userId));
        patient.setUser(user);

        if (guardianId != null) {
            Guardian guardian = guardianRepository.findById(guardianId)
                    .orElseThrow(() -> new RuntimeException("Guardian not found with id: " + guardianId));
            patient.setGuardian(guardian);
        }

        return patientRepository.save(patient);
    }

    public List<Patient> getPatientsByGuardian(Long guardianId) {
        return patientRepository.findByGuardian_GuardianId(guardianId);
    }

    public Patient getPatientById(Long patientId) {
        return patientRepository.findById(patientId).orElse(null);
    }

    // Add a new method to get PatientDetailsResponse with acceptedDate and guardian info
    public PatientDetailsResponse getPatientDetailsWithAcceptedDate(Long patientId) {
        Patient patient = patientRepository.findById(patientId).orElse(null);
        if (patient == null) {
            return null;
        }
        PatientDetailsResponse resp = PatientDetailsResponse.fromPatient(patient);
        // Fetch connection for this patient and find active connection
        List<GuardianPatientCaregiverConnection> connections = connectionRepository.findByPatientId(patientId);
        GuardianPatientCaregiverConnection acceptedConn = connections.stream()
                .filter(conn -> conn.getStatus() == GuardianPatientCaregiverConnection.ConnectionStatus.ACTIVE)
                .findFirst().orElse(null);
        if (acceptedConn != null && acceptedConn.getConnectedDateTime() != null) {
            resp.setAcceptedDate(acceptedConn.getConnectedDateTime().toString());
            // populate guardian info if available
            Long gid = acceptedConn.getGuardianId();
            if (gid != null) {
                resp.setGuardianId(gid);
                Guardian g = guardianRepository.findById(gid).orElse(null);
                if (g != null && g.getUser() != null) {
                    resp.setGuardianName(g.getUser().getFName() + " " + g.getUser().getLName());
                    resp.setGuardianEmail(g.getUser().getEmail());
                    resp.setGuardianPhone(g.getUser().getPhoneNumber());
                }
            }
            // populate caregiver info if available
            Long cid = acceptedConn.getCaregiverId();
            if (cid != null) {
                resp.setCaregiverId(cid);
                Caregiver c = caregiverRepository.findById(cid.intValue()).orElse(null);
                if (c != null && c.getUser() != null) {
                    resp.setCaregiverName(c.getUser().getFName() + " " + c.getUser().getLName());
                    resp.setCaregiverEmail(c.getUser().getEmail());
                    resp.setCaregiverPhone(c.getUser().getPhoneNumber());
                    resp.setCaregiverCity(c.getUser().getCity());
                }
            }
        } else {
            // if no active connection, try to set guardian info if patient has a guardian reference
            if (patient.getGuardian() != null && patient.getGuardian().getUser() != null) {
                resp.setGuardianId(patient.getGuardian().getGuardianId());
                resp.setGuardianName(patient.getGuardian().getUser().getFName() + " " + patient.getGuardian().getUser().getLName());
                resp.setGuardianEmail(patient.getGuardian().getUser().getEmail());
                resp.setGuardianPhone(patient.getGuardian().getUser().getPhoneNumber());
            }
        }
        return resp;
    }

    // New methods for patient dashboard
    public PatientProfileDTO getPatientProfile(Long patientId) {
        Patient patient = patientRepository.findById(patientId)
                .orElseThrow(() -> new RuntimeException("Patient not found"));

        User user = patient.getUser();

        // Get active connection to get guardian and caregiver IDs
        List<GuardianPatientCaregiverConnection> connections = connectionRepository.findByPatientId(patientId);
        GuardianPatientCaregiverConnection activeConn = connections.stream()
                .filter(conn -> conn.getStatus() == GuardianPatientCaregiverConnection.ConnectionStatus.ACTIVE)
                .findFirst().orElse(null);

        Long guardianId = activeConn != null ? activeConn.getGuardianId() : null;
        Long caregiverId = activeConn != null ? activeConn.getCaregiverId() : null;

        PatientProfileDTO dto = new PatientProfileDTO();
        dto.setPatientId(patient.getPatientID());
        dto.setUserId(user.getId());
        dto.setFirstName(user.getFName());
        dto.setLastName(user.getLName());
        dto.setEmail(user.getEmail());
        dto.setDementiaStage(patient.getDementiaStage().name());
        dto.setDementiaType(patient.getDementiaType().name());
        dto.setDateOfDiagnosis(patient.getDateOfDiagnosis() != null ? patient.getDateOfDiagnosis().toString() : null);
        dto.setGuardianId(guardianId);
        dto.setCaregiverId(caregiverId);
        return dto;
    }

    public List<ScheduleTaskDTO> getScheduleForDate(Long patientId, String dateStr) {
        LocalDate date = LocalDate.parse(dateStr);
        List<ScheduleTaskDTO> tasks = new ArrayList<>();

        // Find schedule for this date
        Optional<Schedule> scheduleOpt = scheduleRepository.findByPatientPatientIdAndDate(patientId, date);

        if (!scheduleOpt.isPresent()) {
            return tasks; // Return empty list if no schedule exists
        }

        Schedule schedule = scheduleOpt.get();

        // Get all care activities for this schedule, ordered by time
        List<CareActivity> careActivities = careActivityRepository
                .findByScheduleScheduleIdOrderByTime(schedule.getScheduleId());

        // Convert each care activity to ScheduleTaskDTO
        for (CareActivity careActivity : careActivities) {
            ScheduleTaskDTO taskDTO = convertCareActivityToDTO(careActivity);
            if (taskDTO != null) {
                tasks.add(taskDTO);
            }
        }
        return tasks;
    }

    private ScheduleTaskDTO convertCareActivityToDTO(CareActivity careActivity) {
        ScheduleTaskDTO dto = new ScheduleTaskDTO();
        dto.setCareActivityId(careActivity.getCareActivityId());
        dto.setTime(careActivity.getTime().toString());
        dto.setStatus(careActivity.getStatus().name());
        dto.setSkipReason(careActivity.getSkipReason());
        // Check which type of task this is
        if (!careActivity.getDailyTasks().isEmpty()) {
            // Daily Activity
            DailyTask dailyTask = careActivity.getDailyTasks().iterator().next();
            dto.setTaskType("DAILY_ACTIVITY");
            dto.setTaskId(dailyTask.getDailyTaskId());
            dto.setTitle(dailyTask.getDailyTaskName());
            dto.setDescription(dailyTask.getDescription());
        } else if (!careActivity.getTasks().isEmpty()) {
            // Game
            Task task = careActivity.getTasks().iterator().next();
            Game game = task.getGame();
            dto.setTaskType("GAME");
            dto.setTaskId(task.getTaskId());
            dto.setGameId(game.getGameId());
            dto.setGameName(game.getName());
            dto.setTitle(game.getName());
            dto.setDescription(game.getDescription());
        } else {
            // Check for medication or appointment
            List<MedicationReminder> medReminders = medicationReminderRepository
                    .findByCareActivityCareActivityId(careActivity.getCareActivityId());
            if (!medReminders.isEmpty()) {
                // Medication
                MedicationReminder reminder = medReminders.get(0);
                Medication medication = reminder.getMedication();
                dto.setTaskType("MEDICATION");
                dto.setTaskId(reminder.getMedicationReminderId());
                dto.setMedicationId(medication.getMedicationId());
                dto.setMedicationName(medication.getMedicationName());
                dto.setTitle(medication.getMedicationName());
                dto.setDosage(medication.getDosage());
                dto.setMealTiming(medication.getMealTiming());
                dto.setDescription(medication.getDescription());
            } else {
                // Check for appointment
                List<Appointment> appointments = appointmentRepository
                        .findByCareActivityCareActivityId(careActivity.getCareActivityId());
                if (!appointments.isEmpty()) {
                    Appointment appointment = appointments.get(0);
                    dto.setTaskType("APPOINTMENT");
                    dto.setTaskId(appointment.getAppointmentId());
                    dto.setTitle(appointment.getTaskName());
                    dto.setDescription(appointment.getDescription());
                    dto.setHospital(appointment.getHospital());
                    dto.setDoctorName(appointment.getDoctorName());
                    dto.setAppointmentDate(appointment.getDate() != null ? appointment.getDate().toString() : null);
                }
            }
        }
        return dto;
    }

    public ScheduleTaskDTO createTask(Long patientId, CreateTaskRequestDTO request) {
        Patient patient = patientRepository.findById(patientId)
                .orElseThrow(() -> new RuntimeException("Patient not found"));
        // Validate task type based on dementia stage
        String dementiaStage = patient.getDementiaStage().name();
        if ("SEVERE".equals(dementiaStage) || "VERY_SEVERE".equals(dementiaStage)) {
            if ("MEDICATION".equals(request.getTaskType()) || "APPOINTMENT".equals(request.getTaskType())) {
                throw new RuntimeException(
                        "Patients with SEVERE or VERY_SEVERE dementia cannot add MEDICATION or APPOINTMENT tasks");
            }
        }

        LocalDate date = LocalDate.parse(request.getDate());
        LocalTime time = LocalTime.parse(request.getTime());

        // Get guardian from patient
        Guardian guardian = patient.getGuardian();
        if (guardian == null) {
            throw new RuntimeException("Patient must have a guardian assigned to create tasks");
        }

        // Get active connection to find caregiver (optional)
        List<GuardianPatientCaregiverConnection> connections = connectionRepository.findByPatientId(patientId);
        GuardianPatientCaregiverConnection activeConn = connections.stream()
                .filter(conn -> conn.getStatus() == GuardianPatientCaregiverConnection.ConnectionStatus.ACTIVE)
                .findFirst()
                .orElse(null);

        // Get caregiver from connection (can be null)
        Caregiver caregiver = null;
        if (activeConn != null) {
            caregiver = caregiverRepository.findById(activeConn.getCaregiverId().intValue())
                    .orElse(null);
        }

        // For MEDICATION tasks, handle date range differently
        if ("MEDICATION".equals(request.getTaskType())) {
            return createMedicationTask(patient, guardian, caregiver, patientId, request, time);
        }

        // Find or create schedule for the date (for non-medication tasks)
        Optional<Schedule> scheduleOpt = scheduleRepository.findByPatientPatientIdAndDate(patientId, date);
        Schedule schedule;
        if (!scheduleOpt.isPresent()) {
            // Create new schedule with patient's guardian and connection's caregiver (if
            // exists)
            schedule = new Schedule(patient, guardian, caregiver, date);
            schedule = scheduleRepository.save(schedule);
        } else {
            schedule = scheduleOpt.get();
        }

        // Create CareActivity
        CareActivity careActivity = new CareActivity(schedule, time, CareActivityStatus.PENDING);
        careActivity = careActivityRepository.save(careActivity);

        // Create specific task type
        switch (request.getTaskType()) {
            case "DAILY_ACTIVITY": {
                DailyTask dailyTask = new DailyTask();
                dailyTask.setCareActivity(careActivity);
                dailyTask.setDailyTaskName(request.getTitle());
                dailyTask.setDescription(request.getDescription());
                dailyTaskRepository.save(dailyTask);
                break;
            }
            case "GAME": {
                Game game = gameRepository.findById(request.getGameId())
                        .orElseThrow(() -> new RuntimeException("Game not found"));
                Task task = new Task(careActivity, game);
                taskRepository.save(task);
                break;
            }
            case "APPOINTMENT": {
                Appointment appointment = new Appointment();
                appointment.setCareActivity(careActivity);
                appointment.setTaskName(request.getTitle());
                appointment.setDescription(request.getDescription());
                appointment.setHospital(request.getHospital());
                appointment.setDoctorName(request.getDoctorName());
                appointment.setTime(time);
                appointment.setDate(date);
                appointmentRepository.save(appointment);
                break;
            }
            default:
                throw new RuntimeException("Invalid task type: " + request.getTaskType());
        }
        // Return the created task as DTO
        return convertCareActivityToDTO(careActivity);
    }

    public void updateTaskStatus(Long careActivityId, UpdateTaskStatusDTO request) {
        CareActivity careActivity = careActivityRepository.findById(careActivityId)
                .orElseThrow(() -> new RuntimeException("Care activity not found"));

        CareActivityStatus newStatus = CareActivityStatus.valueOf(request.getStatus());

        // Validate skip reason if status is SKIPPED
        if (newStatus == CareActivityStatus.SKIPPED) {
            if (request.getSkipReason() == null || request.getSkipReason().trim().isEmpty()) {
                throw new RuntimeException("Skip reason is mandatory when skipping a task");
            }
            careActivity.setSkipReason(request.getSkipReason());
        } else {
            // Clear skip reason if not skipping
            careActivity.setSkipReason(null);
        }
        careActivity.setStatus(newStatus);
        careActivityRepository.save(careActivity);
    }

    public Patient getPatientByUserId(Long userId) {
        return patientRepository.findByUser_Id(userId).orElse(null);
    }

    private ScheduleTaskDTO createMedicationTask(Patient patient, Guardian guardian, Caregiver caregiver,
            Long patientId, CreateTaskRequestDTO request, LocalTime time) {
        // Step 1: Create or get Medication entity
        Medication medication;
        if (request.getMedicationId() != null) {
            // Use existing medication
            medication = medicationRepository.findById(request.getMedicationId())
                    .orElseThrow(
                            () -> new RuntimeException("Medication not found with ID: " + request.getMedicationId()));
        } else {
            // Create new medication with all required fields
            if (request.getTitle() == null || request.getTitle().trim().isEmpty()) {
                throw new RuntimeException("Medication name (title) is required");
            }
            if (request.getDosage() == null || request.getDosage().trim().isEmpty()) {
                throw new RuntimeException("Dosage is required for medication tasks");
            }
            if (request.getMealTiming() == null || request.getMealTiming().trim().isEmpty()) {
                throw new RuntimeException("Meal timing is required for medication tasks");
            }
            if (request.getFromDate() == null) {
                throw new RuntimeException("From date is required for medication tasks");
            }
            if (request.getToDate() == null) {
                throw new RuntimeException("To date (due date) is required for medication tasks");
            }

            medication = new Medication();
            medication.setPatientId(patientId);
            medication.setMedicationName(request.getTitle());
            medication.setDosage(request.getDosage());
            medication.setMealTiming(request.getMealTiming());
            medication.setTime(time);
            medication.setDescription(request.getDescription());
            medication.setFromDate(LocalDate.parse(request.getFromDate()));
            medication.setDueDate(LocalDate.parse(request.getToDate()));
            medication = medicationRepository.save(medication);
        }

        // Step 2 & 3: Create Schedule and CareActivity for each date in range
        LocalDate fromDate = LocalDate.parse(request.getFromDate());
        LocalDate toDate = LocalDate.parse(request.getToDate());

        CareActivity firstCareActivity = null; // To return the first one

        // Iterate through each date in the range
        LocalDate currentDate = fromDate;
        while (!currentDate.isAfter(toDate)) {
            // Find or create schedule for this date
            Optional<Schedule> dateScheduleOpt = scheduleRepository.findByPatientPatientIdAndDate(patientId,
                    currentDate);
            Schedule dateSchedule;
            if (!dateScheduleOpt.isPresent()) {
                dateSchedule = new Schedule(patient, guardian, caregiver, currentDate);
                dateSchedule = scheduleRepository.save(dateSchedule);
            } else {
                dateSchedule = dateScheduleOpt.get();
            }

            // Create CareActivity for this date
            CareActivity dateCareActivity = new CareActivity(dateSchedule, time, CareActivityStatus.PENDING);
            dateCareActivity = careActivityRepository.save(dateCareActivity);

            // Step 4: Create MedicationReminder linking CareActivity to Medication
            MedicationReminder reminder = new MedicationReminder();
            reminder.setCareActivity(dateCareActivity);
            reminder.setMedication(medication);
            medicationReminderRepository.save(reminder);

            // Save the first care activity to return
            if (firstCareActivity == null) {
                firstCareActivity = dateCareActivity;
            }

            // Move to next date
            currentDate = currentDate.plusDays(1);
        }

        // Return the first created medication reminder's activity as DTO
        return convertCareActivityToDTO(firstCareActivity);
    }

    public List<PatientDetailsResponse> getAllPatients() {
        List<Patient> patients = patientRepository.findAll();
        return patients.stream()
                .map(PatientDetailsResponse::fromPatient)
                .collect(Collectors.toList());
    }
}
