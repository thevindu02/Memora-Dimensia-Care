package Memora.DimensiaCareApplication.model;

import jakarta.persistence.*;

@Entity
@Table(name = "caregiver_skill")
public class CaregiverSkill {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "caregiver_id", nullable = false)
    private Integer caregiverId;

    @Column(name = "skill_id", nullable = false)
    private Integer skillId;

    // Getters and setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public Integer getCaregiverId() { return caregiverId; }
    public void setCaregiverId(Integer caregiverId) { this.caregiverId = caregiverId; }
    public Integer getSkillId() { return skillId; }
    public void setSkillId(Integer skillId) { this.skillId = skillId; }
} 