package Memora.DimensiaCareApplication.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.util.List;

public class CaregiverDetailsResponse {
    private Long caregiverId;
    private Long userId;
    @JsonProperty("fName")
    private String fName;
    @JsonProperty("lName")
    private String lName;
    private String email;
    private String phoneNumber;
    private String city;
    private String state;
    private String profilePic;
    private String experience;
    private String qualifications;
    private List<String> skills;
    private String gender;
    private String birthdate;
    private String address;

    // Getters and setters
    public Long getCaregiverId() { return caregiverId; }
    public void setCaregiverId(Long caregiverId) { this.caregiverId = caregiverId; }
    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }
    public String getFName() { return fName; }
    public void setFName(String fName) { this.fName = fName; }
    public String getLName() { return lName; }
    public void setLName(String lName) { this.lName = lName; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }
    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }
    public String getState() { return state; }
    public void setState(String state) { this.state = state; }
    public String getProfilePic() { return profilePic; }
    public void setProfilePic(String profilePic) { this.profilePic = profilePic; }
    public String getExperience() { return experience; }
    public void setExperience(String experience) { this.experience = experience; }
    public String getQualifications() { return qualifications; }
    public void setQualifications(String qualifications) { this.qualifications = qualifications; }
    public List<String> getSkills() { return skills; }
    public void setSkills(List<String> skills) { this.skills = skills; }
    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }
    public String getBirthdate() { return birthdate; }
    public void setBirthdate(String birthdate) { this.birthdate = birthdate; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
} 