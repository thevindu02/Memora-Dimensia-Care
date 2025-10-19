package Memora.DimensiaCareApplication.model;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.LocalDateTime;

@Entity
@Table(name = "schedule_sessions")
public class ScheduleSession {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    
    @Column(name = "session_date", nullable = false)
    private LocalDate sessionDate;
    
    @Column(name = "session_time", nullable = false)
    private LocalTime sessionTime;
    
    @Column(name = "session_topic", nullable = false, length = 255)
    private String sessionTopic;
    
    @Column(name = "description", columnDefinition = "TEXT")
    private String description;
    
    @Column(name = "meeting_link", length = 500)
    private String meetingLink;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    // Default constructor
    public ScheduleSession() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }
    
    // Constructor with required fields
    public ScheduleSession(LocalDate sessionDate, LocalTime sessionTime, String sessionTopic) {
        this();
        this.sessionDate = sessionDate;
        this.sessionTime = sessionTime;
        this.sessionTopic = sessionTopic;
    }
    
    // Getters and Setters
    public Integer getId() {
        return id;
    }
    
    public void setId(Integer id) {
        this.id = id;
    }
    
    public LocalDate getSessionDate() {
        return sessionDate;
    }
    
    public void setSessionDate(LocalDate sessionDate) {
        this.sessionDate = sessionDate;
    }
    
    public LocalTime getSessionTime() {
        return sessionTime;
    }
    
    public void setSessionTime(LocalTime sessionTime) {
        this.sessionTime = sessionTime;
    }
    
    public String getSessionTopic() {
        return sessionTopic;
    }
    
    public void setSessionTopic(String sessionTopic) {
        this.sessionTopic = sessionTopic;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public String getMeetingLink() {
        return meetingLink;
    }
    
    public void setMeetingLink(String meetingLink) {
        this.meetingLink = meetingLink;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    @PreUpdate
    public void preUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
    
    @Override
    public String toString() {
        return "ScheduleSession{" +
                "id=" + id +
                ", sessionDate=" + sessionDate +
                ", sessionTime=" + sessionTime +
                ", sessionTopic='" + sessionTopic + '\'' +
                ", description='" + description + '\'' +
                ", meetingLink='" + meetingLink + '\'' +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
} 