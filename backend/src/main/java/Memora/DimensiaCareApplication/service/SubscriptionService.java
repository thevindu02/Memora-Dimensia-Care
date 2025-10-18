package Memora.DimensiaCareApplication.service;

import Memora.DimensiaCareApplication.model.GuardianSubscription;
import Memora.DimensiaCareApplication.repository.GuardianSubscriptionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
public class SubscriptionService {

    @Autowired
    private GuardianSubscriptionRepository subscriptionRepository;

    public GuardianSubscription createSubscription(Long guardianId, Long patientId, 
                                                   String planType, Integer durationMonths) {
        GuardianSubscription subscription = new GuardianSubscription();
        subscription.setGuardianId(guardianId);
        subscription.setPatientId(patientId);
        subscription.setPlanType(GuardianSubscription.PlanType.valueOf(planType.toUpperCase()));
        subscription.setDurationMonths(durationMonths);
        subscription.setStartDate(LocalDate.now());
        subscription.setEndDate(LocalDate.now().plusMonths(durationMonths));
        subscription.setStatus(GuardianSubscription.SubscriptionStatus.PENDING);
        subscription.setAutoRenew(false);

        return subscriptionRepository.save(subscription);
    }

    public GuardianSubscription activateSubscription(Long subscriptionId) {
        Optional<GuardianSubscription> optionalSub = subscriptionRepository.findById(subscriptionId);
        if (optionalSub.isPresent()) {
            GuardianSubscription subscription = optionalSub.get();
            subscription.setStatus(GuardianSubscription.SubscriptionStatus.ACTIVE);
            return subscriptionRepository.save(subscription);
        }
        throw new RuntimeException("Subscription not found with id: " + subscriptionId);
    }

    public List<GuardianSubscription> getSubscriptionsByGuardian(Long guardianId) {
        return subscriptionRepository.findByGuardianId(guardianId);
    }

    public Optional<GuardianSubscription> getActiveSubscriptionForPatient(Long guardianId, Long patientId) {
        return subscriptionRepository.findByGuardianIdAndPatientIdAndStatus(
            guardianId, patientId, GuardianSubscription.SubscriptionStatus.ACTIVE
        );
    }

    public GuardianSubscription cancelSubscription(Long subscriptionId) {
        Optional<GuardianSubscription> optionalSub = subscriptionRepository.findById(subscriptionId);
        if (optionalSub.isPresent()) {
            GuardianSubscription subscription = optionalSub.get();
            subscription.setStatus(GuardianSubscription.SubscriptionStatus.CANCELLED);
            return subscriptionRepository.save(subscription);
        }
        throw new RuntimeException("Subscription not found with id: " + subscriptionId);
    }

    public void checkAndExpireSubscriptions() {
        List<GuardianSubscription> activeSubscriptions = 
            subscriptionRepository.findByStatus(GuardianSubscription.SubscriptionStatus.ACTIVE);
        
        LocalDate today = LocalDate.now();
        for (GuardianSubscription subscription : activeSubscriptions) {
            if (subscription.getEndDate().isBefore(today)) {
                subscription.setStatus(GuardianSubscription.SubscriptionStatus.EXPIRED);
                subscriptionRepository.save(subscription);
            }
        }
    }
}
