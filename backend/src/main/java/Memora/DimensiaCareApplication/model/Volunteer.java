package Memora.DimensiaCareApplication.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "volunteers")
public class Volunteer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "volunteer_id")
    private Long volunteerId;

    @Column(name = "user_id", nullable = false)
    private Long userId;

    @Column(name = "volunteer_id_image")
    private String volunteerIdImage;

    // Constructors
    public Volunteer() {
    }

    public Volunteer(Long userId, String volunteerIdImage) {
        this.userId = userId;
        this.volunteerIdImage = volunteerIdImage;
    }

    // Getters and Setters
    public Long getVolunteerId() {
        return volunteerId;
    }

    public void setVolunteerId(Long volunteerId) {
        this.volunteerId = volunteerId;
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
}
