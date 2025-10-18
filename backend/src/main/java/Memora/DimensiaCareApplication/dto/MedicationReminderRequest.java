package Memora.DimensiaCareApplication.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public class MedicationReminderRequest {

    @NotBlank(message = "Medication name is required")
    @Size(max = 100, message = "Medication name must not exceed 100 characters")
    private String medicationName;

    @NotBlank(message = "Dosage is required")
    @Size(max = 50, message = "Dosage must not exceed 50 characters")
    private String dosage;

    @NotBlank(message = "Meal timing is required")
    @Size(max = 50, message = "Meal timing must not exceed 50 characters")
    private String mealTiming;

    @Size(max = 500, message = "Description must not exceed 500 characters")
    private String description;

    @NotBlank(message = "Time is required")
    private String time; // Format: "HH:mm"

    private String fromDate; // Format: "YYYY-MM-DD"
    private String dueDate; // Format: "YYYY-MM-DD"

    // Default constructor
    public MedicationReminderRequest() {
    }

    // Constructor with parameters
    public MedicationReminderRequest(String medicationName,
            String dosage, String mealTiming, String description, String time, String fromDate, String dueDate) {
        this.medicationName = medicationName;
        this.dosage = dosage;
        this.mealTiming = mealTiming;
        this.description = description;
        this.time = time;
        this.fromDate = fromDate;
        this.dueDate = dueDate;
    }

    // Getters and setters

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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public String getFromDate() {
        return fromDate;
    }

    public void setFromDate(String fromDate) {
        this.fromDate = fromDate;
    }

    public String getDueDate() {
        return dueDate;
    }

    public void setDueDate(String dueDate) {
        this.dueDate = dueDate;
    }

    @Override
    public String toString() {
        return "MedicationReminderRequest{" +
                ", medicationName='" + medicationName + '\'' +
                ", dosage='" + dosage + '\'' +
                ", mealTiming='" + mealTiming + '\'' +
                ", description='" + description + '\'' +
                ", time='" + time + '\'' +
                ", fromDate='" + fromDate + '\'' +
                ", dueDate='" + dueDate + '\'' +
                '}';
    }
}
