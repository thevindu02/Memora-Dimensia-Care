package Memora.DimensiaCareApplication.dto;

import java.time.LocalDate;
import java.time.LocalTime;

public class ScheduleSessionCreateDTO {
    
    private String sessionDate;
    private String sessionTime;
    private String sessionTopic;
    private String description;
    private String meetingLink;
    
    // Default constructor
    public ScheduleSessionCreateDTO() {}
    
    // Constructor with all fields
    public ScheduleSessionCreateDTO(String sessionDate, String sessionTime, String sessionTopic, 
                                   String description, String meetingLink) {
        this.sessionDate = sessionDate;
        this.sessionTime = sessionTime;
        this.sessionTopic = sessionTopic;
        this.description = description;
        this.meetingLink = meetingLink;
    }
    
    // Getters and Setters
    public String getSessionDate() {
        return sessionDate;
    }
    
    public void setSessionDate(String sessionDate) {
        this.sessionDate = sessionDate;
    }
    
    public String getSessionTime() {
        return sessionTime;
    }
    
    public void setSessionTime(String sessionTime) {
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
    
    @Override
    public String toString() {
        return "ScheduleSessionCreateDTO{" +
                "sessionDate='" + sessionDate + '\'' +
                ", sessionTime='" + sessionTime + '\'' +
                ", sessionTopic='" + sessionTopic + '\'' +
                ", description='" + description + '\'' +
                ", meetingLink='" + meetingLink + '\'' +
                '}';
    }
} 