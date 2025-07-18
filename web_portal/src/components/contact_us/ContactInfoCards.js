import React from 'react';
import { Box, Container, Grid, Paper, Typography, IconButton, Stack } from '@mui/material';
import EmailIcon from '@mui/icons-material/Email';
import PhoneIcon from '@mui/icons-material/Phone';
import FacebookIcon from '@mui/icons-material/Facebook';
import TwitterIcon from '@mui/icons-material/Twitter';

function ContactInfoCards() {
  return (
    <Box sx={{ py: 5, bgcolor: '#fff' }}>
      <Container>
        <Grid container spacing={4} justifyContent="center">
          <Grid item xs={12} md={4}>
            <Paper
              elevation={2}
              sx={{
                p: 4,
                borderRadius: 3,
                bgcolor: '#C3B1E1',
                color: '#2B3F99',
                textAlign: 'center',
                mb: 2,
              }}
            >
              <Typography variant="h6" sx={{ fontWeight: 700, mb: 1 }}>
                Head Office
              </Typography>
              <Typography>Colombo, Sri Lanka</Typography>
            </Paper>
          </Grid>
          <Grid item xs={12} md={4}>
            <Paper
              elevation={2}
              sx={{
                p: 4,
                borderRadius: 3,
                bgcolor: '#A0C4FD',
                color: '#2B3F99',
                textAlign: 'center',
                mb: 2,
              }}
            >
              <Stack direction="row" spacing={1} justifyContent="center" alignItems="center" mb={1}>
                <EmailIcon />
                <Typography>info@memora.org</Typography>
              </Stack>
              <Stack direction="row" spacing={1} justifyContent="center" alignItems="center">
                <PhoneIcon />
                <Typography>+94 77 123 4567</Typography>
              </Stack>
            </Paper>
          </Grid>
          <Grid item xs={12} md={4}>
            <Paper
              elevation={2}
              sx={{
                p: 4,
                borderRadius: 3,
                bgcolor: '#F6F4FB',
                color: '#2B3F99',
                textAlign: 'center',
                mb: 2,
              }}
            >
              <Typography variant="h6" sx={{ fontWeight: 700, mb: 1 }}>
                Follow Us
              </Typography>
              <IconButton color="inherit" href="https://facebook.com" target="_blank">
                <FacebookIcon />
              </IconButton>
              <IconButton color="inherit" href="https://twitter.com" target="_blank">
                <TwitterIcon />
              </IconButton>
            </Paper>
          </Grid>
        </Grid>
      </Container>
    </Box>
  );
}

export default ContactInfoCards;
