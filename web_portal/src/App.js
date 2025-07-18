// src/App.js
import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import { ThemeProvider, CssBaseline } from '@mui/material';
import theme from './theme';
import Home from './components/home/Home';
import ForPatientsPage from './components/for_patients/ForPatientsPage';
import ForGuardiansPage from './components/for_guardians/ForGuardiansPage';
import ForCaregiversPage from './components/for_caregivers/ForCaregiversPage';
import ForVolunteersPage from './components/for_volunteers/ForVolunteersPage'; 
import ContactUsPage from './components/contact_us/ContactUsPage'; 

function App() {
     console.log('App component rendered'); 
  return (
    <ThemeProvider theme={theme}>
      <CssBaseline />
      <Router>
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/for_patients" element={<ForPatientsPage />} />
          <Route path="/for_guardians" element={<ForGuardiansPage />} />
          <Route path="/for_caregivers" element={<ForCaregiversPage />} />
          <Route path="/for_volunteers" element={<ForVolunteersPage />} />
          <Route path="/contact_us" element={<ContactUsPage />} />

          {/* Add other routes as needed */}
        </Routes>
      </Router>
    </ThemeProvider>
  );
}

export default App;
