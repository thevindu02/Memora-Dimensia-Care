package Memora.DimensiaCareApplication.repository;

import Memora.DimensiaCareApplication.model.ScheduleSession;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface ScheduleSessionRepository extends JpaRepository<ScheduleSession, Integer> {
    
    // Find sessions by date
    List<ScheduleSession> findBySessionDate(LocalDate sessionDate);
    
    // Find sessions by date range
    List<ScheduleSession> findBySessionDateBetween(LocalDate startDate, LocalDate endDate);
    
    // Find sessions by topic (case-insensitive)
    List<ScheduleSession> findBySessionTopicContainingIgnoreCase(String sessionTopic);
    
    // Find all sessions ordered by date and time
    List<ScheduleSession> findAllByOrderBySessionDateAscSessionTimeAsc();
} 