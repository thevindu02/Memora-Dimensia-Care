package Memora.DimensiaCareApplication.repository;

import Memora.DimensiaCareApplication.model.CareActivity;
import Memora.DimensiaCareApplication.model.CareActivityStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface CareActivityRepository extends JpaRepository<CareActivity, Long> {

    // Find care activities by schedule ID
    List<CareActivity> findByScheduleScheduleId(Long scheduleId);

    // Find care activities by schedule ID ordered by time
    List<CareActivity> findByScheduleScheduleIdOrderByTime(Long scheduleId);

    // Find care activities by status
    List<CareActivity> findByStatus(CareActivityStatus status);

    // Find care activities by schedule ID and status
    List<CareActivity> findByScheduleScheduleIdAndStatus(Long scheduleId, CareActivityStatus status);

    // Find care activities for a specific date
    @Query("SELECT DISTINCT ca FROM CareActivity ca " +
            "JOIN FETCH ca.schedule s " +
            "JOIN FETCH s.patient p " +
            "JOIN FETCH p.user " +
            "LEFT JOIN FETCH p.guardian g " +
            "LEFT JOIN FETCH g.user " +
            "JOIN FETCH s.caregiver c " +
            "JOIN FETCH c.user " +
            "WHERE s.date = :date " +
            "AND ca.status != 'COMPLETED' " +
            "AND ca.status != 'CANCELLED'")
    List<CareActivity> findActivitiesForToday(@Param("date") LocalDate date);
}
