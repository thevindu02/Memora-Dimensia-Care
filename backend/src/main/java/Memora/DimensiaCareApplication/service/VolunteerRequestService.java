package Memora.DimensiaCareApplication.service;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import Memora.DimensiaCareApplication.dto.CombinedVolunteerDTO;
import Memora.DimensiaCareApplication.dto.VolunteerRequestCreateDTO;
import Memora.DimensiaCareApplication.model.User;
import Memora.DimensiaCareApplication.model.Volunteer;
import Memora.DimensiaCareApplication.model.VolunteerRequest;
import Memora.DimensiaCareApplication.repository.UserRepository;
import Memora.DimensiaCareApplication.repository.VolunteerRepository;
import Memora.DimensiaCareApplication.repository.VolunteerRequestRepository;

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
    public boolean rejectVolunteerRequest(Integer requestId) {
        Optional<VolunteerRequest> optionalRequest = volunteerRequestRepository.findById(requestId);
        if (optionalRequest.isPresent()) {
            // Delete the request from database (as per requirement)
            volunteerRequestRepository.deleteById(requestId);
            return true;
        }
        return false;
    }

    @Transactional
    public boolean updateVolunteerStatus(Long volunteerId, User.UserStatus status) {
        Optional<Volunteer> volunteerOpt = volunteerRepository.findById(volunteerId);
        if (volunteerOpt.isPresent()) {
            Volunteer volunteer = volunteerOpt.get();
            Optional<User> userOpt = userRepository.findById(volunteer.getUserId());
            if (userOpt.isPresent()) {
                User user = userOpt.get();
                user.setStatus(status);
                userRepository.save(user);
                return true;
            }
        }
        return false;
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

            // Delete the request from volunteer_request table (it's now a volunteer)
            volunteerRequestRepository.deleteById(requestId);

            return request; // Return the original request for confirmation
        }
        throw new RuntimeException("Volunteer request not found");
    }

    public boolean existsByEmail(String email) {
        return volunteerRequestRepository.existsByEmail(email);
    }

    public List<CombinedVolunteerDTO> getAllVolunteersAndRequests() {
        List<CombinedVolunteerDTO> combinedList = new ArrayList<>();

        // Get only PENDING volunteer requests (rejected ones are deleted, accepted ones become volunteers)
        List<VolunteerRequest> requests = volunteerRequestRepository.findByRequestStatus(VolunteerRequest.RequestStatus.pending);
        for (VolunteerRequest request : requests) {
            CombinedVolunteerDTO dto = new CombinedVolunteerDTO(
                    request.getRequestId(),
                    request.getVolunteerName(),
                    request.getEmail(),
                    request.getPhoneNumber(),
                    request.getGender(),
                    request.getRequestStatus(),
                    request.getVolunteerIdImage(),
                    request.getCreatedAt()
            );
            combinedList.add(dto);
        }

        // Get all volunteers (accepted) with their user data
        List<Volunteer> volunteers = volunteerRepository.findAll();
        for (Volunteer volunteer : volunteers) {
            // Get user data for this volunteer
            Optional<User> userOpt = userRepository.findById(volunteer.getUserId());
            if (userOpt.isPresent()) {
                User user = userOpt.get();
                CombinedVolunteerDTO dto = new CombinedVolunteerDTO(
                        volunteer.getVolunteerId(),
                        volunteer.getUserId(),
                        volunteer.getVolunteerIdImage(),
                        user.getFName(),
                        user.getLName(),
                        user.getEmail(),
                        user.getPhoneNumber(),
                        user.getBirthdate(),
                        user.getCity(),
                        user.getState(),
                        user.getGender(),
                        user.getProfilePic(),
                        user.getStatus(),
                        user.getCreatedAt()
                );
                combinedList.add(dto);
            }
        }

        // Sort by priority: 1=pending/inactive (top), 2=active, 3=disabled/suspended (bottom)
        combinedList.sort(Comparator.comparingInt(CombinedVolunteerDTO::getSortPriority)
                .thenComparing(dto -> dto.getCreatedAt() != null ? dto.getCreatedAt() : java.time.LocalDateTime.MIN));

        return combinedList;
    }

}
