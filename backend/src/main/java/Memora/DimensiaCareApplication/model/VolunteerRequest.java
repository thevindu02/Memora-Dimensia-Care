package Memora.DimensiaCareApplication.model;

import java.time.LocalDateTime;

import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EntityListeners;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "volunteer_requests")
@EntityListeners(AuditingEntityListener.class)
public class VolunteerRequest {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "request_id")
    private Integer requestId;

    @Column(name = "volunteer_name", nullable = false, length = 100)
    private String volunteerName;

    @Column(name = "email", nullable = false, length = 100)
    private String email;

    @Column(name = "phone_number", nullable = false, length = 20)
    private String phoneNumber;

    @Column(name = "gender", nullable = false, length = 10)
    private String gender;

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

    public VolunteerRequest(String volunteerName, String email, String phoneNumber, String gender,
            String volunteerIdImage) {
        this.volunteerName = volunteerName;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.gender = gender;
        this.volunteerIdImage = volunteerIdImage;
    }

    // Getters and Setters
    public Integer getRequestId() {
        return requestId;
    }

    public void setRequestId(Integer requestId) {
        this.requestId = requestId;
    }

    public String getVolunteerName() {
        return volunteerName;
    }

    public void setVolunteerName(String volunteerName) {
        this.volunteerName = volunteerName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
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