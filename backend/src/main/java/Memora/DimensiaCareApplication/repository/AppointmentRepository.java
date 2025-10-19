package Memora.DimensiaCareApplication.repository;

import Memora.DimensiaCareApplication.model.Appointment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface AppointmentRepository extends JpaRepository<Appointment, Long> {

    // Find appointments by care activity ID
    List<Appointment> findByCareActivityCareActivityId(Long careActivityId);

    // Find appointments by schedule ID through care activity
    @Query("SELECT a FROM Appointment a JOIN a.careActivity ca WHERE ca.schedule.scheduleId = :scheduleId")
    List<Appointment> findByScheduleId(@Param("scheduleId") Long scheduleId);

    // Find appointments for a specific date
    @Query("SELECT DISTINCT a FROM Appointment a " +
            "JOIN FETCH a.careActivity ca " +
            "JOIN FETCH ca.schedule s " +
            "JOIN FETCH s.patient p " +
            "JOIN FETCH p.user " +
            "LEFT JOIN FETCH p.guardian g " +
            "LEFT JOIN FETCH g.user " +
            "JOIN FETCH s.caregiver c " +
            "JOIN FETCH c.user " +
            "WHERE a.date = :date")
    List<Appointment> findAppointmentsForToday(@Param("date") LocalDate date);
}
