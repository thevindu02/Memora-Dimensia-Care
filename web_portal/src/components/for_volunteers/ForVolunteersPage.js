// src/components/for_volunteers/ForVolunteersPage.js
import React from 'react';
import Navbar from '../home/Navbar';
import Footer from '../home/Footer';
import VolunteersIntroBanner from './VolunteersIntroBanner';
import VolunteersCallouts from './VolunteersCallouts';
import VolunteersFeatures from './VolunteersFeatures';
import VolunteersRecognition from './VolunteersRecognition';
import { Box } from '@mui/material';

function ForVolunteersPage() {
  return (
    <>
      <Navbar />
      <Box component="main" sx={{ bgcolor: '#fafdff', minHeight: '100vh' }}>
        <VolunteersIntroBanner />
        <VolunteersCallouts />
        <VolunteersFeatures />
        <VolunteersRecognition />
      </Box>
      <Footer />
    </>
  );
}

export default ForVolunteersPage;
