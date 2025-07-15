import React from 'react';
import { Box, Grid, Paper, Typography, Container, Button } from '@mui/material';
import EventAvailableIcon from '@mui/icons-material/EventAvailable';
import AssignmentIcon from '@mui/icons-material/Assignment';
import NotificationImportantIcon from '@mui/icons-material/NotificationImportant';
import InsightsIcon from '@mui/icons-material/Insights';

const tools = [
  {
    icon: <AssignmentIcon sx={{ fontSize: 38, color: '#2B3F99' }} />,
    title: 'Task Scheduling',
    desc: 'Plan daily routines with drag-and-drop ease.',
  },
  {
    icon: <EventAvailableIcon sx={{ fontSize: 38, color: '#C3B1E1' }} />,
    title: 'Appointment Logging',
    desc: 'Never miss a checkup—log and view all appointments in one calendar.',
  },
  {
    icon: <NotificationImportantIcon sx={{ fontSize: 38, color: '#390797' }} />,
    title: 'Health Risk Notifications',
    desc: 'Get proactive alerts if something seems off.',
  },
  {
    icon: <InsightsIcon sx={{ fontSize: 38, color: '#A0C4FD' }} />,
    title: 'Reports & Insights',
    desc: 'Visualize patient progress and share updates with families.',
  },
];

function CaregiversCoreTools() {
  return (
    <Box sx={{ py: 7, bgcolor: '#fff' }}>
      <Container>
        <Typography
          variant="h4"
          sx={{
            color: '#2B3F99',
            fontWeight: 700,
            mb: 4,
            textAlign: 'center',
            letterSpacing: 0.5,
          }}
        >
          Core Tools & Services
        </Typography>
        <Grid container spacing={4} justifyContent="center">
          {tools.map(({ icon, title, desc }) => (
            <Grid item xs={12} sm={6} md={3} key={title}>
              <Paper
                elevation={2}
                sx={{
                  p: 3,
                  borderRadius: 3,
                  textAlign: 'center',
                  bgcolor: '#F8F9FB',
                  height: '100%',
                  display: 'flex',
                  flexDirection: 'column',
                  alignItems: 'center',
                  boxShadow: '0 2px 12px 0 rgba(44,62,80,0.08)',
                  position: 'relative',
                  overflow: 'visible',
                }}
              >
                {icon}
                <Typography variant="h6" sx={{ mt: 2, color: '#2B3F99', fontWeight: 600 }}>
                  {title}
                </Typography>
                <Typography variant="body2" sx={{ mt: 1, color: '#390797', fontSize: 15 }}>
                  {desc}
                </Typography>
                <Button
                  variant="text"
                  color="primary"
                  size="small"
                  sx={{
                    mt: 2,
                    fontWeight: 600,
                    textTransform: 'none',
                    borderRadius: 2,
                    background: 'rgba(195,177,225,0.12)',
                    '&:hover': {
                      background: 'rgba(195,177,225,0.24)',
                    },
                  }}
                >
                  Quick Add
                </Button>
              </Paper>
            </Grid>
          ))}
        </Grid>
      </Container>
    </Box>
  );
}

export default CaregiversCoreTools;

