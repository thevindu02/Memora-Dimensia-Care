package Memora.DimensiaCareApplication.controller;

import Memora.DimensiaCareApplication.dto.request.CaregiverRegisterRequest;
import Memora.DimensiaCareApplication.model.*;
import Memora.DimensiaCareApplication.service.CaregiverService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;

@RestController
@RequestMapping("/api/caregivers")
public class CaregiverController {
    @Autowired
    private CaregiverService caregiverService;

    @PostMapping("/register")
    public Caregiver registerCaregiver(@RequestBody CaregiverRegisterRequest request) {
        User user = new User();
        user.setFName(request.fName);
        user.setLName(request.lName);
        user.setEmail(request.email);
        user.setPassword(request.password);
        user.setPhoneNumber(request.phoneNumber);
        user.setStreet(request.street);
        user.setCity(request.city);
        user.setState(request.state);
        user.setBirthdate(request.birthdate != null ? LocalDate.parse(request.birthdate) : null);
        user.setProfilePic(request.profilePic);
        user.setGender(request.gender);
        user.setRole(User.UserRole.CAREGIVER);
        // set other fields as needed

        Caregiver caregiver = new Caregiver();
        caregiver.setExperience(request.experience);
        caregiver.setQualifications(request.qualifications);

        return caregiverService.registerCaregiver(user, caregiver, request.skills);
    }
}
