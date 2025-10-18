package Memora.DimensiaCareApplication.service;

import Memora.DimensiaCareApplication.dto.MedicationReminderRequest;
import Memora.DimensiaCareApplication.model.CareActivity;
import Memora.DimensiaCareApplication.model.CareActivityStatus;
import Memora.DimensiaCareApplication.model.MedicationReminder;
import Memora.DimensiaCareApplication.model.Schedule;
import Memora.DimensiaCareApplication.model.Medication;
import Memora.DimensiaCareApplication.repository.MedicationRepository;
import Memora.DimensiaCareApplication.repository.CareActivityRepository;
import Memora.DimensiaCareApplication.repository.MedicationReminderRepository;
import Memora.DimensiaCareApplication.repository.ScheduleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;

@Service
public class MedicationReminderService {

    @Autowired
    private CareActivityRepository careActivityRepository;

    @Autowired
    private MedicationReminderRepository medicationReminderRepository;

    @Autowired
    private ScheduleRepository scheduleRepository;

    @Autowired
    private MedicationRepository medicationRepository;

    @Transactional
    public MedicationReminder addMedicationReminder(Long scheduleId, MedicationReminderRequest request) {
        try {
            // Parse time from string format
            LocalTime time = LocalTime.parse(request.getTime(), DateTimeFormatter.ofPattern("HH:mm"));

            // Find the schedule
            Optional<Schedule> scheduleOpt = scheduleRepository.findById(scheduleId);
            if (!scheduleOpt.isPresent()) {
                throw new RuntimeException("Schedule not found with ID: " + scheduleId);
            }

            // Create and save CareActivity first
            CareActivity careActivity = new CareActivity();
            careActivity.setSchedule(scheduleOpt.get());
            careActivity.setTime(time);
            careActivity.setStatus(CareActivityStatus.PENDING);

            CareActivity savedCareActivity = careActivityRepository.save(careActivity);

            // Create and save Medication entity from request
            Medication medication = new Medication();
            medication.setMedicationName(request.getMedicationName());
            medication.setDosage(request.getDosage());
            medication.setMealTiming(request.getMealTiming());
            medication.setTime(time);
            medication.setDescription(request.getDescription());
            medication.setPatientId(scheduleOpt.get().getPatient().getPatientID());
            if (request.getFromDate() != null && !request.getFromDate().isEmpty()) {
                medication.setFromDate(java.time.LocalDate.parse(request.getFromDate()));
            }
            if (request.getDueDate() != null && !request.getDueDate().isEmpty()) {
                medication.setDueDate(java.time.LocalDate.parse(request.getDueDate()));
            }
            Medication savedMedication = medicationRepository.save(medication);

            // Create and save MedicationReminder
            MedicationReminder medicationReminder = new MedicationReminder();
            medicationReminder.setCareActivity(savedCareActivity);
            medicationReminder.setMedication(savedMedication);
            return medicationReminderRepository.save(medicationReminder);

        } catch (Exception e) {
            throw new RuntimeException("Failed to add medication reminder: " + e.getMessage(), e);
        }
    }

    // Remove getMedicationRemindersByScheduleId, as MedicationReminder does not
    // have scheduleId

    public List<MedicationReminder> getMedicationRemindersByCareActivityId(Long careActivityId) {
        return medicationReminderRepository.findByCareActivityCareActivityId(careActivityId);
    }

    public Optional<MedicationReminder> getMedicationReminderById(Long medicationReminderId) {
        return medicationReminderRepository.findById(medicationReminderId);
    }

    // Remove updateMedicationStatus, as MedicationReminder does not have status
    // field

    // Remove getMedicationRemindersByStatus, as MedicationReminder does not have
    // status field

    // Remove searchMedicationsByName, as MedicationReminder does not have
    // medicationName field

    @Transactional
    public void deleteMedicationReminder(Long medicationReminderId) {
        Optional<MedicationReminder> medicationOpt = medicationReminderRepository.findById(medicationReminderId);
        if (!medicationOpt.isPresent()) {
            throw new RuntimeException("Medication reminder not found with ID: " + medicationReminderId);
        }

        MedicationReminder medicationReminder = medicationOpt.get();
        careActivityRepository.delete(medicationReminder.getCareActivity());
    }

    public List<MedicationReminder> getMedicationRemindersByScheduleId(Long scheduleId) {
        // Check if schedule is completed
        Schedule schedule = scheduleRepository.findById(scheduleId)
                .orElseThrow(() -> new RuntimeException("Schedule not found with ID: " + scheduleId));

        if (schedule.getIsCompleted() != null && schedule.getIsCompleted()) {
            return List.of();
        }

        return medicationReminderRepository.findByScheduleId(scheduleId);
    }
}
