// src/App.js
import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { ThemeProvider, CssBaseline } from '@mui/material';
import theme from './theme';
import Home from './components/home/Home';
import ForPatientsPage from './components/for_patients/ForPatientsPage';
import ForGuardiansPage from './components/for_guardians/ForGuardiansPage';
import ForCaregiversPage from './components/for_caregivers/ForCaregiversPage';
import ForVolunteersPage from './components/for_volunteers/ForVolunteersPage'; 
import ContactUsPage from './components/contact_us/ContactUsPage'; 
import Terms from './components/home/Terms'; 
import PrivacyPolicy from './components/home/PrivacyPolicy';
import Community from './components/home/Community';
import VolunteerDashboard from './components/volunteer/VolunteerDashboard';
function App() {
     console.log('App component rendered'); 
  return (
    <ThemeProvider theme={theme}>
      <CssBaseline />
      <Router>
        <Routes>
          <Route path="/" element={<Navigate to="/home" replace />} />
          <Route path="/home" element={<Home />} />
          <Route path="/for_patients" element={<ForPatientsPage />} />
          <Route path="/for_guardians" element={<ForGuardiansPage />} />
          <Route path="/for_caregivers" element={<ForCaregiversPage />} />
          <Route path="/for_volunteers" element={<ForVolunteersPage />} />
          <Route path="/contact_us" element={<ContactUsPage />} />
          <Route path="/terms" element={<Terms />} />
          <Route path="/privacy_policy" element={<PrivacyPolicy />} />
          <Route path="/community" element={<Community />} />
          <Route path= "/volunteer" element= {<VolunteerDashboard/>}/>

          {/* Add other routes as needed */}
        </Routes>
      </Router>
    </ThemeProvider>
  );
}

export default App;
