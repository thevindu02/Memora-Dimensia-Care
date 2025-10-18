package Memora.DimensiaCareApplication.repository;

import Memora.DimensiaCareApplication.model.CareActivity;
import Memora.DimensiaCareApplication.model.CareActivityStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

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
}
