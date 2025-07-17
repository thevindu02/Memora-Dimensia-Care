package Memora.DimensiaCareApplication.dto.request;

import Memora.DimensiaCareApplication.model.Patient;
import java.time.LocalDate;

public class PatientRequest {
    private Long userId;
    private Patient.DementiaStage dementiaStage;
    private LocalDate dateOfDiagnosis;
    private Patient.DementiaType dementiaType;
    private Long guardianId;

    // Getters and setters

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Patient.DementiaStage getDementiaStage() {
        return dementiaStage;
    }

    public void setDementiaStage(Patient.DementiaStage dementiaStage) {
        this.dementiaStage = dementiaStage;
    }

    public LocalDate getDateOfDiagnosis() {
        return dateOfDiagnosis;
    }

    public void setDateOfDiagnosis(LocalDate dateOfDiagnosis) {
        this.dateOfDiagnosis = dateOfDiagnosis;
    }

    public Patient.DementiaType getDementiaType() {
        return dementiaType;
    }

    public void setDementiaType(Patient.DementiaType dementiaType) {
        this.dementiaType = dementiaType;
    }

    public Long getGuardianId() {
        return guardianId;
    }

    public void setGuardianId(Long guardianId) {
        this.guardianId = guardianId;
    }
}
