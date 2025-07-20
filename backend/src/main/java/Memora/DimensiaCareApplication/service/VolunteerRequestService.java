package Memora.DimensiaCareApplication.service;

import Memora.DimensiaCareApplication.model.VolunteerRequest;
import Memora.DimensiaCareApplication.repository.VolunteerRequestRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class VolunteerRequestService {

    @Autowired
    private VolunteerRequestRepository volunteerRequestRepository;

    public VolunteerRequest createVolunteerRequest(Long userId, String volunteerIdImage) {
        VolunteerRequest volunteerRequest = new VolunteerRequest(userId, volunteerIdImage);
        return volunteerRequestRepository.save(volunteerRequest);
    }

    public Optional<VolunteerRequest> findByUserId(Long userId) {
        return volunteerRequestRepository.findByUserId(userId);
    }

    public List<VolunteerRequest> findByStatus(VolunteerRequest.RequestStatus status) {
        return volunteerRequestRepository.findByRequestStatus(status);
    }

    public List<VolunteerRequest> getAllVolunteerRequests() {
        return volunteerRequestRepository.findAll();
    }

    public VolunteerRequest updateRequestStatus(Integer requestId, VolunteerRequest.RequestStatus status) {
        Optional<VolunteerRequest> optionalRequest = volunteerRequestRepository.findById(requestId);
        if (optionalRequest.isPresent()) {
            VolunteerRequest request = optionalRequest.get();
            request.setRequestStatus(status);
            return volunteerRequestRepository.save(request);
        }
        return null;
    }

    public boolean existsByUserId(Long userId) {
        return volunteerRequestRepository.existsByUserId(userId);
    }
} 