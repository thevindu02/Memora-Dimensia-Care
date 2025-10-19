package Memora.DimensiaCareApplication.controller;

import Memora.DimensiaCareApplication.dto.request.CreateSubscriptionRequest;
import Memora.DimensiaCareApplication.model.GuardianSubscription;
import Memora.DimensiaCareApplication.service.SubscriptionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/subscriptions")
public class SubscriptionController {

    @Autowired
    private SubscriptionService subscriptionService;

    @PostMapping
    public ResponseEntity<?> createSubscription(@RequestBody CreateSubscriptionRequest request) {
        try {
            GuardianSubscription subscription = subscriptionService.createSubscription(
                request.getGuardianId(),
                request.getPatientId(),
                request.getPlanType(),
                request.getDurationMonths()
            );
            return ResponseEntity.ok(subscription);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error creating subscription: " + e.getMessage());
        }
    }

    @GetMapping("/guardian/{guardianId}")
    public ResponseEntity<List<GuardianSubscription>> getGuardianSubscriptions(@PathVariable Long guardianId) {
        List<GuardianSubscription> subscriptions = subscriptionService.getSubscriptionsByGuardian(guardianId);
        return ResponseEntity.ok(subscriptions);
    }

    @GetMapping("/active")
    public ResponseEntity<?> getActiveSubscription(
            @RequestParam Long guardianId,
            @RequestParam Long patientId) {
        Optional<GuardianSubscription> subscription = 
            subscriptionService.getActiveSubscriptionForPatient(guardianId, patientId);
        
        if (subscription.isPresent()) {
            return ResponseEntity.ok(subscription.get());
        }
        return ResponseEntity.ok("No active subscription found");
    }

    @PutMapping("/{subscriptionId}/activate")
    public ResponseEntity<?> activateSubscription(@PathVariable Long subscriptionId) {
        try {
            GuardianSubscription subscription = subscriptionService.activateSubscription(subscriptionId);
            return ResponseEntity.ok(subscription);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error activating subscription: " + e.getMessage());
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
