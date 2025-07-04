package Memora.DimensiaCareApplication.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.Map;

@Service
public class ResendEmailService {

    @Value("${resend.api.key}")
    private String apiKey;

    @Value("${resend.from.email}")
    private String fromEmail;

    @Value("${resend.from.name}")
    private String fromName;

    private final RestTemplate restTemplate = new RestTemplate();
    private final ObjectMapper objectMapper = new ObjectMapper();

    public boolean sendEmail(String toEmail, String subject, String htmlContent) {
        return sendEmail(toEmail, null, subject, htmlContent);
    }

    public boolean sendEmail(String toEmail, String toName, String subject, String htmlContent) {
        try {
            // Prepare the request body for Resend API
            Map<String, Object> requestBody = new HashMap<>();
            String from;
            if (fromName != null && !fromName.trim().isEmpty()) {
                from = fromEmail;
            } else {
                from = fromEmail;
            }
            requestBody.put("from", from);
            requestBody.put("to", toEmail);
            requestBody.put("subject", subject);
            requestBody.put("html", htmlContent);

            // Set headers
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.set("Authorization", "Bearer " + apiKey);

            // Create HTTP entity
            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);

            // Make the API call to Resend
            ResponseEntity<String> response = restTemplate.exchange(
                    "https://api.resend.com/emails",
                    HttpMethod.POST,
                    entity,
                    String.class);

            // Resend returns 200 for successful email sending
            return response.getStatusCode() == HttpStatus.OK;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean sendPasswordResetEmail(String toEmail, String resetToken) {
        String subject = "Password Reset Request";
        String htmlContent = buildPasswordResetEmailContent(resetToken);
        return sendEmail(toEmail, subject, htmlContent);
    }

    public boolean sendWelcomeEmail(String toEmail, String firstName) {
        String subject = "Welcome to Memora DimensiaCare!";
        String htmlContent = buildWelcomeEmailContent(firstName);
        return sendEmail(toEmail, subject, htmlContent);
    }

    public boolean sendVerificationEmail(String toEmail, String verificationToken) {
        String subject = "Verify Your Email Address";
        String htmlContent = buildVerificationEmailContent(verificationToken);
        return sendEmail(toEmail, subject, htmlContent);
    }

    private String buildPasswordResetEmailContent(String resetToken) {
        return "<!DOCTYPE html>" +
                "<html>" +
                "<head><meta charset='UTF-8'><title>Password Reset</title></head>" +
                "<body style='font-family: Arial, sans-serif; line-height: 1.6; color: #333;'>" +
                "<div style='max-width: 600px; margin: 0 auto; padding: 20px;'>" +
                "<h2 style='color: #2c3e50;'>Password Reset Request</h2>" +
                "<p>You have requested to reset your password. Please click the button below to reset your password:</p>"
                +
                "<div style='text-align: center; margin: 30px 0;'>" +
                "<a href='memora://reset-password?token=" + resetToken + "' " +
                "style='background-color: #3498db; color: white; padding: 12px 24px; text-decoration: none; border-radius: 5px; display: inline-block;'>"
                +
                "Reset Password</a>" +
                "</div>" +
                "<p>If you did not request this password reset, please ignore this email.</p>" +
                "<p>This link will expire in 24 hours.</p>" +
                "<hr style='border: 1px solid #eee; margin: 30px 0;'>" +
                "<p style='color: #666; font-size: 12px;'>This is an automated email from Memora DimensiaCare Application.</p>"
                +
                "</div>" +
                "</body>" +
                "</html>";
    }

    private String buildWelcomeEmailContent(String firstName) {
        return "<!DOCTYPE html>" +
                "<html>" +
                "<head><meta charset='UTF-8'><title>Welcome</title></head>" +
                "<body style='font-family: Arial, sans-serif; line-height: 1.6; color: #333;'>" +
                "<div style='max-width: 600px; margin: 0 auto; padding: 20px;'>" +
                "<h2 style='color: #2c3e50;'>Welcome to Memora DimensiaCare!</h2>" +
                "<p>Hello " + firstName + ",</p>" +
                "<p>Thank you for joining Memora DimensiaCare. We're excited to have you on board!</p>" +
                "<p>You can now start using our platform to manage your care needs.</p>" +
                "<div style='text-align: center; margin: 30px 0;'>" +
                "<a href='http://localhost:3000/dashboard' " +
                "style='background-color: #27ae60; color: white; padding: 12px 24px; text-decoration: none; border-radius: 5px; display: inline-block;'>"
                +
                "Get Started</a>" +
                "</div>" +
                "<p>If you have any questions, feel free to contact our support team.</p>" +
                "<hr style='border: 1px solid #eee; margin: 30px 0;'>" +
                "<p style='color: #666; font-size: 12px;'>This is an automated email from Memora DimensiaCare Application.</p>"
                +
                "</div>" +
                "</body>" +
                "</html>";
    }

    private String buildVerificationEmailContent(String verificationToken) {
        return "<!DOCTYPE html>" +
                "<html>" +
                "<head><meta charset='UTF-8'><title>Email Verification</title></head>" +
                "<body style='font-family: Arial, sans-serif; line-height: 1.6; color: #333;'>" +
                "<div style='max-width: 600px; margin: 0 auto; padding: 20px;'>" +
                "<h2 style='color: #2c3e50;'>Verify Your Email Address</h2>" +
                "<p>Please click the button below to verify your email address:</p>" +
                "<div style='text-align: center; margin: 30px 0;'>" +
                "<a href='http://localhost:3000/verify-email?token=" + verificationToken + "' " +
                "style='background-color: #e74c3c; color: white; padding: 12px 24px; text-decoration: none; border-radius: 5px; display: inline-block;'>"
                +
                "Verify Email</a>" +
                "</div>" +
                "<p>If you did not create this account, please ignore this email.</p>" +
                "<p>This verification link will expire in 24 hours.</p>" +
                "<hr style='border: 1px solid #eee; margin: 30px 0;'>" +
                "<p style='color: #666; font-size: 12px;'>This is an automated email from Memora DimensiaCare Application.</p>"
                +
                "</div>" +
                "</body>" +
                "</html>";
    }
}