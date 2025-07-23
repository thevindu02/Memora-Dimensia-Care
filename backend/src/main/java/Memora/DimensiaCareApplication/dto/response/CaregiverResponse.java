package Memora.DimensiaCareApplication.dto.response;

import Memora.DimensiaCareApplication.model.Caregiver;
import Memora.DimensiaCareApplication.model.Skill;

import java.util.List;
import java.util.stream.Collectors;

public class CaregiverResponse {
    private Integer caregiverId;
    private Long userId;
    private String name;
    private String email;
    private String phoneNumber;
    private String city;
    private String state;
    private String street;
    private String experience;
    private String qualifications;
    private List<String> skills;
    private String profilePic;
    private String gender;
    private String status;

    public CaregiverResponse() {
    }

    public CaregiverResponse(Caregiver caregiver) {
        this.caregiverId = caregiver.getCaregiverId();
        this.userId = caregiver.getUser().getId();
        this.name = caregiver.getUser().getFName() + " " + caregiver.getUser().getLName();
        this.email = caregiver.getUser().getEmail();
        this.phoneNumber = caregiver.getUser().getPhoneNumber();
        this.city = caregiver.getUser().getCity();
        this.state = caregiver.getUser().getState();
        this.street = caregiver.getUser().getStreet();
        this.experience = caregiver.getExperience();
        this.qualifications = caregiver.getQualifications();
        this.profilePic = caregiver.getUser().getProfilePic();
        this.gender = caregiver.getUser().getGender();
        this.status = caregiver.getUser().getStatus().name();

        this.skills = caregiver.getSkills().stream()
                .map(Skill::getSkillName)
                .collect(Collectors.toList());
    }

    // Getters and Setters
    public Integer getCaregiverId() {
        return caregiverId;
    }

    public void setCaregiverId(Integer caregiverId) {
        this.caregiverId = caregiverId;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getStreet() {
        return street;
    }

    public void setStreet(String street) {
        this.street = street;
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

    public List<String> getSkills() {
        return skills;
    }

    public void setSkills(List<String> skills) {
        this.skills = skills;
    }

    public String getProfilePic() {
        return profilePic;
    }

    public void setProfilePic(String profilePic) {
        this.profilePic = profilePic;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}