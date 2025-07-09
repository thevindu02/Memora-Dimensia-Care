// src/components/for_guardians/ForGuardiansPage.js
import React from 'react';
import Navbar from '../home/Navbar';
import Footer from '../home/Footer';
import ForGuardiansHero from './ForGuardiansHero';
import ForGuardiansBenefits from './ForGuardiansBenefits';
import ForGuardiansFeatures from './ForGuardiansFeatures';
import ForGuardiansReassurance from './ForGuardiansReassurance';
import { Box } from '@mui/material';

function ForGuardiansPage() {
  return (
    <>
      <Navbar />
      <Box component="main" sx={{ bgcolor: '#fff', minHeight: '100vh' }}>
        <ForGuardiansHero />
        <ForGuardiansBenefits />
        <ForGuardiansFeatures />
        <ForGuardiansReassurance />
      </Box>
      <Footer />
    </>
  );
}

export default ForGuardiansPage;
