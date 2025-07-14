import React from 'react';
import Navbar from '../home/Navbar';
import Footer from '../home/Footer';
import CaregiversWelcomeBanner from './CaregiversWelcomeBanner';
import CaregiversBenefits from './CaregiversBenefits';
import CaregiversCoreTools from './CaregiversCoreTools';
import CaregiversSupportSection from './CaregiversSupportSection';
import { Box } from '@mui/material';

function ForCaregiversPage() {
  return (
    <>
      <Navbar />
      <Box component="main" sx={{ bgcolor: '#f9fafe', minHeight: '100vh' }}>
        <CaregiversWelcomeBanner />
        <CaregiversBenefits />
        <CaregiversCoreTools />
        <CaregiversSupportSection />
      </Box>
      <Footer />
    </>
  );
}

export default ForCaregiversPage;

