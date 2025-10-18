package Memora.DimensiaCareApplication.dto.response;

public class CaregiverSummaryResponse {
    private Long caregiverId;
    private Long userId;
    private String fName;
    private String lName;
    private String email;
    private String experience;
    private String qualifications;
    private String status;

    public CaregiverSummaryResponse() {}

    public CaregiverSummaryResponse(Long caregiverId, Long userId, String fName, String lName, String email,
                                    String experience, String qualifications, String status) {
        this.caregiverId = caregiverId;
        this.userId = userId;
        this.fName = fName;
        this.lName = lName;
        this.email = email;
        this.experience = experience;
        this.qualifications = qualifications;
        this.status = status;
    }

    public Long getCaregiverId() { return caregiverId; }
    public Long getUserId() { return userId; }
    public String getFName() { return fName; }
    public String getLName() { return lName; }
    public String getEmail() { return email; }
    public String getExperience() { return experience; }
    public String getQualifications() { return qualifications; }
    public String getStatus() { return status; }

    public void setCaregiverId(Long caregiverId) { this.caregiverId = caregiverId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public void setFName(String fName) { this.fName = fName; }
    public void setLName(String lName) { this.lName = lName; }
    public void setEmail(String email) { this.email = email; }
    public void setExperience(String experience) { this.experience = experience; }
    public void setQualifications(String qualifications) { this.qualifications = qualifications; }
    public void setStatus(String status) { this.status = status; }
}
