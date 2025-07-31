// src/components/volunteers/VolunteerRoutes.js
import React, { useState } from 'react';
import { Box } from '@mui/material';

import VolunteerDashboard from './VolunteerDashboard';
import CreateBlog from './CreateBlog';
import ScheduleSession from './ScheduleSession';

export default function VolunteerRoutes() {
  const [currentPage, setCurrentPage] = useState('Dashboard');

  const handleNavigate = (page) => {
    setCurrentPage(page);
  };

  // Volunteer info to pass to Dashboard (sidebar inside it reads these)
  const volunteerName = "Alex Morgan";
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
        {currentPage === 'Write Blog' && <CreateBlog />}
        {currentPage === 'Schedule Session' && <ScheduleSession />}
        {/* Add other pages similarly */}
      </Box>

      {/* <Footer /> -- Also moved inside Dashboard or all pages layout */}
    </>
  );
}

