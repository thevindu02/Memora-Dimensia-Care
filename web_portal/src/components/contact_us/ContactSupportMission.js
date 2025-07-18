import React from 'react';
import { Box, Typography, Container, Button } from '@mui/material';

function ContactSupportMission() {
  return (
    <Box sx={{ py: 7, background: 'linear-gradient(120deg, #C3B1E1 60%, #A0C4FD 100%)' }}>
      <Container>
        <Box
          sx={{
            bgcolor: '#fff',
            borderRadius: 4,
            p: { xs: 3, md: 5 },
            boxShadow: 2,
            maxWidth: 700,
            mx: 'auto',
            textAlign: 'center',
          }}
        >
          <Typography
            variant="h5"
            sx={{
              color: '#390797',
              fontWeight: 700,
              fontSize: { xs: 22, md: 28 },
              mb: 2,
            }}
          >
            Support Memora’s Mission
          </Typography>
          <Typography sx={{ color: '#2B3F99', mb: 3 }}>
            Interested in supporting Memora’s mission? Learn how you can contribute as a donor, guardian, or volunteer.
          </Typography>
          <Button variant="contained" color="primary" sx={{ borderRadius: 8, px: 5, fontWeight: 700 }}>
            Learn More
          </Button>
        </Box>
      </Container>
    </Box>
  );
}

export default ContactSupportMission;
