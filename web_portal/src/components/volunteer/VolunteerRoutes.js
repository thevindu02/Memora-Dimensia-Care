// src/components/volunteers/VolunteerRoutes.js
import React, { useState } from 'react';
import { Box } from '@mui/material';

import VolunteerDashboard from './VolunteerDashboard';
import CreateBlog from './CreateBlog';
import ScheduleSession from './ScheduleSession';
import VolunteerSettings from './VolunteerSettings';
import ArticleDrafts from './ArticleDrafts'; 
import Articles from './Articles'; 
import PublishedArticles from './PublishedArticles'; 
import ViewArticle from './ViewArticle'; 
import VolunteerProfile from './VolunteerProfile';
import VolunteerSignup from './VolunteerSignup';
import VolunteerRegistrationCompletedScreen from './VolunteerRegistrationCompletedScreen';
import VolunteerRegistrationSubmittedScreen from './VolunteerRegistrationSubmittedScreen';
import ForgetPassword from './ForgetPassword';
import SignIn from './SignIn'; 
import VolunteerPrivacy from './VolunteerPrivacy';
import HelpAndSupport from './HelpAndSupport';


export default function VolunteerRoutes() {
  const [currentPage, setCurrentPage] = useState('Dashboard');

  const handleNavigate = (page) => {
    setCurrentPage(page);
  };

  // Volunteer info to pass to Dashboard (sidebar inside it reads these)
  const volunteerName = "Amanda Nethmini";
  const volunteerProfileImage = "https://randomuser.me/api/portraits/women/44.jpg";

  return (
    <>
      {/* Render navigation bar once around all content if needed */}
      {/* <VolunteerNav />  -- Moved inside Dashboard component */}

      <Box sx={{ minHeight: '100vh', position: 'relative' }}>
        {currentPage === 'Dashboard' && (
          <VolunteerDashboard
            volunteerName={volunteerName}
            volunteerProfileImage={volunteerProfileImage}
            onNavigate={handleNavigate}
          />
        )}
        {/* {currentPage === 'Dashboard' && <VolunteerDashboard />} */}
        {currentPage === 'Write Blog' && <CreateBlog />}
        {currentPage === 'Schedule Session' && <ScheduleSession />}
        {currentPage === 'Settings' && <VolunteerSettings />}
        {currentPage === 'Article Drafts' && <ArticleDrafts/>}
        {currentPage === 'Articles' && <Articles />}
        {currentPage === 'Published Articles' && <PublishedArticles />}
        {currentPage === 'View Article' && <ViewArticle />}
        {currentPage === 'Volunteer Profile' && <VolunteerProfile />}
        {currentPage === 'Volunteer Signup' && <VolunteerSignup />}
        {currentPage === 'Registration Completed' && <VolunteerRegistrationCompletedScreen />}
        {currentPage === 'Registration Submitted' && <VolunteerRegistrationSubmittedScreen />}
        {currentPage === 'Forget Password' && <ForgetPassword />}
        {currentPage === 'Sign In' && <SignIn />}
        {currentPage === 'Volunteer Privacy' && <VolunteerPrivacy />}
        {currentPage === 'Help and Support' && <HelpAndSupport />}
      </Box>

      {/* <Footer /> -- Also moved inside Dashboard or all pages layout */}
    </>
  );
}

