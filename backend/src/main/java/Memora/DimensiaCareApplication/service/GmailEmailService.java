package Memora.DimensiaCareApplication.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;

@Service
public class GmailEmailService {

    @Autowired
    private JavaMailSender mailSender;

    private static final String BASE_URL = "http://192.168.8.127:8080";

    public void sendPasswordResetEmail(String toEmail, String resetToken) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true);

            helper.setFrom("memorademen@gmail.com");
            helper.setTo(toEmail);
            helper.setSubject("Password Reset Request - Memora");

            String webUrl = BASE_URL + "/reset-redirect?token=" + resetToken;
            String deepLinkUrl = "memora://reset-password?token=" + resetToken;

            String htmlContent = "<!DOCTYPE html>" +
                    "<html>" +
                    "<head>" +
                    "<meta charset='UTF-8'>" +
                    "<meta name='viewport' content='width=device-width, initial-scale=1.0'>" +
                    "<script>" +
                    "function openApp() {" +
                    "  if (/Android|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)) {" +
                    "    window.location.href = '" + deepLinkUrl + "';" +
                    "    setTimeout(function() {" +
                    "      alert('Please open the Memora app manually and enter this token: " + resetToken + "');" +
                    "    }, 2500);" +
                    "  } else {" +
                    "    alert('Please open this link on your mobile device with the Memora app installed.');" +
                    "  }" +
                    "  return false;" +
                    "}" +
                    "</script>" +
                    "</head>" +
                    "<body style='font-family: Arial, sans-serif; line-height: 1.6; color: #333; margin: 0; padding: 20px;'>"
                    +
                    "<div style='max-width: 600px; margin: 0 auto; background-color: #f9f9f9; padding: 20px; border-radius: 10px;'>"
                    +
                    "<h2 style='color: #4CAF50; text-align: center;'>Password Reset Request</h2>" +
                    "<p>Hello,</p>" +
                    "<p>You have requested to reset your password for your Memora account.</p>" +
                    "<p>Please click the button below to reset your password:</p>" +
                    "<div style='text-align: center; margin: 30px 0;'>" +
                    "<a href='" + webUrl
                    + "' onclick='openApp()' style='background-color: #4CAF50; color: white; padding: 15px 30px; text-decoration: none; border-radius: 5px; font-size: 16px; display: inline-block;'>Reset Password</a>"
                    +
                    "</div>" +
                    "<p><strong>Reset Token:</strong></p>" +
                    "<p style='background-color: #f0f0f0; padding: 15px; border-radius: 5px; font-family: monospace; font-size: 16px; text-align: center; letter-spacing: 1px; border: 2px solid #4CAF50;'>"
                    +
                    resetToken +
                    "</p>" +
                    "<p style='color: #666; font-size: 14px;'><strong>Instructions:</strong></p>" +
                    "<ol style='color: #666; font-size: 14px;'>" +
                    "<li>Click the 'Reset Password' button above</li>" +
                    "<li>If it doesn't open the app automatically, open the Memora app manually</li>" +
                    "<li>Navigate to 'Forgot Password' and enter the token above</li>" +
                    "</ol>" +
                    "<p style='color: #666; font-size: 14px;'>This token will expire in 24 hours.</p>" +
                    "<p style='color: #666; font-size: 14px;'>If you didn't request this password reset, please ignore this email.</p>"
                    +
                    "<hr style='border: none; border-top: 1px solid #ddd; margin: 20px 0;'>" +
                    "<p style='text-align: center; color: #666; font-size: 14px;'>Best regards,<br>The Memora Team</p>"
                    +
                    "</div>" +
                    "</body>" +
                    "</html>";

            helper.setText(htmlContent, true);

            mailSender.send(message);
            System.out.println("Password reset email sent successfully to: " + toEmail);

        } catch (MessagingException e) {
            System.err.println("Failed to send password reset email to: " + toEmail);
            e.printStackTrace();
            throw new RuntimeException("Failed to send email", e);
        }
    }

    public void sendWelcomeEmail(String toEmail, String userName) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true);

            helper.setFrom("memorademen@gmail.com");
            helper.setTo(toEmail);
            helper.setSubject("Welcome to Memora!");

            String htmlContent = "<!DOCTYPE html>" +
                    "<html>" +
                    "<head>" +
                    "<meta charset='UTF-8'>" +
                    "<meta name='viewport' content='width=device-width, initial-scale=1.0'>" +
                    "</head>" +
                    "<body style='font-family: Arial, sans-serif; line-height: 1.6; color: #333; margin: 0; padding: 20px;'>"
                    +
                    "<div style='max-width: 600px; margin: 0 auto; background-color: #f9f9f9; padding: 20px; border-radius: 10px;'>"
                    +
                    "<h2 style='color: #4CAF50; text-align: center;'>Welcome to Memora!</h2>" +
                    "<p>Hello " + userName + ",</p>" +
                    "<p>Welcome to Memora! Your account has been successfully created.</p>" +
                    "<p>We're excited to have you join our community dedicated to dementia care.</p>" +
                    "<p>If you have any questions, please don't hesitate to reach out to our support team.</p>" +
                    "<hr style='border: none; border-top: 1px solid #ddd; margin: 20px 0;'>" +
                    "<p style='text-align: center; color: #666; font-size: 14px;'>Best regards,<br>The Memora Team</p>"
                    +
                    "</div>" +
                    "</body>" +
                    "</html>";

            helper.setText(htmlContent, true);

            mailSender.send(message);
            System.out.println("Welcome email sent successfully to: " + toEmail);

        } catch (MessagingException e) {
            System.err.println("Failed to send welcome email to: " + toEmail);
            e.printStackTrace();
            throw new RuntimeException("Failed to send email", e);
        }
    }

    public void sendGuardianConnectionEmail(String patientEmail, String patientName,
            String guardianName, String guardianEmail,
            String relationship, String connectionToken) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true);

            helper.setFrom("memorademen@gmail.com");
            helper.setTo(patientEmail);
            helper.setSubject("Guardian Connection Request - Memora");

            String webUrl = BASE_URL + "/guardian-connection-redirect?token=" + connectionToken;

            String htmlContent = "<!DOCTYPE html>" +
                    "<html>" +
                    "<head>" +
                    "<meta charset='UTF-8'>" +
                    "<meta name='viewport' content='width=device-width, initial-scale=1.0'>" +
                    "</head>" +
                    "<body style='font-family: Arial, sans-serif; line-height: 1.6; color: #333; margin: 0; padding: 20px;'>"
                    +
                    "<div style='max-width: 600px; margin: 0 auto; background-color: #f9f9f9; padding: 20px; border-radius: 10px;'>"
                    +
                    "<h2 style='color: #2B3F99; text-align: center;'>Guardian Connection Request</h2>" +
                    "<p>Hello " + patientName + ",</p>" +
                    "<p><strong>" + guardianName + "</strong> (" + guardianEmail
                    + ") wants to connect with you as your " + relationship.toLowerCase() + " on Memora.</p>" +
                    "<p>Memora is a dementia care application designed to help you and your loved ones manage your health and well-being together.</p>"
                    +
                    "<div style='background-color: #A0C4FD; padding: 15px; border-radius: 8px; margin: 20px 0;'>" +
                    "<h3 style='color: #2B3F99; margin: 0 0 10px 0;'>What does this mean?</h3>" +
                    "<p style='margin: 0; color: #2B3F99;'>Your " + relationship.toLowerCase()
                    + " will be able to help monitor your health progress, coordinate care, and receive important notifications about your well-being.</p>"
                    +
                    "</div>" +
                    "<p>Please click the button below to review and respond to this connection request:</p>" +
                    "<div style='text-align: center; margin: 30px 0;'>" +
                    "<a href='" + webUrl
                    + "' style='background-color: #A0C4FD; color: #2B3F99; padding: 15px 30px; text-decoration: none; border-radius: 8px; font-size: 16px; font-weight: 600; display: inline-block;'>View Connection Request</a>"
                    +
                    "</div>" +
                    "<div style='background-color: #f0f0f0; padding: 15px; border-radius: 5px; margin: 20px 0;'>" +
                    "<h4 style='color: #2B3F99; margin: 0 0 10px 0;'>Guardian Information:</h4>" +
                    "<p style='margin: 5px 0;'><strong>Name:</strong> " + guardianName + "</p>" +
                    "<p style='margin: 5px 0;'><strong>Email:</strong> " + guardianEmail + "</p>" +
                    "<p style='margin: 5px 0;'><strong>Relationship:</strong> " + relationship + "</p>" +
                    "</div>" +
                    "<p style='color: #666; font-size: 14px;'><strong>Instructions:</strong></p>" +
                    "<ol style='color: #666; font-size: 14px;'>" +
                    "<li>Click the 'View Connection Request' button above</li>" +
                    "<li>This will open a page that automatically launches the Memora app</li>" +
                    "<li>Review the guardian connection request and choose to accept or decline</li>" +
                    "</ol>" +
                    "<p style='color: #666; font-size: 14px;'>You can accept or decline this request at any time. Your privacy and autonomy are always respected.</p>"
                    +
                    "<hr style='border: none; border-top: 1px solid #ddd; margin: 20px 0;'>" +
                    "<p style='text-align: center; color: #666; font-size: 14px;'>Best regards,<br>The Memora Team</p>"
                    +
                    "</div>" +
                    "</body>" +
                    "</html>";

            helper.setText(htmlContent, true);

            mailSender.send(message);
            System.out.println("Guardian connection email sent successfully to: " + patientEmail);

        } catch (MessagingException e) {
            System.err.println("Failed to send guardian connection email to: " + patientEmail);
            e.printStackTrace();
            throw new RuntimeException("Failed to send email", e);
        }
    }

    public void sendGeneralEmail(String toEmail, String subject, String body) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true);

            helper.setFrom("memorademen@gmail.com");
            helper.setTo(toEmail);
            helper.setSubject(subject);
            helper.setText(body, false); // false = plain text

            mailSender.send(message);
            System.out.println("Email sent successfully to: " + toEmail + " with subject: " + subject);

        } catch (MessagingException e) {
            System.err.println("Failed to send email to: " + toEmail);
            e.printStackTrace();
            throw new RuntimeException("Failed to send email", e);
        }
    }

    public void sendVerificationCodeEmail(String toEmail, String code, String patientName) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true);

            helper.setFrom("memorademen@gmail.com");
            helper.setTo(toEmail);
            helper.setSubject("Your Memora Verification Code");

            String htmlContent = "<!DOCTYPE html>" +
                    "<html>" +
                    "<head>" +
                    "<meta charset='UTF-8'>" +
                    "<meta name='viewport' content='width=device-width, initial-scale=1.0'>" +
                    "</head>" +
                    "<body style='font-family: Arial, sans-serif; line-height: 1.6; color: #333; margin: 0; padding: 20px;'>" +
                    "<div style='max-width: 600px; margin: 0 auto; background-color: #f9f9f9; padding: 20px; border-radius: 10px;'>" +
                    "<h2 style='color: #2B3F99; text-align: center;'>Your Verification Code</h2>" +
                    "<p>Hello " + patientName + ",</p>" +
                    "<p>Your verification code to log in to Memora is:</p>" +
                    "<div style='text-align: center; margin: 30px 0;'>" +
                    "<div style='background-color: #A0C4FD; padding: 20px; border-radius: 10px; display: inline-block;'>" +
                    "<p style='font-size: 36px; font-weight: bold; color: #2B3F99; margin: 0; letter-spacing: 8px; font-family: monospace;'>" +
                    code.charAt(0) + " " + code.charAt(1) + " " + code.charAt(2) + " " + 
                    code.charAt(3) + " " + code.charAt(4) + " " + code.charAt(5) +
                    "</p>" +
                    "</div>" +
                    "</div>" +
                    "<p style='text-align: center; color: #2B3F99; font-weight: bold;'>This code expires in 15 minutes</p>" +
                    "<p style='color: #666; font-size: 14px; margin-top: 30px;'>If you didn't request this code, please ignore this email or contact support if you have concerns.</p>" +
                    "<hr style='border: none; border-top: 1px solid #ddd; margin: 20px 0;'>" +
                    "<p style='text-align: center; color: #666; font-size: 14px;'>Best regards,<br>The Memora Team</p>" +
                    "</div>" +
                    "</body>" +
                    "</html>";

            helper.setText(htmlContent, true);

            mailSender.send(message);
            System.out.println("Verification code email sent successfully to: " + toEmail);

        } catch (MessagingException e) {
            System.err.println("Failed to send verification code email to: " + toEmail);
            e.printStackTrace();
            throw new RuntimeException("Failed to send email", e);
        }
    }

}
