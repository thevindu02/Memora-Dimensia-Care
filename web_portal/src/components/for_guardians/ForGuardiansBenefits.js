// src/components/for_guardians/ForGuardiansBenefits.js
import React from 'react';
import { Box, Grid, Card, CardContent, Typography, Container } from '@mui/material';
import HealthAndSafetyIcon from '@mui/icons-material/HealthAndSafety';
import SupervisorAccountIcon from '@mui/icons-material/SupervisorAccount';
import ForumIcon from '@mui/icons-material/Forum';

const benefits = [
  {
    icon: <HealthAndSafetyIcon sx={{ fontSize: 48, color: '#390797' }} />,
    title: 'Health & Task Updates',
    desc: 'Receive real-time updates on patient health and daily tasks.',
  },
  {
    icon: <SupervisorAccountIcon sx={{ fontSize: 48, color: '#2B3F99' }} />,
    title: 'Caregiver Management',
    desc: 'Easily coordinate with caregivers and manage their roles.',
  },
  {
    icon: <ForumIcon sx={{ fontSize: 48, color: '#A0C4FD' }} />,
    title: 'Patient Communication',
    desc: 'Stay in touch with patients through secure messaging and alerts.',
  },
];

function ForGuardiansBenefits() {
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

export default ForGuardiansBenefits;
