
package Memora.DimensiaCareApplication.model;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalTime;

@Entity
@Table(name = "medications")
public class Medication {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "medication_id")
    private Long medicationId;

    @Column(name = "patient_id", nullable = false)
    private Long patientId;

    @Column(name = "medication_name", nullable = false)
    private String medicationName;

    @Column(name = "dosage")
    private String dosage;

    @Column(name = "meal_timing")
    private String mealTiming;

    @Column(name = "time")
    private LocalTime time;

    @Column(name = "description")
    private String description;

    @Column(name = "from_date")
    private LocalDate fromDate;

    @Column(name = "due_date")
    private LocalDate dueDate;

    // Getters and setters
    public Long getMedicationId() {
        return medicationId;
    }

    public void setMedicationId(Long medicationId) {
        this.medicationId = medicationId;
    }

    public Long getPatientId() {
        return patientId;
    }

    public void setPatientId(Long patientId) {
        this.patientId = patientId;
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

    public LocalTime getTime() {
        return time;
    }

    public void setTime(LocalTime time) {
        this.time = time;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public LocalDate getFromDate() {
        return fromDate;
    }

    public void setFromDate(LocalDate fromDate) {
        this.fromDate = fromDate;
    }

    public LocalDate getDueDate() {
        return dueDate;
    }

    public void setDueDate(LocalDate dueDate) {
        this.dueDate = dueDate;
    }
}
