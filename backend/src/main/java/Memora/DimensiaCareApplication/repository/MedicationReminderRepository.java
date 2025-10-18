package Memora.DimensiaCareApplication.repository;

import Memora.DimensiaCareApplication.model.MedicationReminder;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MedicationReminderRepository extends JpaRepository<MedicationReminder, Long> {

    // Find medication reminders by care activity ID
    List<MedicationReminder> findByCareActivityCareActivityId(Long careActivityId);

    // Find medication reminders by schedule ID through care activity
    @Query("SELECT mr FROM MedicationReminder mr JOIN mr.careActivity ca WHERE ca.schedule.scheduleId = :scheduleId")
    List<MedicationReminder> findByScheduleId(@Param("scheduleId") Long scheduleId);

}
