package Memora.DimensiaCareApplication.controller;


import Memora.DimensiaCareApplication.model.VolunteerRequest;
import Memora.DimensiaCareApplication.dto.VolunteerRequestWithUserDTO;
import Memora.DimensiaCareApplication.dto.VolunteerRequestCreateDTO;
import Memora.DimensiaCareApplication.service.VolunteerRequestService;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import Memora.DimensiaCareApplication.model.VolunteerRequest;
import Memora.DimensiaCareApplication.service.VolunteerRequestService;

@RestController
@RequestMapping("/api/volunteer-requests")
public class VolunteerRequestController {

    @Autowired
    private VolunteerRequestService volunteerRequestService;

    @PostMapping
    public ResponseEntity<?> createVolunteerRequest(@RequestBody VolunteerRequestCreateDTO request) {
        try {

            // Validate required fields
            if (request.getVolunteerName() == null || request.getVolunteerName().trim().isEmpty() ||
                request.getEmail() == null || request.getEmail().trim().isEmpty() ||
                request.getPhoneNumber() == null || request.getPhoneNumber().trim().isEmpty() ||
                request.getGender() == null || request.getGender().trim().isEmpty() ||
                request.getVolunteerIdImage() == null || request.getVolunteerIdImage().trim().isEmpty()) {
                return ResponseEntity.badRequest().body("All fields are required.");
            }
            VolunteerRequest volunteerRequest = volunteerRequestService.createVolunteerRequest(request);

            return ResponseEntity.ok(volunteerRequest);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error creating volunteer request: " + e.getMessage());
        }
    }


    @GetMapping("/email/{email}")
    public ResponseEntity<?> getVolunteerRequestByEmail(@PathVariable String email) {
        return volunteerRequestService.findByEmail(email)
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


    // Simple endpoint to get all volunteer requests (same as above, for compatibility)
    @GetMapping("/with-user-data")
    public ResponseEntity<List<VolunteerRequest>> getAllVolunteerRequestsWithUserData() {
        List<VolunteerRequest> requests = volunteerRequestService.getAllVolunteerRequests();
        return ResponseEntity.ok(requests);
    }

    // Simple endpoint to get volunteer requests by status (for compatibility)
    @GetMapping("/with-user-data/status/{status}")
    public ResponseEntity<List<VolunteerRequest>> getVolunteerRequestsWithUserDataByStatus(@PathVariable String status) {
        try {
            VolunteerRequest.RequestStatus requestStatus = VolunteerRequest.RequestStatus.valueOf(status.toLowerCase());
            List<VolunteerRequest> requests = volunteerRequestService.findByStatus(requestStatus);
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

    @PutMapping("/{requestId}/accept")
    public ResponseEntity<?> acceptVolunteerRequest(
            @PathVariable Integer requestId,
            @RequestBody Map<String, String> request) {
        try {
            String password = request.get("password");
            
            if (password == null || password.trim().isEmpty()) {
                return ResponseEntity.badRequest().body("Password is required");
            }
            
            VolunteerRequest updatedRequest = volunteerRequestService.acceptVolunteerRequest(requestId, password);
            return ResponseEntity.ok(updatedRequest);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error accepting volunteer request: " + e.getMessage());
        }
    }

    @PutMapping("/{requestId}/reject")
    public ResponseEntity<?> rejectVolunteerRequest(@PathVariable Integer requestId) {
        try {
            VolunteerRequest updatedRequest = volunteerRequestService.updateRequestStatus(requestId, VolunteerRequest.RequestStatus.rejected);
            if (updatedRequest != null) {
                return ResponseEntity.ok(updatedRequest);
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error rejecting volunteer request: " + e.getMessage());
        }
    }
}