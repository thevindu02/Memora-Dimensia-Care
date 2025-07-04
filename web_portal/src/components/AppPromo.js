import React from 'react';
import { Box, Typography, Button, Container, Stack } from '@mui/material';
import PhoneIphoneIcon from '@mui/icons-material/PhoneIphone';

// Use your local asset or the provided URL
import mobileMockup from '../assets/mobile-mockup.png';
// Or, if you want to use the provided URL directly:
// const mobileMockup = "https://pplx-res.cloudinary.com/image/private/user_uploads/62025049/950c7ee5-6839-4b11-9ce4-c3678f9079f5/mobile-mockup.jpg";

function AppPromo() {
  return (
    <Box
      sx={{
        py: 8,
        bgcolor: 'accent.main',
        background: 'linear-gradient(135deg, #C3B1E1 60%, #A0C4FD 100%)',
      }}
    >
      <Container>
        <Stack
          direction={{ xs: 'column', md: 'row' }}
          spacing={6}
          alignItems="center"
          justifyContent="center"
        >
          {/* Left side: Text and button */}
          <Box flex={1} sx={{ minWidth: 280 }}>
            <Typography
              variant="h4"
              sx={{
                color: 'primary.main',
                mb: 2,
                fontWeight: 700,
                fontFamily: 'Poppins Bold',
                fontSize: { xs: 32, md: 48 },
              }}
            >
              Take Memora With You! Care Anywhere, Anytime
            </Typography>
            <Typography
              variant="body1"
              sx={{
                mb: 3,
                color: 'info.main',
                fontSize: 20,
                fontFamily: 'Poppins Regular',
              }}
            >
              Access Memora on your mobile device for instant support, resources, and community, wherever you are.
            </Typography>
            <Button
              variant="contained"
              color="primary"
              size="large"
              startIcon={<PhoneIphoneIcon />}
              sx={{
                borderRadius: 8,
                px: 4,
                fontWeight: 600,
                fontSize: 18,
                boxShadow: 3,
                fontFamily: 'Roboto',
              }}
            >
              Download the App
            </Button>
          </Box>
          {/* Right side: Mobile mockup image */}
          <Box
            flex={1}
            sx={{
              display: 'flex',
              justifyContent: 'center',
              alignItems: 'center',
              minWidth: 280,
              py: { xs: 4, md: 0 },
            }}
          >
            <Box
              component="img"
              src={mobileMockup}
              alt="Memora App"
              sx={{
                width: { xs: '100%', md: 450 },
                maxWidth: 500,
                borderRadius: 7,
                boxShadow: '0 8px 32px 0 rgba(57, 7, 151, 0.25), 0 1.5px 4px 0 rgba(44, 62, 80, 0.08)',
                background: '#fff',
                objectFit: 'contain',
                p: 1,
              }}
            />
          </Box>
        </Stack>
      </Container>
    </Box>
  );
}

export default AppPromo;

