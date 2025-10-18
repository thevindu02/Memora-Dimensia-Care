package Memora.DimensiaCareApplication.repository;

import Memora.DimensiaCareApplication.model.DailyTask;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DailyTaskRepository extends JpaRepository<DailyTask, Long> {

    // Find daily tasks by care activity ID
    List<DailyTask> findByCareActivityCareActivityId(Long careActivityId);

    // Find daily tasks by task name
    List<DailyTask> findByDailyTaskName(String dailyTaskName);

    // Find daily tasks by care activity's schedule ID
    List<DailyTask> findByCareActivityScheduleScheduleId(Long scheduleId);
}
