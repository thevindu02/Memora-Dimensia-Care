// src/components/for_volunteers/VolunteersIntroBanner.js
import React from 'react';
import { Box, Typography, Container, Grid, Button } from '@mui/material';

function VolunteersIntroBanner() {
  return (
    <Box
      sx={{
        position: 'relative',
        bgcolor: 'transparent',
        py: { xs: 8, md: 12 },
        background: 'linear-gradient(120deg, #A0C4FD 60%, #C3B1E1 100%)',
        overflow: 'hidden',
        minHeight: { md: 380 },
      }}
    >
      {/* Decorative background image */}
      <Box
        sx={{
          position: 'absolute',
          top: -50,
          right: -60,
          width: 350,
          height: 350,
          background: `url('/assets/volunteer-bg-abstract.png') center/cover no-repeat`,
          opacity: 0.13,
          zIndex: 0,
        }}
      />
      <Container sx={{ position: 'relative', zIndex: 1 }}>
        <Grid container spacing={4} alignItems="center">
          <Grid item xs={12} md={7}>
            <Typography
              variant="h2"
              sx={{
                color: '#2B3F99',
                fontWeight: 800,
                fontSize: { xs: 28, md: 44 },
                mb: 2,
                fontFamily: 'Poppins, Lato, Nunito, Arial, sans-serif',
                letterSpacing: 1,
              }}
            >
              Share Knowledge, Make an Impact
            </Typography>
            <Typography
              variant="h5"
              sx={{
                color: '#390797',
                fontWeight: 500,
                fontSize: { xs: 18, md: 26 },
                mb: 3,
                fontFamily: 'Poppins, Lato, Nunito, Arial, sans-serif',
              }}
            >
              Your insights and care can change lives.
            </Typography>
            <Button
              variant="contained"
              color="primary"
              size="large"
              sx={{
                borderRadius: 8,
                fontWeight: 700,
                px: 5,
                mt: 2,
                boxShadow: '0 4px 24px 0 rgba(44,62,80,0.10)',
              }}
            >
              Start Contributing
            </Button>
          </Grid>
          <Grid item xs={12} md={5} sx={{ textAlign: 'center' }}>
            <Box
              component="img"
              src="/assets/volunteer-illustration.png"
              alt="Volunteer contributing"
              sx={{
                width: { xs: '85%', md: 320 },
                maxWidth: 360,
                borderRadius: 6,
                boxShadow: '0 8px 32px 0 rgba(44,62,80,0.16)',
                background: '#fff',
                p: 1,
              }}
            />
          </Grid>
        </Grid>
      </Container>
    </Box>
  );
}

export default VolunteersIntroBanner;
