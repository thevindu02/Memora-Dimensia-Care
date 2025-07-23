// src/components/Navbar.js
import React from 'react';
import { AppBar, Toolbar, Typography, Button, Box } from '@mui/material';
import logo from '../../assets/logo.png'; 

const navItems = [
  { label: 'Home', to: '/home', type: 'route' },
  { label: 'For Patients', to: '/for_patients', type: 'route' },
  { label: 'For Caregivers', to: '/for_caregivers', type: 'route' },
  { label: 'For Guardians', to: '/for_guardians', type: 'route' },
  { label: 'For Volunteers', to: '/for_volunteers', type: 'route' },
  { label: 'Contact Us', to: '/contact_us', type: 'route' },
];

function Navbar() {
  return (
     <AppBar
      position="sticky"
      elevation={0}
      sx={{
        bgcolor: 'background.default',
        color: 'primary.main',
        borderBottom: '1px solid #eee',
      }}
    >
      <Toolbar sx={{ justifyContent: 'space-between' }}>
        <Box sx={{ display: 'flex', alignItems: 'center', gap: 0 }}>
          <img
            src={logo}
            alt="Memora Logo"
            style={{ height: 80, width: 80, borderRadius: 8 }}
          />
          <Typography
            variant="h6"
            sx={{ fontWeight: 700, color: 'primary.main', letterSpacing: 1 }}
          >
            Memora
          </Typography>
        </Box>
        <Box sx={{ display: { xs: 'none', md: 'flex' }, gap: 2 }}>
          {navItems.map((item) => (
            <Button key={item.label} href={item.to} color="inherit" sx={{ fontWeight: 600 }}>
              {item.label}
            </Button>
          ))}
        </Box>
      </Toolbar>
    </AppBar>
  );
}

export default Navbar;
