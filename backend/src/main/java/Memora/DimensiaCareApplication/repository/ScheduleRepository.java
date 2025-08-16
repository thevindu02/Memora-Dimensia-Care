package Memora.DimensiaCareApplication.repository;

import Memora.DimensiaCareApplication.model.Schedule;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface ScheduleRepository extends JpaRepository<Schedule, Long> {

    // Find schedules by patient ID
    List<Schedule> findByPatientPatientId(Long patientId);

    // Find schedules by caregiver ID
    List<Schedule> findByCaregiverCaregiverId(Integer caregiverId);

    // Find schedules by guardian ID
    List<Schedule> findByGuardianGuardianId(Long guardianId);

    // Find schedule by patient and date
    Optional<Schedule> findByPatientPatientIdAndDate(Long patientId, LocalDate date);

    // Find schedules by date range
    @Query("SELECT s FROM Schedule s WHERE s.date BETWEEN :startDate AND :endDate")
    List<Schedule> findByDateRange(@Param("startDate") LocalDate startDate, @Param("endDate") LocalDate endDate);

    // Find incomplete schedules
    List<Schedule> findByIsCompletedFalse();

    // Find completed schedules
    List<Schedule> findByIsCompletedTrue();
}
