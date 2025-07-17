import React from 'react';
import Navbar from '../home/Navbar';
import Footer from '../home/Footer';
import ContactIntroBanner from './ContactIntroBanner';
import ContactFormSection from './ContactFormSection';
import ContactInfoCards from './ContactInfoCards';
import ContactSupportMission from './ContactSupportMission';
import { Box } from '@mui/material';

function ContactUsPage() {
  return (
    <>
      <Navbar />
      <Box component="main" sx={{ bgcolor: '#fafdff', minHeight: '100vh' }}>
        <ContactIntroBanner />
        <ContactFormSection />
        <ContactInfoCards />
        <ContactSupportMission />
      </Box>
      <Footer />
    </>
  );
}

export default ContactUsPage;
