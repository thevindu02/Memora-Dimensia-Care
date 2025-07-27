package Memora.DimensiaCareApplication.service;

import Memora.DimensiaCareApplication.dto.response.CaregiverDetailsResponse;
import Memora.DimensiaCareApplication.dto.response.CaregiverResponse;
import Memora.DimensiaCareApplication.model.*;
import Memora.DimensiaCareApplication.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.scheduling.annotation.Scheduled;
import java.util.List;
import java.util.stream.Collectors;
import java.time.LocalDateTime;

@Service
public class CaregiverService {
    @Autowired
    private CaregiverRepository caregiverRepository;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private SkillRepository skillRepository;
    @Autowired
    private GuardianPatientCaregiverConnectionRepository connectionRepository;
    @Autowired
    private PasswordEncoder passwordEncoder;

    public List<CaregiverDetailsResponse> getAllCaregivers() {
        List<Caregiver> caregivers = caregiverRepository.findAll();
        return caregivers.stream().map(caregiver -> {
            User user = caregiver.getUser();
            CaregiverDetailsResponse resp = new CaregiverDetailsResponse();
            resp.setCaregiverId(caregiver.getCaregiverId().longValue());
            resp.setUserId(user.getId());
            resp.setFName(user.getFName());
            resp.setLName(user.getLName());
            resp.setEmail(user.getEmail());
            resp.setPhoneNumber(user.getPhoneNumber());
            resp.setCity(user.getCity());
            resp.setState(user.getState());
            resp.setProfilePic(user.getProfilePic());
            resp.setExperience(caregiver.getExperience());
            resp.setQualifications(caregiver.getQualifications());

            // Get skills using the new many-to-many relationship
            List<String> skills = caregiver.getSkills().stream()
                    .map(Skill::getSkillName)
                    .collect(Collectors.toList());
            resp.setSkills(skills);
            return resp;
        }).collect(Collectors.toList());
    }

    @Transactional
    public Caregiver registerCaregiver(User user, Caregiver caregiver, List<String> skillNames) {
        // Hash the password before saving
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        User savedUser = userRepository.save(user);
        caregiver.setUser(savedUser);
        Caregiver savedCaregiver = caregiverRepository.save(caregiver);

        // TODO: Add skills association once caregiver_skills table is created
        // For now, just validate that the skills exist
        for (String skillName : skillNames) {
            skillRepository.findBySkillName(skillName)
                    .orElseThrow(() -> new RuntimeException("Skill not found: " + skillName));
        }

        return savedCaregiver;
    }

    public List<CaregiverResponse> getCaregiversByCity(String city) {
        List<Caregiver> caregivers = caregiverRepository.findByUserCity(city);
        return caregivers.stream()
                .map(CaregiverResponse::new)
                .collect(Collectors.toList());
    }

    // Scheduled job to expire pending requests older than 24 hours
    @Scheduled(cron = "0 0 * * * *") // every hour
    public void expireOldPendingRequests() {
        LocalDateTime cutoff = LocalDateTime.now().minusHours(24);
        List<GuardianPatientCaregiverConnection> expired = connectionRepository.findByStatusAndConnectedDateTimeBefore(
                GuardianPatientCaregiverConnection.ConnectionStatus.PENDING, cutoff);
        for (GuardianPatientCaregiverConnection conn : expired) {
            conn.setStatus(GuardianPatientCaregiverConnection.ConnectionStatus.EXPIRED);
        }
        connectionRepository.saveAll(expired);
    }
}
