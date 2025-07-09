import React from 'react';
import { Box, Grid, Paper, Typography, Container } from '@mui/material';
import DashboardIcon from '@mui/icons-material/Dashboard';
import WarningAmberIcon from '@mui/icons-material/WarningAmber';
import MedicationIcon from '@mui/icons-material/Medication';

const benefits = [
  {
    icon: <DashboardIcon sx={{ fontSize: 40, color: '#2B3F99' }} />,
    title: 'Smart Dashboard Access',
    desc: 'Instantly view your daily tasks, patient updates, and helpful resources—all in one place.',
    bgcolor: 'rgba(195,177,225,0.15)',
  },
  {
    icon: <WarningAmberIcon sx={{ fontSize: 40, color: '#C3B1E1' }} />,
    title: 'Emergency Alerts',
    desc: 'Real-time notifications for urgent situations, so you never miss a critical moment.',
    bgcolor: 'rgba(160,196,253,0.15)',
  },
  {
    icon: <MedicationIcon sx={{ fontSize: 40, color: '#390797' }} />,
    title: 'Task & Med Tracking',
    desc: 'Effortlessly manage medication schedules and care routines with gentle reminders.',
    bgcolor: 'rgba(43,63,153,0.08)',
  },
];

function CaregiversBenefits() {
  return (
    <Box sx={{ py: 7, bgcolor: '#fff' }}>
      <Container>
        <Typography
          variant="h4"
          sx={{
            color: '#2B3F99',
            fontWeight: 700,
            mb: 4,
            textAlign: 'center',
            letterSpacing: 0.5,
          }}
        >
          What You Receive
        </Typography>
        <Typography
          variant="subtitle1"
          sx={{
            color: '#390797',
            textAlign: 'center',
            mb: 5,
            fontSize: 18,
            opacity: 0.85,
          }}
        >
          Everything you need to provide outstanding care, while nurturing your own well-being.
        </Typography>
        <Grid container spacing={4} justifyContent="center">
          {benefits.map(({ icon, title, desc, bgcolor }) => (
            <Grid item xs={12} sm={6} md={4} key={title}>
              <Paper
                elevation={0}
                sx={{
                  p: 4,
                  borderRadius: 4,
                  bgcolor,
                  boxShadow: '0 2px 12px 0 rgba(44,62,80,0.06)',
                  textAlign: 'center',
                  height: '100%',
                  display: 'flex',
                  flexDirection: 'column',
                  alignItems: 'center',
                  justifyContent: 'center',
                  transition: 'transform 0.2s, box-shadow 0.2s',
                  '&:hover': {
                    transform: 'translateY(-6px) scale(1.03)',
                    boxShadow: '0 8px 32px 0 rgba(44,62,80,0.12)',
                  },
                }}
              >
                {icon}
                <Typography variant="h6" sx={{ mt: 2, color: '#2B3F99', fontWeight: 700 }}>
                  {title}
                </Typography>
                <Typography variant="body1" sx={{ mt: 1, color: '#390797', fontSize: 17 }}>
                  {desc}
                </Typography>
              </Paper>
            </Grid>
          ))}
        </Grid>
      </Container>
    </Box>
  );
}

export default CaregiversBenefits;

