package Memora.DimensiaCareApplication.repository;

import Memora.DimensiaCareApplication.model.Payment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PaymentRepository extends JpaRepository<Payment, Long> {
    
    List<Payment> findByGuardianId(Long guardianId);
    
    List<Payment> findBySubscriptionId(Long subscriptionId);
    
    Optional<Payment> findByPayhereOrderId(String payhereOrderId);
    
    Optional<Payment> findByTransactionId(String transactionId);
    
    List<Payment> findByPaymentStatus(Payment.PaymentStatus status);
    
    List<Payment> findByGuardianIdOrderByCreatedAtDesc(Long guardianId);
}
