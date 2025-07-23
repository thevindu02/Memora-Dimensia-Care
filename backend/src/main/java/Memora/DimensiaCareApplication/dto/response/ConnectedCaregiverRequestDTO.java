package Memora.DimensiaCareApplication.dto.response;

public class ConnectedCaregiverRequestDTO {
    private Long connectionId;
    private String guardianName;
    private String guardianEmail;
    private String patientName;
    private Integer patientAge;
    private String diagnosis;
    private String relationship;
    private String status;
    private String connectedDateTime;
    private Long patientId;
    private String dementiaStage;
    private String dementiaType;

    // Getters and setters
    public Long getConnectionId() { return connectionId; }
    public void setConnectionId(Long connectionId) { this.connectionId = connectionId; }
    public String getGuardianName() { return guardianName; }
    public void setGuardianName(String guardianName) { this.guardianName = guardianName; }
    public String getGuardianEmail() { return guardianEmail; }
    public void setGuardianEmail(String guardianEmail) { this.guardianEmail = guardianEmail; }
    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }
    public Integer getPatientAge() { return patientAge; }
    public void setPatientAge(Integer patientAge) { this.patientAge = patientAge; }
    public String getDiagnosis() { return diagnosis; }
    public void setDiagnosis(String diagnosis) { this.diagnosis = diagnosis; }
    public String getRelationship() { return relationship; }
    public void setRelationship(String relationship) { this.relationship = relationship; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getConnectedDateTime() { return connectedDateTime; }
    public void setConnectedDateTime(String connectedDateTime) { this.connectedDateTime = connectedDateTime; }
    public Long getPatientId() { return patientId; }
    public void setPatientId(Long patientId) { this.patientId = patientId; }
    public String getDementiaStage() { return dementiaStage; }
    public void setDementiaStage(String dementiaStage) { this.dementiaStage = dementiaStage; }
    public String getDementiaType() { return dementiaType; }
    public void setDementiaType(String dementiaType) { this.dementiaType = dementiaType; }
} 