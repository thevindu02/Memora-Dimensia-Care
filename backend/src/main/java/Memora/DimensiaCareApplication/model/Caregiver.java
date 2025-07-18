package Memora.DimensiaCareApplication.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "caregivers")
public class Caregiver {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "caregiver_id")
    private Integer caregiverId;

    @OneToOne
    @JoinColumn(name = "user_id", referencedColumnName = "id")
    private User user;

    private String experience;
    private String qualifications;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    // Getters and setters
    public void setExperience(String experience) {
        this.experience = experience;
    }

    public void setQualifications(String qualifications) {
        this.qualifications = qualifications;
    }

    public void setUser(User user) {
        this.user = user;
    }
}
