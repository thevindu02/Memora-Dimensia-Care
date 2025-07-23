package Memora.DimensiaCareApplication.model;

import jakarta.persistence.*;
import java.util.Set;
import java.util.HashSet;

@Entity
@Table(name = "skills")
public class Skill {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "skill_id")
    private Integer skillId;

    @Column(name = "skill_name", nullable = false, unique = true)
    private String skillName;


    @ManyToMany(mappedBy = "skills", fetch = FetchType.LAZY)
    private Set<Caregiver> caregivers = new HashSet<>();

    // Constructors
    public Skill() {
    }

    public Skill(String skillName) {
        this.skillName = skillName;
    }

    // Getters and Setters
    public Integer getSkillId() {
        return skillId;
    }

    public void setSkillId(Integer skillId) {
        this.skillId = skillId;
    }

    public String getSkillName() {
        return skillName;
    }

    public void setSkillName(String skillName) {
        this.skillName = skillName;
    }

    public Set<Caregiver> getCaregivers() {
        return caregivers;
    }
    public void setCaregivers(Set<Caregiver> caregivers) {
        this.caregivers = caregivers;
    }

    // Helper methods
    public void addCaregiver(Caregiver caregiver) {
        this.caregivers.add(caregiver);
        caregiver.getSkills().add(this);
    }

    public void removeCaregiver(Caregiver caregiver) {
        this.caregivers.remove(caregiver);
        caregiver.getSkills().remove(this);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o)
            return true;
        if (o == null || getClass() != o.getClass())
            return false;
        Skill skill = (Skill) o;
        return skillId != null && skillId.equals(skill.skillId);
    }

    @Override
    public int hashCode() {
        return skillId != null ? skillId.hashCode() : 0;
    }
}
