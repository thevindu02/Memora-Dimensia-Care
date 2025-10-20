package Memora.DimensiaCareApplication.model;

import jakarta.persistence.*;
import java.time.LocalDate;
//import Memora.DimensiaCareApplication.model.Guardian;

@Entity
@Table(name = "patients")
public class Patient {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "patient_id")
    private Long patientId;

    @Enumerated(EnumType.STRING)
    @Column(name = "dementia_stage", nullable = false)
    private DementiaStage dementiaStage;

    @Column(name = "date_of_diagnosis")
    private LocalDate dateOfDiagnosis;

    @Enumerated(EnumType.STRING)
    @Column(name = "dementia_type", nullable = false)
    private DementiaType dementiaType;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "guardian_id", referencedColumnName = "guardian_id")
    private Guardian guardian;

    @Column(name = "relationship")
    private String relationship;

    // Getters and setters

    public Long getPatientID() {
        return patientId;
    }

    public void setPatientID(Long patientID) {
        this.patientId = patientID;
    }

    public DementiaStage getDementiaStage() {
        return dementiaStage;
    }

    public void setDementiaStage(DementiaStage dementiaStage) {
        this.dementiaStage = dementiaStage;
    }

    public LocalDate getDateOfDiagnosis() {
        return dateOfDiagnosis;
    }

    public void setDateOfDiagnosis(LocalDate dateOfDiagnosis) {
        this.dateOfDiagnosis = dateOfDiagnosis;
    }

    public DementiaType getDementiaType() {
        return dementiaType;
    }

    public void setDementiaType(DementiaType dementiaType) {
        this.dementiaType = dementiaType;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Guardian getGuardian() {
        return guardian;
    }

    public void setGuardian(Guardian guardian) {
        this.guardian = guardian;
    }

    public String getRelationship() {
        return relationship;
    }

    public void setRelationship(String relationship) {
        this.relationship = relationship;
    }

    // Enums
    public enum DementiaStage {
        MILD, MODERATE, SEVERE, VERY_SEVERE
    }

    public enum DementiaType {
        ALZHEIMERS_DISEASE,
        VASCULAR_DEMENTIA,
        LEWY_BODY_DEMENTIA,
        FRONTOTEMPORAL_DEMENTIA,
        MIXED_DEMENTIA,
        PARKINSONS_DISEASE_DEMENTIA,
        CREUTZFELDT_JAKOB_DISEASE,
        NORMAL_PRESSURE_HYDROCEPHALUS,
        HUNTINGTONS_DISEASE,
        WERNICKE_KORSAKOFF_SYNDROME
    }
}
