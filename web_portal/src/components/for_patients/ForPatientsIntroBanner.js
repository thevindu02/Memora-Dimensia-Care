// src/components/for_patients/ForPatientsIntroBanner.js
import React from 'react';
import { Box, Typography, Container, Stack } from '@mui/material';
import patientIllustration from '../../assets/patient-illustration.png'; // SVG or PNG
import patientIllustrationbg from '../../assets/bg-abstract-patients.jpg'; // Soft background abstract shape
import CheckCircleIcon from '@mui/icons-material/CheckCircle';

function ForPatientsIntroBanner() {
  return (
    <Box
      sx={{
        position: 'relative',
        py: { xs: 8, md: 11 },
        background: 'linear-gradient(100deg,#C3B1E1 65%, #A0C4FD 100%)',
        overflow: 'hidden',
        minHeight: { xs: 350, md: 430 },
      }}
    >
      {/* Soft abstract background shape, low opacity */}
      <Box
        component="img"
        src={patientIllustrationbg}
        alt="" // Decorative only
        aria-hidden="true"
        sx={{
          position: 'absolute',
          right: { xs: -90, md: -100 },
          top: { xs: -38, md: -45 },
          width: { xs: 340, md: 500 },
          height: 450,
          opacity: 0.17,
          zIndex: 0,
          pointerEvents: 'none',
          userSelect: 'none',
        }}
      />
      <Container sx={{ position: 'relative', zIndex: 1 }}>
        <Stack
          direction={{ xs: 'column', md: 'row' }}
          spacing={8}
          alignItems="center"
          justifyContent="space-between"
        >
          <Box flex={1} sx={{ py: 2 }}>
            <Typography
              variant="h2"
              sx={{
                color: '#2d047aff',
                fontWeight: 800,
                lineHeight: 1.13,
                fontSize: { xs: 32, md: 52 },
                mb: 2,
                fontFamily: 'Poppins Bold',
                letterSpacing: 0.7,
                textShadow: '0 3px 22px rgba(57,7,151,0.09), 0 1.5px 6px rgba(42,56,120, 0.13)',
              }}
            >
              Empowering You&nbsp;<br />to Live with Confidence
            </Typography>
            <Typography
              variant="h5"
              sx={{
                color: '#2B3F99',
                fontWeight: 700,
                fontSize: { xs: 19, md: 27 },
                mb: 3,
                mt: 1,
                letterSpacing: 0.1,
                textShadow: '0 2px 15px rgba(43,63,153, 0.09)',
                fontFamily: 'Poppins Medium',
              }}
            >
              Gentle reminders, safe monitoring,<br />
              and simplified tools, designed just for you.
            </Typography>
            <Box
              sx={{
                mt: 3,
                display: 'inline-block',
                py: 1.3,
                px: 1.5,
                bgcolor: 'rgba(160,196,253,0.22)',
                borderRadius: 3,
                boxShadow: '0 2px 8px rgba(160,196,253,0.12)',
                fontWeight: 500,
                color: '#390797',
                letterSpacing: 0.05,
                fontSize: { xs: 16.5, md: 18 },
                fontFamily: 'Poppins Regular',
                backdropFilter: 'blur(1.5px)',
              }}
            >
              New! One-tap check-ins available with Memora mobile app.
            </Box>
          </Box>
          <Box flex={1} sx={{ display: 'flex', minWidth: 220, justifyContent: 'center' }}>
            <Box sx={{ position: 'relative', display: 'inline-block' }}>
              {/* Faint shadow ring below illustration */}
              <Box
                sx={{
                  display: { xs: 'none', md: 'block' },
                  position: 'absolute',
                  bottom: -30,
                  left: '50%',
                  width: 210,
                  height: 50,
                  transform: 'translateX(-50%)',
                  borderRadius: '50%',
                  background: 'radial-gradient(circle,rgba(43,63,153, 0.12),transparent 80%)',
                  zIndex: 1,
                  filter: 'blur(6px)',
                  pointerEvents: 'none',
                  userSelect: 'none',
                }}
              />
              {/* Patient illustration */}
              <Box
                component="img"
                src={patientIllustration}
                alt="Patient using mobile app"
                sx={{
                  width: { xs: '80%', md: 340 },
                  maxWidth: 390,
                  borderRadius: 7,
                  boxShadow: '0 8px 34px 0 rgba(44,62,80,0.22)',
                  background: '#fff',
                  p: 1.5,
                  zIndex: 2,
                  position: 'relative',
                  transition: 'box-shadow 0.15s',
                  '&:hover': {
                    boxShadow: '0 10px 38px rgba(160,196,253,0.23), 0 2px 10px 0 rgba(57,7,151,0.13)',
                  },
                }}
              />
              {/* Decorative floating badge icon */}
              <Box
                sx={{
                  position: 'absolute',
                  top: -22,
                  right: -15,
                  width: 50,
                  height: 50,
                  borderRadius: '50%',
                  background: 'linear-gradient(120deg,#A0C4FD 55%,#C3B1E1 95%)',
                  boxShadow: '0 4px 16px 0 rgba(160,196,253,0.23)',
                  display: { xs: 'none', md: 'flex' },
                  alignItems: 'center',
                  justifyContent: 'center',
                }}
              >
                <CheckCircleIcon sx={{ color: '#2B3F99', fontSize: 28 }} />
              </Box>
            </Box>
          </Box>
        </Stack>
      </Container>
    </Box>
  );
}

export default ForPatientsIntroBanner;


