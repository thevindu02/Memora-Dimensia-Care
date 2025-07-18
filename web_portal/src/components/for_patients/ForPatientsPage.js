// src/components/ForPatientsPage.js
import React from 'react';
import { Box } from '@mui/material';
import Navbar from '../home/Navbar';
import Footer from '../home/Footer';
import ForPatientsIntroBanner from './ForPatientsIntroBanner';
import ForPatientsBenefits from './ForPatientsBenefits';
import ForPatientsFeatures from './ForPatientsFeatures';
import ForPatientsPromise from './ForPatientsPromise';


function ForPatientsPage() {
    console.log('ForPatientsPage rendered');
  return (
    <>
      <Navbar />
      <Box component="main" sx={{ bgcolor: '#fff', minHeight: '100vh' }}>
        <ForPatientsIntroBanner />
        <ForPatientsBenefits />
        <ForPatientsFeatures />
        <ForPatientsPromise />
      </Box>
      <Footer />
    </>
  );
}

export default ForPatientsPage;
// This component serves as the main page for patients, integrating various sections