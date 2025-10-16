package Memora.DimensiaCareApplication.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "guardian_connection_requests")
public class GuardianConnectionRequest {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "connection_token", unique = true, nullable = false)
    private String connectionToken;

    @Column(name = "guardian_name", nullable = false)
    private String guardianName;

    @Column(name = "guardian_email", nullable = false)
    private String guardianEmail;

    @Column(name = "patient_name", nullable = false)
    private String patientName;

    @Column(name = "patient_email", nullable = false)
    private String patientEmail;

    @Column(name = "relationship", nullable = false)
    private String relationship;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt;

    @Column(name = "expires_at", nullable = false)
    private LocalDateTime expiresAt;

    @Column(name = "status")
    @Enumerated(EnumType.STRING)
    private RequestStatus status = RequestStatus.PENDING;

    public enum RequestStatus {
        PENDING,
        ACCEPTED,
        DECLINED,
        EXPIRED
    }

    // Constructors
    public GuardianConnectionRequest() {
    }

    public GuardianConnectionRequest(String connectionToken, String guardianName, String guardianEmail,
            String patientName, String patientEmail, String relationship) {
        this.connectionToken = connectionToken;
        this.guardianName = guardianName;
        this.guardianEmail = guardianEmail;
        this.patientName = patientName;
        this.patientEmail = patientEmail;
        this.relationship = relationship;
        this.createdAt = LocalDateTime.now();
        this.expiresAt = LocalDateTime.now().plusDays(7); // Token expires in 7 days
        this.status = RequestStatus.PENDING;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getConnectionToken() {
        return connectionToken;
    }

    public void setConnectionToken(String connectionToken) {
        this.connectionToken = connectionToken;
    }

    public String getGuardianName() {
        return guardianName;
    }

    public void setGuardianName(String guardianName) {
        this.guardianName = guardianName;
    }

    public String getGuardianEmail() {
        return guardianEmail;
    }

    public void setGuardianEmail(String guardianEmail) {
        this.guardianEmail = guardianEmail;
    }

    public String getPatientName() {
        return patientName;
    }

    public void setPatientName(String patientName) {
        this.patientName = patientName;
    }

    public String getPatientEmail() {
        return patientEmail;
    }

    public void setPatientEmail(String patientEmail) {
        this.patientEmail = patientEmail;
    }

    public String getRelationship() {
        return relationship;
    }

    public void setRelationship(String relationship) {
        this.relationship = relationship;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getExpiresAt() {
        return expiresAt;
    }

    public void setExpiresAt(LocalDateTime expiresAt) {
        this.expiresAt = expiresAt;
    }

    public RequestStatus getStatus() {
        return status;
    }

    public void setStatus(RequestStatus status) {
        this.status = status;
    }
}
