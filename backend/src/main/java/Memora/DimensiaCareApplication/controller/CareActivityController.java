package Memora.DimensiaCareApplication.controller;

import Memora.DimensiaCareApplication.model.CareActivity;
import Memora.DimensiaCareApplication.model.CareActivityStatus;
import Memora.DimensiaCareApplication.service.CareActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/care-activities")
@CrossOrigin(origins = "*")
public class CareActivityController {

    @Autowired
    private CareActivityService careActivityService;

    /**
     * Update the status of a care activity
     * 
     * @param careActivityId The ID of the care activity
     * @param requestBody    Map containing the new status and optional skipReason
     * @return Response with updated care activity information
     */
    @PutMapping("/{careActivityId}/status")
    public ResponseEntity<Map<String, Object>> updateCareActivityStatus(
            @PathVariable Long careActivityId,
            @RequestBody Map<String, String> requestBody) {

        Map<String, Object> response = new HashMap<>();

        try {
            // Extract status from request body
            String statusString = requestBody.get("status");
            if (statusString == null || statusString.trim().isEmpty()) {
                response.put("success", false);
                response.put("message", "Status is required");
                return ResponseEntity.badRequest().body(response);
            }

            // Parse status
            CareActivityStatus newStatus;
            try {
                newStatus = CareActivityStatus.valueOf(statusString.toUpperCase());
            } catch (IllegalArgumentException e) {
                response.put("success", false);
                response.put("message", "Invalid status value: " + statusString);
                return ResponseEntity.badRequest().body(response);
            }

            // Extract optional skip reason from request body
            String skipReason = requestBody.get("skipReason");

            // Update the status (with or without skip reason)
            CareActivity updatedCareActivity;
            if (skipReason != null && !skipReason.trim().isEmpty()) {
                updatedCareActivity = careActivityService.updateStatusWithReason(careActivityId, newStatus, skipReason);
            } else {
                updatedCareActivity = careActivityService.updateStatusWithReason(careActivityId, newStatus, null);
            }

            // Build success response
            response.put("success", true);
            response.put("message", "Care activity status updated successfully");

            Map<String, Object> data = new HashMap<>();
            data.put("careActivityId", updatedCareActivity.getCareActivityId());
            data.put("status", updatedCareActivity.getStatus().toString());
            data.put("skipReason", updatedCareActivity.getSkipReason());
            data.put("time", updatedCareActivity.getTime() != null ? updatedCareActivity.getTime().toString() : null);

            response.put("data", data);

            return ResponseEntity.ok(response);

        } catch (RuntimeException e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "An error occurred while updating care activity status");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * Move a care activity to a different schedule
     * 
     * @param careActivityId The ID of the care activity to move
     * @param requestBody    Map containing the new scheduleId
     * @return Response with updated care activity information
     */
    @PutMapping("/{careActivityId}/schedule")
    public ResponseEntity<Map<String, Object>> moveCareActivityToSchedule(
            @PathVariable Long careActivityId,
            @RequestBody Map<String, Long> requestBody) {

        Map<String, Object> response = new HashMap<>();

        try {
            // Extract scheduleId from request body
            Long newScheduleId = requestBody.get("scheduleId");
            if (newScheduleId == null) {
                response.put("success", false);
                response.put("message", "Schedule ID is required");
                return ResponseEntity.badRequest().body(response);
            }

            // Move the care activity to the new schedule
            CareActivity updatedCareActivity = careActivityService.moveCareActivityToSchedule(careActivityId,
                    newScheduleId);

            // Build success response
            response.put("success", true);
            response.put("message", "Care activity moved to new schedule successfully");

            Map<String, Object> data = new HashMap<>();
            data.put("careActivityId", updatedCareActivity.getCareActivityId());
            data.put("scheduleId", updatedCareActivity.getSchedule().getScheduleId());
            data.put("status", updatedCareActivity.getStatus().toString());
            data.put("time", updatedCareActivity.getTime() != null ? updatedCareActivity.getTime().toString() : null);

            response.put("data", data);

            return ResponseEntity.ok(response);

        } catch (RuntimeException e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "An error occurred while moving care activity");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }
}
