package Memora.DimensiaCareApplication.service;

import Memora.DimensiaCareApplication.model.Volunteer;
import Memora.DimensiaCareApplication.model.User;
import Memora.DimensiaCareApplication.dto.response.VolunteerProfileResponse;
import Memora.DimensiaCareApplication.dto.request.VolunteerProfileUpdateRequest;
import Memora.DimensiaCareApplication.repository.VolunteerRepository;
import Memora.DimensiaCareApplication.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class VolunteerService {

    @Autowired
    private VolunteerRepository volunteerRepository;

    @Autowired
    private UserRepository userRepository;

    public VolunteerProfileResponse getVolunteerProfile(Long volunteerId) {
        Volunteer volunteer = volunteerRepository.findById(volunteerId).orElse(null);
        if (volunteer == null) return null;
        User user = userRepository.findById(volunteer.getUserId()).orElse(null);
        if (user == null) return null;

        VolunteerProfileResponse resp = new VolunteerProfileResponse();
        resp.setVolunteerId(volunteer.getVolunteerId());
        resp.setFName(user.getFName());
        resp.setLName(user.getLName());
        resp.setEmail(user.getEmail());
        resp.setPhoneNumber(user.getPhoneNumber());
        resp.setGender(user.getGender());
        resp.setProfilePic(user.getProfilePic());
        // volunteerIdImage removed
        return resp;
    }

    public boolean updateVolunteerProfile(Long volunteerId, VolunteerProfileUpdateRequest updateRequest) {
        Volunteer volunteer = volunteerRepository.findById(volunteerId).orElse(null);
        if (volunteer == null) return false;
        User user = userRepository.findById(volunteer.getUserId()).orElse(null);
        if (user == null) return false;

        user.setFName(updateRequest.getfName() != null ? updateRequest.getfName() : user.getFName());
        user.setLName(updateRequest.getlName() != null ? updateRequest.getlName() : user.getLName());
        user.setEmail(updateRequest.getEmail());
        user.setPhoneNumber(updateRequest.getPhoneNumber());
        user.setGender(updateRequest.getGender());
        user.setProfilePic(updateRequest.getProfilePic());
        // volunteerIdImage removed

        userRepository.save(user);
        volunteerRepository.save(volunteer);
        return true;
    }

    public Long getVolunteerIdByUserId(Long userId) {
        Volunteer volunteer = volunteerRepository.findByUserId(userId).orElse(null);
        if (volunteer != null) {
            return volunteer.getVolunteerId();
        }
        return null;
    }
}
