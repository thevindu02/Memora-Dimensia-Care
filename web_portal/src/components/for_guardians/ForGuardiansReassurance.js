// src/components/for_guardians/ForGuardiansReassurance.js
import React from 'react';
import { Box, Typography, Container, Stack, Button } from '@mui/material';
import guardianSupport from '../../assets/guardian-support.png'; // Use your own supportive image

function ForGuardiansReassurance() {
  return (
    <Box sx={{ py: 8, bgcolor: '#bdd2f5ff' }}>
      <Container>
        <Stack direction={{ xs: 'column', md: 'row' }} spacing={6} alignItems="center">
          <Box flex={1} sx={{ textAlign: 'center' }}>
            <Box
              component="img"
              src={guardianSupport}
              alt="Guardians support"
              sx={{
                width: { xs: '90%', md: 340 },
                maxWidth: 400,
                borderRadius: 6,
                boxShadow: 3,
                background: '#fff',
                p: 1,
                mb: { xs: 3, md: 0 },
              }}
            />
          </Box>
          <Box flex={2}>
            <Typography
              variant="h5"
              sx={{
                color: '#390797',
                fontWeight: 700,
                mb: 2,
                fontSize: { xs: 22, md: 36 },
                fontFamily: 'Poppins Bold',
              }}
            >
              Your role matters. Memora gives you the tools and peace of mind to care from anywhere.
            </Typography>
            <Stack direction={{ xs: 'column', sm: 'row' }} spacing={2} mt={3}>
              <Button variant="contained" color="primary" sx={{ borderRadius: 8 }}>
                View Patient Reports
              </Button>
              <Button variant="outlined" color="primary" sx={{ borderRadius: 8 }}>
                Browse Caregivers
              </Button>
            </Stack>
          </Box>
        </Stack>
      </Container>
    </Box>
  );
}

export default ForGuardiansReassurance;
