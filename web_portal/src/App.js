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
import VolunteerSettings from './components/volunteer/VolunteerSettings';
import ArticleDrafts from './components/volunteer/ArticleDrafts'; 
import Articles from './components/volunteer/Articles'; 
import PublishedArticles from './components/volunteer/PublishedArticles'; 
import ViewArticle from './components/volunteer/ViewArticle'; 
import SingleArticle from './components/volunteer/SingleArticle';
import ViewDraft from './components/volunteer/ViewDraft';
import EditDraft from './components/volunteer/EditDraft';
import VolunteerProfile from './components/volunteer/VolunteerProfile';
import VolunteerSignup from './components/volunteer/VolunteerSignup';
import VolunteerRegistrationSubmittedScreen from './components/volunteer/VolunteerRegistrationSubmittedScreen';
import VolunteerRegistrationCompletedScreen from './components/volunteer/VolunteerRegistrationCompletedScreen';
import ForgetPassword from './components/volunteer/ForgetPassword';
import SignIn from './components/volunteer/SignIn';
import VolunteerPrivacy from './components/volunteer/VolunteerPrivacy';
import HelpAndSupport from './components/volunteer/HelpAndSupport';


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
          <Route path= "/VolunteerSettings" element={<VolunteerSettings />} />
          <Route path="/ArticleDrafts" element={<ArticleDrafts />} />
          <Route path="/Articles" element={<Articles />} />
          <Route path="/PublishedArticles" element={<PublishedArticles />} />
          <Route path="/ViewArticle/:id" element={<ViewArticle />} />
          <Route path="/volunteer/articles" element={<Articles />} />
          <Route path="/volunteer/articles/:id" element={<SingleArticle />} />
          <Route path="/ViewDraft/:id" element={<ViewDraft />} />
          <Route path="/EditDraft/:id" element={<EditDraft />} />
          <Route path="/VolunteerProfile" element={<VolunteerProfile />} />
          <Route path="/VolunteerSignup" element={<VolunteerSignup />} />
          <Route path="/VolunteerRegistrationSubmitted" element={<VolunteerRegistrationSubmittedScreen />} />
          <Route path="/VolunteerRegistrationComp leted" element={<VolunteerRegistrationCompletedScreen />} />
          <Route path="/ForgetPassword" element={<ForgetPassword />} />
          <Route path="/SignIn" element={<SignIn />} />
          <Route path="/VolunteerPrivacy" element={<VolunteerPrivacy />} />
          <Route path="/HelpAndSupport" element={<HelpAndSupport />} />

        </Routes>
      </Router>
    </ThemeProvider>
  );
}

export default App;
