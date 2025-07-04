import React from 'react';
import { Box, Typography, Button, Container, Stack } from '@mui/material';
import { Link as ScrollLink } from 'react-scroll';
import heroBg from '../assets/bg.png';

function HeroSection() {
  return (
    <Box
      id="hero"
      sx={{
        position: 'relative', // Important for overlay positioning
        minHeight: { xs: 500, md: 700 },
        display: 'flex',
        alignItems: 'center',
        // bgcolor: 'accent.main',
        color: 'text.primary',
        py: { xs: 6, md: 10 },
        overflow: 'hidden',
      }}
    >
      {/* Background image with opacity */}
      <Box
        sx={{
          position: 'absolute',
          top: 0,
          left: 0,
          width: '100%',
          height: '100%',
          backgroundImage: `url(${heroBg})`,
          backgroundPosition: 'center',
          backgroundSize: 'cover',
          backgroundRepeat: 'no-repeat',
          opacity: 0.6,  // Adjust opacity here
          zIndex: 0,
        }}
      />

      {/* Content above background */}
      <Container sx={{ position: 'relative', zIndex: 1 }}>
        <Stack direction={{ xs: 'column', md: 'row' }} spacing={6} alignItems="center">
          <Box flex={1}>
            <Typography
              variant="h2"
              component="h1"
              sx={{
                color: 'primary.main',
                mb: 2,
                textAlign: 'left',
                fontFamily: 'Poppins Bold',
                fontSize: 75,
              }}
            >
              Supporting Dementia Care with Compassion and Technology
            </Typography>
            <Typography
              variant="h5"
              sx={{
                color: 'deep.main',
                mb: 4,
                textAlign: 'left',
                fontFamily: 'Poppins',
                fontSize: 28,
              }}
            >
              Memora empowers families, caregivers, and patients to live better, together.
            </Typography>
            <ScrollLink to="about" smooth duration={600}>
              <Button variant="contained" size="large" color="deep" sx={{ px: 5 }}>
                Learn More
              </Button>
            </ScrollLink>
          </Box>
          {/* Optional right-side content */}
        </Stack>
      </Container>
    </Box>
  );
}

export default HeroSection;

