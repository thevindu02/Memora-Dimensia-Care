package Memora.DimensiaCareApplication.model;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "guardian_subscriptions")
public class GuardianSubscription {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "subscription_id")
    private Long subscriptionId;

    @Column(name = "guardian_id", nullable = false)
    private Long guardianId;

    @Column(name = "patient_id", nullable = false)
    private Long patientId;

    // Trial period tracking
    @Column(name = "trial_start_date")
    private LocalDate trialStartDate;

    @Column(name = "trial_end_date")
    private LocalDate trialEndDate;

    // Paid subscription tracking
    @Column(name = "paid_start_date")
    private LocalDate paidStartDate;

    @Column(name = "paid_end_date")
    private LocalDate paidEndDate;

    @Column(name = "duration_months")
    private Integer durationMonths;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private SubscriptionStatus status;

    @Column(name = "auto_renew")
    private Boolean autoRenew = false;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    public enum SubscriptionStatus {
        TRIAL, // During 3-month free trial
        ACTIVE, // Paid subscription active
        EXPIRED, // Trial or paid period expired
        CANCELLED, // Cancelled by guardian
        PENDING // Waiting for caregiver assignment to start trial
    }

    // Constructors
    public GuardianSubscription() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    // Getters and Setters
    public Long getSubscriptionId() {
        return subscriptionId;
    }

    public void setSubscriptionId(Long subscriptionId) {
        this.subscriptionId = subscriptionId;
    }

    public Long getGuardianId() {
        return guardianId;
    }

    public void setGuardianId(Long guardianId) {
        this.guardianId = guardianId;
    }

    public Long getPatientId() {
        return patientId;
    }

    public void setPatientId(Long patientId) {
        this.patientId = patientId;
    }

    public LocalDate getTrialStartDate() {
        return trialStartDate;
    }

    public void setTrialStartDate(LocalDate trialStartDate) {
        this.trialStartDate = trialStartDate;
    }

    public LocalDate getTrialEndDate() {
        return trialEndDate;
    }

    public void setTrialEndDate(LocalDate trialEndDate) {
        this.trialEndDate = trialEndDate;
    }

    public LocalDate getPaidStartDate() {
        return paidStartDate;
    }

    public void setPaidStartDate(LocalDate paidStartDate) {
        this.paidStartDate = paidStartDate;
    }

    public LocalDate getPaidEndDate() {
        return paidEndDate;
    }

    public void setPaidEndDate(LocalDate paidEndDate) {
        this.paidEndDate = paidEndDate;
    }

    public Integer getDurationMonths() {
        return durationMonths;
    }

    public void setDurationMonths(Integer durationMonths) {
        this.durationMonths = durationMonths;
    }

    public SubscriptionStatus getStatus() {
        return status;
    }

    public void setStatus(SubscriptionStatus status) {
        this.status = status;
    }

    public Boolean getAutoRenew() {
        return autoRenew;
    }

    public void setAutoRenew(Boolean autoRenew) {
        this.autoRenew = autoRenew;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    @PreUpdate
    public void preUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
}
