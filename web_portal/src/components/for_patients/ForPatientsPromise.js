// src/components/ForPatientsPromise.js
import React from 'react';
import { Box, Typography, Container, Stack, Button } from '@mui/material';
import CheckCircleIcon from '@mui/icons-material/CheckCircle';
import SmartphoneIcon from '@mui/icons-material/Smartphone';
// Replace with your actual screenshot path or use a beautiful relevant visual!
import appScreenshot from '../../assets/memora-app-screenshot.png';

function ForPatientsPromise() {
  return (
    <Box
      sx={{
        py: { xs: 7, md: 10 },
        px: 0,
        background: 'linear-gradient(100deg, #C3B1E1 68%, #A0C4FD 100%)',
        position: 'relative',
        overflow: 'hidden',
      }}
    >
      {/* Soft decorative background icon, faint for subtle depth */}
      <CheckCircleIcon
        sx={{
          position: 'absolute',
          fontSize: { xs: 140, md: 220 },
          color: '#A0C4FD',
          opacity: 0.10,
          left: { xs: -40, md: 80 },
          top: { xs: 20, md: -40 },
          zIndex: 0,
          pointerEvents: 'none',
        }}
        aria-hidden="true"
      />
      <Container sx={{ position: 'relative', zIndex: 1 }}>
        <Box
          sx={{
            bgcolor: '#fff',
            borderRadius: 5,
            p: { xs: 3, md: 5 },
            boxShadow: '0 8px 48px 0 rgba(44,62,80,0.09), 0 2px 6px 0 rgba(57,7,151,0.09)',
            maxWidth: 830,
            mx: 'auto',
            textAlign: 'center',
            border: '2px solid #C3B1E133',
            position: 'relative',
            overflow: 'visible',
          }}
        >
          <Typography
            variant="h5"
            sx={{
              color: '#390797',
              fontWeight: 700,
              fontSize: { xs: 22, md: 34 },
              fontFamily: 'Poppins Bold',
              mb: { xs: 2.5, md: 3 },
              letterSpacing: 0.1,
              textShadow: '0 2px 18px rgba(160,196,253,0.12)',
            }}
          >
            YOU'RE NOT ALONE...
            <br />
            <span style={{ color: '#2B3F99', fontWeight: 800 }}>
              Memora ensures your care journey is supported with dignity and simplicity.
            </span>
          </Typography>

          {/* Memora App Promotion */}
          <Stack
            direction={{ xs: 'column', md: 'row' }}
            spacing={3}
            alignItems="center"
            justifyContent="center"
            sx={{ mt: { xs: 2.5, md: 4 } }}
          >
            {/* Icon or badge, left */}
            <Box
              sx={{
                bgcolor: 'linear-gradient(120deg, #7dafffff 50%, #986ae1ff 100%)',
                borderRadius: '60%',
                width: 70,
                height: 70,
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                border: '2.5px solid #C3B1E1',
                boxShadow: '0 2px 10px 0 rgba(160,196,253,0.16)',
                flexShrink: 0,
              }}
            >
              <SmartphoneIcon sx={{ color: '#2B3F99', fontSize: 38 }} />
            </Box>
            {/* Promo text and button, middle */}
            <Box sx={{ textAlign: { xs: 'center', md: 'left' }, flex: 1 }}>
              <Typography
                variant="subtitle1"
                sx={{
                  color: '#2B3F99',
                  fontWeight: 700,
                  fontSize: { xs: 18.5, sm: 22 },
                  fontFamily: 'Poppins Regular',
                  letterSpacing: 0.15,
                  mb: 1,
                }}
              >
                Try the Memora App!
              </Typography>
              <Typography
                variant="body2"
                sx={{
                  color: '#390797',
                  fontSize: { xs: 15, md: 19 },
                  mb: 1.5,
                  opacity: 0.82,
                  fontFamily: 'Poppins Regular',
                }}
              >
                One-tap check-ins, easy reminders, and peace of mind for you and your loved ones.  
              </Typography>
              <Button
                variant="contained"
                color="primary"
                sx={{ borderRadius: 4, fontWeight: 700, mt: 0.5, px: 3.6, py: 1.1, fontSize: 16 }}
                disableElevation
                href="#" // Place actual app download or info link here!
              >
                Download the App
              </Button>
            </Box>
            {/* Screenshot or promo image, right */}
            <Box
              component="img"
              src={appScreenshot}
              alt="Screenshot of Memora app"
              sx={{
                width: { xs: 100, md: 140 },
                height: 'auto',
                borderRadius: 3,
                boxShadow: '0 4px 18px 0 rgba(44,62,80,0.09)',
                ml: { xs: 0, md: 2 },
                mt: { xs: 2, md: 0 },
                display: 'block',
                objectFit: 'contain',
                background: '#F6F4FB',
              }}
            />
          </Stack>
        </Box>
      </Container>
    </Box>
  );
}

export default ForPatientsPromise;


