package Memora.DimensiaCareApplication.service;

import Memora.DimensiaCareApplication.dto.response.CaregiverResponse;
import Memora.DimensiaCareApplication.model.Caregiver;
import Memora.DimensiaCareApplication.repository.CaregiverRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class CaregiverService {

    @Autowired
    private CaregiverRepository caregiverRepository;

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