package Memora.DimensiaCareApplication.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import Memora.DimensiaCareApplication.model.Patient;
import Memora.DimensiaCareApplication.model.User;
import Memora.DimensiaCareApplication.model.Guardian;

public class PatientDetailsResponse {
    private Long patientId;
    private String FName;
    private String LName;
    private String email;
    private String phoneNumber;
    private String gender;
    private String birthdate;
    private String street;
    private String city;
    private String state;
    private String dementiaType;
    private String dementiaStage;
    private String label;
    private String profilePic;
    private String acceptedDate;

    public static PatientDetailsResponse fromPatient(Patient patient) {
        PatientDetailsResponse resp = new PatientDetailsResponse();
        resp.patientId = patient.getPatientID();
        User user = patient.getUser();
        resp.FName = user.getFName();
        resp.LName = user.getLName();
        resp.email = user.getEmail();
        resp.phoneNumber = user.getPhoneNumber();
        resp.gender = user.getGender();
        resp.birthdate = user.getBirthdate() != null ? user.getBirthdate().toString() : "";
        resp.street = user.getStreet();
        resp.city = user.getCity();
        resp.state = user.getState();
        resp.profilePic = user.getProfilePic();
        resp.dementiaType = patient.getDementiaType() != null ? patient.getDementiaType().name() : "";
        resp.dementiaStage = patient.getDementiaStage() != null ? patient.getDementiaStage().name() : "";
        resp.label = patient.getLabel();
        return resp;
    }

    // Getters and Setters
    public Long getPatientId() {
        return patientId;
    }

    public void setPatientId(Long patientId) {
        this.patientId = patientId;
    }

    public String getFName() {
        return FName;
    }

    public void setFName(String fName) {
        this.FName = fName;
    }

    public String getLName() {
        return LName;
    }

    public void setLName(String lName) {
        this.LName = lName;
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

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getBirthdate() {
        return birthdate;
    }

    public void setBirthdate(String birthdate) {
        this.birthdate = birthdate;
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

    public String getDementiaType() {
        return dementiaType;
    }

    public void setDementiaType(String dementiaType) {
        this.dementiaType = dementiaType;
    }

    public String getDementiaStage() {
        return dementiaStage;
    }

    public void setDementiaStage(String dementiaStage) {
        this.dementiaStage = dementiaStage;
    }

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public String getProfilePic() {
        return profilePic;
    }

    public void setProfilePic(String profilePic) {
        this.profilePic = profilePic;
    }

    public String getAcceptedDate() {
        return acceptedDate;
    }

    public void setAcceptedDate(String acceptedDate) {
        this.acceptedDate = acceptedDate;
    }
}