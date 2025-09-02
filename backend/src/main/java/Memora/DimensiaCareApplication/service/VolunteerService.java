package Memora.DimensiaCareApplication.service;

import Memora.DimensiaCareApplication.model.Volunteer;
import Memora.DimensiaCareApplication.model.User;
import Memora.DimensiaCareApplication.repository.VolunteerRepository;
import Memora.DimensiaCareApplication.repository.UserRepository;
import Memora.DimensiaCareApplication.dto.response.VolunteerProfileResponse;
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
        resp.setVolunteerIdImage(volunteer.getVolunteerIdImage()); // <-- THIS IS IMPORTANT
        return resp;
    }
}
