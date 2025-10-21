package Memora.DimensiaCareApplication.controller;

import Memora.DimensiaCareApplication.dto.request.CreatePaymentRequest;
import Memora.DimensiaCareApplication.model.Payment;
import Memora.DimensiaCareApplication.service.PaymentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/payments")
public class PaymentController {

    @Autowired
    private PaymentService paymentService;

    @PostMapping
    public ResponseEntity<?> createPayment(@RequestBody CreatePaymentRequest request) {
        try {
            Payment payment = paymentService.createPayment(
                request.getGuardianId(),
                request.getSubscriptionId(),
                request.getAmount(),
                request.getPaymentMethod(),
                request.getCardHolderName(),
                request.getCardLastFour(),
                request.getPayhereOrderId()
            );
            return ResponseEntity.ok(payment);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error creating payment: " + e.getMessage());
        }
    }

    @GetMapping("/guardian/{guardianId}")
    public ResponseEntity<List<Payment>> getGuardianPayments(@PathVariable Long guardianId) {
        List<Payment> payments = paymentService.getPaymentsByGuardian(guardianId);
        return ResponseEntity.ok(payments);
    }

    @GetMapping("/{paymentId}")
    public ResponseEntity<?> getPaymentById(@PathVariable Long paymentId) {
        Optional<Payment> payment = paymentService.getPaymentById(paymentId);
        if (payment.isPresent()) {
            return ResponseEntity.ok(payment.get());
        }
        return ResponseEntity.notFound().build();
    }

    @PutMapping("/{paymentId}/status")
    public ResponseEntity<?> updatePaymentStatus(
            @PathVariable Long paymentId,
            @RequestBody Map<String, String> statusUpdate) {
        try {
            String status = statusUpdate.get("status");
            String transactionId = statusUpdate.get("transactionId");
            
            Payment payment = paymentService.updatePaymentStatus(paymentId, status, transactionId);
            return ResponseEntity.ok(payment);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error updating payment status: " + e.getMessage());
        }
    }

    // Webhook endpoint for PayHere callbacks
    @PostMapping("/webhook/payhere")
    public ResponseEntity<?> payhereWebhook(@RequestBody Map<String, String> payload) {
        try {
            String orderId = payload.get("order_id");
            String status = payload.get("status_code"); // 2 = success, -1 = cancelled, 0 = pending
            String transactionId = payload.get("payment_id");

            String paymentStatus;
            if ("2".equals(status)) {
                paymentStatus = "SUCCESS";
            } else if ("-1".equals(status) || "-2".equals(status)) {
                paymentStatus = "FAILED";
            } else if ("0".equals(status)) {
                paymentStatus = "PENDING";
            } else {
                paymentStatus = "FAILED";
            }

            Payment payment = paymentService.updatePaymentStatusByOrderId(
                orderId, paymentStatus, transactionId
            );
            
            return ResponseEntity.ok(payment);
        } catch (Exception e) {
            System.err.println("PayHere webhook error: " + e.getMessage());
            return ResponseEntity.badRequest().body("Webhook processing error: " + e.getMessage());
        }
    }

    // Revenue Analytics Endpoints
    
    @GetMapping("/analytics/revenue")
    public ResponseEntity<?> getRevenueAnalytics() {
        try {
            Map<String, Object> analytics = paymentService.getRevenueAnalytics();
            return ResponseEntity.ok(analytics);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error fetching revenue analytics: " + e.getMessage());
        }
    }

    @GetMapping("/analytics/transactions")
    public ResponseEntity<List<Payment>> getAllTransactions() {
        try {
            List<Payment> transactions = paymentService.getAllSuccessfulPayments();
            return ResponseEntity.ok(transactions);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }
}
