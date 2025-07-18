// src/components/for_volunteers/VolunteersIntroBanner.js
import React from 'react';
import { Box, Typography, Container, Grid, Button } from '@mui/material';
import volunteerbg from '../../assets/volunteer-bg.png'; // Adjust the path as necessary

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
        component="img"
        src={volunteerbg}
        alt="Decorative background"
        sx={{
          position: 'absolute',
          top: -20,
          right: -40,
          width: 680,
          height: 440,
          opacity: 0.13,
          zIndex: 0,
          pointerEvents: 'none', // (optional, prevents pointer capture)
          userSelect: 'none',    // (optional, avoids blue selection highlight)
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
                fontSize: { xs: 30, md: 75 },
                mb: 2,
                fontFamily: 'Poppins Bold',
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
                fontSize: { xs: 18, md: 28 },
                mb: 3,
                fontFamily: 'Poppins Regular',
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
                fontFamily: 'Roboto', 
                fontSize: 18,
              }}
            >
              Start Contributing
            </Button>
          </Grid>
          <Grid item xs={12} md={5} sx={{ textAlign: 'center' }}>
            <Box
              component="img"
              src={volunteerbg}
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
