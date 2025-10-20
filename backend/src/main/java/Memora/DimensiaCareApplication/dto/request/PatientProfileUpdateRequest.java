package Memora.DimensiaCareApplication.dto.request;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;
import Memora.DimensiaCareApplication.model.Patient;

import java.time.LocalDate;

public class PatientProfileUpdateRequest {
    @JsonProperty("FName")
    private String FName;
    @JsonProperty("LName")
    private String LName;

    // Automatically parse date from JSON (yyyy-MM-dd format)
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
    private LocalDate birthdate;

    private String gender;
    private String phoneNumber;
    private String street;
    private String city;
    private String state;
    private String email;

    @JsonProperty("dementiaType")
    private Patient.DementiaType dementiaType;
    @JsonProperty("dementiaStage")
    private Patient.DementiaStage dementiaStage;

    private String profilePic;

    // --- Getters and Setters ---
    public String getFName() {
        return FName;
    }

    public void setFName(String FName) {
        this.FName = FName;
    }

    public String getLName() {
        return LName;
    }

    public void setLName(String LName) {
        this.LName = LName;
    }

    public LocalDate getBirthdate() {
        return birthdate;
    }

    public void setBirthdate(LocalDate birthdate) {
        this.birthdate = birthdate;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getStreet() {
        return street;
    }

    public void setStreet(String street) {
        this.street = street;
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

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Patient.DementiaType getDementiaType() {
        return dementiaType;
    }

    public void setDementiaType(Patient.DementiaType dementiaType) {
        this.dementiaType = dementiaType;
    }

    public Patient.DementiaStage getDementiaStage() {
        return dementiaStage;
    }

    public void setDementiaStage(Patient.DementiaStage dementiaStage) {
        this.dementiaStage = dementiaStage;
    }

    public String getProfilePic() {
        return profilePic;
    }

    public void setProfilePic(String profilePic) {
        this.profilePic = profilePic;
    }
}
