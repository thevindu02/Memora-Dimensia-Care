package Memora.DimensiaCareApplication.service;

import Memora.DimensiaCareApplication.model.*;
import Memora.DimensiaCareApplication.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.*;

@Service
@Transactional
public class TaskReminderScheduler {

    private static final Logger logger = LoggerFactory.getLogger(TaskReminderScheduler.class);
    private static final int REMINDER_MINUTES_BEFORE = 4;

    @Autowired
    private CareActivityRepository careActivityRepository;

    @Autowired
    private MedicationReminderRepository medicationReminderRepository;

    @Autowired
    private AppointmentRepository appointmentRepository;

    @Autowired
    private FCMNotificationService fcmNotificationService;

    @Autowired
    private UserFCMTokenService userFCMTokenService;

    // Track sent reminders to avoid duplicates (in-memory, could be moved to
    // database)
    private Set<String> sentReminders = Collections.synchronizedSet(new HashSet<>());

    /**
     * Check for upcoming tasks every 1 minute
     * Sends notifications 4 minutes before the scheduled time
     */
    @Scheduled(fixedRate = 60000) // 1 minute = 60000 milliseconds
    public void checkUpcomingTasks() {
        try {
            LocalDateTime now = LocalDateTime.now();
            // Calculate the target time (REMINDER_MINUTES_BEFORE from now)
            LocalDateTime targetTime = now.plusMinutes(REMINDER_MINUTES_BEFORE);
            // Create a window: ±1 minute around the target time (to catch tasks within
            // 1-minute check interval)
            LocalDateTime windowStart = targetTime.minusMinutes(1);
            LocalDateTime windowEnd = targetTime.plusMinutes(1);

            logger.info("===========================================");
            logger.info("⏰ CHECKING FOR UPCOMING TASKS");
            logger.info("Current Time: {}", now);
            logger.info("Target Reminder Time: {} ({} minutes from now)", targetTime, REMINDER_MINUTES_BEFORE);
            logger.info("Looking for tasks between {} and {} (2-minute window)", windowStart, windowEnd);
            logger.info("===========================================");

            // Check Daily Activities & Game Tasks
            checkDailyActivities(windowStart, windowEnd);

            // Check Medication Reminders
            checkMedicationReminders(windowStart, windowEnd);

            // Check Appointments
            checkAppointments(windowStart, windowEnd);

            // Clean up old reminders (older than 1 hour)
            cleanupOldReminders();

        } catch (Exception e) {
            logger.error("Error in task reminder scheduler: {}", e.getMessage(), e);
        }
    }

    /**
     * Check and send reminders for daily activities and game tasks
     */
    private void checkDailyActivities(LocalDateTime windowStart, LocalDateTime windowEnd) {
        try {
            logger.info("📋 Checking Daily Activities...");
            List<CareActivity> activities = careActivityRepository.findActivitiesForToday(LocalDate.now());
            logger.info("Found {} activities for today", activities.size());

            for (CareActivity activity : activities) {
                LocalDateTime activityDateTime = LocalDateTime.of(
                        activity.getSchedule().getDate(),
                        activity.getTime());

                logger.info("  - Activity ID {}: {} scheduled at {}",
                        activity.getCareActivityId(),
                        getTaskNameFromActivity(activity),
                        activityDateTime);

                // Check if activity is within the reminder window
                if (isWithinReminderWindow(activityDateTime, windowStart, windowEnd)) {
                    logger.info("    ✅ WITHIN REMINDER WINDOW - Sending notification!");
                    sendDailyActivityReminder(activity);
                } else {
                    logger.info("    ⏸️  Not in window (task: {}, window: {} to {})", activityDateTime, windowStart,
                            windowEnd);
                }
            }
        } catch (Exception e) {
            logger.error("Error checking daily activities: {}", e.getMessage(), e);
        }
    }

    /**
     * Check and send reminders for medication
     */
    private void checkMedicationReminders(LocalDateTime windowStart, LocalDateTime windowEnd) {
        try {
            logger.info("💊 Checking Medication Reminders...");
            List<MedicationReminder> medications = medicationReminderRepository
                    .findMedicationsForToday(LocalDate.now());
            logger.info("Found {} medications for today", medications.size());

            for (MedicationReminder medication : medications) {
                // Medication time comes from the associated CareActivity
                LocalDateTime medicationDateTime = LocalDateTime.of(
                        medication.getCareActivity().getSchedule().getDate(),
                        medication.getCareActivity().getTime());

                logger.info("  - Medication ID {}: {} scheduled at {}",
                        medication.getMedicationReminderId(),
                        medication.getMedication().getMedicationName(),
                        medicationDateTime);

                if (isWithinReminderWindow(medicationDateTime, windowStart, windowEnd)) {
                    logger.info("    ✅ WITHIN REMINDER WINDOW - Sending notification!");
                    sendMedicationReminder(medication);
                } else {
                    logger.info("    ⏸️  Not in window");
                }
            }
        } catch (Exception e) {
            logger.error("Error checking medications: {}", e.getMessage(), e);
        }
    }

    /**
     * Check and send reminders for appointments
     */
    private void checkAppointments(LocalDateTime windowStart, LocalDateTime windowEnd) {
        try {
            logger.info("🏥 Checking Appointments...");
            List<Appointment> appointments = appointmentRepository.findAppointmentsForToday(LocalDate.now());
            logger.info("Found {} appointments for today", appointments.size());

            for (Appointment appointment : appointments) {
                // Appointment has its own time field
                LocalDateTime appointmentDateTime = LocalDateTime.of(
                        appointment.getDate(),
                        appointment.getTime());

                logger.info("  - Appointment ID {}: {} at {} scheduled at {}",
                        appointment.getAppointmentId(),
                        appointment.getHospital(),
                        appointment.getDoctorName(),
                        appointmentDateTime);

                if (isWithinReminderWindow(appointmentDateTime, windowStart, windowEnd)) {
                    logger.info("    ✅ WITHIN REMINDER WINDOW - Sending notification!");
                    sendAppointmentReminder(appointment);
                } else {
                    logger.info("    ⏸️  Not in window");
                }
            }
        } catch (Exception e) {
            logger.error("Error checking appointments: {}", e.getMessage(), e);
        }
    }

    /**
     * Send reminder for daily activity or game task
     */
    private void sendDailyActivityReminder(CareActivity activity) {
        try {
            String reminderKey = "activity_" + activity.getCareActivityId() + "_" + LocalDate.now();

            if (sentReminders.contains(reminderKey)) {
                logger.info("⚠️  Reminder already sent for activity ID: {}", activity.getCareActivityId());
                return;
            }

            Schedule schedule = activity.getSchedule();
            Patient patient = schedule.getPatient();
            Caregiver caregiver = schedule.getCaregiver();

            // Get task name from daily tasks or game tasks
            String taskName = getTaskNameFromActivity(activity);

            logger.info("📤 Sending Daily Activity Reminder:");
            logger.info("   Task: {}", taskName);
            logger.info("   Patient: {} {} (ID: {})", patient.getUser().getFName(), patient.getUser().getLName(),
                    patient.getPatientID());
            logger.info("   Caregiver: {} {} (ID: {})", caregiver.getUser().getFName(), caregiver.getUser().getLName(),
                    caregiver.getCaregiverId());

            // Send to Patient and Guardian
            sendToPatientAndGuardian(
                    patient,
                    "Task Reminder",
                    taskName,
                    "task_reminder",
                    String.valueOf(activity.getCareActivityId()),
                    null);

            // Send to Caregiver
            sendToCaregiver(
                    caregiver,
                    patient,
                    "Task Reminder",
                    taskName,
                    "task_reminder",
                    String.valueOf(activity.getCareActivityId()));

            sentReminders.add(reminderKey);
            logger.info("✅ Successfully sent reminder for activity ID: {} - {}", activity.getCareActivityId(),
                    taskName);

        } catch (Exception e) {
            logger.error("Error sending activity reminder: {}", e.getMessage(), e);
        }
    }

    /**
     * Send reminder for medication
     */
    private void sendMedicationReminder(MedicationReminder medication) {
        try {
            String reminderKey = "medication_" + medication.getMedicationReminderId() + "_" + LocalDate.now();

            if (sentReminders.contains(reminderKey)) {
                logger.info("⚠️  Reminder already sent for medication ID: {}", medication.getMedicationReminderId());
                return;
            }

            CareActivity careActivity = medication.getCareActivity();
            Schedule schedule = careActivity.getSchedule();
            Patient patient = schedule.getPatient();
            Caregiver caregiver = schedule.getCaregiver();

            String taskName = medication.getMedication().getMedicationName();
            String dosage = medication.getMedication().getDosage();

            logger.info("📤 Sending Medication Reminder:");
            logger.info("   Medication: {} ({})", taskName, dosage);
            logger.info("   Patient: {} {} (ID: {})", patient.getUser().getFName(), patient.getUser().getLName(),
                    patient.getPatientID());
            logger.info("   Caregiver: {} {} (ID: {})", caregiver.getUser().getFName(), caregiver.getUser().getLName(),
                    caregiver.getCaregiverId());

            // Send to Patient and Guardian
            sendToPatientAndGuardian(
                    patient,
                    "Medication Reminder",
                    taskName + (dosage != null ? " (" + dosage + ")" : ""),
                    "medication_reminder",
                    String.valueOf(medication.getMedicationReminderId()),
                    dosage);

            // Send to Caregiver
            sendToCaregiver(
                    caregiver,
                    patient,
                    "Medication Reminder",
                    taskName,
                    "medication_reminder",
                    String.valueOf(medication.getMedicationReminderId()));

            sentReminders.add(reminderKey);
            logger.info("✅ Successfully sent medication reminder for ID: {} - {}", medication.getMedicationReminderId(),
                    taskName);

        } catch (Exception e) {
            logger.error("Error sending medication reminder: {}", e.getMessage(), e);
        }
    }

    /**
     * Send reminder for appointment
     */
    private void sendAppointmentReminder(Appointment appointment) {
        try {
            String reminderKey = "appointment_" + appointment.getAppointmentId() + "_" + LocalDate.now();

            if (sentReminders.contains(reminderKey)) {
                logger.info("⚠️  Reminder already sent for appointment ID: {}", appointment.getAppointmentId());
                return;
            }

            CareActivity careActivity = appointment.getCareActivity();
            Schedule schedule = careActivity.getSchedule();
            Patient patient = schedule.getPatient();
            Caregiver caregiver = schedule.getCaregiver();

            String taskName = "Appointment at " + appointment.getHospital();
            String doctorName = appointment.getDoctorName();

            logger.info("📤 Sending Appointment Reminder:");
            logger.info("   Hospital: {}", appointment.getHospital());
            logger.info("   Doctor: {}", doctorName);
            logger.info("   Patient: {} {} (ID: {})", patient.getUser().getFName(), patient.getUser().getLName(),
                    patient.getPatientID());
            logger.info("   Caregiver: {} {} (ID: {})", caregiver.getUser().getFName(), caregiver.getUser().getLName(),
                    caregiver.getCaregiverId());

            // Send to Patient and Guardian
            sendToPatientAndGuardian(
                    patient,
                    "Appointment Reminder",
                    taskName + (doctorName != null ? " with Dr. " + doctorName : ""),
                    "appointment_reminder",
                    String.valueOf(appointment.getAppointmentId()),
                    doctorName);

            // Send to Caregiver
            sendToCaregiver(
                    caregiver,
                    patient,
                    "Appointment Reminder",
                    taskName,
                    "appointment_reminder",
                    String.valueOf(appointment.getAppointmentId()));

            sentReminders.add(reminderKey);
            logger.info("Sent reminder for appointment ID: {}", appointment.getAppointmentId());

        } catch (Exception e) {
            logger.error("Error sending appointment reminder: {}", e.getMessage(), e);
        }
    }

    /**
     * Send notification to patient and their guardian
     */
    private void sendToPatientAndGuardian(Patient patient, String title, String taskName,
            String notificationType, String taskId, String additionalInfo) {
        try {
            // Get FCM tokens for patient
            List<String> patientTokens = userFCMTokenService.getActiveTokensForUser(patient.getPatientID().intValue());

            // Get FCM tokens for guardian
            List<String> guardianTokens = new ArrayList<>();
            if (patient.getGuardian() != null) {
                guardianTokens = userFCMTokenService
                        .getActiveTokensForUser(patient.getGuardian().getGuardianId().intValue());
            }

            // Combine tokens
            List<String> allTokens = new ArrayList<>();
            allTokens.addAll(patientTokens);
            allTokens.addAll(guardianTokens);

            if (allTokens.isEmpty()) {
                logger.warn("⚠️  No FCM tokens found for patient ID: {} or guardian", patient.getPatientID());
                return;
            }

            logger.info("   Found {} FCM tokens (Patient: {}, Guardian: {})",
                    allTokens.size(), patientTokens.size(), guardianTokens.size());

            // Prepare notification content for patient/guardian
            String body = taskName + " is starting in " + REMINDER_MINUTES_BEFORE + " minutes";

            logger.info("   Notification Body: {}", body);

            Map<String, String> data = new HashMap<>();
            data.put("type", notificationType);
            data.put("taskId", taskId);
            data.put("taskName", taskName);
            data.put("patientId", String.valueOf(patient.getPatientID()));
            data.put("action", "view_details");
            if (additionalInfo != null) {
                data.put("additionalInfo", additionalInfo);
            }

            fcmNotificationService.sendNotificationToMultipleDevices(allTokens, title, body, data);
            logger.info("   ✅ Notification sent to {} devices (Patient + Guardian)", allTokens.size());

        } catch (Exception e) {
            logger.error("Error sending notification to patient/guardian: {}", e.getMessage(), e);
        }
    }

    /**
     * Send notification to caregiver
     */
    private void sendToCaregiver(Caregiver caregiver, Patient patient, String title, String taskName,
            String notificationType, String taskId) {
        try {
            List<String> caregiverTokens = userFCMTokenService
                    .getActiveTokensForUser(caregiver.getCaregiverId().intValue());

            if (caregiverTokens.isEmpty()) {
                logger.warn("⚠️  No FCM tokens found for caregiver ID: {}", caregiver.getCaregiverId());
                return;
            }

            logger.info("   Found {} FCM tokens for caregiver", caregiverTokens.size());

            // Get patient name from User
            User patientUser = patient.getUser();
            String patientName = patientUser.getFName() + " " + patientUser.getLName();

            // Prepare notification content for caregiver (includes patient name)
            String body = taskName + " for " + patientName + " is starting in " + REMINDER_MINUTES_BEFORE + " minutes";

            logger.info("   Notification Body: {}", body);

            Map<String, String> data = new HashMap<>();
            data.put("type", notificationType);
            data.put("taskId", taskId);
            data.put("taskName", taskName);
            data.put("patientId", String.valueOf(patient.getPatientID()));
            data.put("patientName", patientName);
            data.put("action", "view_details");

            fcmNotificationService.sendNotificationToMultipleDevices(caregiverTokens, title, body, data);
            logger.info("   ✅ Notification sent to {} caregiver devices", caregiverTokens.size());

        } catch (Exception e) {
            logger.error("Error sending notification to caregiver: {}", e.getMessage(), e);
        }
    }

    /**
     * Check if a task is within the reminder window
     * The window is centered around (now + REMINDER_MINUTES_BEFORE)
     * with a tolerance to account for the 5-minute check interval
     */
    private boolean isWithinReminderWindow(LocalDateTime taskTime, LocalDateTime windowStart, LocalDateTime windowEnd) {
        // Task should be scheduled within the window AND not in the past
        return (taskTime.isAfter(windowStart) || taskTime.isEqual(windowStart))
                && (taskTime.isBefore(windowEnd) || taskTime.isEqual(windowEnd))
                && taskTime.isAfter(LocalDateTime.now());
    }

    /**
     * Get task name from care activity (daily task or game task)
     */
    private String getTaskNameFromActivity(CareActivity activity) {
        // Check daily tasks
        if (!activity.getDailyTasks().isEmpty()) {
            DailyTask dailyTask = activity.getDailyTasks().iterator().next();
            return dailyTask.getDailyTaskName();
        }

        // Check game tasks
        if (!activity.getTasks().isEmpty()) {
            Task gameTask = activity.getTasks().iterator().next();
            return gameTask.getGame().getName();
        }

        return "Task";
    }

    /**
     * Clean up old reminder keys (older than 1 hour)
     * This prevents the set from growing indefinitely
     */
    private void cleanupOldReminders() {
        // Since we're using date in the key, we can clear all if it's a new day
        // This is a simple approach; for production, consider using a database table
        if (sentReminders.size() > 1000) { // Safety limit
            logger.info("Cleaning up old reminders...");
            sentReminders.clear();
        }
    }

    /**
     * Manually trigger a reminder for testing purposes
     */
    public void sendTestReminder(Long activityId) {
        try {
            Optional<CareActivity> activityOpt = careActivityRepository.findById(activityId);
            if (activityOpt.isPresent()) {
                sendDailyActivityReminder(activityOpt.get());
                logger.info("Test reminder sent for activity ID: {}", activityId);
            }
        } catch (Exception e) {
            logger.error("Error sending test reminder: {}", e.getMessage(), e);
        }
    }
}
