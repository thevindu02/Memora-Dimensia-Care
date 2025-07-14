// src/components/ForPatientsIntroBanner.js
import React from 'react';
import { Box, Typography, Container, Stack } from '@mui/material';
import patientIllustration from '../../assets/patient-illustration.png';

function ForPatientsIntroBanner() {
  return (
    <Box sx={{ bgcolor: '#C3B1E1', py: { xs: 6, md: 10 } }}>
      <Container>
        <Stack direction={{ xs: 'column', md: 'row' }} spacing={6} alignItems="center">
          <Box flex={1}>
            <Typography
              variant="h2"
              sx={{
                color: '#390797',
                fontWeight: 700,
                fontSize: { xs: 36, md: 54 },
                mb: 2,
                fontFamily: 'Poppins, Lato, Nunito, Arial, sans-serif',
              }}
            >
              Empowering You to Live with Confidence
            </Typography>
            <Typography
              variant="h5"
              sx={{
                color: '#2B3F99',
                fontWeight: 500,
                fontSize: { xs: 20, md: 28 },
                mb: 2,
                fontFamily: 'Poppins, Lato, Nunito, Arial, sans-serif',
              }}
            >
              Gentle reminders, safe monitoring, and simplified tools—designed just for you.
            </Typography>
          </Box>
          <Box flex={1} sx={{ textAlign: 'center' }}>
            <Box
              component="img"
              src={patientIllustration}
              alt="Patient using mobile app"
              sx={{
                width: { xs: '80%', md: 340 },
                maxWidth: 400,
                borderRadius: 6,
                boxShadow: 3,
                background: '#fff',
                p: 1,
              }}
            />
          </Box>
        </Stack>
      </Container>
    </Box>
  );
}

export default ForPatientsIntroBanner;
