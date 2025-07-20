package Memora.DimensiaCareApplication.dto.request;

import java.util.List;

public class CaregiverRegisterRequest {
    // User fields
    public String fName;
    public String lName;
    public String email;
    public String password;
    public String phoneNumber;
    public String street;
    public String city;
    public String state;
    public String birthdate;
    public String profilePic;
    public String gender;

    // Caregiver fields
    public String experience;
    public String qualifications;

    // Skills
    public List<String> skills;
}
