package Memora.DimensiaCareApplication.controller;

import Memora.DimensiaCareApplication.model.Skill;
import Memora.DimensiaCareApplication.repository.SkillRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/skills")
@CrossOrigin(origins = "*")
public class SkillController {

    @Autowired
    private SkillRepository skillRepository;

    @GetMapping
    public ResponseEntity<List<String>> getAllSkills() {
        List<Skill> skills = skillRepository.findAll();
        List<String> skillNames = skills.stream()
                .map(Skill::getSkillName)
                .collect(java.util.stream.Collectors.toList());
        return ResponseEntity.ok(skillNames);
    }

    @PostMapping("/init")
    public ResponseEntity<String> initializeSkills() {
        String[] defaultSkills = {
                "Elder Care",
                "Companionship",
                "Housekeeping",
                "Medication Management",
                "Meal Preparation",
                "Personal Care",
                "Transportation",
                "Dementia Care",
                "Physical Therapy Assistance",
                "Emotional Support"
        };

        for (String skillName : defaultSkills) {
            // Only add if skill doesn't already exist
            if (skillRepository.findBySkillName(skillName).isEmpty()) {
                Skill skill = new Skill();
                skill.setSkillName(skillName);
                skillRepository.save(skill);
            }
        }

        return ResponseEntity.ok("Skills initialized successfully");
    }

    @PostMapping
    public ResponseEntity<Skill> createSkill(@RequestBody Skill skill) {
        Skill savedSkill = skillRepository.save(skill);
        return ResponseEntity.ok(savedSkill);
    }
}
