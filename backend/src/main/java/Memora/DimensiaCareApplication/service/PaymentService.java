package Memora.DimensiaCareApplication.service;

import Memora.DimensiaCareApplication.model.Payment;
import Memora.DimensiaCareApplication.repository.PaymentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.List;
import java.util.Optional;
import java.util.Map;
import java.util.HashMap;

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

    // Revenue Analytics Methods
    
    /**
     * Get total revenue from all successful payments
     */
    public BigDecimal getTotalRevenue() {
        List<Payment> successfulPayments = paymentRepository.findByPaymentStatus(Payment.PaymentStatus.SUCCESS);
        return successfulPayments.stream()
                .map(Payment::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    /**
     * Get revenue for current month
     */
    public BigDecimal getCurrentMonthRevenue() {
        LocalDateTime startOfMonth = LocalDateTime.now().withDayOfMonth(1).withHour(0).withMinute(0).withSecond(0);
        LocalDateTime endOfMonth = startOfMonth.plusMonths(1).minusSeconds(1);
        
        List<Payment> allPayments = paymentRepository.findByPaymentStatus(Payment.PaymentStatus.SUCCESS);
        return allPayments.stream()
                .filter(payment -> payment.getPaymentDate() != null)
                .filter(payment -> payment.getPaymentDate().isAfter(startOfMonth) && 
                                 payment.getPaymentDate().isBefore(endOfMonth))
                .map(Payment::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    /**
     * Get count of active subscriptions (successful payments)
     */
    public long getActiveSubscriptionsCount() {
        return paymentRepository.findByPaymentStatus(Payment.PaymentStatus.SUCCESS).size();
    }

    /**
     * Get monthly revenue for the last 12 months
     */
    public Map<String, BigDecimal> getMonthlyRevenue() {
        Map<String, BigDecimal> monthlyRevenue = new HashMap<>();
        List<Payment> successfulPayments = paymentRepository.findByPaymentStatus(Payment.PaymentStatus.SUCCESS);
        
        for (int i = 11; i >= 0; i--) {
            YearMonth month = YearMonth.now().minusMonths(i);
            String monthKey = month.toString(); // Format: 2025-01
            
            LocalDateTime startOfMonth = month.atDay(1).atStartOfDay();
            LocalDateTime endOfMonth = month.atEndOfMonth().atTime(23, 59, 59);
            
            BigDecimal monthRevenue = successfulPayments.stream()
                    .filter(payment -> payment.getPaymentDate() != null)
                    .filter(payment -> payment.getPaymentDate().isAfter(startOfMonth) && 
                                     payment.getPaymentDate().isBefore(endOfMonth))
                    .map(Payment::getAmount)
                    .reduce(BigDecimal.ZERO, BigDecimal::add);
            
            monthlyRevenue.put(monthKey, monthRevenue);
        }
        
        return monthlyRevenue;
    }

    /**
     * Get all successful payments for transactions list
     */
    public List<Payment> getAllSuccessfulPayments() {
        return paymentRepository.findByPaymentStatus(Payment.PaymentStatus.SUCCESS);
    }

    /**
     * Get revenue analytics summary
     */
    public Map<String, Object> getRevenueAnalytics() {
        Map<String, Object> analytics = new HashMap<>();
        
        BigDecimal totalRevenue = getTotalRevenue();
        BigDecimal currentMonthRevenue = getCurrentMonthRevenue();
        long activeSubscriptions = getActiveSubscriptionsCount();
        Map<String, BigDecimal> monthlyRevenue = getMonthlyRevenue();
        
        analytics.put("totalRevenue", totalRevenue);
        analytics.put("currentMonthRevenue", currentMonthRevenue);
        analytics.put("activeSubscriptions", activeSubscriptions);
        analytics.put("monthlyRevenue", monthlyRevenue);
        
        // Calculate average revenue per month (based on months with revenue > 0)
        long monthsWithRevenue = monthlyRevenue.values().stream()
                .mapToLong(revenue -> revenue.compareTo(BigDecimal.ZERO) > 0 ? 1 : 0)
                .sum();
        
        BigDecimal avgRevenue = BigDecimal.ZERO;
        if (monthsWithRevenue > 0) {
            BigDecimal totalFromMonths = monthlyRevenue.values().stream()
                    .filter(revenue -> revenue.compareTo(BigDecimal.ZERO) > 0)
                    .reduce(BigDecimal.ZERO, BigDecimal::add);
            avgRevenue = totalFromMonths.divide(BigDecimal.valueOf(monthsWithRevenue), 2, RoundingMode.HALF_UP);
        }
        
        analytics.put("averageRevenuePerMonth", avgRevenue);
        
        return analytics;
    }
}
