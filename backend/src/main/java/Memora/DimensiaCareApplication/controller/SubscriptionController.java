package Memora.DimensiaCareApplication.controller;

import Memora.DimensiaCareApplication.dto.request.CreateSubscriptionRequest;
import Memora.DimensiaCareApplication.model.GuardianSubscription;
import Memora.DimensiaCareApplication.service.SubscriptionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/subscriptions")
@CrossOrigin(origins = "*")
public class SubscriptionController {

    @Autowired
    private SubscriptionService subscriptionService;

    /**
     * Get subscription status for a specific patient
     * Returns: status (TRIAL/ACTIVE/EXPIRED/PENDING), isActive (boolean),
     * trial/paid dates
     */
    @GetMapping("/patient/{patientId}/status")
    public ResponseEntity<Map<String, Object>> getPatientSubscriptionStatus(@PathVariable Long patientId) {
        try {
            String status = subscriptionService.getSubscriptionStatus(patientId);
            boolean isActive = subscriptionService.isSubscriptionActive(patientId);

            Optional<GuardianSubscription> subscription = subscriptionService.getSubscriptionByPatientId(patientId);

            Map<String, Object> response = new HashMap<>();
            response.put("patientId", patientId);
            response.put("status", status);
            response.put("isActive", isActive);

            if (subscription.isPresent()) {
                GuardianSubscription sub = subscription.get();
                response.put("trialStartDate", sub.getTrialStartDate());
                response.put("trialEndDate", sub.getTrialEndDate());
                response.put("paidStartDate", sub.getPaidStartDate());
                response.put("paidEndDate", sub.getPaidEndDate());
                response.put("durationMonths", sub.getDurationMonths());
            }

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(errorResponse);
        }
    }

    /**
     * Get all expired patients for a guardian
     */
    @GetMapping("/guardian/{guardianId}/expired-patients")
    public ResponseEntity<Map<String, Object>> getExpiredPatients(@PathVariable Long guardianId) {
        try {
            List<Long> expiredPatientIds = subscriptionService.getExpiredPatientIds(guardianId);

            Map<String, Object> response = new HashMap<>();
            response.put("guardianId", guardianId);
            response.put("expiredPatientIds", expiredPatientIds);
            response.put("count", expiredPatientIds.size());

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("error", e.getMessage());
            return ResponseEntity.badRequest().body(errorResponse);
        }
    }

    /**
     * Get subscription details by patient ID
     */
    @GetMapping("/patient/{patientId}")
    public ResponseEntity<?> getSubscriptionByPatient(@PathVariable Long patientId) {
        try {
            Optional<GuardianSubscription> subscription = subscriptionService.getSubscriptionByPatientId(patientId);
            if (subscription.isPresent()) {
                return ResponseEntity.ok(subscription.get());
            }
            return ResponseEntity.ok("No subscription found for patient");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error: " + e.getMessage());
        }
    }

    @GetMapping("/guardian/{guardianId}")
    public ResponseEntity<List<GuardianSubscription>> getGuardianSubscriptions(@PathVariable Long guardianId) {
        List<GuardianSubscription> subscriptions = subscriptionService.getSubscriptionsByGuardian(guardianId);
        return ResponseEntity.ok(subscriptions);
    }

    @PostMapping
    public ResponseEntity<?> createSubscription(@RequestBody CreateSubscriptionRequest request) {
        try {
            // Create pending subscription (old flow - may be deprecated)
            GuardianSubscription subscription = subscriptionService.createPendingSubscription(
                    request.getGuardianId(),
                    request.getPatientId());
            return ResponseEntity.ok(subscription);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error creating subscription: " + e.getMessage());
        }
    }

    @PutMapping("/{subscriptionId}/cancel")
    public ResponseEntity<?> cancelSubscription(@PathVariable Long subscriptionId) {
        try {
            GuardianSubscription subscription = subscriptionService.cancelSubscription(subscriptionId);
            return ResponseEntity.ok(subscription);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error cancelling subscription: " + e.getMessage());
        }
    }
}
