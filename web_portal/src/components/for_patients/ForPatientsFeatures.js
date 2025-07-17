// src/components/ForPatientsFeatures.js
import React from 'react';
import { Box, Grid, Typography, Container, Paper } from '@mui/material';
import AssignmentTurnedInIcon from '@mui/icons-material/AssignmentTurnedIn';
import MedicationIcon from '@mui/icons-material/Medication';
import NotificationsActiveIcon from '@mui/icons-material/NotificationsActive';
import EventAvailableIcon from '@mui/icons-material/EventAvailable';
import PeopleIcon from '@mui/icons-material/People';
import MonitorHeartIcon from '@mui/icons-material/MonitorHeart';

const features = [
  {
    icon: <AssignmentTurnedInIcon sx={{ fontSize: 40, color: '#390797' }} />,
    title: 'Task & Routine Tracking ',
  },
  {
    icon: <MedicationIcon sx={{ fontSize: 40, color: '#A0C4FD' }} />,
    title: 'Medication Management',
  },
  {
    icon: <NotificationsActiveIcon sx={{ fontSize: 40, color: '#2B3F99' }} />,
    title: 'Notifications on Emergencies',
  },
  {
    icon: <EventAvailableIcon sx={{ fontSize: 40, color: '#a784dfff' }} />,
    title: 'Appointment Reminders',
  },
  {
    icon: <PeopleIcon sx={{ fontSize: 40, color: '#390797' }} />,
    title: 'Care Circle Communication ',
  },
  {
    icon: <MonitorHeartIcon sx={{ fontSize: 40, color: '#A0C4FD' }} />,
    title: 'Health & Safety Monitoring',
  },
];

function ForPatientsFeatures() {
  return (
    <Box sx={{ py: 8, bgcolor: '#fff' }}>
      <Container>
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
          Features Designed for You
        </Typography>
        <Grid container spacing={4} justifyContent="center">
          {features.map(({ icon, title }) => (
            <Grid item xs={12} sm={6} md={3} key={title}>
              <Paper
                elevation={2}
                sx={{
                  p: 4,
                  borderRadius: 4,
                  textAlign: 'center',
                  bgcolor: '#F6F4FB',
                  minHeight: 180,
                  display: 'flex',
                  flexDirection: 'column',
                  alignItems: 'center',
                  justifyContent: 'center',
                }}
              >
                {icon}
                <Typography variant="body1" sx={{ fontFamily: 'Poppins Medium', mt: 2, color: '#2B3F99', fontWeight: 600, fontSize: 21 }}>
                  {title}
                </Typography>
              </Paper>
            </Grid>
          ))}
        </Grid>
      </Container>
    </Box>
  );
}

export default ForPatientsFeatures;
