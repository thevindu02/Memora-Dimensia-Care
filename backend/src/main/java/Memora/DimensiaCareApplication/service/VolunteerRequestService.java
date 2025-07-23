package Memora.DimensiaCareApplication.service;

import Memora.DimensiaCareApplication.model.VolunteerRequest;
import Memora.DimensiaCareApplication.model.User;
import Memora.DimensiaCareApplication.model.Volunteer;
import Memora.DimensiaCareApplication.dto.VolunteerRequestCreateDTO;
import Memora.DimensiaCareApplication.repository.VolunteerRequestRepository;

import Memora.DimensiaCareApplication.repository.UserRepository;
import Memora.DimensiaCareApplication.repository.VolunteerRepository;


import Memora.DimensiaCareApplication.service.UserService;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class VolunteerRequestService {

    @Autowired
    private VolunteerRequestRepository volunteerRequestRepository;

    @Autowired


    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private VolunteerRepository volunteerRepository;



    private UserService userService;


    public VolunteerRequest createVolunteerRequest(VolunteerRequestCreateDTO dto) {
        VolunteerRequest volunteerRequest = new VolunteerRequest(
                dto.getVolunteerName(),
                dto.getEmail(),
                dto.getPhoneNumber(),
                dto.getGender(),
                dto.getVolunteerIdImage());
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

            newUser.setPassword(passwordEncoder.encode(password)); // Encrypt password
            
            // Save the user to users table
            User savedUser = userRepository.save(newUser);
            
            // Create volunteer record with user_id and volunteer_id_image
            Volunteer volunteer = new Volunteer(savedUser.getId(), request.getVolunteerIdImage());
            volunteerRepository.save(volunteer);
            

            newUser.setPassword(password); // UserService will encrypt this

            // Set the password - UserService will handle encryption
            newUser.setPassword(password);

            // Create the user using UserService (handles password encryption)
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