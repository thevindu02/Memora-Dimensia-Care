package Memora.DimensiaCareApplication.service;

import Memora.DimensiaCareApplication.model.*;
import Memora.DimensiaCareApplication.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
}
