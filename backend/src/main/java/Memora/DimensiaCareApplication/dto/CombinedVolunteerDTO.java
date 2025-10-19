package Memora.DimensiaCareApplication.dto;

import java.time.LocalDate;
import java.time.LocalDateTime;

import Memora.DimensiaCareApplication.model.User.UserStatus;
import Memora.DimensiaCareApplication.model.VolunteerRequest.RequestStatus;

public class CombinedVolunteerDTO {

    // Common fields
    private String email;
    private String firstName;
    private String lastName;
    private String phoneNumber;
    private String gender;
    private LocalDate birthdate;
    private String city;
    private String state;
    private String profilePic;
    private LocalDateTime createdAt;

    // Fields for volunteer requests (pending volunteers)
    private Integer requestId;
    private String volunteerName;
    private RequestStatus requestStatus;
    private String volunteerIdImage;

    // Fields for accepted volunteers
    private Long volunteerId;
    private Long userId;
    private UserStatus userStatus;
    private String type; // "request" or "volunteer"
    private String displayStatus; // Combined status for display

    // Constructors
    public CombinedVolunteerDTO() {
    }

    // Constructor for volunteer request data
    public CombinedVolunteerDTO(Integer requestId, String volunteerName, String email,
            String phoneNumber, String gender, RequestStatus requestStatus,
            String volunteerIdImage, LocalDateTime createdAt) {
        this.requestId = requestId;
        this.volunteerName = volunteerName;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.gender = gender;
        this.requestStatus = requestStatus;
        this.volunteerIdImage = volunteerIdImage;
        this.createdAt = createdAt;
        this.type = "request";
        this.displayStatus = requestStatus != null ? requestStatus.name() : "pending";

        // Parse volunteer name into first and last name
        if (volunteerName != null && !volunteerName.trim().isEmpty()) {
            String[] nameParts = volunteerName.split(" ", 2);
            this.firstName = nameParts[0];
            this.lastName = nameParts.length > 1 ? nameParts[1] : "";
        }
    }

    // Constructor for volunteer data (with user info)
    public CombinedVolunteerDTO(Long volunteerId, Long userId, String volunteerIdImage,
            String firstName, String lastName, String email,
            String phoneNumber, LocalDate birthdate, String city,
            String state, String gender, String profilePic,
            UserStatus userStatus, LocalDateTime createdAt) {
        this.volunteerId = volunteerId;
        this.userId = userId;
        this.volunteerIdImage = volunteerIdImage;
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.birthdate = birthdate;
        this.city = city;
        this.state = state;
        this.gender = gender;
        this.profilePic = profilePic;
        this.userStatus = userStatus;
        this.createdAt = createdAt;
        this.type = "volunteer";
        
        // Map UserStatus to display status for volunteers
        if (userStatus != null) {
            switch (userStatus) {
                case ACTIVE:
                    this.displayStatus = "accepted";
                    break;
                case INACTIVE:
                    this.displayStatus = "pending";
                    break;
                case SUSPENDED:
                    this.displayStatus = "rejected";
                    break;
                default:
                    this.displayStatus = "pending";
            }
        } else {
            this.displayStatus = "pending";
        }

        // Set volunteer name for consistency
        this.volunteerName = (firstName != null ? firstName : "")
                + (lastName != null && !lastName.isEmpty() ? " " + lastName : "");
    }

    // Getters and Setters
    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
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

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
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

    public String getProfilePic() {
        return profilePic;
    }

    public void setProfilePic(String profilePic) {
        this.profilePic = profilePic;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public Integer getRequestId() {
        return requestId;
    }

    public void setRequestId(Integer requestId) {
        this.requestId = requestId;
    }

    public String getVolunteerName() {
        return volunteerName;
    }

    public void setVolunteerName(String volunteerName) {
        this.volunteerName = volunteerName;
    }

    public RequestStatus getRequestStatus() {
        return requestStatus;
    }

    public void setRequestStatus(RequestStatus requestStatus) {
        this.requestStatus = requestStatus;
    }

    public String getVolunteerIdImage() {
        return volunteerIdImage;
    }

    public void setVolunteerIdImage(String volunteerIdImage) {
        this.volunteerIdImage = volunteerIdImage;
    }

    public Long getVolunteerId() {
        return volunteerId;
    }

    public void setVolunteerId(Long volunteerId) {
        this.volunteerId = volunteerId;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public UserStatus getUserStatus() {
        return userStatus;
    }

    public void setUserStatus(UserStatus userStatus) {
        this.userStatus = userStatus;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getDisplayStatus() {
        return displayStatus;
    }

    public void setDisplayStatus(String displayStatus) {
        this.displayStatus = displayStatus;
    }

    // Helper method for sorting priority
    // 1 = INACTIVE (highest priority - show first)
    // 2 = ACTIVE 
    // 3 = SUSPENDED (lowest priority - show last)
    public int getSortPriority() {
        if (this.type.equals("request") && this.requestStatus == RequestStatus.pending) {
            return 1; // Pending requests first
        } else if (this.type.equals("volunteer")) {
            if (this.userStatus == UserStatus.INACTIVE) {
                return 1; // INACTIVE volunteers - first
            } else if (this.userStatus == UserStatus.ACTIVE) {
                return 2; // ACTIVE volunteers - second
            } else if (this.userStatus == UserStatus.SUSPENDED) {
                return 3; // SUSPENDED volunteers - last
            }
        } else if (this.type.equals("request") && this.requestStatus == RequestStatus.accepted) {
            return 2; // Accepted requests - second
        } else if (this.type.equals("request") && this.requestStatus == RequestStatus.rejected) {
            return 3; // Rejected requests - last
        }
        return 4; // Default - lowest priority
    }
}
