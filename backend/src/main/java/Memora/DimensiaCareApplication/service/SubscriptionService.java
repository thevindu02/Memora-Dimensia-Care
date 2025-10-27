package Memora.DimensiaCareApplication.service;

import Memora.DimensiaCareApplication.model.GuardianSubscription;
import Memora.DimensiaCareApplication.repository.GuardianSubscriptionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
public class SubscriptionService {

    private static final Logger logger = LoggerFactory.getLogger(SubscriptionService.class);

    @Autowired
    private GuardianSubscriptionRepository subscriptionRepository;

    /**
     * Create a new pending subscription for a patient (before caregiver assignment)
     */
    public GuardianSubscription createPendingSubscription(Long guardianId, Long patientId) {
        GuardianSubscription subscription = new GuardianSubscription();
        subscription.setGuardianId(guardianId);
        subscription.setPatientId(patientId);
        subscription.setStatus(GuardianSubscription.SubscriptionStatus.PENDING);
        subscription.setAutoRenew(false);

        logger.info("Created PENDING subscription for guardian {} and patient {}", guardianId, patientId);
        return subscriptionRepository.save(subscription);
    }

    /**
     * Start the 3-month free trial when caregiver is assigned to patient
     */
    public GuardianSubscription startTrial(Long patientId) {
        List<GuardianSubscription> subscriptions = subscriptionRepository.findByPatientId(patientId);

        if (subscriptions.isEmpty()) {
            throw new RuntimeException("No subscription found for patient: " + patientId);
        }

        GuardianSubscription subscription = subscriptions.get(0); // Should only be one per patient
        LocalDate today = LocalDate.now();

        subscription.setTrialStartDate(today);
        subscription.setTrialEndDate(today.plusMonths(3)); // 3-month free trial
        subscription.setStatus(GuardianSubscription.SubscriptionStatus.TRIAL);

        logger.info("Started 3-month trial for patient {}. Trial ends: {}", patientId, subscription.getTrialEndDate());
        return subscriptionRepository.save(subscription);
    }

    /**
     * Add paid subscription period to patient (can stack with trial)
     */
    public GuardianSubscription addPaidSubscription(Long patientId, Integer durationMonths) {
        List<GuardianSubscription> subscriptions = subscriptionRepository.findByPatientId(patientId);

        if (subscriptions.isEmpty()) {
            throw new RuntimeException("No subscription found for patient: " + patientId);
        }

        GuardianSubscription subscription = subscriptions.get(0);
        LocalDate today = LocalDate.now();

        // Paid period starts after trial ends (or immediately if no trial)
        LocalDate paidStartDate;
        if (subscription.getTrialEndDate() != null && subscription.getTrialEndDate().isAfter(today)) {
            // Trial still active, paid period starts after trial
            paidStartDate = subscription.getTrialEndDate().plusDays(1);
        } else {
            // No active trial, start immediately
            paidStartDate = today;
        }

        subscription.setPaidStartDate(paidStartDate);
        subscription.setPaidEndDate(paidStartDate.plusMonths(durationMonths));
        subscription.setDurationMonths(durationMonths);
        subscription.setStatus(GuardianSubscription.SubscriptionStatus.ACTIVE);

        logger.info("Added paid subscription for patient {}. Duration: {} months. Paid period: {} to {}",
                patientId, durationMonths, paidStartDate, subscription.getPaidEndDate());

        return subscriptionRepository.save(subscription);
    }

    /**
     * Check if patient subscription is currently active (trial or paid)
     */
    public boolean isSubscriptionActive(Long patientId) {
        List<GuardianSubscription> subscriptions = subscriptionRepository.findByPatientId(patientId);

        if (subscriptions.isEmpty()) {
            return false;
        }

        GuardianSubscription sub = subscriptions.get(0);
        LocalDate today = LocalDate.now();

        // Check trial period
        if (sub.getTrialStartDate() != null && sub.getTrialEndDate() != null) {
            if (!today.isBefore(sub.getTrialStartDate()) && !today.isAfter(sub.getTrialEndDate())) {
                return true; // Trial is active
            }
        }

        // Check paid period
        if (sub.getPaidStartDate() != null && sub.getPaidEndDate() != null) {
            if (!today.isBefore(sub.getPaidStartDate()) && !today.isAfter(sub.getPaidEndDate())) {
                return true; // Paid subscription is active
            }
        }

        return false;
    }

    /**
     * Get subscription status for a patient
     */
    public String getSubscriptionStatus(Long patientId) {
        List<GuardianSubscription> subscriptions = subscriptionRepository.findByPatientId(patientId);

        if (subscriptions.isEmpty()) {
            return "NO_SUBSCRIPTION";
        }

        GuardianSubscription sub = subscriptions.get(0);
        LocalDate today = LocalDate.now();

        // Check if in trial period
        if (sub.getTrialStartDate() != null && sub.getTrialEndDate() != null) {
            if (!today.isBefore(sub.getTrialStartDate()) && !today.isAfter(sub.getTrialEndDate())) {
                return "TRIAL";
            }
        }

        // Check if in paid period
        if (sub.getPaidStartDate() != null && sub.getPaidEndDate() != null) {
            if (!today.isBefore(sub.getPaidStartDate()) && !today.isAfter(sub.getPaidEndDate())) {
                return "ACTIVE";
            }
        }

        // Check if subscription has ended
        if ((sub.getTrialEndDate() != null && today.isAfter(sub.getTrialEndDate())) ||
                (sub.getPaidEndDate() != null && today.isAfter(sub.getPaidEndDate()))) {
            return "EXPIRED";
        }

        return sub.getStatus().name();
    }

    /**
     * Get subscription by patient ID
     */
    public Optional<GuardianSubscription> getSubscriptionByPatientId(Long patientId) {
        List<GuardianSubscription> subscriptions = subscriptionRepository.findByPatientId(patientId);
        return subscriptions.isEmpty() ? Optional.empty() : Optional.of(subscriptions.get(0));
    }

    /**
     * Get all subscriptions for a guardian
     */
    public List<GuardianSubscription> getSubscriptionsByGuardian(Long guardianId) {
        return subscriptionRepository.findByGuardianId(guardianId);
    }

    /**
     * Get expired patients for a guardian
     */
    public List<Long> getExpiredPatientIds(Long guardianId) {
        List<GuardianSubscription> subscriptions = subscriptionRepository.findByGuardianId(guardianId);
        LocalDate today = LocalDate.now();

        return subscriptions.stream()
                .filter(sub -> {
                    // Check if both trial and paid periods have expired
                    boolean trialExpired = sub.getTrialEndDate() != null && today.isAfter(sub.getTrialEndDate());
                    boolean paidExpired = sub.getPaidEndDate() == null || today.isAfter(sub.getPaidEndDate());
                    return trialExpired && paidExpired;
                })
                .map(GuardianSubscription::getPatientId)
                .toList();
    }

    /**
     * Cancel subscription
     */
    public GuardianSubscription cancelSubscription(Long subscriptionId) {
        Optional<GuardianSubscription> optionalSub = subscriptionRepository.findById(subscriptionId);
        if (optionalSub.isPresent()) {
            GuardianSubscription subscription = optionalSub.get();
            subscription.setStatus(GuardianSubscription.SubscriptionStatus.CANCELLED);
            logger.info("Cancelled subscription {} for patient {}", subscriptionId, subscription.getPatientId());
            return subscriptionRepository.save(subscription);
        }
        throw new RuntimeException("Subscription not found with id: " + subscriptionId);
    }

    /**
     * Scheduled task to check and update expired subscriptions
     */
    public void checkAndExpireSubscriptions() {
        List<GuardianSubscription> activeSubscriptions = subscriptionRepository
                .findByStatus(GuardianSubscription.SubscriptionStatus.ACTIVE);

        activeSubscriptions.addAll(subscriptionRepository.findByStatus(GuardianSubscription.SubscriptionStatus.TRIAL));

        LocalDate today = LocalDate.now();
        int expiredCount = 0;

        for (GuardianSubscription subscription : activeSubscriptions) {
            boolean shouldExpire = false;

            // Check if trial expired and no paid period
            if (subscription.getTrialEndDate() != null && today.isAfter(subscription.getTrialEndDate()) &&
                    (subscription.getPaidStartDate() == null || subscription.getPaidEndDate() == null)) {
                shouldExpire = true;
            }

            // Check if paid period expired
            if (subscription.getPaidEndDate() != null && today.isAfter(subscription.getPaidEndDate())) {
                shouldExpire = true;
            }

            if (shouldExpire) {
                subscription.setStatus(GuardianSubscription.SubscriptionStatus.EXPIRED);
                subscriptionRepository.save(subscription);
                expiredCount++;
                logger.info("Expired subscription for patient {}", subscription.getPatientId());
            }
        }

        if (expiredCount > 0) {
            logger.info("Expired {} subscriptions", expiredCount);
        }
    }
}
