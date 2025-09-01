package Memora.DimensiaCareApplication.service;

import Memora.DimensiaCareApplication.model.*;
import Memora.DimensiaCareApplication.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.Optional;

@Service
public class MedicationService {

    @Autowired
    private MedicationRepository medicationRepository;

    @Autowired
    private ScheduleRepository scheduleRepository;

    @Autowired
    private CareActivityRepository careActivityRepository;

    @Autowired
    private MedicationReminderRepository medicationReminderRepository;

    public Medication addMedication(Medication medication) {
        Medication savedMedication = medicationRepository.save(medication);

        LocalDate today = LocalDate.now();
        if ((medication.getFromDate() == null || !medication.getFromDate().isAfter(today)) &&
                (medication.getDueDate() == null || !medication.getDueDate().isBefore(today))) {

            Optional<Schedule> scheduleOpt = scheduleRepository.findByPatientPatientIdAndDate(
                    medication.getPatientId().longValue(), today);

            if (scheduleOpt.isPresent()) {
                Schedule schedule = scheduleOpt.get();

                CareActivity careActivity = new CareActivity();
                careActivity.setSchedule(schedule);
                careActivity.setTime(medication.getTime());
                careActivity.setStatus(CareActivityStatus.PENDING);
                careActivityRepository.save(careActivity);

                MedicationReminder reminder = new MedicationReminder();
                reminder.setCareActivity(careActivity);
                reminder.setMedication(medication); // Set medication reference
                medicationReminderRepository.save(reminder);
            } else {
                throw new RuntimeException(
                        "No schedule found for patient " + medication.getPatientId() + " on " + today);
            }
        }
        return savedMedication;
    }
}
