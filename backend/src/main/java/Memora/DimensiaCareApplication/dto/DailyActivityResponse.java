package Memora.DimensiaCareApplication.dto;

import java.time.LocalTime;

public class DailyActivityResponse {
    private Long careActivityId;
    private Long dailyTaskId;
    private String taskName;
    private String time; // Format: "HH:mm"
    private String description;
    private String status;

    // Default constructor
    public DailyActivityResponse() {
    }

    // Constructor with parameters
    public DailyActivityResponse(Long careActivityId, Long dailyTaskId, String taskName,
            String time, String description, String status) {
        this.careActivityId = careActivityId;
        this.dailyTaskId = dailyTaskId;
        this.taskName = taskName;
        this.time = time;
        this.description = description;
        this.status = status;
    }

    // Getters and setters
    public Long getCareActivityId() {
        return careActivityId;
    }

    public void setCareActivityId(Long careActivityId) {
        this.careActivityId = careActivityId;
    }

    public Long getDailyTaskId() {
        return dailyTaskId;
    }

    public void setDailyTaskId(Long dailyTaskId) {
        this.dailyTaskId = dailyTaskId;
    }

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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    // Helper method to convert time to LocalTime if needed
    public LocalTime getTimeAsLocalTime() {
        if (time != null && !time.isEmpty()) {
            return LocalTime.parse(time);
        }
        return null;
    }
}
