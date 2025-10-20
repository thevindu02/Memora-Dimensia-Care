// src/components/volunteers/SideBar.js
import React, { useState } from 'react';
import {
  Box,
  Typography,
  Avatar,
  Divider,
  List,
  ListItemButton,
  ListItemIcon,
  ListItemText,
  Collapse,
} from '@mui/material';
import { NavLink } from 'react-router-dom';

import DashboardIcon from '@mui/icons-material/Dashboard';
import ScheduleIcon from '@mui/icons-material/Schedule';
import SettingsIcon from '@mui/icons-material/Settings';
import Article from '@mui/icons-material/Article';
import ExpandLess from '@mui/icons-material/ExpandLess';
import ExpandMore from '@mui/icons-material/ExpandMore';

const colors = {
  white: '#FFFFFF',
  softLavender: '#C3B1E1',
  deepPurple: '#390797',
  lightSkyBlue: '#A0C4FD',
  calmNavy: '#2B3F99',
};

const navItems = [
  { label: 'Dashboard', icon: DashboardIcon, to: '/VolunteerDashboard' },
  {
    label: 'Articles',
    icon: Article,
    to: '/Articles',
    subItems: [
      { label: 'All', to: '/Articles' },
      { label: 'Create New', to: '/CreateBlog' },
      { label: 'Published', to: '/PublishedArticles' }, 
      { label: 'Drafts', to: '/ArticleDrafts' },
    ],
  },
  { label: 'Schedule Session', icon: ScheduleIcon, to: '/ScheduleSession' },
  { label: 'Settings', icon: SettingsIcon, to: '/VolunteerSettings' },
];

export default function SideBar({
  volunteerName = 'Amanda Nethmini',
  profileImage = 'https://randomuser.me/api/portraits/women/44.jpg',
}) {
  const [articlesOpen, setArticlesOpen] = useState(false);

  const handleArticlesClick = () => {
    setArticlesOpen((prev) => !prev);
  };

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
      <List sx={{ flexGrow: 1, mb: 10, mt: 12 }}>
        {/* Dashboard */}
        <ListItemButton
          component={NavLink}
          to={navItems[0].to}
          style={({ isActive }) => ({
            color: isActive ? colors.deepPurple : colors.calmNavy,
            backgroundColor: isActive ? colors.softLavender : 'transparent',
          })}
          sx={{
            borderRadius: 1,
            mb: 0.5,
            '&:hover': {
              backgroundColor: colors.softLavender,
              color: colors.deepPurple,
            },
          }}
        >
          <ListItemIcon>
            {React.createElement(navItems[0].icon, { sx: { color: 'inherit' } })}
          </ListItemIcon>
          <ListItemText primary={navItems[0].label} />
        </ListItemButton>

        {/* Articles */}
        <ListItemButton
          onClick={handleArticlesClick}
          aria-expanded={articlesOpen}
          aria-controls="my-articles-submenu"
          sx={{
            borderRadius: 1,
            mb: 0.5,
            color: articlesOpen ? colors.deepPurple : colors.calmNavy,
            bgcolor: articlesOpen ? colors.softLavender : 'transparent',
            '&:hover': {
              bgcolor: colors.softLavender,
              color: colors.deepPurple,
            },
          }}
        >
          <ListItemIcon>
            <Article sx={{ color: 'inherit' }} />
          </ListItemIcon>
          <ListItemText primary="Articles" />
          {articlesOpen ? <ExpandLess /> : <ExpandMore />}
        </ListItemButton>

        <Collapse in={articlesOpen} timeout="auto" unmountOnExit>
          <List
            component="div"
            disablePadding
            id="my-articles-submenu"
            aria-label="Articles Submenu"
          >
            {navItems[1].subItems.map(({ label, to }) => (
              <ListItemButton
                key={to}
                component={NavLink}
                to={to}
                sx={{
                  pl: 4,
                  borderRadius: 1,
                  mb: 0.5,
                  color: colors.calmNavy,
                  '&.active': {
                    color: colors.deepPurple,
                    bgcolor: colors.softLavender,
                  },
                  '&:hover': {
                    bgcolor: colors.softLavender,
                    color: colors.deepPurple,
                  },
                }}
              >
                <ListItemText primary={label} />
              </ListItemButton>
            ))}
          </List>
        </Collapse>

        {/* Remaining nav items */}
        {navItems.slice(2).map(({ label, icon: IconComp, to }) => (
          <ListItemButton
            key={to}
            component={NavLink}
            to={to}
            style={({ isActive }) => ({
              color: isActive ? colors.deepPurple : colors.calmNavy,
              backgroundColor: isActive ? colors.softLavender : 'transparent',
            })}
            sx={{
              borderRadius: 1,
              mb: 0.5,
              '&:hover': {
                backgroundColor: colors.softLavender,
                color: colors.deepPurple,
              },
            }}
          >
            <ListItemIcon>
              <IconComp sx={{ color: 'inherit' }} />
            </ListItemIcon>
            <ListItemText primary={label} />
          </ListItemButton>
        ))}
      </List>

      <Divider sx={{ my: 2 }} />

      {/* Profile Section at bottom */}
      <Box
        sx={{ display: 'flex', alignItems: 'center', gap: 2, mt: 'auto' }}
        aria-label="User profile information"
      >
        <Avatar
          alt={volunteerName}
          src={profileImage}
          sx={{ width: 56, height: 56, border: `2px solid ${colors.deepPurple}` }}
        />
        <Box>
          <Typography
            variant="subtitle1"
            sx={{ mb: 0.2, color: colors.calmNavy, fontWeight: 'bold' }}
          >
            Welcome,
          </Typography>
          <Typography variant="h6" sx={{ color: colors.deepPurple, fontWeight: 'bold' }}>
            {volunteerName}
          </Typography>
          <Typography
            variant="body2"
            sx={{ color: colors.lightSkyBlue, fontStyle: 'italic' }}
          >
            Volunteer
          </Typography>
        </Box>
      </Box>
    </Box>
  );
}


