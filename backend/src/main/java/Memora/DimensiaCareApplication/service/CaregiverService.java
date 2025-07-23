package Memora.DimensiaCareApplication.service;

import Memora.DimensiaCareApplication.dto.response.CaregiverDetailsResponse;
import Memora.DimensiaCareApplication.model.User;
import Memora.DimensiaCareApplication.model.Caregiver;
import Memora.DimensiaCareApplication.model.Skill;
import Memora.DimensiaCareApplication.model.GuardianPatientCaregiverConnection;
import Memora.DimensiaCareApplication.repository.UserRepository;
import Memora.DimensiaCareApplication.repository.CaregiverRepository;
import Memora.DimensiaCareApplication.repository.SkillRepository;
import Memora.DimensiaCareApplication.repository.CaregiverSkillRepository;
import Memora.DimensiaCareApplication.repository.GuardianPatientCaregiverConnectionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
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
    private CaregiverSkillRepository caregiverSkillRepository;
    @Autowired
    private SkillRepository skillRepository;
    @Autowired
    private GuardianPatientCaregiverConnectionRepository connectionRepository;

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
            List<String> skills = caregiverSkillRepository.findByCaregiverId(caregiver.getCaregiverId())
                .stream()
                .map(cs -> skillRepository.findById(cs.getSkillId()).map(Skill::getSkillName).orElse(""))
                .collect(Collectors.toList());
            resp.setSkills(skills);
            return resp;
        }).collect(Collectors.toList());
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