// VisionMissionValues.js
import React from 'react';
import { Box, Grid, Card, CardContent, Typography, Container } from '@mui/material';
import EmojiObjectsIcon from '@mui/icons-material/EmojiObjects';
import FavoriteIcon from '@mui/icons-material/Favorite';
import Diversity3Icon from '@mui/icons-material/Diversity3';

const cards = [
  {
    icon: <EmojiObjectsIcon sx={{ fontSize: 50, color: 'primary.main' }} />,
    title: 'Vision',
    desc: 'A future where dementia care is accessible, connected, and compassionate.',
  },
  {
    icon: <FavoriteIcon sx={{ fontSize: 50, color: 'secondary.main' }} />,
    title: 'Mission',
    desc: 'To enhance the quality of life for dementia patients and caregivers through digital tools and community support.',
  },
  {
    icon: <Diversity3Icon sx={{ fontSize: 50, color: 'primary.main' }} />,
    title: 'Values',
    desc: 'Empathy, Trust, Inclusivity, Innovation, and Community are at the core of our mission.',
  },
];

function VisionMissionValues() {
  return (
    <Box sx={{ py: 8, bgcolor: 'background.default' }}>
      <Container>
        <Typography
          variant="h4"
          sx={{
            textAlign: 'center',
            mb: 2.5,
            color: '#2B3F99',
            fontFamily: 'Poppins Bold',
            fontWeight: 800,
            fontSize: 48,
            letterSpacing: 1,
          }}
        >
          Advancing Well-being Through Innovation
        </Typography>
        <Typography
          variant="h6"
          sx={{
            textAlign: 'center',
            mb: 7,
            color: '#390797',
            fontFamily: 'Poppins Regular',
            fontSize: { xs: 16, md: 28 },
            fontWeight: 500,
            opacity: 0.85,
            maxWidth: 640,
            mx: 'auto',
          }}
        >
          Empowering lives with compassionate technology for a healthier, happier tomorrow.
        </Typography>
        <Grid container spacing={4} justifyContent="center" alignItems="stretch" wrap="nowrap">
          {cards.map(({ icon, title, desc }) => (
            <Grid item xs={12} sm={6} md={3} key={title} sx={{ display: 'flex' }}> 
              <Card elevation={2} sx={{ p: 3, borderRadius: 4, bgcolor: 'accent.main', maxHeight: 300, maxWidth:550, transition: 'transform 0.2s, box-shadow 0.2s', '&:hover': {
                    transform: 'translateY(-6px) scale(1.03)',
                    boxShadow: '0 8px 32px 0 rgba(44,62,80,0.12)',
                  }}}>
                <CardContent>
                  <Box sx={{ mb: 2 }}>{icon}</Box>
                  <Typography variant="h5" sx={{ fontWeight: 600, mb: 1, fontFamily: 'Poppins Bold', fontSize: 30 }} noWrap>
                    {title}
                  </Typography>
                  <Typography variant="body1"sx={{ fontFamily: 'Poppins Regular', fontSize: 20}} >{desc}</Typography>
                </CardContent>
              </Card>
            </Grid>
          ))}
        </Grid>
      </Container>
    </Box>
  );
}

export default VisionMissionValues;

