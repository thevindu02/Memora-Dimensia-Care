// src/components/ForPatientsBenefits.js
import React from 'react';
import { Box, Grid, Card, CardContent, Typography, Container } from '@mui/material';
import AccessAlarmIcon from '@mui/icons-material/AccessAlarm';
import PeopleIcon from '@mui/icons-material/People';
import WatchIcon from '@mui/icons-material/Watch';

const benefits = [
  {
    icon: <AccessAlarmIcon sx={{ fontSize: 48, color: '#a784dfff' }} />,
    title: 'Personalized Reminders',
    desc: 'Never miss important tasks, medications, or appointments with gentle reminders tailored to daily routines and health schedules, designed to reduce confusion and promote independence.',
  },
  {
    icon: <PeopleIcon sx={{ fontSize: 48, color: '#2B3F99' }} />,
    title: 'Connection with Caregivers',
    desc: 'Maintain continuous communication with caregivers and family members through secure messaging and alerts, ensuring emotional support, timely intervention, and peace of mind for everyone involved.',
  },
  {
    icon: <WatchIcon sx={{ fontSize: 48, color: '#A0C4FD' }} />,
    title: 'Smartwatch-Based Health Safety',
    desc: 'Leverage wearable technology to track vital signs, detect unusual patterns, and send instant alerts during emergencies, empowering caregivers with real-time insights and ensuring proactive safety monitoring.',
  },
];

function ForPatientsBenefits() {
  return (
    <Box sx={{ py: 8, bgcolor: '#fff' }}>
      <Container maxWidth="lg">
        <Typography
                  variant="h4"
                  sx={{
                    textAlign: 'center',
                    mb:5,
                    color: '#2B3F99',
                    fontFamily: 'Poppins Bold',
                    fontWeight: 700,
                    fontSize: 48,
                    letterSpacing: 1,
                  }}
                >
                  What We Offer
                </Typography>
        <Grid container spacing={4} alignItems="stretch">
          {benefits.map(({ icon, title, desc }) => (
            <Grid item xs={12} sm={6} md={4} key={title} sx={{ display: 'flex' }}>
              <Card
                elevation={3}
                sx={{
                  width: '100%',
                  borderRadius: 4,
                  bgcolor: '#F6F4FB',
                  display: 'flex',
                  flexDirection: 'column',
                  flex: 1,
                  alignItems: 'center',
                  textAlign: 'center',
                  p: 3,
                }}
              >
                <CardContent sx={{ flex: 1 }}>
                  <Box sx={{ mb: 2 }}>{icon}</Box>
                  <Typography variant="h5" sx={{ fontFamily: 'Poppins Medium', fontWeight: 700, mb: 1, color: '#390797' }}>
                    {title}
                  </Typography>
                  <Typography variant="body1" sx={{ fontFamily: 'Poppins Regular', color: '#2B3F99', fontSize: 19 }}>
                    {desc}
                  </Typography>
                </CardContent>
              </Card>
            </Grid>
          ))}
        </Grid>
      </Container>
    </Box>
  );
}

export default ForPatientsBenefits;
