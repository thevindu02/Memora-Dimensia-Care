import React, { useState } from 'react';
import SideBar from './SideBar';
import VolunteerDashboard from './VolunteerDashboard';
import CreateBlog from './CreateBlog';
import ScheduleSession from './ScheduleSession';

export default function VolunteerLayout() {
  const [currentPage, setCurrentPage] = useState('Dashboard');

  const handleNavigate = (page) => {
    setCurrentPage(page);
  };

  return (
    <Box sx={{ display: 'flex' }}>
      <SideBar
        volunteerName="Alex Morgan"
        profileImage="https://randomuser.me/api/portraits/women/44.jpg"
        onNavigate={handleNavigate}
      />
      <Box sx={{ flexGrow: 1, ml: '260px' }}>
        {currentPage === 'Dashboard' && <VolunteerDashboard />}
        {currentPage === 'Write Blog' && <CreateBlog />}
        {currentPage === 'Schedule Session' && <ScheduleSession />}
        {/* Add other pages similarly */}
      </Box>
    </Box>
  );
}
