import React from 'react';
import { Box, Typography, Container, Grid, Paper, Avatar, Stack, Button } from '@mui/material';
import GroupIcon from '@mui/icons-material/Group';

function CaregiversSupportSection() {
  return (
    <Box
      sx={{
        py: 8,
        bgcolor: 'linear-gradient(120deg, #A0C4FD 60%, #C3B1E1 100%)',
        borderRadius: { xs: 0, md: '32px' },
        mt: 6,
        position: 'relative',
        overflow: 'hidden',
      }}
    >
      {/* Decorative background image with low opacity */}
      <Box
        sx={{
          position: 'absolute',
          left: -80,
          bottom: -60,
          width: 320,
          height: 320,
          background: `url('/assets/support-bg-abstract.png') center/cover no-repeat`,
          opacity: 0.12,
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
                <GroupIcon sx={{ fontSize: 44, color: '#390797' }} />
                <Typography
                  variant="h5"
                  sx={{
                    color: '#2B3F99',
                    fontWeight: 700,
                    fontSize: { xs: 20, md: 26 },
                  }}
                >
                  “We’re here for you—because caregivers need care too.”
                </Typography>
              </Stack>
              <Typography variant="body1" sx={{ color: '#390797', mb: 2 }}>
                Join our supportive community, access 24/7 chat, and discover tips for caregiver wellness. Your well-being is just as important as those you care for.
              </Typography>
              <Stack direction="row" spacing={2} alignItems="center" mb={2}>
                <Avatar
                  src="/assets/caregiver-avatar.jpg"
                  alt="Priya"
                  sx={{ width: 48, height: 48 }}
                />
                <Box>
                  <Typography variant="subtitle2" sx={{ color: '#2B3F99', fontWeight: 700 }}>
                    “Memora helped me feel less alone and more confident in my caregiving journey.”
                  </Typography>
                  <Typography variant="caption" sx={{ color: '#390797' }}>
                    — Priya, Caregiver
                  </Typography>
                </Box>
              </Stack>
              <Stack direction="row" spacing={2}>
                <Button variant="contained" color="primary" sx={{ borderRadius: 8 }}>
                  Join the Community
                </Button>
                <Button variant="outlined" color="primary" sx={{ borderRadius: 8 }}>
                  Explore Self-Care Tips
                </Button>
              </Stack>
            </Paper>
          </Grid>
          <Grid item xs={12} md={5} sx={{ textAlign: 'center' }}>
            <Box
              component="img"
              src="/assets/caregiver-support-group.jpg"
              alt="Caregiver support group"
              sx={{
                width: { xs: '80%', md: 320 },
                maxWidth: 350,
                borderRadius: 6,
                boxShadow: 3,
                background: '#fff',
                p: 1,
              }}
            />
          </Grid>
        </Grid>
      </Container>
      {/* CTA Banner */}
      <Container sx={{ mt: 8 }}>
        <Paper
          elevation={0}
          sx={{
            bgcolor: 'rgba(160,196,253,0.7)',
            borderRadius: 3,
            py: { xs: 4, md: 5 },
            px: { xs: 2, md: 8 },
            textAlign: 'center',
            boxShadow: '0 2px 12px 0 rgba(44,62,80,0.10)',
            backdropFilter: 'blur(2px)',
          }}
        >
          <Typography
            variant="h5"
            sx={{
              color: '#2B3F99',
              fontWeight: 800,
              mb: 2,
              fontSize: { xs: 22, md: 28 },
              letterSpacing: 0.5,
            }}
          >
            Ready to Transform Your Caregiving Experience?
          </Typography>
          <Typography
            variant="subtitle1"
            sx={{
              color: '#390797',
              mb: 3,
              fontSize: 18,
              opacity: 0.9,
            }}
          >
            Start your free trial today and see how Memora can make a difference for you and those you care for.
          </Typography>
          <Stack direction={{ xs: 'column', sm: 'row' }} spacing={2} justifyContent="center">
            <Button
              variant="contained"
              color="primary"
              size="large"
              sx={{
                borderRadius: 8,
                fontWeight: 700,
                px: 5,
                boxShadow: '0 4px 24px 0 rgba(44,62,80,0.14)',
              }}
            >
              Start Free Trial
            </Button>
            <Button
              variant="outlined"
              color="primary"
              size="large"
              sx={{
                borderRadius: 8,
                fontWeight: 700,
                px: 5,
              }}
            >
              Contact Support
            </Button>
          </Stack>
        </Paper>
      </Container>
    </Box>
  );
}

export default CaregiversSupportSection;

