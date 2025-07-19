package Memora.DimensiaCareApplication.model;

import jakarta.persistence.*;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "caregivers")
@EntityListeners(AuditingEntityListener.class)
public class Caregiver {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "caregiver_id")
    private Integer caregiverId;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(name = "experience")
    private String experience;

    @Column(name = "qualifications")
    private String qualifications;

    @CreatedDate
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @LastModifiedDate
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
        name = "caregiver_skill",
        joinColumns = @JoinColumn(name = "caregiver_id"),
        inverseJoinColumns = @JoinColumn(name = "skill_id")
    )
    private Set<Skill> skills = new HashSet<>();

    // Constructors
    public Caregiver() {
    }

    public Caregiver(User user, String experience, String qualifications) {
        this.user = user;
        this.experience = experience;
        this.qualifications = qualifications;
    }

    // Getters and Setters
    public Integer getCaregiverId() {
        return caregiverId;
    }

    public void setCaregiverId(Integer caregiverId) {
        this.caregiverId = caregiverId;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public String getExperience() {
        return experience;
    }

    public void setExperience(String experience) {
        this.experience = experience;
    }

    public String getQualifications() {
        return qualifications;
    }

    public void setQualifications(String qualifications) {
        this.qualifications = qualifications;
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

    public Set<Skill> getSkills() {
        return skills;
    }

    public void setSkills(Set<Skill> skills) {
        this.skills = skills;
    }

    // Helper methods
    public void addSkill(Skill skill) {
        this.skills.add(skill);
        skill.getCaregivers().add(this);
    }

    public void removeSkill(Skill skill) {
        this.skills.remove(skill);
        skill.getCaregivers().remove(this);
    }
} 