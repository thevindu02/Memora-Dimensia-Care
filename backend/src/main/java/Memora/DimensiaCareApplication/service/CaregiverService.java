package Memora.DimensiaCareApplication.service;

import Memora.DimensiaCareApplication.model.*;
import Memora.DimensiaCareApplication.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import Memora.DimensiaCareApplication.dto.response.CaregiverResponse;
import Memora.DimensiaCareApplication.model.Caregiver;
import Memora.DimensiaCareApplication.repository.CaregiverRepository;
import java.util.stream.Collectors;
import java.util.List;

@Service
public class CaregiverService {
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private CaregiverRepository caregiverRepository;
    @Autowired
    private CaregiverSkillRepository caregiverSkillRepository;
    @Autowired
    private PasswordEncoder passwordEncoder;
    @Autowired
    private SkillRepository skillRepository;

    @Transactional
    public Caregiver registerCaregiver(User user, Caregiver caregiver, List<String> skillNames) {
        // Hash the password before saving
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        User savedUser = userRepository.save(user);
        caregiver.setUser(savedUser);
        Caregiver savedCaregiver = caregiverRepository.save(caregiver);

        for (String skillName : skillNames) {
            Skill skill = skillRepository.findBySkillName(skillName)
                    .orElseThrow(() -> new RuntimeException("Skill not found: " + skillName));
            CaregiverSkill caregiverSkill = new CaregiverSkill();
            caregiverSkill.setCaregiver(savedCaregiver);
            caregiverSkill.setSkill(skill);
            caregiverSkillRepository.save(caregiverSkill);
        }
        return savedCaregiver;
    }

    public List<CaregiverResponse> getCaregiversByCity(String city) {
        List<Caregiver> caregivers = caregiverRepository.findByUserCity(city);
        return caregivers.stream()
                .map(CaregiverResponse::new)
                .collect(Collectors.toList());
    }

    public List<CaregiverResponse> getAllActiveCaregivers() {
        List<Caregiver> caregivers = caregiverRepository.findAllActiveCaregivers();
        return caregivers.stream()
                .map(CaregiverResponse::new)
                .collect(Collectors.toList());
    }

    public CaregiverResponse getCaregiverById(Integer caregiverId) {
        Caregiver caregiver = caregiverRepository.findById(caregiverId)
                .orElseThrow(() -> new RuntimeException("Caregiver not found with id: " + caregiverId));
        return new CaregiverResponse(caregiver);
    }

    public CaregiverResponse getCaregiverByUserId(Long userId) {
        Caregiver caregiver = caregiverRepository.findByUserId(userId);
        if (caregiver == null) {
            throw new RuntimeException("Caregiver not found with user id: " + userId);
        }
        return new CaregiverResponse(caregiver);
    }
}
