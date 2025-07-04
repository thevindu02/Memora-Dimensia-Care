// src/App.js
import React from 'react';
import { ThemeProvider, CssBaseline, Box } from '@mui/material';
import theme from './theme';
import Navbar from './components/Navbar';
import HeroSection from './components/HeroSection';
import VisionMissionValues from './components/VisionMissionValues';
import AboutUs from './components/AboutUs';
import QuickNavigation from './components/QuickNavigation';
import AppPromo from './components/AppPromo';
import Footer from './components/Footer';

function App() {
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

export default App;

