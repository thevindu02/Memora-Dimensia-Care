import React from 'react';
import { Box, Typography, Container, Grid, Button, Stack } from '@mui/material';
import caregiverbg from '../../assets/caregiver-bg.png'; // Your mockup image

function CaregiversWelcomeBanner() {
  return (
    <Box
      sx={{
        position: 'relative',
        bgcolor: 'transparent',
        py: { xs: 7, md: 22 },
        overflow: 'hidden',
        minHeight: { md: 700 },
        background:
          'linear-gradient(120deg, #C3B1E1 60%, #A0C4FD 100%)',
      }}
    >
      {/* Decorative low-opacity background image */}
      <Box
        component="img"
        src={caregiverbg}
        alt="Caregiver using a tablet"
        sx={{
            position: 'absolute',
            top: 0,
            left: 0,
            width: '100%',
            height: '150%',
            backgroundImage: `url(${caregiverbg})`,
            backgroundPosition: 'center',
            backgroundSize: 'cover',
            backgroundRepeat: 'no-repeat',
            opacity: 0.6,  // Adjust opacity here
            zIndex: 0,
          }}
      />
      <Container sx={{ position: 'relative', zIndex: 1, top: 10 }}>
        <Grid container spacing={4} alignItems="center" >
          <Grid item xs={12} md={7}>
            <Typography
              variant="h2"
              sx={{
                color: 'primary.main',
                fontWeight: 800,
                fontSize: { xs: 30, md: 75 },
                mb: 2,
                fontFamily: 'Poppins Bold',
                letterSpacing: 1,
                
              }}
            >
              Support for Those Who Give Their All
            </Typography>
            <Typography
              variant="h5"
              sx={{
                color: '#ffffffff',
                fontWeight: 500,
                fontSize: { xs: 18, md: 28 },
                mb: 3,
                fontFamily: 'Poppins Regular',
              }}
            >
              Tools, insights, and care coordination at your fingertips. You care for others! let Memora care for you.
            </Typography>
            <Stack direction="row" spacing={2} mt={2}>
              <Button
                variant="contained"
                color="deep"
                size="large"
                sx={{ borderRadius: 8, fontWeight: 700, px: 4,fontFamily: 'Roboto', fontSize: 18 }}
              >
                Start Free Trial
              </Button>
              <Button
                variant="outlined"
                color="deep"
                size="large"
                sx={{ borderRadius: 8, fontWeight: 700, px: 4,fontFamily: 'Roboto', fontSize: 18 }}
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
            {/* <Box
              component="img"
              src={caregiverbg}
              alt="Caregiver using a tablet"
              sx={{
                        position: 'absolute',
                        top: 0,
                        left: 0,
                        width: '100%',
                        height: '100%',
                        backgroundImage: `url(${caregiverbg})`,
                        backgroundPosition: 'center',
                        backgroundSize: 'cover',
                        backgroundRepeat: 'no-repeat',
                        opacity: 0.6,  // Adjust opacity here
                        zIndex: 0,
                      }}
            /> */}

          </Grid>
        </Grid>
      </Container>
    </Box>
  );
}

export default CaregiversWelcomeBanner;

