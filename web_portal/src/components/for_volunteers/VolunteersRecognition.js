// src/components/for_volunteers/VolunteersRecognition.js
import React from 'react';
import { Box, Typography, Container, Grid, Paper, Stack, Button } from '@mui/material';
import EmojiEventsIcon from '@mui/icons-material/EmojiEvents';
import VolunteerActivismIcon from '@mui/icons-material/VolunteerActivism';
// import vcom from '../../assets/volunteer-community.png'; // Adjust the path as necessary

function VolunteersRecognition() {
  return (
    <Box
      sx={{
        py: 8,
        bgcolor: 'linear-gradient(120deg, #C3B1E1 60%, #A0C4FD 100%)',
        borderRadius: { xs: 0, md: '32px' },
        mt: 6,
        position: 'relative',
        overflow: 'hidden',
      }}
    >
      {/* Decorative low-opacity background image */}
      <Box
        sx={{
          position: 'absolute',
          left: -80,
          bottom: -60,
          width: 320,
          height: 320,
          background: `url('/assets/volunteer-recognition-bg.png') center/cover no-repeat`,
          opacity: 0.10,
          zIndex: 0,
        }}
      />
      <Container sx={{ position: 'relative', zIndex: 1 }}>
        <Grid container spacing={4} alignItems="center">
          <Grid item xs={12} md={7}>
            <Paper
              elevation={0}
              sx={{
                bgcolor: '#fff',
                borderRadius: 4,
                p: { xs: 3, md: 5 },
                boxShadow: '0 2px 12px 0 rgba(44,62,80,0.10)',
                textAlign: 'left',
                display: 'flex',
                flexDirection: 'column',
                gap: 2,
                alignItems: 'flex-start',
              }}
            >
              <Stack direction="row" alignItems="center" spacing={2} mb={2}>
                <VolunteerActivismIcon sx={{ fontSize: 44, color: '#390797' }} />
                <Typography
                  variant="h5"
                  sx={{
                    color: '#2B3F99',
                    fontWeight: 700,
                    fontSize: { xs: 20, md: 38 },
                    fontFamily: 'Poppins Bold',
                  }}
                >
                  Every contribution counts be part of a kinder care ecosystem.
                </Typography>
              </Stack>
              <Typography variant="body1" sx={{ color: '#390797', mb: 2, fontSize: 25, fontFamily: 'Poppins Regular'  }}>
                Your time, knowledge, and compassion help families and caregivers thrive. Earn recognition, connect with like-minded volunteers, and see the impact you make.
              </Typography>
              <Stack direction="row" spacing={2}>
                <Button variant="contained" color="primary" sx={{ borderRadius: 8,fontFamily: 'Roboto', fontSize: 18 }}>
                  Start Contributing
                </Button>
                <Button variant="outlined" color="primary" sx={{ borderRadius: 8,fontFamily: 'Roboto', fontSize: 18 }}>
                  Meet the Community
                </Button>
              </Stack>
              <Stack direction="row" alignItems="center" spacing={2} mt={3}>
                <EmojiEventsIcon sx={{ fontSize: 32, color: '#A0C4FD' }} />
                <Typography variant="subtitle2" sx={{ color: '#2B3F99', fontWeight: 700, fontSize: { xs: 18, md: 24 }, fontFamily: 'Poppins Regular' }}>
                  Top Volunteer of the Month: Thevindu Dilmith
                </Typography>
              </Stack>
            </Paper>
          </Grid>
          <Grid item xs={12} md={5} sx={{ textAlign: 'center' }}>
            {/* <Box
              component="img"
              src= {vcom}
              alt="Volunteer community"
              sx={{
                width: { xs: '80%', md: 320 },
                maxWidth: 350,
                borderRadius: 6,
                boxShadow: 3,
                background: '#fff',
                p: 1,
              }}
            /> */}
          </Grid>
        </Grid>
      </Container>
    </Box>
  );
}

export default VolunteersRecognition;
