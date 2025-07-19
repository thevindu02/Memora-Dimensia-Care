// src/components/for_volunteers/VolunteersFeatures.js
import React from 'react';
import { Box, Grid, Paper, Typography, Container } from '@mui/material';
import ArticleIcon from '@mui/icons-material/Article';
import GroupIcon from '@mui/icons-material/Group';
import TrendingUpIcon from '@mui/icons-material/TrendingUp';

const features = [
  {
    icon: <ArticleIcon sx={{ fontSize: 40, color: '#2B3F99' }} />,
    title: 'Submit Articles & Videos',
    desc: 'Share your expertise and help others learn with your original content.',
  },
  {
    icon: <GroupIcon sx={{ fontSize: 40, color: '#A0C4FD' }} />,
    title: 'Join Forums',
    desc: 'Collaborate, discuss, and grow together in a supportive space.',
  },
  {
    icon: <TrendingUpIcon sx={{ fontSize: 40, color: '#C3B1E1' }} />,
    title: 'Track Engagement',
    desc: 'See the impact of your contributions and connect with the community.',
  },
];

function VolunteersFeatures() {
  return (
    <Box sx={{ py: 7, bgcolor: '#fafdff', position: 'relative' }}>
      {/* Decorative low-opacity background image */}
      <Box
        sx={{
          position: 'absolute',
          right: -80,
          top: 0,
          width: 320,
          height: 320,
          background: `url('/assets/volunteer-features-bg.png') center/cover no-repeat`,
          opacity: 0.10,
          zIndex: 0,
        }}
      />
      <Container sx={{ position: 'relative', zIndex: 1 }}>
        <Typography
          variant="h4"
          sx={{
            color: '#2B3F99',
            fontWeight: 700,
            mb: 4,
            textAlign: 'center',
            letterSpacing: 0.5,
            fontFamily: 'Poppins Bold',
            fontSize: { xs: 30, md: 48 },
          }}
        >
          Contribution Features
        </Typography>
        <Grid container spacing={4} justifyContent="center">
          {features.map(({ icon, title, desc }) => (
            <Grid item xs={12} sm={6} md={4} key={title}>
              <Paper
                elevation={2}
                sx={{
                  p: 4,
                  borderRadius: 4,
                  bgcolor: '#fff',
                  boxShadow: '0 2px 12px 0 rgba(44,62,80,0.08)',
                  textAlign: 'center',
                  height: '100%',
                  display: 'flex',
                  flexDirection: 'column',
                  alignItems: 'center',
                  justifyContent: 'center',
                  position: 'relative',
                  overflow: 'visible',
                }}
              >
                {icon}
                <Typography variant="h6" sx={{ mt: 2, color: '#2B3F99', fontWeight: 600, fontFamily: 'Poppins Medium', fontSize: 30 }}>
                  {title}
                </Typography>
                <Typography variant="body2" sx={{ mt: 1, color: '#390797', fontFamily: 'Poppins Regular', fontSize: 20 }}>
                  {desc}
                </Typography>
              </Paper>
            </Grid>
          ))}
        </Grid>
      </Container>
    </Box>
  );
}

export default VolunteersFeatures;
