package Memora.DimensiaCareApplication.model;

import jakarta.persistence.*;
import org.hibernate.annotations.CreationTimestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "daily_report")
public class DailyReport {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "report_id")
    private Long reportId;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "schedule_id", nullable = false, unique = true)
    private Schedule schedule;

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

    @Column(name = "routine_summary", columnDefinition = "TEXT")
    private String routineSummary;

    @Column(name = "completion_rate")
    private Integer completionRate;

    @CreationTimestamp
    @Column(name = "generated_at", nullable = false, updatable = false)
    private LocalDateTime generatedAt;

    // Constructors
    public DailyReport() {
    }

    public DailyReport(Schedule schedule, Patient patient, Guardian guardian, Caregiver caregiver, 
                      LocalDate date, String routineSummary, Integer completionRate) {
        this.schedule = schedule;
        this.patient = patient;
        this.guardian = guardian;
        this.caregiver = caregiver;
        this.date = date;
        this.routineSummary = routineSummary;
        this.completionRate = completionRate;
    }

    // Getters and Setters
    public Long getReportId() {
        return reportId;
    }

    public void setReportId(Long reportId) {
        this.reportId = reportId;
    }

    public Schedule getSchedule() {
        return schedule;
    }

    public void setSchedule(Schedule schedule) {
        this.schedule = schedule;
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

    public String getRoutineSummary() {
        return routineSummary;
    }

    public void setRoutineSummary(String routineSummary) {
        this.routineSummary = routineSummary;
    }

    public Integer getCompletionRate() {
        return completionRate;
    }

    public void setCompletionRate(Integer completionRate) {
        this.completionRate = completionRate;
    }

    public LocalDateTime getGeneratedAt() {
        return generatedAt;
    }

    public void setGeneratedAt(LocalDateTime generatedAt) {
        this.generatedAt = generatedAt;
    }
}
