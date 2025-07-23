// src/components/Term.js
import React from 'react';
import { Box, Typography, Container } from '@mui/material';

function Terms() {
  return (
    <Box sx={{ bgcolor: '#fff', py: { xs: 6, md: 12 }, px: { xs: 2, md: 0 } }}>
      <Container maxWidth="md">
        <Typography
          variant="h2"
          sx={{
            color: '#390797',
            fontWeight: 800,
            mb: 4,
            fontFamily: 'Poppins Bold',
            textAlign: 'center',
          }}
        >
          Terms and Conditions
        </Typography>

        {/* Introduction */}
        <Typography
          variant="body1"
          sx={{ mb: 4, fontSize: 20, color: '#2B3F99', fontFamily: 'Poppins Regular', lineHeight: 1.6 }}
        >
          Welcome to Memora. These Terms and Conditions ("Terms") govern your use of our platform and services,
          including but not limited to our app users who are guardians, caregivers, volunteers, and subscribers.
          Please read them carefully before using our services.
        </Typography>

        {/* User Responsibilities */}
        <Typography
          variant="h5"
          sx={{ color: '#390797', fontWeight: 700, mt: 4, mb: 1, fontFamily: 'Poppins Medium' }}
        >
          1. User Responsibilities
        </Typography>
        <Typography variant="body1" sx={{ mb: 3, fontSize: 18, color: '#2B3F99', lineHeight: 1.6, fontFamily: ' Poppins Regular' }}>
          By using Memora, you agree to:
          <ul>
            <li>Provide accurate and up-to-date information in your profile and communications.</li>
            <li>Use the platform in a respectful and lawful manner.</li>
            <li>Abide by all applicable laws and regulations.</li>
            <li>Not misuse, abuse, or interfere with the operation of the platform.</li>
            <li>Caregivers, guardians, and volunteers must ensure privacy and confidentiality of all personal data they access.</li>
          </ul>
        </Typography>

        {/* Volunteer Participation */}
        <Typography
          variant="h5"
          sx={{ color: '#390797', fontWeight: 700, mt: 4, mb: 1, fontFamily: 'Poppins Medium' }}
        >
          2. Volunteers
        </Typography>
        <Typography variant="body1" sx={{ mb: 3, fontSize: 18, color: '#2B3F99', lineHeight: 1.6, fontFamily: ' Poppins Regular' }}>
          Volunteers contribute their time and knowledge to the community. By participating, volunteers agree to:
          <ul>
            <li>Provide helpful, truthful, and respectful assistance.</li>
            <li>Respect users’ privacy and confidentiality.</li>
            <li>Refrain from offering professional medical, legal, or financial advice unless qualified.</li>
            <li>Memora is not responsible for volunteer actions or advice.</li>
          </ul>
        </Typography>

        {/* Caregivers and Guardians */}
        <Typography
          variant="h5"
          sx={{ color: '#390797', fontWeight: 700, mt: 4, mb: 1, fontFamily: 'Poppins Medium' }}
        >
          3. Caregivers and Guardians
        </Typography>
        <Typography variant="body1" sx={{ mb: 3, fontSize: 18, color: '#2B3F99', lineHeight: 1.6, fontFamily: ' Poppins Regular' }}>
          Caregivers and guardians using Memora agree to:
          <ul>
            <li>Use the platform to improve care coordination and communication.</li>
            <li>Obtain necessary consents for managing patient information and sharing data on Memora.</li>
            <li>Understand Memora is a supportive tool, not a substitute for professional medical services.</li>
            <li>Notify Memora promptly of any concerns about privacy or unauthorized access.</li>
          </ul>
        </Typography>

        {/* Subscription and Payments */}
        <Typography
          variant="h5"
          sx={{ color: '#390797', fontWeight: 700, mt: 4, mb: 1, fontFamily: 'Poppins Medium' }}
        >
          4. Subscription & Payments
        </Typography>
        <Typography variant="body1" sx={{ mb: 3, fontSize: 18, color: '#2B3F99', lineHeight: 1.6, fontFamily: ' Poppins Regular' }}>
          Memora offers subscription plans including a 1 month free trial. By subscribing, you agree to:
          <ul>
            <li>The free trial includes full access to all features for one month.</li>
            <li>After the trial, your subscription will automatically renew and payment will be charged to your payment method.</li>
            <li>You can cancel your subscription anytime before the trial ends to avoid charges.</li>
            <li>Subscription fees are non-refundable except as required by law.</li>
            <li>Payment processing is handled securely but Memora is not responsible for issues related to your financial institution.</li>
            <li>Prices and plans may change, but existing subscribers will be notified in advance.</li>
          </ul>
        </Typography>

        {/* Intellectual Property */}
        <Typography
          variant="h5"
          sx={{ color: '#390797', fontWeight: 700, mt: 4, mb: 1, fontFamily: 'Poppins Medium' }}
        >
          5. Intellectual Property
        </Typography>
        <Typography variant="body1" sx={{ mb: 3, fontSize: 18, color: '#2B3F99', lineHeight: 1.6, fontFamily: ' Poppins Regular' }}>
          All content, branding, software, and materials on Memora are the property of Memora or its licensors and protected by law.
          Users may not copy, distribute or create derivative works without permission.
        </Typography>

        {/* Disclaimers and Limitation of Liability */}
        <Typography
          variant="h5"
          sx={{ color: '#390797', fontWeight: 700, mt: 4, mb: 1, fontFamily: 'Poppins Medium' }}
        >
          6. Disclaimers and Limitation of Liability
        </Typography>
        <Typography variant="body1" sx={{ mb: 3, fontSize: 18, color: '#2B3F99', lineHeight: 1.6, fontFamily: ' Poppins Regular' }}>
          Memora provides tools to support care coordination but is not a healthcare provider.
          Use of the platform is at your own risk.
          Memora disclaims all warranties and limits liability to the maximum extent permitted by law.
        </Typography>

        {/* Privacy */}
        <Typography
          variant="h5"
          sx={{ color: '#390797', fontWeight: 700, mt: 4, mb: 1, fontFamily: 'Poppins Medium' }}
        >
          7. Privacy
        </Typography>
        <Typography variant="body1" sx={{ mb: 3, fontSize: 18, color: '#2B3F99', lineHeight: 1.6, fontFamily: ' Poppins Regular' }}>
          User privacy is important to Memora. Please refer to our Privacy Policy for details on how we collect, use, and protect your data.
        </Typography>

        <Box mt={6} mb={4}>
          <Typography variant="caption" sx={{ color: '#390797', fontWeight: 500, fontFamily: 'Nunito, Arial, sans-serif', fontSize: 15 }}>
            Last updated: July 2025
          </Typography>
        </Box>
      </Container>
    </Box>
  );
}

export default Terms;
