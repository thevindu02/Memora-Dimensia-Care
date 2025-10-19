package Memora.DimensiaCareApplication.dto;

public class CreateTaskRequestDTO {
    private String taskType; // DAILY_ACTIVITY, GAME, MEDICATION, APPOINTMENT
    private String time; // HH:mm format
    private String date; // YYYY-MM-DD format

    // Common fields
    private String title;
    private String description;

    // Game specific
    private Long gameId;

    // Medication specific
    private Long medicationId;
    private String dosage;
    private String mealTiming;
    private String fromDate; // For date range (medications)
    private String toDate; // For date range (medications)

    // Appointment specific
    private String hospital;
    private String doctorName;

    // Constructors
    public CreateTaskRequestDTO() {
    }

    // Getters and Setters
    public String getTaskType() {
        return taskType;
    }

    public void setTaskType(String taskType) {
        this.taskType = taskType;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
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

    public Long getMedicationId() {
        return medicationId;
    }

    public void setMedicationId(Long medicationId) {
        this.medicationId = medicationId;
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

    public String getFromDate() {
        return fromDate;
    }

    public void setFromDate(String fromDate) {
        this.fromDate = fromDate;
    }

    public String getToDate() {
        return toDate;
    }

    public void setToDate(String toDate) {
        this.toDate = toDate;
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
}
