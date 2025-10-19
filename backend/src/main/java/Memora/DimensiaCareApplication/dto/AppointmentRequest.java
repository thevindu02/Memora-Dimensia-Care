package Memora.DimensiaCareApplication.dto;

import jakarta.validation.constraints.NotBlank;

public class AppointmentRequest {

    @NotBlank(message = "Task name is required")
    private String taskName;

    @NotBlank(message = "Hospital is required")
    private String hospital;

    @NotBlank(message = "Doctor name is required")
    private String doctorName;

    private String description;

    @NotBlank(message = "Date is required")
    private String date;

    @NotBlank(message = "Time is required")
    private String time;

    // Default constructor
    public AppointmentRequest() {
    }

    // Constructor with parameters
    public AppointmentRequest(String taskName, String hospital, String doctorName,
            String description, String date, String time) {
        this.taskName = taskName;
        this.hospital = hospital;
        this.doctorName = doctorName;
        this.description = description;
        this.date = date;
        this.time = time;
    }

    // Getters and setters
    public String getTaskName() {
        return taskName;
    }

    public void setTaskName(String taskName) {
        this.taskName = taskName;
    }

    public String getHospital() {
        return hospital;
    }

    public void setHospital(String hospital) {
        this.hospital = hospital;
    }

    public String getDoctorName() {
        return doctorName;
    }

    public void setDoctorName(String doctorName) {
        this.doctorName = doctorName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }
}
