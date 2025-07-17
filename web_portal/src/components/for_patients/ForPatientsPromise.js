// src/components/ForPatientsPromise.js
import React from 'react';
import { Box, Typography, Container } from '@mui/material';

function ForPatientsPromise() {
  return (
    <Box sx={{ py: 6, bgcolor: '#C3B1E1' }}>
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
              fontFamily: 'Poppins, Lato, Nunito, Arial, sans-serif',
            }}
          >
            You’re not alone—Memora ensures your care journey is supported with dignity and simplicity.
          </Typography>
        </Box>
      </Container>
    </Box>
  );
}

export default ForPatientsPromise;
