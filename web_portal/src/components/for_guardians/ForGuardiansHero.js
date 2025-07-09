// src/components/for_guardians/ForGuardiansHero.js
import React from 'react';
import { Box, Typography, Container, Stack, Button } from '@mui/material';
import guardianDashboard from '../../assets/guardian-dashboard.png'; // Use your own dashboard illustration

function ForGuardiansHero() {
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
                fontSize: { xs: 32, md: 48 },
                mb: 2,
                fontFamily: 'Poppins, Lato, Nunito, Arial, sans-serif',
              }}
            >
              Stay Connected, Stay Informed
            </Typography>
            <Typography
              variant="h5"
              sx={{
                color: '#2B3F99',
                fontWeight: 500,
                fontSize: { xs: 20, md: 26 },
                mb: 4,
                fontFamily: 'Poppins, Lato, Nunito, Arial, sans-serif',
              }}
            >
              Monitor, manage, and care—wherever you are.
            </Typography>
            <Stack direction="row" spacing={2}>
              <Button variant="contained" color="primary" size="large" sx={{ borderRadius: 8 }}>
                Start Monitoring
              </Button>
              <Button variant="outlined" color="primary" size="large" sx={{ borderRadius: 8 }}>
                View Care Plans
              </Button>
            </Stack>
          </Box>
          <Box flex={1} sx={{ textAlign: 'center' }}>
            <Box
              component="img"
              src={guardianDashboard}
              alt="Guardian dashboard"
              sx={{
                width: { xs: '90%', md: 350 },
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

export default ForGuardiansHero;
