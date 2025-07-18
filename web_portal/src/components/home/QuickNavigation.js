// src/components/QuickNavigation.js
import React from 'react';
import { Box, Grid, Card, CardContent, Typography, Button, Container } from '@mui/material';
import ElderlyIcon from '@mui/icons-material/Elderly';
import FamilyRestroomIcon from '@mui/icons-material/FamilyRestroom';
import VolunteerActivismIcon from '@mui/icons-material/VolunteerActivism';
import Diversity3Icon from '@mui/icons-material/Diversity3';

const sections = [
  {
    icon: <ElderlyIcon sx={{ fontSize: 48, color: 'primary.main' }} />,
    title: 'For Patients',
    desc: 'Guidance and resources designed for dementia patients.',
    link: '/for_patients',
  },
  {
    icon: <VolunteerActivismIcon sx={{ fontSize: 48, color: 'accent.main' }} />,
    title: 'For Caregivers',
    desc: 'Practical advice, moniter patients and community for caregivers.',
    link: '/for_caregivers',
  },
  {
    icon: <FamilyRestroomIcon sx={{ fontSize: 48, color: 'secondary.main' }} />,
    title: 'For Guardians',
    desc: 'Support and information for guardians and loved ones.',
    link: '/for_guardians',
  },
  {
    icon: <Diversity3Icon sx={{ fontSize: 48, color: 'info.main' }} />,
    title: 'For Volunteers',
    desc: 'Get involved and make a difference in dementia care.',
    link: '/for_volunteers',
  },
];

function QuickNavigation() {
  return (
    <Box sx={{ py: 8, bgcolor: 'background.default' }}>
      <Container>
        <Typography variant="h4" sx={{ textAlign: 'center', mb: 4, color: 'primary.main', fontFamily: 'Poppins Bold', fontSize: 42 }}>
          Who We Serve
        </Typography>
        <Grid container spacing={4} justifyContent="center" alignItems="stretch" >
          {sections.map(section => (
            <Grid item xs={12} sm={6} md={3} key={section.title}>
              <Card elevation={2} sx={{ p: 3, borderRadius: 4, textAlign: 'center', maxHeight: 300, maxWidth:500 }}>
                <CardContent>
                  {section.icon}
                  <Typography variant="h6" sx={{ fontWeight: 600, mt: 2, fontFamily:'Poppins Medium', fontSize: 26}}>{section.title}</Typography>
                  <Typography variant="body2" sx={{ mb: 2,fontFamily:'Poppins Regular', fontSize:20 }}>{section.desc}</Typography>
                  <Button variant="outlined" color="primary" href={section.link}>
                    Read More
                  </Button>
                </CardContent>
              </Card>
            </Grid>
          ))}
        </Grid>
      </Container>
    </Box>
  );
}

export default QuickNavigation;
