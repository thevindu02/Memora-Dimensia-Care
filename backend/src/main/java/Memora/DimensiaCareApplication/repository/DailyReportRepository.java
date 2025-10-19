package Memora.DimensiaCareApplication.repository;

import Memora.DimensiaCareApplication.model.DailyReport;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface DailyReportRepository extends JpaRepository<DailyReport, Long> {

    // Find all reports by guardian ID, ordered by date descending
    List<DailyReport> findByGuardianGuardianIdOrderByDateDesc(Long guardianId);

    // Find all reports by patient ID, ordered by date descending
    List<DailyReport> findByPatientPatientIdOrderByDateDesc(Long patientId);

    // Find report by patient ID and specific date
    Optional<DailyReport> findByPatientPatientIdAndDate(Long patientId, LocalDate date);

    // Find reports by patient ID within a date range
    @Query("SELECT dr FROM DailyReport dr WHERE dr.patient.patientId = :patientId AND dr.date BETWEEN :startDate AND :endDate ORDER BY dr.date DESC")
    List<DailyReport> findByPatientIdAndDateRange(
        @Param("patientId") Long patientId, 
        @Param("startDate") LocalDate startDate, 
        @Param("endDate") LocalDate endDate
    );

    // Find reports by guardian ID within a date range
    @Query("SELECT dr FROM DailyReport dr WHERE dr.guardian.guardianId = :guardianId AND dr.date BETWEEN :startDate AND :endDate ORDER BY dr.date DESC")
    List<DailyReport> findByGuardianIdAndDateRange(
        @Param("guardianId") Long guardianId, 
        @Param("startDate") LocalDate startDate, 
        @Param("endDate") LocalDate endDate
    );

    // Find report by schedule ID (to check if report already exists)
    Optional<DailyReport> findByScheduleScheduleId(Long scheduleId);
}
