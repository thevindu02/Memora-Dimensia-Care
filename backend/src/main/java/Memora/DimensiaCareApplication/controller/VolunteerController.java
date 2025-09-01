package Memora.DimensiaCareApplication.controller;

import Memora.DimensiaCareApplication.dto.response.VolunteerProfileResponse;
import Memora.DimensiaCareApplication.service.VolunteerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/volunteers")
public class VolunteerController {
    @Autowired
    private VolunteerService volunteerService;

    @GetMapping("/{volunteerId}/profile")
    public ResponseEntity<VolunteerProfileResponse> getVolunteerProfile(@PathVariable Long volunteerId) {
        VolunteerProfileResponse resp = volunteerService.getVolunteerProfile(volunteerId);
        if (resp == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(resp);
    }
}
