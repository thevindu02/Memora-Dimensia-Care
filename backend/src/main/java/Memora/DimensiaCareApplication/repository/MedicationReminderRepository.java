package Memora.DimensiaCareApplication.repository;

import Memora.DimensiaCareApplication.model.MedicationReminder;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface MedicationReminderRepository extends JpaRepository<MedicationReminder, Long> {

    // Find medication reminders by care activity ID
    List<MedicationReminder> findByCareActivityCareActivityId(Long careActivityId);

    // Find medication reminders by schedule ID through care activity
    @Query("SELECT mr FROM MedicationReminder mr JOIN mr.careActivity ca WHERE ca.schedule.scheduleId = :scheduleId")
    List<MedicationReminder> findByScheduleId(@Param("scheduleId") Long scheduleId);

    // Find medication reminders for a specific date
    @Query("SELECT DISTINCT mr FROM MedicationReminder mr " +
            "JOIN FETCH mr.careActivity ca " +
            "JOIN FETCH ca.schedule s " +
            "JOIN FETCH s.patient p " +
            "JOIN FETCH p.user " +
            "LEFT JOIN FETCH p.guardian g " +
            "LEFT JOIN FETCH g.user " +
            "JOIN FETCH s.caregiver c " +
            "JOIN FETCH c.user " +
            "JOIN FETCH mr.medication m " +
            "WHERE s.date = :date " +
            "AND ca.status != 'COMPLETED' " +
            "AND ca.status != 'CANCELLED'")
    List<MedicationReminder> findMedicationsForToday(@Param("date") LocalDate date);

}
