// src/components/Footer.js
import React from 'react';
import { Box, Typography, Container, Stack, IconButton, Link } from '@mui/material';
import { Link as RouterLink } from 'react-router-dom';
import EmailIcon from '@mui/icons-material/Email';
import PhoneIcon from '@mui/icons-material/Phone';
import FacebookIcon from '@mui/icons-material/Facebook';
import TwitterIcon from '@mui/icons-material/Twitter';
import LinkedInIcon from '@mui/icons-material/LinkedIn';


function Footer() {
  return (
    <Box
      component="footer"
      sx={{
        bgcolor: '#2B3F99',
        color: '#fff',
        py: 4,
        fontSize: 18,
        fontFamily: 'Poppins Regular',
      }}
    >
      <Container maxWidth="lg">
        <Stack
          direction={{ xs: 'column', md: 'row' }}
          spacing={6}
          justifyContent="space-between"
          alignItems={{ xs: 'flex-start', md: 'center' }}
          flexWrap="wrap"
        >
          {/* About Section */}
          <Box sx={{ flex: '1 1 250px', minWidth: 250 }}>
            <Stack direction="row" alignItems="center" spacing={1} sx={{ mb: 2 }}>
              {/* <Box
                component="img"
                src={logo}
                alt="Memora Logo"
                sx={{
                  width: 40,
                  height: 40,
                  borderRadius: '100px',
                  bgcolor: '#fff',
                  p: '1px',
                  boxShadow: 1,
                }}
              /> */}
              <Typography variant="h6" sx={{ fontFamily: 'Poppins Regular', fontWeight: 700, fontSize: 24 }}>
                Memora
              </Typography>
            </Stack>
            <Typography variant="body2" sx={{ fontFamily: 'Poppins Regular', mb: 2, maxWidth: 320, fontSize: 18 }}>
              Supporting dementia care with compassion and technology.  
              Empowering patients, families, and caregivers with trusted resources.
            </Typography>
            <Stack direction="row" spacing={1}>
              <IconButton
                aria-label="Facebook"
                color="inherit"
                href="https://facebook.com"
                target="_blank"
                size="large"
              >
                <FacebookIcon />
              </IconButton>
              <IconButton
                aria-label="Twitter"
                color="inherit"
                href="https://twitter.com"
                target="_blank"
                size="large"
              >
                <TwitterIcon />
              </IconButton>
              <IconButton
                aria-label="LinkedIn"
                color="inherit"
                href="https://linkedin.com"
                target="_blank"
                size="large"
              >
                <LinkedInIcon />
              </IconButton>
            </Stack>
          </Box>

          {/* Quick Links */}
          <Box sx={{ flex: '1 1 150px', minWidth: 150 }}>
            <Typography variant="h6" sx={{ fontFamily: 'Poppins Regular', fontWeight: 700, mb: 2, fontSize: 24 }}>
              Quick Links
            </Typography>
            <Stack spacing={1}>
              <Link href="/home" underline="hover" color="inherit" sx={{ cursor: 'pointer' }}>
                Home
              </Link>
              <Link href="/for_patients" underline="hover" color="inherit" sx={{ cursor: 'pointer' }}>
                For Patients
              </Link>
              <Link href="/for_guardians" underline="hover" color="inherit" sx={{ cursor: 'pointer' }}>
                For Guardians
              </Link>
              <Link href="/for_caregivers" underline="hover" color="inherit" sx={{ cursor: 'pointer' }}>
                For Caregivers
              </Link>
              <Link href="/for_volunteers" underline="hover" color="inherit" sx={{ cursor: 'pointer' }}>
                For Volunteers
              </Link>
              <Link   component={RouterLink} to="/terms" underline="hover" color="inherit" sx={{ cursor: 'pointer' }}>
                Terms & Conditions
              </Link>
              <Link   component={RouterLink} to="/privacy_policy" underline="hover" color="inherit" sx={{ cursor: 'pointer' }}>
                Privacy Policy
              </Link>
            </Stack>
          </Box>

          {/* Contact Info */}
          <Box sx={{ flex: '1 1 250px', minWidth: 250 }}>
            <Typography variant="h6" sx={{ fontFamily: 'Poppins Regular', fontWeight: 700, mb: 2, fontSize: 24 }}>
              Contact Us
            </Typography>
            <Stack direction="row" spacing={1} alignItems="center" sx={{ mb: 1 }}>
              <EmailIcon />
              <Typography variant="body2" sx={{ fontFamily: 'Poppins Regular', fontWeight: 700, fontSize: 18 }}>
                memorademen@gmail.com
              </Typography>
            </Stack>
            <Stack direction="row" spacing={1} alignItems="center" sx={{ mb: 2 }}>
              <PhoneIcon />
              <Typography variant="body2" sx={{ fontFamily: 'Poppins Regular', fontWeight: 700, fontSize: 18 }}>
                +94 77 123 4567
              </Typography>
            </Stack>
            {/* Optional: Newsletter Signup (commented out)
            <Typography sx={{ mb: 1 }}>Subscribe to our newsletter</Typography>
            <Stack direction="row" spacing={1}>
              <TextField
                placeholder="Your email"
                variant="filled"
                size="small"
                sx={{ bgcolor: '#fff', borderRadius: 1, flexGrow: 1 }}
                InputProps={{ disableUnderline: true }}
              />
              <Button variant="contained" color="primary" sx={{ px: 3 }}>
                Subscribe
              </Button>
            </Stack>
            */}
          </Box>
        </Stack>

        {/* Bottom copyright */}
        <Typography variant="body2" align="center" sx={{ mt: 6, opacity: 0.7 }}>
          © {new Date().getFullYear()} Memora. All rights reserved.
        </Typography>
      </Container>
    </Box>
  );
}

export default Footer;




