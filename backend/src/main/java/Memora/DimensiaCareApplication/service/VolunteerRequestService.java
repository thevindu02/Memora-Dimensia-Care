package Memora.DimensiaCareApplication.service;

import Memora.DimensiaCareApplication.model.VolunteerRequest;
import Memora.DimensiaCareApplication.dto.VolunteerRequestWithUserDTO;
import Memora.DimensiaCareApplication.dto.VolunteerRequestCreateDTO;
import Memora.DimensiaCareApplication.repository.VolunteerRequestRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class VolunteerRequestService {

    @Autowired
    private VolunteerRequestRepository volunteerRequestRepository;

    public VolunteerRequest createVolunteerRequest(VolunteerRequestCreateDTO dto) {
        VolunteerRequest volunteerRequest = new VolunteerRequest(
            dto.getVolunteerName(),
            dto.getEmail(),
            dto.getPhoneNumber(),
            dto.getGender(),
            dto.getVolunteerIdImage()
        );
        return volunteerRequestRepository.save(volunteerRequest);
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
}