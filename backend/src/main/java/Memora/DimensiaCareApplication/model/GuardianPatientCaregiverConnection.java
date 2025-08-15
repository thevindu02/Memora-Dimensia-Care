package Memora.DimensiaCareApplication.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "guardian_patient_caregiver_connection")
public class GuardianPatientCaregiverConnection {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "connection_id")
    private Long connectionId;

    @Column(name = "guardian_id", nullable = false)
    private Long guardianId;

    @Column(name = "patient_id", nullable = false)
    private Long patientId;

    @Column(name = "caregiver_id", nullable = false)
    private Long caregiverId;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private ConnectionStatus status;

    @Column(name = "connected_date_time")
    private LocalDateTime connectedDateTime;

    @Column(name = "rejected_date_time")
    private LocalDateTime rejectedDateTime;

    @Column(name = "cancelled_date_time")
    private LocalDateTime cancelledDateTime;

    public enum ConnectionStatus {
        PENDING, REJECTED, EXPIRED, ACTIVE, INACTIVE, CANCELLED
    }

    // Getters and setters
    public Long getConnectionId() { return connectionId; }
    public void setConnectionId(Long connectionId) { this.connectionId = connectionId; }
    public Long getGuardianId() { return guardianId; }
    public void setGuardianId(Long guardianId) { this.guardianId = guardianId; }
    public Long getPatientId() { return patientId; }
    public void setPatientId(Long patientId) { this.patientId = patientId; }
    public Long getCaregiverId() { return caregiverId; }
    public void setCaregiverId(Long caregiverId) { this.caregiverId = caregiverId; }
    public ConnectionStatus getStatus() { return status; }
    public void setStatus(ConnectionStatus status) { this.status = status; }
    public LocalDateTime getConnectedDateTime() { return connectedDateTime; }
    public void setConnectedDateTime(LocalDateTime connectedDateTime) { this.connectedDateTime = connectedDateTime; }
    public LocalDateTime getRejectedDateTime() { return rejectedDateTime; }
    public void setRejectedDateTime(LocalDateTime rejectedDateTime) { this.rejectedDateTime = rejectedDateTime; }
    public LocalDateTime getCancelledDateTime() { return cancelledDateTime; }
    public void setCancelledDateTime(LocalDateTime cancelledDateTime) { this.cancelledDateTime = cancelledDateTime; }
} 