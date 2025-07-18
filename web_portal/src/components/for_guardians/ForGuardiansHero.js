// src/components/for_guardians/ForGuardiansHero.js
import React from 'react';
import { Box, Typography, Container, Stack, Button } from '@mui/material';
import ShieldIcon from '@mui/icons-material/Shield';
import LiveHelpIcon from '@mui/icons-material/LiveHelp';
import guardianDashboard from '../../assets/guardian-dashboard.png'; // Your mockup image
// Optionally, use an abstract SVG shape as faint background
import guardiansBg from '../../assets/guardians-abstract-bg.png';

function ForGuardiansHero() {
  return (
    <Box
      sx={{
        position: 'relative',
        maxHeight: { md: 550, xs: 800 },
        py: { xs: 8, md: 11 },
        px: 0,
        background:
          'linear-gradient(120deg, #C3B1E1 67%, #A0C4FD 96%)',
        overflow: 'hidden',
        display: 'flex',
        alignItems: 'center',
      }}
    >
      {/* Abstract SVG or texture, softly layered, as decorator */}
      <Box
        component="img"
        src={guardiansBg}
        alt=""
        aria-hidden="true"
        sx={{
          position: 'absolute',
          right: -30,
          top: 2,
          width: { xs: 400, md: 590 },
          height: { xs: 400, md: 590 },
          opacity: 0.15,
          zIndex: 0,
          pointerEvents: 'none',
          userSelect: 'none',
        }}
      />

      {/* Optionally, use a faint repeating icon for guardian feeling */}
      <ShieldIcon
        sx={{
          position: 'absolute',
          right: { xs: -35, md: 60 },
          bottom: { xs: 4, md: -38 },
          fontSize: { xs: 140, md: 210 },
          color: '#A0C4FD',
          opacity: 0.11,
          zIndex: 0,
          pointerEvents: 'none',
        }}
        aria-hidden="true"
      />

      {/* Content */}
      <Container sx={{ position: 'relative', zIndex: 2 }}>
        <Stack
          direction={{ xs: 'column-reverse', md: 'row' }}
          spacing={8}
          alignItems="center"
          justifyContent="space-between"
        >
          {/* Text and Actions */}
          <Box flex={1} sx={{ textAlign: { xs: 'center', md: 'left' }, py: 1 }}>
            <Box
              sx={{
                display: 'flex',
                alignItems: 'center',
                mb: 0.8,
                flexDirection: { xs: 'column', sm: 'row' },
                gap: 2,
                justifyContent: { xs: 'center', md: 'flex-start' }
              }}
            >
              <ShieldIcon sx={{ fontSize: 64, color: '#390797', mr: { sm: 1, xs: 0 } }} />
              <Typography
                variant="h2"
                sx={{
                  fontFamily: 'Poppins Bold',
                  fontWeight: 800,
                  fontSize: 52,
                  color: '#390797',
                  lineHeight: 1.12,
                  letterSpacing: 0.5,
                  mb: 0,
                  textShadow: '0 2px 16px rgba(57,7,151,0.06)',
                  pt: { xs: 1, sm: 0 }
                }}
              >
                Stay Connected,  
                <Box component="span" sx={{ fontFamily: 'Poppins Bold', color: '#2B3F99', fontWeight: 800 }}> Stay Informed</Box>
              </Typography>
            </Box>
            <Typography
              variant="h5"
              sx={{
                fontFamily: 'Poppins Bold',
                color: '#2B3F99',
                fontWeight: 600,
                fontSize: 27,
                mt: 1,
                mb: 3.2,
                textShadow: '0 1.5px 6px rgba(44,62,80,0.08)',
              }}
            >
              Monitor, manage, and care, wherever you are.
            </Typography>
            <Box
              sx={{
                display: 'inline-flex',
                gap: 2,
                p: 1.4,
                bgcolor: 'rgba(255,255,255,0.18)',
                borderRadius: 5,
                boxShadow: '0 3px 15px rgba(160,196,253,0.10)',
                mb: { xs: 2, md: 0 },
                border: '1.5px solid #A0C4FD55',
                flexWrap: 'wrap',
              }}
            >
              <Button
                variant="contained"
                color="primary"
                size="large"
                sx={{
                  borderRadius: 8,
                  px: 4,
                  fontFamily: 'Roboto', 
                  fontSize: 18,
                  fontWeight: 700,
                  boxShadow: '0 6px 18px rgba(43,63,153,0.09)',
                }}
                startIcon={<LiveHelpIcon />}
              >
                Start Monitoring
              </Button>
              <Button
                variant="outlined"
                color="primary"
                size="large"
                sx={{
                  borderRadius: 8,
                  px: 4,
                  fontFamily: 'Roboto', 
                  fontSize: 18,
                  fontWeight: 700,
                  boxShadow: '0 2px 12px rgba(195,177,225,0.16)',
                  bgcolor: 'rgba(255,255,255,0.09)',
                  '&:hover': { bgcolor: 'rgba(195,177,225,0.13)' },
                }}
              >
                View Care Plans
              </Button>
            </Box>
          </Box>
          {/* Dashboard illustration, with floating badge */}
          <Box flex={1} sx={{ display: 'flex', justifyContent: 'center', alignItems: 'center', position: 'relative', minWidth: { xs: 220, md: 280 } }}>
            {/* Shadow ring accent */}
            <Box
              sx={{
                display: { xs: 'none', md: 'block' },
                position: 'absolute',
                bottom: -32,
                left: '50%',
                width: 180,
                height: 42,
                transform: 'translateX(-50%)',
                borderRadius: '50%',
                background: 'radial-gradient(circle,rgba(43,63,153, 0.13),transparent 85%)',
                zIndex: 1,
                filter: 'blur(6px)',
              }}
            />
            {/* Main guardian dashboard image */}
            <Box
              component="img"
              src={guardianDashboard}
              alt="Guardian dashboard view"
              sx={{
                width: { xs: '78%', md: 335 },
                maxWidth: 390,
                borderRadius: 7,
                boxShadow: '0 6px 32px 0 rgba(44,62,80,0.17)',
                background: '#fff',
                p: 1.7,
                position: 'relative',
                zIndex: 2,
                transition: 'box-shadow 0.15s',
                '&:hover': {
                  boxShadow: '0 10px 38px rgba(160,196,253,0.19), 0 2px 10px 0 rgba(57,7,151,0.12)',
                },
              }}
            />
            {/* Floating Guardian MUI icon badge */}
            {/* <Box
              sx={{
                position: 'absolute',
                top: -18,
                right: -18,
                width: 48,
                height: 48,
                borderRadius: '50%',
                background: 'linear-gradient(120deg,#2B3F99 55%,#C3B1E1 95%)',
                boxShadow: '0 4px 16px 0 rgba(160,196,253,0.19)',
                display: { xs: 'none', md: 'flex' },
                alignItems: 'center',
                justifyContent: 'center',
                zIndex: 3,
              }}
            >
              <ShieldIcon sx={{ color: '#fff', fontSize: 29 }} />
            </Box> */}
          </Box>
        </Stack>
      </Container>
    </Box>
  );
}

export default ForGuardiansHero;

