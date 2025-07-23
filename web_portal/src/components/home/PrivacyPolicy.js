// src/components/PrivacyPolicy.js
import React from 'react';
import { Box, Typography, Container } from '@mui/material';

function PrivacyPolicy() {
  return (
    <Box sx={{ bgcolor: '#fff', py: { xs: 6, md: 12 }, px: { xs: 2, md: 0 } }}>
      <Container maxWidth="md">
        <Typography
          variant="h3"
          sx={{
            color: '#390797',
            fontWeight: 800,
            mb: 4,
            fontFamily: 'Poppins Bold',
            textAlign: 'center',
          }}
        >
          Privacy Policy
        </Typography>

        <Typography
          variant="body1"
          sx={{ mb: 4, fontSize: 20, color: '#2B3F99', fontFamily: 'Poppins Medium', lineHeight: 1.7 }}
        >
          At Memora, your privacy and the security of your personal data are our top priorities. This Privacy Policy explains how we collect,
          use, disclose, and protect the information of our users, including patients, guardians, caregivers, volunteers, and subscribers,
          in accordance with applicable laws and industry best practices.
        </Typography>

        <Typography
          variant="h5"
          sx={{ color: '#390797', fontWeight: 700, mt: 4, mb: 1, fontFamily: 'Poppins Medium' }}
        >
          1. Information We Collect
        </Typography>
        <Typography variant="body1" sx={{ mb: 3, fontSize: 18, color: '#2B3F99', lineHeight: 1.6, fontFamily: ' Poppins Regular' }}>
          We collect various types of information to provide and improve our services, including:
          <ul>
            <li><strong>Personal Identification Information:</strong> name, email address, contact number, user role (patient, caregiver, etc.).</li>
            <li><strong>Health and Monitoring Data:</strong> smartwatch sensor data, medication schedules, task completion status.</li>
            <li><strong>Usage Data:</strong> app interactions, preferences, notifications settings.</li>
            <li><strong>Payment and Subscription Info:</strong> billing details processed securely through our payment gateway.</li>
            <li><strong>Communication Data:</strong> messages, alerts, and forum interaction data.</li>
          </ul>
        </Typography>

        <Typography
          variant="h5"
          sx={{ color: '#390797', fontWeight: 700, mt: 4, mb: 1, fontFamily: 'Poppins Medium'}}
        >
          2. How We Use Your Information
        </Typography>
        <Typography variant="body1" sx={{mb: 3, fontSize: 18, color: '#2B3F99', lineHeight: 1.6, fontFamily: ' Poppins Regular' }}>
          We use your information to:
          <ul>
            <li>Provide and maintain Memora’s personalized care and monitoring services.</li>
            <li>Enable communication and coordination between patients, caregivers, guardians, and volunteers.</li>
            <li>Send reminders, notifications, and alerts relevant to user needs and preferences.</li>
            <li>Process payments securely and manage subscription plans.</li>
            <li>Improve and customize the platform based on usage and feedback.</li>
            <li>Comply with legal and regulatory obligations.</li>
          </ul>
        </Typography>

        <Typography
          variant="h5"
          sx={{ color: '#390797', fontWeight: 700, mt: 4, mb: 1, fontFamily: 'Poppins Medium' }}
        >
          3. Data Sharing and Disclosure
        </Typography>
        <Typography variant="body1" sx={{ mb: 3, fontSize: 18, color: '#2B3F99', lineHeight: 1.6, fontFamily: ' Poppins Regular' }}>
          We do not sell or rent your personal data to third parties. We may share your information with:
          <ul>
            <li>Authorized healthcare providers and caregivers involved in your care coordination, with your consent.</li>
            <li>Service providers and partners who help operate the platform (e.g., payment processors, cloud services) under strict confidentiality agreements.</li>
            <li>When required by law or court order.</li>
            <li>To protect against fraud, unauthorized access, or illegal activities.</li>
          </ul>
        </Typography>

        <Typography
          variant="h5"
          sx={{ color: '#390797', fontWeight: 700, mt: 4, mb: 1, fontFamily: 'Poppins Medium' }}
        >
          4. Data Security
        </Typography>
        <Typography variant="body1" sx={{ mb: 3, fontSize: 18, color: '#2B3F99', lineHeight: 1.6, fontFamily: ' Poppins Regular'}}>
          We implement industry-standard security measures including encryption, access controls, and regular audits to safeguard your data from
          unauthorized access, alteration, disclosure, or destruction. We continuously update our security protocols to adapt to emerging threats.
        </Typography>

        <Typography
          variant="h5"
          sx={{ color: '#390797', fontWeight: 700, mt: 4, mb: 1,fontFamily: 'Poppins Medium' }}
        >
          5. Your Rights and Choices
        </Typography>
        <Typography variant="body1" sx={{ mb: 3, fontSize: 18, color: '#2B3F99', lineHeight: 1.6, fontFamily: ' Poppins Regular' }}>
          Depending on your jurisdiction, you have rights including:
          <ul>
            <li>Access to your personal data stored by Memora.</li>
            <li>Rectification of inaccurate or incomplete information.</li>
            <li>Request deletion or restriction of processing.</li>
            <li>Opt-out of certain communications and marketing.</li>
            <li>Data portability.</li>
          </ul>
          To exercise these rights, please contact us through our support channels.
        </Typography>

        <Typography
          variant="h5"
          sx={{ color: '#390797', fontWeight: 700, mt: 4, mb: 1, fontFamily: 'Poppins Medium' }}
        >
          6. Cookies and Tracking Technologies
        </Typography>
        <Typography variant="body1" sx={{ mb: 3, fontSize: 18, color: '#2B3F99', lineHeight: 1.6, fontFamily: ' Poppins Regular' }}>
          We use cookies and similar technologies to enhance user experience, analyze platform usage, and provide personalized content.
          You can control cookie preferences via your browser settings.
        </Typography>

        <Typography
          variant="h5"
          sx={{ color: '#390797', fontWeight: 700, mt: 4, mb: 1, fontFamily: 'Poppins Medium' }}
        >
          7. Children's Privacy
        </Typography>
        <Typography variant="body1" sx={{ mb: 3, fontSize: 18, color: '#2B3F99', lineHeight: 1.6, fontFamily: ' Poppins Regular'}}>
          Memora is not intended for children under 13 years. We do not knowingly collect personal data from children under 13. If you are a parent or guardian
          and believe we have collected data for a child under 13, please contact us immediately.
        </Typography>

        <Typography
          variant="h5"
          sx={{ color: '#390797', fontWeight: 700, mt: 4, mb: 1,fontFamily: 'Poppins Medium' }}
        >
          8. Changes to This Privacy Policy
        </Typography>
        <Typography variant="body1" sx={{ mb: 3, fontSize: 18, color: '#2B3F99', lineHeight: 1.6, fontFamily: ' Poppins Regular' }}>
          We may update this Privacy Policy periodically to reflect changes in practices or legal requirements. We will notify users
          of significant changes through the platform or email. Continued use of Memora after updates constitutes acceptance of those changes.
        </Typography>

        <Box mt={6} mb={4}>
          <Typography variant="caption" sx={{ color: '#390797', fontWeight: 500, fontFamily: 'Nunito, Arial, sans-serif', fontSize: 15 }}>
            Last updated: July 22, 2025
          </Typography>
        </Box>
      </Container>
    </Box>
  );
}

export default PrivacyPolicy;
