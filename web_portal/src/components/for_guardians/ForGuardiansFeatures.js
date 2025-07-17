// src/components/for_guardians/ForGuardiansFeatures.js
import React from 'react';
import { Box, Grid, Typography, Container, Paper } from '@mui/material';
import AssessmentIcon from '@mui/icons-material/Assessment';
import AssignmentTurnedInIcon from '@mui/icons-material/AssignmentTurnedIn';
import PersonAddAlt1Icon from '@mui/icons-material/PersonAddAlt1';
import ForumIcon from '@mui/icons-material/Forum';

const features = [
  {
    icon: <AssessmentIcon sx={{ fontSize: 40, color: '#390797' }} />,
    title: 'Real-Time Reports',
  },
  {
    icon: <AssignmentTurnedInIcon sx={{ fontSize: 40, color: '#2B3F99' }} />,
    title: 'Task Review',
  },
  {
    icon: <PersonAddAlt1Icon sx={{ fontSize: 40, color: '#A0C4FD' }} />,
    title: 'Connection Requests',
  },
  {
    icon: <ForumIcon sx={{ fontSize: 40, color: '#C3B1E1' }} />,
    title: 'Forum Access',
  },
];

function ForGuardiansFeatures() {
  return (
    <Box sx={{ py: 8, bgcolor: '#fff' }}>
      <Container>
        <Typography
          variant="h4"
          sx={{
            textAlign: 'center',
            mb:5,
            color: '#390797',
            fontFamily: 'Poppins Bold',
            fontWeight: 700,
            fontSize: 48,
            letterSpacing: 1,
          }}
        >
         Comprehensive Care Features
        </Typography>
        <Grid container spacing={4} justifyContent="center">
          {features.map(({ icon, title }) => (
            <Grid item xs={12} sm={6} md={3} key={title}>
              <Paper
                elevation={2}
                sx={{
                  p: 4,
                  borderRadius: 4,
                  textAlign: 'center',
                  bgcolor: '#F6F4FB',
                  minHeight: 160,
                  display: 'flex',
                  flexDirection: 'column',
                  alignItems: 'center',
                  justifyContent: 'center',
                }}
              >
                {icon}
                <Typography variant="h6" sx={{ mt: 2, color: '#2B3F99', fontWeight: 600 }}>
                  {title}
                </Typography>
              </Paper>
            </Grid>
          ))}
        </Grid>
      </Container>
    </Box>
  );
}

export default ForGuardiansFeatures;
