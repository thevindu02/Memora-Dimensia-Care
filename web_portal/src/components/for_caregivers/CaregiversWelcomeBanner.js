import React from 'react';
import { Box, Typography, Container, Grid, Button, Stack } from '@mui/material';

function CaregiversWelcomeBanner() {
  return (
    <Box
      sx={{
        position: 'relative',
        bgcolor: 'transparent',
        py: { xs: 7, md: 10 },
        overflow: 'hidden',
        minHeight: { md: 380 },
        background:
          'linear-gradient(120deg, #C3B1E1 60%, #A0C4FD 100%)',
      }}
    >
      {/* Decorative low-opacity background image */}
      <Box
        sx={{
          position: 'absolute',
          top: -60,
          right: -60,
          width: 350,
          height: 350,
          background: `url('/assets/caregiving-bg-abstract.png') center/cover no-repeat`,
          opacity: 0.15,
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
                fontSize: { xs: 30, md: 48 },
                mb: 2,
                fontFamily: 'Poppins, Lato, Nunito, Arial, sans-serif',
                letterSpacing: 1,
              }}
            >
              Support for Those Who Give Their All
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
              Tools, insights, and care coordination at your fingertips. You care for others—let Memora care for you.
            </Typography>
            <Stack direction="row" spacing={2} mt={2}>
              <Button
                variant="contained"
                color="primary"
                size="large"
                sx={{ borderRadius: 8, fontWeight: 700, px: 4 }}
              >
                Start Free Trial
              </Button>
              <Button
                variant="outlined"
                color="primary"
                size="large"
                sx={{ borderRadius: 8, fontWeight: 700, px: 4 }}
                startIcon={
                  <Box
                    component="span"
                    sx={{
                      display: 'inline-block',
                      width: 20,
                      height: 20,
                      background: `url('/assets/play-icon.svg') center/contain no-repeat`,
                    }}
                  />
                }
              >
                Watch How It Works
              </Button>
            </Stack>
          </Grid>
          <Grid item xs={12} md={5} sx={{ textAlign: 'center' }}>
            <Box
              component="img"
              src="/assets/caregiver-tablet.png"
              alt="Caregiver using a tablet"
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

export default CaregiversWelcomeBanner;

