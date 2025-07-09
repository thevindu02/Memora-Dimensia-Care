// src/components/ForPatientsBenefits.js
import React from 'react';
import { Box, Grid, Card, CardContent, Typography, Container } from '@mui/material';
import AccessAlarmIcon from '@mui/icons-material/AccessAlarm';
import PeopleIcon from '@mui/icons-material/People';
import WatchIcon from '@mui/icons-material/Watch';

const benefits = [
  {
    icon: <AccessAlarmIcon sx={{ fontSize: 48, color: '#390797' }} />,
    title: 'Personalized Reminders',
    desc: 'Never miss important tasks or medications with gentle, timely reminders.',
  },
  {
    icon: <PeopleIcon sx={{ fontSize: 48, color: '#2B3F99' }} />,
    title: 'Connection with Caregivers',
    desc: 'Stay connected with your care team and loved ones for support and reassurance.',
  },
  {
    icon: <WatchIcon sx={{ fontSize: 48, color: '#A0C4FD' }} />,
    title: 'Smartwatch-Based Health Safety',
    desc: 'Monitor your health and safety with easy-to-use wearable technology.',
  },
];

function ForPatientsBenefits() {
  return (
    <Box sx={{ py: 8, bgcolor: '#fff' }}>
      <Container maxWidth="lg">
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
                  <Typography variant="h6" sx={{ fontWeight: 700, mb: 1, color: '#390797' }}>
                    {title}
                  </Typography>
                  <Typography variant="body1" sx={{ color: '#2B3F99', fontSize: 18 }}>
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
