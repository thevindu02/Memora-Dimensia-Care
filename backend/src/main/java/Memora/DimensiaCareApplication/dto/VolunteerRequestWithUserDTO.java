package Memora.DimensiaCareApplication.dto;

import java.time.LocalDate;
import java.time.LocalDateTime;

import Memora.DimensiaCareApplication.model.VolunteerRequest.RequestStatus;

public class VolunteerRequestWithUserDTO {
    
    // VolunteerRequest fields
    private Integer requestId;
    private Long userId;
    private String volunteerIdImage;
    private RequestStatus requestStatus;
    private LocalDateTime createdAt;
    
    // User fields
    private String firstName;
    private String lastName;
    private String email;
    private String phoneNumber;
    private LocalDate birthdate;
    private String city;
    private String state;
    private String gender;
    private String profilePic;

    // Constructors
    public VolunteerRequestWithUserDTO() {
    }

    public VolunteerRequestWithUserDTO(Integer requestId, Long userId, String volunteerIdImage, 
                                     RequestStatus requestStatus, LocalDateTime createdAt,
                                     String firstName, String lastName, String email, 
                                     String phoneNumber, LocalDate birthdate, String city, 
                                     String state, String gender, String profilePic) {
        this.requestId = requestId;
        this.userId = userId;
        this.volunteerIdImage = volunteerIdImage;
        this.requestStatus = requestStatus;
        this.createdAt = createdAt;
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.birthdate = birthdate;
        this.city = city;
        this.state = state;
        this.gender = gender;
        this.profilePic = profilePic;
    }

    // Getters and Setters
    public Integer getRequestId() {
        return requestId;
    }

    public void setRequestId(Integer requestId) {
        this.requestId = requestId;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getVolunteerIdImage() {
        return volunteerIdImage;
    }

    public void setVolunteerIdImage(String volunteerIdImage) {
        this.volunteerIdImage = volunteerIdImage;
    }

    public RequestStatus getRequestStatus() {
        return requestStatus;
    }

    public void setRequestStatus(RequestStatus requestStatus) {
        this.requestStatus = requestStatus;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
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

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public LocalDate getBirthdate() {
        return birthdate;
    }

    public void setBirthdate(LocalDate birthdate) {
        this.birthdate = birthdate;
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

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getProfilePic() {
        return profilePic;
    }

    public void setProfilePic(String profilePic) {
        this.profilePic = profilePic;
    }
}
