package Memora.DimensiaCareApplication.service;

import Memora.DimensiaCareApplication.model.Payment;
import Memora.DimensiaCareApplication.repository.PaymentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class PaymentService {

    @Autowired
    private PaymentRepository paymentRepository;

    @Autowired
    private SubscriptionService subscriptionService;

    public Payment createPayment(Long guardianId, Long subscriptionId, BigDecimal amount,
                                String paymentMethod, String cardHolderName, 
                                String cardLastFour, String payhereOrderId) {
        Payment payment = new Payment();
        payment.setGuardianId(guardianId);
        payment.setSubscriptionId(subscriptionId);
        payment.setAmount(amount);
        payment.setPaymentMethod(Payment.PaymentMethod.valueOf(paymentMethod.toUpperCase()));
        payment.setPaymentStatus(Payment.PaymentStatus.PENDING);
        payment.setCardHolderName(cardHolderName);
        payment.setCardLastFour(cardLastFour);
        payment.setPayhereOrderId(payhereOrderId);
        payment.setPaymentDescription("Subscription payment");

        return paymentRepository.save(payment);
    }

    public Payment updatePaymentStatus(Long paymentId, String status, String transactionId) {
        Optional<Payment> optionalPayment = paymentRepository.findById(paymentId);
        if (optionalPayment.isPresent()) {
            Payment payment = optionalPayment.get();
            payment.setPaymentStatus(Payment.PaymentStatus.valueOf(status.toUpperCase()));
            payment.setTransactionId(transactionId);
            payment.setPaymentDate(LocalDateTime.now());

            // If payment successful, activate the subscription
            if (status.equalsIgnoreCase("SUCCESS") && payment.getSubscriptionId() != null) {
                subscriptionService.activateSubscription(payment.getSubscriptionId());
            }

            return paymentRepository.save(payment);
        }
        throw new RuntimeException("Payment not found with id: " + paymentId);
    }

    public Payment updatePaymentStatusByOrderId(String payhereOrderId, String status, String transactionId) {
        Optional<Payment> optionalPayment = paymentRepository.findByPayhereOrderId(payhereOrderId);
        if (optionalPayment.isPresent()) {
            Payment payment = optionalPayment.get();
            payment.setPaymentStatus(Payment.PaymentStatus.valueOf(status.toUpperCase()));
            payment.setTransactionId(transactionId);
            payment.setPaymentDate(LocalDateTime.now());

            // If payment successful, activate the subscription
            if (status.equalsIgnoreCase("SUCCESS") && payment.getSubscriptionId() != null) {
                subscriptionService.activateSubscription(payment.getSubscriptionId());
            }

            return paymentRepository.save(payment);
        }
        throw new RuntimeException("Payment not found with order id: " + payhereOrderId);
    }

    public List<Payment> getPaymentsByGuardian(Long guardianId) {
        return paymentRepository.findByGuardianIdOrderByCreatedAtDesc(guardianId);
    }

    public Optional<Payment> getPaymentById(Long paymentId) {
        return paymentRepository.findById(paymentId);
    }

    public List<Payment> getPaymentsBySubscription(Long subscriptionId) {
        return paymentRepository.findBySubscriptionId(subscriptionId);
    }
}
