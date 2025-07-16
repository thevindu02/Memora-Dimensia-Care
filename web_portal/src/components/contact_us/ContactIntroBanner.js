import React from 'react';
import { Box, Typography} from '@mui/material';

function ContactIntroBanner() {
  return (
    <Box
      sx={{
        py: { xs: 7, md: 10 },
        background: 'linear-gradient(120deg, #C3B1E1 60%, #A0C4FD 100%)',
        textAlign: 'center',
        position: 'relative',
        overflow: 'hidden',
      }}
    >
      <Typography
        variant="h2"
        sx={{
          color: '#2B3F99',
          fontWeight: 800,
          fontSize: { xs: 30, md: 48 },
          mb: 2,
          fontFamily: 'Poppins, Lato, Nunito, Arial, sans-serif',
        }}
      >
        We're Here to Help
      </Typography>
      <Typography
        variant="h6"
        sx={{
          color: '#390797',
          fontWeight: 500,
          fontSize: { xs: 18, md: 24 },
          maxWidth: 600,
          mx: 'auto',
          mb: 2,
        }}
      >
        Whether you have questions, suggestions, or need support, don’t hesitate to reach out. Our team is committed to supporting you and your loved ones.
      </Typography>
    </Box>
  );
}

export default ContactIntroBanner;
