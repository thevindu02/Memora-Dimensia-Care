package Memora.DimensiaCareApplication.repository;

import Memora.DimensiaCareApplication.model.Task;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TaskRepository extends JpaRepository<Task, Integer> {

    /**
     * Find all tasks by schedule ID through CareActivity relationship
     */
    @Query("SELECT t FROM Task t WHERE t.careActivity.schedule.scheduleId = :scheduleId")
    List<Task> findByScheduleId(@Param("scheduleId") Integer scheduleId);

    /**
     * Find all tasks by care activity ID
     */
    @Query("SELECT t FROM Task t WHERE t.careActivity.careActivityId = :careActivityId")
    List<Task> findByCareActivityId(@Param("careActivityId") Long careActivityId);

    /**
     * Find all tasks by game ID
     */
    @Query("SELECT t FROM Task t WHERE t.game.gameId = :gameId")
    List<Task> findByGameId(@Param("gameId") Long gameId);
}