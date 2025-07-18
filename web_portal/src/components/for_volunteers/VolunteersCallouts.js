// src/components/for_volunteers/VolunteersCallouts.js
import React from 'react';
import { Box, Grid, Paper, Typography, Container } from '@mui/material';
import MenuBookIcon from '@mui/icons-material/MenuBook';
import ForumIcon from '@mui/icons-material/Forum';
import EventAvailableIcon from '@mui/icons-material/EventAvailable';

const callouts = [
  {
    icon: <MenuBookIcon sx={{ fontSize: 40, color: '#390797' }} />,
    title: 'Share Educational Content',
    desc: 'Create and share articles, guides, or videos to help families and caregivers.',
    bgcolor: 'rgba(160,196,253,0.13)',
  },
  {
    icon: <ForumIcon sx={{ fontSize: 40, color: '#2B3F99' }} />,
    title: 'Answer Questions',
    desc: 'Support others by answering questions in the community forum.',
    bgcolor: 'rgba(195,177,225,0.15)',
  },
  {
    icon: <EventAvailableIcon sx={{ fontSize: 40, color: '#A0C4FD' }} />,
    title: 'Offer Availability for Sessions',
    desc: 'Volunteer your time for Q&A sessions, workshops, or peer support.',
    bgcolor: 'rgba(43,63,153,0.08)',
  },
];

function VolunteersCallouts() {
  return (
    <Box sx={{ py: 7, bgcolor: '#fff' }}>
      <Container>
        <Grid container spacing={4} justifyContent="center">
          {callouts.map(({ icon, title, desc, bgcolor }) => (
            <Grid item xs={12} sm={6} md={4} key={title}>
              <Paper
                elevation={0}
                sx={{
                  p: 4,
                  borderRadius: 4,
                  bgcolor,
                  boxShadow: '0 2px 12px 0 rgba(44,62,80,0.06)',
                  textAlign: 'center',
                  height: '100%',
                  display: 'flex',
                  flexDirection: 'column',
                  alignItems: 'center',
                  justifyContent: 'center',
                  transition: 'transform 0.2s, box-shadow 0.2s',
                  '&:hover': {
                    transform: 'translateY(-6px) scale(1.03)',
                    boxShadow: '0 8px 32px 0 rgba(44,62,80,0.12)',
                  },
                }}
              >
                {icon}
                <Typography variant="h6" sx={{ mt: 2, color: '#2B3F99', fontWeight: 700, fontFamily: 'Poppins Medium', fontSize: 30 }}>
                  {title}
                </Typography>
                <Typography variant="body1" sx={{ mt: 1, color: '#390797', fontFamily: 'Poppins Regular', fontSize: 20}}>
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

export default VolunteersCallouts;
