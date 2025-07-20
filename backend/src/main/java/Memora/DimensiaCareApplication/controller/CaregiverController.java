package Memora.DimensiaCareApplication.controller;
import Memora.DimensiaCareApplication.dto.request.CaregiverRegisterRequest;
import Memora.DimensiaCareApplication.model.*;
import Memora.DimensiaCareApplication.service.CaregiverService;
import Memora.DimensiaCareApplication.dto.response.CaregiverResponse;
import org.springframework.http.ResponseEntity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.time.LocalDate;

@RestController
@CrossOrigin(origins = "*", maxAge = 3600)
@RequestMapping("/api/caregivers")
public class CaregiverController {
    @Autowired
    private CaregiverService caregiverService;

    @GetMapping("/by-city/{city}")
    public ResponseEntity<List<CaregiverResponse>> getCaregiversByCity(@PathVariable String city) {
        try {
            List<CaregiverResponse> caregivers = caregiverService.getCaregiversByCity(city);
            return ResponseEntity.ok(caregivers);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    @GetMapping("/all")
    public ResponseEntity<List<CaregiverResponse>> getAllActiveCaregivers() {
        try {
            List<CaregiverResponse> caregivers = caregiverService.getAllActiveCaregivers();
            return ResponseEntity.ok(caregivers);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    @GetMapping("/{caregiverId}")
    public ResponseEntity<CaregiverResponse> getCaregiverById(@PathVariable Integer caregiverId) {
        try {
            CaregiverResponse caregiver = caregiverService.getCaregiverById(caregiverId);
            return ResponseEntity.ok(caregiver);
        } catch (Exception e) {
            return ResponseEntity.notFound().build();
        }
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<CaregiverResponse> getCaregiverByUserId(@PathVariable Long userId) {
        try {
            CaregiverResponse caregiver = caregiverService.getCaregiverByUserId(userId);
            return ResponseEntity.ok(caregiver);
        } catch (Exception e) {
            return ResponseEntity.notFound().build();
        }
    }

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







