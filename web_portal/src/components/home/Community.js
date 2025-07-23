// src/components/community.js
import React from 'react';
import {
  Box,
  Container,
  Grid,
  Card,
  CardMedia,
  CardContent,
  Typography,
  Button,
  Stack,
} from '@mui/material';
import Navbar from '../home/Navbar';
import Footer from '../home/Footer';
import ArticleIcon from '@mui/icons-material/Article';
import PersonIcon from '@mui/icons-material/Person';

// Sample blog data - replace with real data or API
const blogPosts = [
  {
    id: 1,
    title: 'The Power of Community in Dementia Care',
    author: 'Jane Volunteer',
    date: 'July 12, 2025',
    excerpt:
      'Discover how our volunteers create meaningful connections that improve lives through compassionate dementia support.',
    image: '/assets/blog1.jpg', // replace with your actual image path
    readMoreLink: '#',
  },
  {
    id: 2,
    title: 'Smartwatch Monitoring: A Volunteer Perspective',
    author: 'Mark Volunteer',
    date: 'July 8, 2025',
    excerpt:
      'Insights into how smartwatch technologies empower caregivers and volunteers in monitoring patients efficiently.',
    image: '/assets/blog2.jpg',
    readMoreLink: '#',
  },
  {
    id: 3,
    title: 'Volunteer Story: Making a Difference Every Day',
    author: 'Sophia Johnson',
    date: 'June 29, 2025',
    excerpt:
      'Read about Sophia’s journey volunteering with Memora and how small acts have a large impact on dementia care.',
    image: '/assets/blog3.jpg',
    readMoreLink: '#',
  },
];

// Color Palette Constants
const colors = {
  white: '#FFFFFF',
  softLavender: '#C3B1E1',
  deepPurple: '#390797',
  lightSkyBlue: '#A0C4FD',
  calmNavy: '#2B3F99',
};

export default function Community() {
  return (
    <>
      <Navbar />

      <Box
        component="section"
        sx={{
          bgcolor: colors.white,
          minHeight: '100vh',
          py: { xs: 8, md: 12 },
          position: 'relative',
          overflow: 'hidden',
        }}
      >
        {/* Decorative Background Elements */}
        <Box
          sx={{
            position: 'absolute',
            top: -60,
            left: -60,
            width: 220,
            height: 220,
            borderRadius: '50%',
            bgcolor: colors.softLavender,
            opacity: 0.22,
            filter: 'blur(90px)',
            zIndex: 0,
            pointerEvents: 'none',
          }}
        />
        <Box
          sx={{
            position: 'absolute',
            bottom: -80,
            right: -80,
            width: 280,
            height: 280,
            bgcolor: colors.lightSkyBlue,
            opacity: 0.18,
            borderRadius: '50%',
            filter: 'blur(100px)',
            zIndex: 0,
            pointerEvents: 'none',
          }}
        />

        <Container sx={{ position: 'relative', zIndex: 1, maxWidth: 'lg' }}>
          <Stack alignItems="center" spacing={2} mb={6}>
            <ArticleIcon sx={{ fontSize: 48, color: colors.deepPurple }} />
            <Typography
              variant="h3"
              component="h1"
              sx={{
                fontFamily: 'Poppins, Lato, Nunito, Arial, sans-serif',
                fontWeight: 900,
                color: colors.deepPurple,
                textAlign: 'center',
                letterSpacing: 1,
              }}
            >
              Volunteer Blogs & Articles
            </Typography>
            <Typography
              variant="subtitle1"
              sx={{
                maxWidth: 600,
                textAlign: 'center',
                fontFamily: 'Nunito, Arial, sans-serif',
                fontWeight: 500,
                color: colors.calmNavy,
                fontSize: { xs: 16, md: 18 },
                lineHeight: 1.6,
              }}
            >
              Stories, insights, and tips shared by our dedicated volunteers to support the dementia care community.
            </Typography>
          </Stack>

          <Grid container spacing={5} justifyContent="center">
            {blogPosts.map(({ id, title, author, date, excerpt, image, readMoreLink }) => (
              <Grid item xs={12} sm={6} md={4} key={id}>
                <Card
                  sx={{
                    height: '100%',
                    display: 'flex',
                    flexDirection: 'column',
                    boxShadow:
                      '0 8px 32px 0 rgba(57, 7, 151, 0.10), 0 2px 12px 0 rgba(160, 196, 253, 0.15)',
                    borderRadius: 3,
                    ':hover': {
                      boxShadow:
                        '0 14px 48px 0 rgba(57, 7, 151, 0.22), 0 4px 18px 0 rgba(160, 196, 253, 0.25)',
                      transform: 'translateY(-8px)',
                      transition: 'all 0.3s ease',
                    },
                    cursor: 'pointer',
                  }}
                  component="article"
                  aria-labelledby={`blog-title-${id}`}
                >
                  <CardMedia
                    component="img"
                    image={image}
                    alt={title}
                    sx={{ height: 180, borderTopLeftRadius: 12, borderTopRightRadius: 12, objectFit: 'cover' }}
                  />
                  <CardContent sx={{ flexGrow: 1 }}>
                    <Typography
                      id={`blog-title-${id}`}
                      variant="h6"
                      component="h2"
                      gutterBottom
                      sx={{
                        color: colors.deepPurple,
                        fontFamily: 'Poppins, Lato, Nunito, Arial, sans-serif',
                        fontWeight: 700,
                        lineHeight: 1.2,
                      }}
                    >
                      {title}
                    </Typography>
                    <Typography
                      variant="caption"
                      component="p"
                      sx={{
                        display: 'flex',
                        alignItems: 'center',
                        color: colors.calmNavy,
                        fontWeight: 600,
                        mb: 1,
                        fontFamily: 'Nunito, Arial, sans-serif',
                        gap: 1,
                      }}
                    >
                      <PersonIcon fontSize="small" sx={{ color: colors.lightSkyBlue }} />
                      {author} &bull; {date}
                    </Typography>
                    <Typography
                      variant="body2"
                      color={colors.deepPurple}
                      sx={{ fontFamily: 'Nunito, Arial, sans-serif', lineHeight: 1.5 }}
                    >
                      {excerpt}
                    </Typography>
                  </CardContent>
                  <Box sx={{ p: 2, pt: 0 }}>
                    <Button
                      size="small"
                      color="primary"
                      href={readMoreLink}
                      sx={{
                        fontWeight: 600,
                        fontFamily: 'Poppins, Lato, Nunito, Arial, sans-serif',
                        textTransform: 'none',
                      }}
                    >
                      Read More
                    </Button>
                  </Box>
                </Card>
              </Grid>
            ))}
          </Grid>
        </Container>
      </Box>

      
      <Footer />
    </>
  );
}
