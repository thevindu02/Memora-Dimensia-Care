package Memora.DimensiaCareApplication.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import Memora.DimensiaCareApplication.model.User;
import Memora.DimensiaCareApplication.model.VolunteerRequest;
import Memora.DimensiaCareApplication.repository.VolunteerRequestRepository;

@Service
public class VolunteerRequestService {

    @Autowired
    private VolunteerRequestRepository volunteerRequestRepository;

    @Autowired
    private UserService userService;

    public VolunteerRequest createVolunteerRequest(String volunteerName, String email, String phoneNumber, String gender, String volunteerIdImage) {
        VolunteerRequest volunteerRequest = new VolunteerRequest(volunteerName, email, phoneNumber, gender, volunteerIdImage);
        return volunteerRequestRepository.save(volunteerRequest);
    }

    public Optional<VolunteerRequest> findByEmail(String email) {
        return volunteerRequestRepository.findByEmail(email);
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

    @Transactional
    public VolunteerRequest acceptVolunteerRequest(Integer requestId, String password) {
        Optional<VolunteerRequest> optionalRequest = volunteerRequestRepository.findById(requestId);
        if (optionalRequest.isPresent()) {
            VolunteerRequest request = optionalRequest.get();
            
            // Extract first name and last name from volunteer_name
            String[] nameParts = request.getVolunteerName().split(" ", 2);
            String firstName = nameParts[0];
            String lastName = nameParts.length > 1 ? nameParts[1] : "";
            
            // Create new user in users table
            User newUser = new User();
            newUser.setFName(firstName);
            newUser.setLName(lastName);
            newUser.setEmail(request.getEmail());
            newUser.setPhoneNumber(request.getPhoneNumber());
            newUser.setGender(request.getGender());
            newUser.setRole(User.UserRole.VOLUNTEER);
            newUser.setStatus(User.UserStatus.ACTIVE);
            newUser.setPassword(password); // UserService will encrypt this
            
            // Create the user
            userService.createUser(newUser);
            
            // Update request status to accepted
            request.setRequestStatus(VolunteerRequest.RequestStatus.accepted);
            return volunteerRequestRepository.save(request);
        }
        throw new RuntimeException("Volunteer request not found");
    }

    public boolean existsByEmail(String email) {
        return volunteerRequestRepository.existsByEmail(email);
    }
}