package Memora.DimensiaCareApplication.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import Memora.DimensiaCareApplication.model.Patient;
import Memora.DimensiaCareApplication.model.User;
import Memora.DimensiaCareApplication.model.Guardian;

public class PatientDetailsResponse {
    private Long patientId;
    private String dementiaStage;
    private String dementiaType;
    private String dateOfDiagnosis;
    
    // User details
    private Long userId;
    @JsonProperty("fName")
    private String fName;
    @JsonProperty("lName")
    private String lName;
    private String email;
    private String phoneNumber;
    private String birthdate;
    private String gender;
    private String street;
    private String city;
    private String state;
    
    // Guardian details
    private Long guardianId;
    private String guardianName;
    private String guardianEmail;
    private String guardianPhone;
    private String guardianCity;
    
    // Relationship
    private String relationship;

    private String patientName;
    private Integer patientAge;
    private String acceptedDate;

    public static PatientDetailsResponse fromPatient(Patient patient) {
        User user = patient.getUser();
        PatientDetailsResponse resp = new PatientDetailsResponse();
        
        resp.patientId = patient.getPatientID();
        resp.dementiaStage = patient.getDementiaStage().name();
        resp.dementiaType = patient.getDementiaType().name();
        resp.dateOfDiagnosis = patient.getDateOfDiagnosis() != null ? patient.getDateOfDiagnosis().toString() : null;
        resp.relationship = patient.getRelationship();
        
        if (user != null) {
            resp.userId = user.getId();
            resp.fName = user.getFName();
            resp.lName = user.getLName();
            resp.email = user.getEmail();
            resp.phoneNumber = user.getPhoneNumber();
            resp.birthdate = user.getBirthdate() != null ? user.getBirthdate().toString() : null;
            resp.gender = user.getGender();
            resp.street = user.getStreet();
            resp.city = user.getCity();
            resp.state = user.getState();
            // Set patientName
            resp.patientName = (user.getFName() != null ? user.getFName() : "") +
                               (user.getLName() != null ? (" " + user.getLName()) : "");
            // Set patientAge
            if (user.getBirthdate() != null) {
                java.time.LocalDate birth = user.getBirthdate();
                java.time.LocalDate now = java.time.LocalDate.now();
                resp.patientAge = java.time.Period.between(birth, now).getYears();
            }
        }
        
        // Add guardian information
        Guardian guardian = patient.getGuardian();
        if (guardian != null && guardian.getUser() != null) {
            User guardianUser = guardian.getUser();
            resp.guardianId = guardian.getGuardianId();
            resp.guardianName = guardianUser.getFName() + " " + guardianUser.getLName();
            resp.guardianEmail = guardianUser.getEmail();
            resp.guardianPhone = guardianUser.getPhoneNumber();
            resp.guardianCity = guardianUser.getCity();
        }
        
        return resp;
    }

    // Getters and Setters
    public Long getPatientId() {
        return patientId;
    }

    public void setPatientId(Long patientId) {
        this.patientId = patientId;
    }

    public String getDementiaStage() {
        return dementiaStage;
    }

    public void setDementiaStage(String dementiaStage) {
        this.dementiaStage = dementiaStage;
    }

    public String getDementiaType() {
        return dementiaType;
    }

    public void setDementiaType(String dementiaType) {
        this.dementiaType = dementiaType;
    }

    public String getDateOfDiagnosis() {
        return dateOfDiagnosis;
    }

    public void setDateOfDiagnosis(String dateOfDiagnosis) {
        this.dateOfDiagnosis = dateOfDiagnosis;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getFName() {
        return fName;
    }

    public void setFName(String fName) {
        this.fName = fName;
    }

    public String getLName() {
        return lName;
    }

    public void setLName(String lName) {
        this.lName = lName;
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

    public String getBirthdate() {
        return birthdate;
    }

    public void setBirthdate(String birthdate) {
        this.birthdate = birthdate;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
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
    
    public Long getGuardianId() {
        return guardianId;
    }
    
    public void setGuardianId(Long guardianId) {
        this.guardianId = guardianId;
    }
    
    public String getGuardianName() {
        return guardianName;
    }
    
    public void setGuardianName(String guardianName) {
        this.guardianName = guardianName;
    }
    
    public String getGuardianEmail() {
        return guardianEmail;
    }
    
    public void setGuardianEmail(String guardianEmail) {
        this.guardianEmail = guardianEmail;
    }
    
    public String getGuardianPhone() {
        return guardianPhone;
    }
    
    public void setGuardianPhone(String guardianPhone) {
        this.guardianPhone = guardianPhone;
    }
    
    public String getGuardianCity() {
        return guardianCity;
    }
    
    public void setGuardianCity(String guardianCity) {
        this.guardianCity = guardianCity;
    }
    
    public String getRelationship() {
        return relationship;
    }
    
    public void setRelationship(String relationship) {
        this.relationship = relationship;
    }

    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }
    public Integer getPatientAge() { return patientAge; }
    public void setPatientAge(Integer patientAge) { this.patientAge = patientAge; }
    public String getAcceptedDate() { return acceptedDate; }
    public void setAcceptedDate(String acceptedDate) { this.acceptedDate = acceptedDate; }
}