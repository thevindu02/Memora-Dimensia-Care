package Memora.DimensiaCareApplication.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.*;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;

@Entity
@Table(name = "volunteer_requests")
@EntityListeners(AuditingEntityListener.class)
public class VolunteerRequest {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "request_id")
    private Integer requestId;

    @Column(name = "user_id", nullable = false)
    private Long userId;

    @Column(name = "volunteer_id_image", nullable = true)
    private String volunteerIdImage;

    @Enumerated(EnumType.STRING)
    @Column(name = "request_status", columnDefinition = "VARCHAR(20)")
    private RequestStatus requestStatus = RequestStatus.pending;

    @CreatedDate
    @Column(name = "created_at")
    private LocalDateTime createdAt;

    // Constructors
    public VolunteerRequest() {
    }

    public VolunteerRequest(Long userId, String volunteerIdImage) {
        this.userId = userId;
        this.volunteerIdImage = volunteerIdImage;
    }

    // Getters and Setters
    public Integer getRequestId() {
        return requestId;
    }

    public void setRequestId(Integer requestId) {
        this.requestId = requestId;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getVolunteerIdImage() {
        return volunteerIdImage;
    }

    public void setVolunteerIdImage(String volunteerIdImage) {
        this.volunteerIdImage = volunteerIdImage;
    }

    public RequestStatus getRequestStatus() {
        return requestStatus;
    }

    public void setRequestStatus(RequestStatus requestStatus) {
        this.requestStatus = requestStatus;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public enum RequestStatus {
        pending, approved, accepted, rejected
    }
}