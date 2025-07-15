// src/components/ForPatientsFeatures.js
import React from 'react';
import { Box, Grid, Typography, Container, Paper } from '@mui/material';
import AssignmentTurnedInIcon from '@mui/icons-material/AssignmentTurnedIn';
import MedicationIcon from '@mui/icons-material/Medication';
import NotificationsActiveIcon from '@mui/icons-material/NotificationsActive';
import EventAvailableIcon from '@mui/icons-material/EventAvailable';

const features = [
  {
    icon: <AssignmentTurnedInIcon sx={{ fontSize: 40, color: '#390797' }} />,
    title: 'Task Tracking',
  },
  {
    icon: <MedicationIcon sx={{ fontSize: 40, color: '#2B3F99' }} />,
    title: 'Medication Management',
  },
  {
    icon: <NotificationsActiveIcon sx={{ fontSize: 40, color: '#A0C4FD' }} />,
    title: 'Notifications & Alerts',
  },
  {
    icon: <EventAvailableIcon sx={{ fontSize: 40, color: '#C3B1E1' }} />,
    title: 'Appointment Reminders',
  },
];

function ForPatientsFeatures() {
  return (
    <Box sx={{ py: 8, bgcolor: '#fff' }}>
      <Container>
        <Typography
          variant="h4"
          sx={{
            color: '#390797',
            fontWeight: 700,
            mb: 4,
            textAlign: 'center',
            fontFamily: 'Poppins, Lato, Nunito, Arial, sans-serif',
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
                <Typography variant="h6" sx={{ mt: 2, color: '#2B3F99', fontWeight: 600 }}>
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
