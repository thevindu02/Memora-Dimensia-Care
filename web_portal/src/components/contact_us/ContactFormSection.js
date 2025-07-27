import React from 'react';
import { Box, Grid, Paper, Typography, TextField, Button, MenuItem,IconButton } from '@mui/material';
import HelpOutlineIcon from '@mui/icons-material/HelpOutline';
import AccessTimeIcon from '@mui/icons-material/AccessTime';
import LocationIcon from '@mui/icons-material/LocationCity';
import FacebookIcon from '@mui/icons-material/Facebook';
import TwitterIcon from '@mui/icons-material/Twitter';
import SocialIcon from '@mui/icons-material/PeopleOutlineTwoTone';

function ContactFormSection() {
  return (
    <Box sx={{ py: 6, bgcolor: '#fff' }}>
      <Grid container spacing={4} justifyContent="center">
        <Grid item xs={12} md={6}>
          <Paper
            elevation={3}
            sx={{
              p: 4,
              borderRadius: 4,
              boxShadow: '0 4px 24px 0 rgba(44,62,80,0.08)',
              bgcolor: '#F6F4FB',
            }}
          >
            <Typography variant="h6" sx={{ color: '#2B3F99', fontWeight: 700, mb: 2 }}>
              Send us a Message
            </Typography>
            <form>
              <TextField
                label="Your Name"
                fullWidth
                required
                sx={{ mb: 2 }}
              />
              <TextField
                label="Email Address"
                fullWidth
                required
                type="email"
                sx={{ mb: 2 }}
              />
              <TextField
                label="Category"
                select
                fullWidth
                defaultValue=""
                sx={{ mb: 2 }}
              >
                <MenuItem value="General">General Inquiry</MenuItem>
                <MenuItem value="Support">Support</MenuItem>
                <MenuItem value="Feedback">Feedback</MenuItem>
              </TextField>
              <TextField
                label="Your Message"
                fullWidth
                required
                multiline
                minRows={4}
                sx={{ mb: 3 }}
              />
              <Button
                variant="contained"
                color="primary"
                size="large"
                sx={{ borderRadius: 8, fontWeight: 700, px: 5, fontFamily: 'Roboto', fontSize: 18 }}
                type="submit"
              >
                Send Message
              </Button>
            </form>
          </Paper>
        </Grid>
        <Grid item xs={12} md={4}>
          <Box sx={{ display: 'flex', flexDirection: 'column', gap: 3 }}>
            <Paper
              elevation={2}
              sx={{
                p: 3,
                borderRadius: 3,
                bgcolor: '#A0C4FD',
                color: '#2B3F99',
                display: 'flex',
                alignItems: 'center',
                gap: 2,
              }}
            >
              <HelpOutlineIcon sx={{ fontSize: 32 }} />
              <Box>
                <Typography sx={{ fontWeight: 700 }}>Urgent Support</Typography>
                <Typography sx={{ fontSize: 18, fontWeight: 600 }}>
                  +94 112 554 678
                </Typography>
              </Box>
            </Paper>
            <Paper
              elevation={2}
              sx={{
                p: 3,
                borderRadius: 3,
                bgcolor: '#C3B1E1',
                color: '#390797',
                display: 'flex',
                alignItems: 'center',
                gap: 2,
              }}
            >
              <AccessTimeIcon sx={{ fontSize: 32 }} />
              <Box>
                <Typography sx={{ fontWeight: 700 }}>Response Time</Typography>
                <Typography sx={{ fontSize: 16 }}>
                  We typically respond within 24–48 hours on working days.
                </Typography>
              </Box>
            </Paper>
            <Paper
              elevation={2}
              sx={{
                p: 3,
                borderRadius: 3,
                bgcolor: '#cfe0fdff',
                color: '#2B3F99',
                display: 'flex',
                alignItems: 'center',
                gap: 2,
              }}
            >
              <LocationIcon sx={{ fontSize: 32 }} />
              <Box>
                <Typography sx={{ fontWeight: 700 }}>Head Office</Typography>
                <Typography sx={{ fontSize: 16 }}>
                  Memora.pvt,
                  Colombo 10, Sri Lanka
                </Typography>
              </Box>
            </Paper>
            <Paper
              elevation={2}
              sx={{
                p: 3,
                borderRadius: 3,
                bgcolor: '#ece5f7ff',
                color: '#390797',
                display: 'flex',
                alignItems: 'center',
                gap: 2,
              }}
            >
              <SocialIcon sx={{ fontSize: 32 }} />
              <Box>
                <Typography sx={{ fontWeight: 700 }}>Follow Us</Typography>
                <IconButton color="inherit" href="https://facebook.com" target="_blank">
                <FacebookIcon />
              </IconButton>
              <IconButton color="inherit" href="https://twitter.com" target="_blank">
                <TwitterIcon />
              </IconButton>
              </Box>
            </Paper>
          </Box>
        </Grid>
      </Grid>
    </Box>
  );
}

export default ContactFormSection;
