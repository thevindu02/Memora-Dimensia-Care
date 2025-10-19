package Memora.DimensiaCareApplication.dto;

public class PatientProfileDTO {
    private Long patientId;
    private Long userId;
    private String firstName;
    private String lastName;
    private String email;
    private String dementiaStage;
    private String dementiaType;
    private String dateOfDiagnosis;
    private Long guardianId;
    private Long caregiverId;

    // Constructors
    public PatientProfileDTO() {
    }

    public PatientProfileDTO(Long patientId, Long userId, String firstName, String lastName,
            String email, String dementiaStage, String dementiaType,
            String dateOfDiagnosis, Long guardianId, Long caregiverId) {
        this.patientId = patientId;
        this.userId = userId;
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.dementiaStage = dementiaStage;
        this.dementiaType = dementiaType;
        this.dateOfDiagnosis = dateOfDiagnosis;
        this.guardianId = guardianId;
        this.caregiverId = caregiverId;
    }

    // Getters and Setters
    public Long getPatientId() {
        return patientId;
    }

    public void setPatientId(Long patientId) {
        this.patientId = patientId;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getDementiaStage() {
        return dementiaStage;
    }

    public void setDementiaStage(String dementiaStage) {
        this.dementiaStage = dementiaStage;
    }

    public String getDementiaType() {
        return dementiaType;
    }

    public void setDementiaType(String dementiaType) {
        this.dementiaType = dementiaType;
    }

    public String getDateOfDiagnosis() {
        return dateOfDiagnosis;
    }

    public void setDateOfDiagnosis(String dateOfDiagnosis) {
        this.dateOfDiagnosis = dateOfDiagnosis;
    }

    public Long getGuardianId() {
        return guardianId;
    }

    public void setGuardianId(Long guardianId) {
        this.guardianId = guardianId;
    }

    public Long getCaregiverId() {
        return caregiverId;
    }

    public void setCaregiverId(Long caregiverId) {
        this.caregiverId = caregiverId;
    }
}
