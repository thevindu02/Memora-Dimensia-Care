package Memora.DimensiaCareApplication.dto;

import java.time.LocalTime;

public class DailyActivityRequest {
    private String taskName;
    private String time; // Format: "HH:mm"
    private String description;

    // Default constructor
    public DailyActivityRequest() {
    }

    // Constructor with parameters
    public DailyActivityRequest(String taskName, String time, String description) {
        this.taskName = taskName;
        this.time = time;
        this.description = description;
    }

    // Getters and setters
    public String getTaskName() {
        return taskName;
    }

    public void setTaskName(String taskName) {
        this.taskName = taskName;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    // Helper method to convert string time to LocalTime
    public LocalTime getTimeAsLocalTime() {
        if (time != null && !time.isEmpty()) {
            return LocalTime.parse(time);
        }
        return null;
    }
}
