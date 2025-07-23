package Memora.DimensiaCareApplication.dto;

public class VolunteerRequestCreateDTO {
    private String volunteerName;
    private String email;
    private String phoneNumber;
    private String gender;
    private String volunteerIdImage;

    public VolunteerRequestCreateDTO() {}

    public String getVolunteerName() { return volunteerName; }
    public void setVolunteerName(String volunteerName) { this.volunteerName = volunteerName; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }
    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }
    public String getVolunteerIdImage() { return volunteerIdImage; }
    public void setVolunteerIdImage(String volunteerIdImage) { this.volunteerIdImage = volunteerIdImage; }
} 