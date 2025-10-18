package Memora.DimensiaCareApplication.service;

import Memora.DimensiaCareApplication.model.ScheduleSession;
import Memora.DimensiaCareApplication.dto.ScheduleSessionCreateDTO;
import Memora.DimensiaCareApplication.repository.ScheduleSessionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.Optional;

@Service
public class ScheduleSessionService {
    
    @Autowired
    private ScheduleSessionRepository scheduleSessionRepository;
    
    // Create a new schedule session
    public ScheduleSession createScheduleSession(ScheduleSessionCreateDTO dto) {
        // Validate required fields
        if (dto.getSessionDate() == null || dto.getSessionDate().trim().isEmpty()) {
            throw new IllegalArgumentException("Session date is required");
        }
        if (dto.getSessionTime() == null || dto.getSessionTime().trim().isEmpty()) {
            throw new IllegalArgumentException("Session time is required");
        }
        if (dto.getSessionTopic() == null || dto.getSessionTopic().trim().isEmpty()) {
            throw new IllegalArgumentException("Session topic is required");
        }
        
        // Parse date and time
        LocalDate sessionDate;
        LocalTime sessionTime;
        
        try {
            sessionDate = LocalDate.parse(dto.getSessionDate());
        } catch (DateTimeParseException e) {
            throw new IllegalArgumentException("Invalid session date format. Expected YYYY-MM-DD");
        }
        
        try {
            // Handle time format with or without seconds
            String timeStr = dto.getSessionTime();
            if (timeStr.length() == 5) {
                // Format: HH:MM
                sessionTime = LocalTime.parse(timeStr, DateTimeFormatter.ofPattern("HH:mm"));
            } else {
                // Format: HH:MM:SS
                sessionTime = LocalTime.parse(timeStr);
            }
        } catch (DateTimeParseException e) {
            throw new IllegalArgumentException("Invalid session time format. Expected HH:MM or HH:MM:SS");
        }
        
        // Validate that session is not in the past
        LocalDate today = LocalDate.now();
        if (sessionDate.isBefore(today)) {
            throw new IllegalArgumentException("Cannot schedule sessions in the past");
        }
        
        // Create the schedule session
        ScheduleSession scheduleSession = new ScheduleSession();
        scheduleSession.setSessionDate(sessionDate);
        scheduleSession.setSessionTime(sessionTime);
        scheduleSession.setSessionTopic(dto.getSessionTopic().trim());
        
        // Set optional fields
        if (dto.getDescription() != null && !dto.getDescription().trim().isEmpty()) {
            scheduleSession.setDescription(dto.getDescription().trim());
        }
        
        if (dto.getMeetingLink() != null && !dto.getMeetingLink().trim().isEmpty()) {
            scheduleSession.setMeetingLink(dto.getMeetingLink().trim());
        }
        
        return scheduleSessionRepository.save(scheduleSession);
    }
    
    // Get all schedule sessions
    public List<ScheduleSession> getAllScheduleSessions() {
        return scheduleSessionRepository.findAllByOrderBySessionDateAscSessionTimeAsc();
    }
    
    // Get schedule session by ID
    public Optional<ScheduleSession> getScheduleSessionById(Integer id) {
        return scheduleSessionRepository.findById(id);
    }
    
    // Get schedule sessions by date
    public List<ScheduleSession> getScheduleSessionsByDate(LocalDate date) {
        return scheduleSessionRepository.findBySessionDate(date);
    }
    
    // Get schedule sessions by date range
    public List<ScheduleSession> getScheduleSessionsByDateRange(LocalDate startDate, LocalDate endDate) {
        return scheduleSessionRepository.findBySessionDateBetween(startDate, endDate);
    }
    
    // Get schedule sessions by topic
    public List<ScheduleSession> getScheduleSessionsByTopic(String topic) {
        return scheduleSessionRepository.findBySessionTopicContainingIgnoreCase(topic);
    }
    
    // Update schedule session
    public ScheduleSession updateScheduleSession(Integer id, ScheduleSessionCreateDTO dto) {
        Optional<ScheduleSession> existingSession = scheduleSessionRepository.findById(id);
        if (existingSession.isEmpty()) {
            throw new IllegalArgumentException("Schedule session not found with ID: " + id);
        }
        
        ScheduleSession session = existingSession.get();
        
        // Update fields if provided
        if (dto.getSessionDate() != null && !dto.getSessionDate().trim().isEmpty()) {
            try {
                LocalDate sessionDate = LocalDate.parse(dto.getSessionDate());
                session.setSessionDate(sessionDate);
            } catch (DateTimeParseException e) {
                throw new IllegalArgumentException("Invalid session date format. Expected YYYY-MM-DD");
            }
        }
        
        if (dto.getSessionTime() != null && !dto.getSessionTime().trim().isEmpty()) {
            try {
                String timeStr = dto.getSessionTime();
                LocalTime sessionTime;
                if (timeStr.length() == 5) {
                    sessionTime = LocalTime.parse(timeStr, DateTimeFormatter.ofPattern("HH:mm"));
                } else {
                    sessionTime = LocalTime.parse(timeStr);
                }
                session.setSessionTime(sessionTime);
            } catch (DateTimeParseException e) {
                throw new IllegalArgumentException("Invalid session time format. Expected HH:MM or HH:MM:SS");
            }
        }
        
        if (dto.getSessionTopic() != null && !dto.getSessionTopic().trim().isEmpty()) {
            session.setSessionTopic(dto.getSessionTopic().trim());
        }
        
        if (dto.getDescription() != null) {
            session.setDescription(dto.getDescription().trim());
        }
        
        if (dto.getMeetingLink() != null) {
            session.setMeetingLink(dto.getMeetingLink().trim());
        }
        
        return scheduleSessionRepository.save(session);
    }
    
    // Delete schedule session
    public void deleteScheduleSession(Integer id) {
        if (!scheduleSessionRepository.existsById(id)) {
            throw new IllegalArgumentException("Schedule session not found with ID: " + id);
        }
        scheduleSessionRepository.deleteById(id);
    }
} 