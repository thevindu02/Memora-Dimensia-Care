// src/components/AboutUs.js
import React from 'react';
import { Box, Typography, Container, Stack } from '@mui/material';
import aboutImg from '../assets/about.png'; // Use your actual file name


function AboutUs() {
  return (
    <Box id="about" sx={{ py: 8, bgcolor: 'secondary.main' }}>
      <Container>
        <Stack direction={{ xs: 'column', md: 'row' }} spacing={6} alignItems="center">
          <Box flex={1}>
            <Typography variant="h3" sx={{ color: 'deep.main', mb: 2, fontFamily:'Poppins Bold', fontSize: 48 }}>
              About Memora
            </Typography>
            <Typography variant="body1" sx={{ color: 'text.primary', mb: 2, fontWeight: 510, fontSize: 20, fontFamily: 'Poppins' }}>
              Memora is a comprehensive cross-platform digital solution designed specifically with Sri Lankan communities in mind. We understand the unique challenges faced by families dealing with dementia patients and have created a platform that bridges the gap between technology and compassionate care.
            </Typography>
             <Typography variant="body1" sx={{ color: 'text.primary', mb: 2, fontWeight: 510, fontSize: 20, fontFamily: 'Poppins' }}>
              Our platform brings together patients, families, caregivers, and volunteers in a supportive digital ecosystem that promotes understanding, connection, and improved quality of life for everyone involved in the dementia care journey.
            </Typography>
          </Box>

<Box flex={1} sx={{ position: 'relative', display: 'flex', justifyContent: 'center', alignItems: 'center' }}>
  {/* Background shading (blue rounded rectangle) */}
  <Box
    sx={{position: 'absolute',
      top: 105,
      left: 110,
      width: 400,
      height: { xs: '90%', md: '85%' },
      bgcolor: '#2B3F99', 
      borderRadius: 4, 
      zIndex: 1,
    }}
  />
  {/* Foreground image */}
  <Box
    component="img"
    src={aboutImg}
    alt="About Memora"
    sx={{
      position: 'relative',
      width: '100%',
      height: '100%',
      maxWidth: 400,
      borderRadius: 4,
      boxShadow: 4,
      zIndex: 2,
      border: '2px solid #C3B1E1', 
    }}
  />
</Box>

        </Stack>
      </Container>
    </Box>
  );
}

export default AboutUs;
