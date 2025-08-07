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
import VolunteerRoutes from './components/volunteer/VolunteerRoutes'; 
import VolunteerDashboard from './components/volunteer/VolunteerDashboard';
import CreateBlog from './components/volunteer/CreateBlog';
import ScheduleSession from './components/volunteer/ScheduleSession';
import QnAforum from './components/volunteer/QnAforum';
import VolunteerSettings from './components/volunteer/VolunteerSettings';
import ArticleDrafts from './components/volunteer/ArticleDrafts'; 
import Articles from './components/volunteer/Articles'; 
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
          <Route path= "/volunteer" element= {<VolunteerRoutes/>}/>
          <Route path="/VolunteerDashboard" element={<VolunteerDashboard />} />
          <Route path="/CreateBlog" element={<CreateBlog />} />
          <Route path="/ScheduleSession" element={<ScheduleSession />} />
          <Route path="/QnAforum" element={<QnAforum />} />
          <Route path= "/VolunteerSettings" element={<VolunteerSettings />} />
          <Route path="/ArticleDrafts" element={<ArticleDrafts />} />
          <Route path="/Articles" element={<Articles />} />

        </Routes>
      </Router>
    </ThemeProvider>
  );
}

export default App;
