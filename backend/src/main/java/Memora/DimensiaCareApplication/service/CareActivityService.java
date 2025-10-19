package Memora.DimensiaCareApplication.service;

import Memora.DimensiaCareApplication.model.CareActivity;
import Memora.DimensiaCareApplication.model.CareActivityStatus;
import Memora.DimensiaCareApplication.model.Schedule;
import Memora.DimensiaCareApplication.repository.CareActivityRepository;
import Memora.DimensiaCareApplication.repository.ScheduleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
public class CareActivityService {

    @Autowired
    private CareActivityRepository careActivityRepository;

    @Autowired
    private ScheduleRepository scheduleRepository;

    /**
     * Update the status of a care activity
     * 
     * @param careActivityId The ID of the care activity to update
     * @param newStatus      The new status to set
     * @return The updated care activity
     * @throws RuntimeException if care activity not found
     */
    @Transactional
    public CareActivity updateStatus(Long careActivityId, CareActivityStatus newStatus) {
        Optional<CareActivity> careActivityOptional = careActivityRepository.findById(careActivityId);

        if (careActivityOptional.isEmpty()) {
            throw new RuntimeException("Care activity not found with ID: " + careActivityId);
        }

        CareActivity careActivity = careActivityOptional.get();
        careActivity.setStatus(newStatus);

        return careActivityRepository.save(careActivity);
    }

    /**
     * Update the status and skip reason of a care activity
     * 
     * @param careActivityId The ID of the care activity to update
     * @param newStatus      The new status to set
     * @param skipReason     The reason for skipping/cancelling (optional)
     * @return The updated care activity
     * @throws RuntimeException if care activity not found
     */
    @Transactional
    public CareActivity updateStatusWithReason(Long careActivityId, CareActivityStatus newStatus, String skipReason) {
        Optional<CareActivity> careActivityOptional = careActivityRepository.findById(careActivityId);

        if (careActivityOptional.isEmpty()) {
            throw new RuntimeException("Care activity not found with ID: " + careActivityId);
        }

        CareActivity careActivity = careActivityOptional.get();
        careActivity.setStatus(newStatus);

        // Set skip reason if provided, clear it if status is PENDING
        if (newStatus == CareActivityStatus.PENDING) {
            careActivity.setSkipReason(null);
        } else if (skipReason != null && !skipReason.trim().isEmpty()) {
            careActivity.setSkipReason(skipReason);
        }

        return careActivityRepository.save(careActivity);
    }

    /**
     * Get a care activity by ID
     * 
     * @param careActivityId The ID of the care activity
     * @return The care activity if found
     */
    public Optional<CareActivity> getCareActivityById(Long careActivityId) {
        return careActivityRepository.findById(careActivityId);
    }

    /**
     * Move a care activity to a different schedule
     * 
     * @param careActivityId The ID of the care activity to move
     * @param newScheduleId  The ID of the target schedule
     * @return The updated care activity
     * @throws RuntimeException if care activity or schedule not found
     */
    @Transactional
    public CareActivity moveCareActivityToSchedule(Long careActivityId, Long newScheduleId) {
        // Find the care activity
        Optional<CareActivity> careActivityOptional = careActivityRepository.findById(careActivityId);
        if (careActivityOptional.isEmpty()) {
            throw new RuntimeException("Care activity not found with ID: " + careActivityId);
        }

        // Find the target schedule
        Optional<Schedule> scheduleOptional = scheduleRepository.findById(newScheduleId);
        if (scheduleOptional.isEmpty()) {
            throw new RuntimeException("Schedule not found with ID: " + newScheduleId);
        }

        CareActivity careActivity = careActivityOptional.get();
        Schedule newSchedule = scheduleOptional.get();

        // Update the schedule
        careActivity.setSchedule(newSchedule);

        return careActivityRepository.save(careActivity);
    }
}
