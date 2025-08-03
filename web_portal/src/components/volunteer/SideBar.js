// src/components/volunteers/SideBar.js
import React from 'react';
import {
  Box,
  Typography,
  Avatar,
  Divider,
  List,
  ListItemButton,
  ListItemIcon,
  ListItemText,
} from '@mui/material';

import DashboardIcon from '@mui/icons-material/Dashboard';
// import ArticleIcon from '@mui/icons-material/Article';
import ScheduleIcon from '@mui/icons-material/Schedule';
import ForumIcon from '@mui/icons-material/Forum';
import SettingsIcon from '@mui/icons-material/Settings';
import WriteIcon from '@mui/icons-material/Create';

const colors = {
  white: '#FFFFFF',
  softLavender: '#C3B1E1',
  deepPurple: '#390797',
  lightSkyBlue: '#A0C4FD',
  calmNavy: '#2B3F99',
};

export default function SideBar({ volunteerName, profileImage, onNavigate }) {
  return (
    <Box
      sx={{
        width: 260,
        bgcolor: colors.white,
        height: '100vh',
        display: 'flex',
        flexDirection: 'column',
        p: 2,
        borderRight: `1px solid ${colors.softLavender}`,
        position: 'fixed',
        top: 0,
        left: 0,
        overflowY: 'auto',
      }}
      role="navigation"
      aria-label="Volunteer sidebar navigation"
    >
      {/* Navigation Menu with flexGrow to push profile to bottom */}
      <List sx={{ flexGrow: 1, mb: 10, mt : 12 }}>
        <ListItemButton onClick={() => onNavigate('Dashboard')}>
          <ListItemIcon>
            <DashboardIcon sx={{ color: colors.deepPurple }} />
          </ListItemIcon>
          <ListItemText primary="Dashboard" />
        </ListItemButton>
        <ListItemButton onClick={() => onNavigate('Write Blog')}>
          <ListItemIcon>
            <WriteIcon sx={{ color: colors.deepPurple }} />
          </ListItemIcon>
          <ListItemText primary="New Article" />
        </ListItemButton>
        <ListItemButton onClick={() => onNavigate('Schedule Session')}>
          <ListItemIcon>
            <ScheduleIcon sx={{ color: colors.deepPurple }} />
          </ListItemIcon>
          <ListItemText primary="Schedule Session" />
        </ListItemButton>
        <ListItemButton onClick={() => onNavigate('Forum')}>
          <ListItemIcon>
            <ForumIcon sx={{ color: colors.deepPurple }} />
          </ListItemIcon>
          <ListItemText primary="Forum" />
        </ListItemButton>
        <ListItemButton onClick={() => onNavigate('Settings')}>
          <ListItemIcon>
            <SettingsIcon sx={{ color: colors.deepPurple }} />
          </ListItemIcon>
          <ListItemText primary="Settings" />
        </ListItemButton>
      </List>

      <Divider sx={{ my: 2 }} />

      {/* Profile Section moved to bottom */}
      <Box sx={{ display: 'flex', alignItems: 'center', gap: 2, mt: 'auto' }}>
        <Avatar
          alt={volunteerName}
          src={profileImage}
          sx={{ width: 56, height: 56, border: `2px solid ${colors.deepPurple}` }}
        />
        <Box>
          <Typography variant="subtitle1" sx={{ mb: 0.2, color: colors.calmNavy, fontWeight: 'bold' }}>
            Welcome,
          </Typography>
          <Typography variant="h6" sx={{ color: colors.deepPurple, fontWeight: 'bold' }}>
            {volunteerName}
          </Typography>
          <Typography variant="body2" sx={{ color: colors.lightSkyBlue, fontStyle: 'italic' }}>
            Volunteer Contributor
          </Typography>
        </Box>
      </Box>
    </Box>
  );
}
