package Memora.DimensiaCareApplication.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "caregivers")
public class Caregiver {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "caregiver_id")
    private Integer caregiverId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(name = "experience")
    private String experience;

    @Column(name = "qualifications")
    private String qualifications;

    @Column(name = "severity_score", nullable = false)
    private Integer severityScore = 0;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    // Getters and setters
    public Integer getCaregiverId() { return caregiverId; }
    public void setCaregiverId(Integer caregiverId) { this.caregiverId = caregiverId; }
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
    public String getExperience() { return experience; }
    public void setExperience(String experience) { this.experience = experience; }
    public String getQualifications() { return qualifications; }
    public void setQualifications(String qualifications) { this.qualifications = qualifications; }
    public Integer getSeverityScore() { return severityScore; }
    public void setSeverityScore(Integer severityScore) { this.severityScore = severityScore; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
} 