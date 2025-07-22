// src/components/subscription/Subscription.js
import React from 'react';
import { Box, Grid, Card, Typography, Container, Button, Stack } from '@mui/material';
import AccessAlarmIcon from '@mui/icons-material/AccessAlarm';
import EventAvailableIcon from '@mui/icons-material/EventAvailable';
import StarIcon from '@mui/icons-material/Star';

const plans = [
  {
    title: '6 Months Subscription',
    price: 'LKR 1500',
    duration: '6 months',
    features: [
      'All exclusive features included',
      'Smartwatch monitoring & reminders',
      '24/7 health reports',
      'Caregiver & guardian coordination',
    ],
    icon: <AccessAlarmIcon sx={{ fontSize: 48, color: '#390797' }} />,
  },
  {
    title: '1 Year Subscription',
    price: 'LKR 2500',
    duration: '12 months',
    features: [
      'All exclusive features included',
      'Smartwatch monitoring & reminders',
      'Priority customer support',
      'Caregiver & guardian coordination',
      'Advanced analytics and reports',
    ],
    icon: <EventAvailableIcon sx={{ fontSize: 48, color: '#2B3F99' }} />,
  },
];

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
          {plans.map(({ title, price, duration, features, icon }) => (
            <Grid item xs={12} sm={6} key={title} sx={{ display: 'flex' }}>
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
                }}
              >
                <Box sx={{ mb: 2 }}>{icon}</Box>
                <Typography
                  variant="h5"
                  sx={{
                    color: '#390797',
                    fontWeight: 700,
                    mb: 1,
                    fontFamily: 'Poppins Medium',
                    fontSize: 30,
                  }}
                >
                  {title}
                </Typography>
                <Typography
                  variant="h4"
                  sx={{
                    fontWeight: 800,
                    color: '#2B3F99',
                    mb: 2,
                    fontFamily: 'Poppins bold',
                  }}
                >
                  {price}{' '}
                  <Typography
                    component="span"
                    sx={{ fontSize: 20, color: '#390797', fontWeight: 500, fontFamily: 'Poppins Regular' }}
                  >
                    / {duration}
                  </Typography>
                </Typography>

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
                      <Typography sx={{ color: '#390797', fontWeight: 500, fontSize: 24, fontFamily: 'Poppins Regular' }}>
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
                  sx={{ borderRadius: 8, fontWeight: 700,fontFamily: 'Roboto', fontSize: 18 }}
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
