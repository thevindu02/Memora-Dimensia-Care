package Memora.DimensiaCareApplication.dto;

public class ScheduleTaskDTO {
    private Long careActivityId;
    private String taskType; // DAILY_ACTIVITY, GAME, MEDICATION, APPOINTMENT
    private Long taskId; // ID of the specific task (DailyTask, Task, MedicationReminder, or Appointment)
    private String time;
    private String status;
    private String skipReason;

    // Common fields
    private String title;
    private String description;

    // Game specific
    private Long gameId;
    private String gameName;

    // Medication specific
    private Long medicationId;
    private String medicationName;
    private String dosage;
    private String mealTiming;
    // Appointment specific
    private String hospital;
    private String doctorName;
    private String appointmentDate;

    // Constructors
    public ScheduleTaskDTO() {
    }

    // Getters and Setters
    public Long getCareActivityId() {
        return careActivityId;
    }

    public void setCareActivityId(Long careActivityId) {
        this.careActivityId = careActivityId;
    }

    public String getTaskType() {
        return taskType;
    }

    public void setTaskType(String taskType) {
        this.taskType = taskType;
    }

    public Long getTaskId() {
        return taskId;
    }

    public void setTaskId(Long taskId) {
        this.taskId = taskId;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getSkipReason() {
        return skipReason;
    }

    public void setSkipReason(String skipReason) {
        this.skipReason = skipReason;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Long getGameId() {
        return gameId;
    }

    public void setGameId(Long gameId) {
        this.gameId = gameId;
    }

    public String getGameName() {
        return gameName;
    }

    public void setGameName(String gameName) {
        this.gameName = gameName;
    }

    public Long getMedicationId() {
        return medicationId;
    }

    public void setMedicationId(Long medicationId) {
        this.medicationId = medicationId;
    }

    public String getMedicationName() {
        return medicationName;
    }

    public void setMedicationName(String medicationName) {
        this.medicationName = medicationName;
    }

    public String getDosage() {
        return dosage;
    }

    public void setDosage(String dosage) {
        this.dosage = dosage;
    }

    public String getMealTiming() {
        return mealTiming;
    }

    public void setMealTiming(String mealTiming) {
        this.mealTiming = mealTiming;
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

    public String getAppointmentDate() {
        return appointmentDate;
    }

    public void setAppointmentDate(String appointmentDate) {
        this.appointmentDate = appointmentDate;
    }
}
