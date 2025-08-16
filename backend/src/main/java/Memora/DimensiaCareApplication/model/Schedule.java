package Memora.DimensiaCareApplication.model;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.util.Set;
import java.util.HashSet;

@Entity
@Table(name = "schedule")
public class Schedule {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "schedule_id")
    private Long scheduleId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "patient_id", nullable = false)
    private Patient patient;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "guardian_id", nullable = false)
    private Guardian guardian;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "caregiver_id", nullable = false)
    private Caregiver caregiver;

    @Column(name = "date", nullable = false)
    private LocalDate date;

    @Column(name = "iscompleted", nullable = false)
    private Boolean isCompleted = false;

    @OneToMany(mappedBy = "schedule", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private Set<CareActivity> careActivities = new HashSet<>();

    // Default constructor
    public Schedule() {
    }

    // Constructor with parameters
    public Schedule(Patient patient, Guardian guardian, Caregiver caregiver, LocalDate date) {
        this.patient = patient;
        this.guardian = guardian;
        this.caregiver = caregiver;
        this.date = date;
        this.isCompleted = false;
    }

    // Getters and setters
    public Long getScheduleId() {
        return scheduleId;
    }

    public void setScheduleId(Long scheduleId) {
        this.scheduleId = scheduleId;
    }

    public Patient getPatient() {
        return patient;
    }

    public void setPatient(Patient patient) {
        this.patient = patient;
    }

    public Guardian getGuardian() {
        return guardian;
    }

    public void setGuardian(Guardian guardian) {
        this.guardian = guardian;
    }

    public Caregiver getCaregiver() {
        return caregiver;
    }

    public void setCaregiver(Caregiver caregiver) {
        this.caregiver = caregiver;
    }

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public Boolean getIsCompleted() {
        return isCompleted;
    }

    public void setIsCompleted(Boolean isCompleted) {
        this.isCompleted = isCompleted;
    }

    public Set<CareActivity> getCareActivities() {
        return careActivities;
    }

    public void setCareActivities(Set<CareActivity> careActivities) {
        this.careActivities = careActivities;
    }
}
