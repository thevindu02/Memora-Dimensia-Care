package Memora.DimensiaCareApplication.controller;

import Memora.DimensiaCareApplication.model.VolunteerRequest;
import Memora.DimensiaCareApplication.dto.VolunteerRequestWithUserDTO;
import Memora.DimensiaCareApplication.service.VolunteerRequestService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/volunteer-requests")
public class VolunteerRequestController {

    @Autowired
    private VolunteerRequestService volunteerRequestService;

    @PostMapping
    public ResponseEntity<?> createVolunteerRequest(@RequestBody Map<String, Object> request) {
        try {
            Long userId = Long.parseLong(request.get("userId").toString());
            String volunteerIdImage = request.get("volunteerIdImage").toString();
            
            VolunteerRequest volunteerRequest = volunteerRequestService.createVolunteerRequest(userId, volunteerIdImage);
            return ResponseEntity.ok(volunteerRequest);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error creating volunteer request: " + e.getMessage());
        }
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<?> getVolunteerRequestByUserId(@PathVariable Long userId) {
        return volunteerRequestService.findByUserId(userId)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/status/{status}")
    public ResponseEntity<List<VolunteerRequest>> getVolunteerRequestsByStatus(@PathVariable String status) {
        try {
            VolunteerRequest.RequestStatus requestStatus = VolunteerRequest.RequestStatus.valueOf(status.toLowerCase());
            List<VolunteerRequest> requests = volunteerRequestService.findByStatus(requestStatus);
            return ResponseEntity.ok(requests);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().build();
        }
    }

    @GetMapping
    public ResponseEntity<List<VolunteerRequest>> getAllVolunteerRequests() {
        List<VolunteerRequest> requests = volunteerRequestService.getAllVolunteerRequests();
        return ResponseEntity.ok(requests);
    }

    // New endpoint to get volunteer requests with user data
    @GetMapping("/with-user-data")
    public ResponseEntity<List<VolunteerRequestWithUserDTO>> getAllVolunteerRequestsWithUserData() {
        List<VolunteerRequestWithUserDTO> requests = volunteerRequestService.getAllVolunteerRequestsWithUserData();
        return ResponseEntity.ok(requests);
    }

    // New endpoint to get volunteer requests with user data by status
    @GetMapping("/with-user-data/status/{status}")
    public ResponseEntity<List<VolunteerRequestWithUserDTO>> getVolunteerRequestsWithUserDataByStatus(@PathVariable String status) {
        try {
            VolunteerRequest.RequestStatus requestStatus = VolunteerRequest.RequestStatus.valueOf(status.toLowerCase());
            List<VolunteerRequestWithUserDTO> requests = volunteerRequestService.getVolunteerRequestsWithUserDataByStatus(requestStatus);
            return ResponseEntity.ok(requests);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().build();
        }
    }

    @PutMapping("/{requestId}/status")
    public ResponseEntity<?> updateRequestStatus(
            @PathVariable Integer requestId,
            @RequestBody Map<String, String> request) {
        try {
            String status = request.get("status");
            
            VolunteerRequest.RequestStatus requestStatus = VolunteerRequest.RequestStatus.valueOf(status.toLowerCase());
            VolunteerRequest updatedRequest = volunteerRequestService.updateRequestStatus(requestId, requestStatus);
            
            if (updatedRequest != null) {
                return ResponseEntity.ok(updatedRequest);
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error updating request status: " + e.getMessage());
        }
    }
}