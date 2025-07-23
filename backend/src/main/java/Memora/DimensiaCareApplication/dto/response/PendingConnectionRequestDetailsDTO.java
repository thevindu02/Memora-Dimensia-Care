package Memora.DimensiaCareApplication.dto.response;

public class PendingConnectionRequestDetailsDTO {
    private Long connectionId;
    private String guardianName;
    private String guardianEmail;
    private String guardianPhone;
    private String patientName;
    private Integer patientAge;
    private String diagnosis;
    private String dementiaType;
    private String dementiaStage;
    private String status;
    private String connectedDateTime;
    private String relationship;

    // Getters and setters
    public Long getConnectionId() { return connectionId; }
    public void setConnectionId(Long connectionId) { this.connectionId = connectionId; }
    public String getGuardianName() { return guardianName; }
    public void setGuardianName(String guardianName) { this.guardianName = guardianName; }
    public String getGuardianEmail() { return guardianEmail; }
    public void setGuardianEmail(String guardianEmail) { this.guardianEmail = guardianEmail; }
    public String getGuardianPhone() { return guardianPhone; }
    public void setGuardianPhone(String guardianPhone) { this.guardianPhone = guardianPhone; }
    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }
    public Integer getPatientAge() { return patientAge; }
    public void setPatientAge(Integer patientAge) { this.patientAge = patientAge; }
    public String getDiagnosis() { return diagnosis; }
    public void setDiagnosis(String diagnosis) { this.diagnosis = diagnosis; }
    public String getDementiaType() { return dementiaType; }
    public void setDementiaType(String dementiaType) { this.dementiaType = dementiaType; }
    public String getDementiaStage() { return dementiaStage; }
    public void setDementiaStage(String dementiaStage) { this.dementiaStage = dementiaStage; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getConnectedDateTime() { return connectedDateTime; }
    public void setConnectedDateTime(String connectedDateTime) { this.connectedDateTime = connectedDateTime; }
    public String getRelationship() { return relationship; }
    public void setRelationship(String relationship) { this.relationship = relationship; }
} 