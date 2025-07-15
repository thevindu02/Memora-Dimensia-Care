// src/App.js
import React from 'react';
import { ThemeProvider, CssBaseline, Box } from '@mui/material';
import theme from '../../theme';
import Navbar from './Navbar';
import HeroSection from './HeroSection';
import VisionMissionValues from './VisionMissionValues';
import AboutUs from './AboutUs';
import QuickNavigation from './QuickNavigation';
import AppPromo from './AppPromo';
import Footer from './Footer';

function Home() {
  return (
    <ThemeProvider theme={theme}>
      <CssBaseline />
      <Navbar />
      <Box component="main" sx={{ bgcolor: 'background.default' }}>
        <HeroSection />
        <VisionMissionValues />
        <AboutUs />
        <QuickNavigation />
        <AppPromo />
      </Box>
      <Footer />
    </ThemeProvider>
  );
}

export default Home;

