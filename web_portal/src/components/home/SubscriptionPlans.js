// src/components/subscription/Subscription.js
import React from 'react';
import { Box, Grid, Card, Typography, Container, Button, Stack } from '@mui/material';
import AccessAlarmIcon from '@mui/icons-material/AccessAlarm';
import EventAvailableIcon from '@mui/icons-material/EventAvailable';
import StarIcon from '@mui/icons-material/Star';

// Use your subscription plans data
const subscriptionPlansData = [
  {
    id: 1,
    title: 'Basic Care',
    description: 'Essential dementia care features including basic monitoring and simple reminders.',
    durations: {
      '3months': 499,
      '6months': 899,
      annual: 1499,
    },
    features: [
      'Basic Health Monitoring',
      'Medication Reminders',
      'Emergency Alerts',
      'View upto 4 caregivers',
      '1 article or blog per day',
    ],
    isActive: true,
    createdAt: '2024-01-15',
    updatedAt: '2024-02-20',
  },
  {
    id: 2,
    title: 'Premium Care',
    description: 'Comprehensive dementia care with advanced monitoring, AI assistance, and caregiver support.',
    durations: {
      '3months': 999,
      '6months': 1899,
      annual: 2499,
    },
    features: [
      'Advanced Health Monitoring',
      'Smart Watch Integration',
      'Video Consultations',
      'Unlimited caregiver options',
      'Unlimited articles and blog posts',
      '24/7 Support',
    ],
    isActive: true,
    createdAt: '2024-01-15',
    updatedAt: '2024-03-10',
  },
];

// Helper to pick icon based on title (or any logic)
const getIconByTitle = (title) => {
  if (title.toLowerCase().includes('basic')) {
    return <AccessAlarmIcon sx={{ fontSize: 48, color: '#390797' }} />;
  }
  if (title.toLowerCase().includes('premium')) {
    return <EventAvailableIcon sx={{ fontSize: 48, color: '#2B3F99' }} />;
  }
  return <StarIcon sx={{ fontSize: 48, color: '#A0C4FD' }} />;
};

// Format duration strings for display
const durationLabels = {
  '3months': '3 Months',
  '6months': '6 Months',
  annual: '1 Year',
};

function Subscription() {
  return (
    <Box sx={{ bgcolor: '#fff', py: { xs: 8, md: 12 }, position: 'relative' }}>
      {/* Background Elements */}
      <Box
        sx={{
          position: 'absolute',
          top: -80,
          right: -80,
          width: 300,
          height: 300,
          borderRadius: '60%',
          background: 'radial-gradient(circle at center, #6f28e2ff 0%, transparent 70%)',
          opacity: 0.2,
          zIndex: 0,
          pointerEvents: 'none',
        }}
      />
      <Box
        sx={{
          position: 'absolute',
          bottom: -90,
          left: -100,
          width: 280,
          height: 280,
          borderRadius: '50%',
          background: 'radial-gradient(circle at center, #A0C4FD 0%, transparent 75%)',
          opacity: 0.18,
          zIndex: 0,
          pointerEvents: 'none',
        }}
      />

      <Container sx={{ position: 'relative', zIndex: 1, maxWidth: 'lg' }}>
        <Typography
          variant="h3"
          sx={{
            color: '#390797',
            fontWeight: 800,
            textAlign: 'center',
            mb: 2,
            fontFamily: 'Poppins Bold',
            fontSize: 45,
          }}
        >
          Subscription Plans
        </Typography>

        <Typography
          variant="h6"
          sx={{
            color: '#2B3F99',
            maxWidth: 640,
            mx: 'auto',
            mb: 6,
            fontFamily: 'Poppins Regular',
            fontSize: 25,
            fontWeight: 500,
            textAlign: 'center',
          }}
        >
          Try all features free for 1 month. After your trial, continue with a subscription or cancel anytime.
        </Typography>

        <Grid container spacing={6} justifyContent="center">
          {subscriptionPlansData.map(({ id, title, features, durations }) => (
            <Grid item xs={12} sm={6} key={id} sx={{ display: 'flex', flexDirection: 'column' }}>
              <Card
                sx={{
                  width: '100%',
                  borderRadius: 4,
                  boxShadow: '0 8px 32px 0 rgba(57,7,151,0.12)',
                  position: 'relative',
                  ':hover': {
                    boxShadow: '0 14px 48px 0 rgba(57,7,151,0.2)',
                    transform: 'translateY(-6px)',
                    transition: 'transform 0.3s ease, box-shadow 0.3s ease',
                  },
                  p: 4,
                  display: 'flex',
                  flexDirection: 'column',
                  alignItems: 'center',
                  bgcolor: '#F6F4FB',
                  mb: 4,
                }}
              >
                <Box sx={{ mb: 2 }}>{getIconByTitle(title)}</Box>
                <Typography
                  variant="h5"
                  sx={{
                    color: '#390797',
                    fontWeight: 700,
                    mb: 1,
                    fontFamily: 'Poppins Medium',
                    fontSize: 30,
                    textAlign: 'center',
                  }}
                >
                  {title}
                </Typography>

                {/* Durations & Prices */}
                <Box sx={{ mb: 3, width: '100%', display: 'flex', justifyContent: 'center', gap: 3, flexWrap: 'wrap' }}>
                  {Object.entries(durations).map(([durationKey, price]) => (
                    <Box
                      key={durationKey}
                      sx={{
                        bgcolor: '#fff',
                        borderRadius: 3,
                        px: 3,
                        py: 1.5,
                        boxShadow: '0 2px 12px 0 rgba(160,196,253,0.16)',
                        minWidth: 110,
                        textAlign: 'center',
                        fontFamily: 'Poppins Regular',
                        fontWeight: 600,
                        color: '#390797',
                        fontSize: 20,
                        userSelect: 'none',
                        cursor: 'default',
                      }}
                    >
                      {`LKR ${price.toLocaleString()}`} <br />
                      <Typography
                        component="span"
                        sx={{ fontSize: 16, color: '#2B3F99', fontWeight: 500, fontFamily: 'Poppins Regular' }}
                      >
                        / {durationLabels[durationKey]}
                      </Typography>
                    </Box>
                  ))}
                </Box>

                <Box sx={{ mb: 3, width: '100%' }}>
                  {features.map((feature) => (
                    <Stack
                      direction="row"
                      spacing={1}
                      key={feature}
                      alignItems="center"
                      sx={{ mb: 1 }}
                    >
                      <StarIcon sx={{ color: '#A0C4FD', fontSize: 22 }} />
                      <Typography sx={{ color: '#390797', fontWeight: 500, fontSize: 20, fontFamily: 'Poppins Regular' }}>
                        {feature}
                      </Typography>
                    </Stack>
                  ))}
                </Box>

                <Button
                  variant="contained"
                  color="primary"
                  fullWidth
                  size="large"
                  sx={{ borderRadius: 8, fontWeight: 700, fontFamily: 'Roboto', fontSize: 18 }}
                >
                  Start Free Trial
                </Button>
              </Card>
            </Grid>
          ))}
        </Grid>
      </Container>
    </Box>
  );
}

export default Subscription;
