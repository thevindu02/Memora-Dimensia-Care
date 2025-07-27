import React, { useState } from 'react';
import { 
  Box, 
  Container, 
  Typography, 
  Accordion, 
  AccordionSummary, 
  AccordionDetails,
  Stack
} from '@mui/material';
import ExpandMoreIcon from '@mui/icons-material/ExpandMore';
import HelpOutlineIcon from '@mui/icons-material/HelpOutline';

function ContactInfoCards() {
  const [expanded, setExpanded] = useState(false);

  const handleChange = (panel) => (event, isExpanded) => {
    setExpanded(isExpanded ? panel : false);
  };

  const faqData = [
    {
      id: 'panel1',
      question: 'How can I access resources on Memora?',
      answer: 'You can access resources by creating an account and selecting your role (Patient, Guardian, Caregiver, or Volunteer). Each role has tailored resources and tools available on the platform.'
    },
    {
      id: 'panel2',
      question: 'Can I volunteer with Memora?',
      answer: 'Yes! We welcome volunteers who want to support the dementia care community. You can sign up as a volunteer through our platform and contribute by sharing knowledge, providing support, and helping other users.'
    },
    {
      id: 'panel3',
      question: 'What is included in the free trial?',
      answer: 'Our 1-month free trial includes full access to all Memora features including care coordination tools, resource library, communication features, and personalized support based on your role.'
    },
    {
      id: 'panel4',
      question: 'How do I cancel my subscription?',
      answer: 'You can cancel your subscription anytime before the trial ends through your account settings. Go to "Subscription" in your profile menu and select "Cancel Subscription".'
    },
    {
      id: 'panel5',
      question: 'Is my personal information secure?',
      answer: 'Yes, we take privacy and security very seriously. All personal data is encrypted and stored securely. Please refer to our Privacy Policy for detailed information about how we protect your data.'
    },
    {
      id: 'panel6',
      question: 'What support is available for caregivers?',
      answer: 'Caregivers have access to specialized tools for care coordination, communication with families, resource libraries, training materials, and a supportive community of other caregivers.'
    },
    {
      id: 'panel7',
      question: 'How does Memora help families and guardians?',
      answer: 'Memora provides guardians with tools to monitor care, communicate with caregivers, access educational resources, and connect with support networks to better care for their loved ones.'
    },
    {
      id: 'panel8',
      question: 'Can I use Memora on mobile devices?',
      answer: 'Yes! Memora is available as a mobile app for both iOS and Android devices, as well as through our web portal for desktop access.'
    }
  ];

  return (
    <Box sx={{ py: 8, bgcolor: '#fff' }}>
      <Container maxWidth="md">
        {/* Header Section */}
        <Stack direction="row" spacing={2} justifyContent="center" alignItems="center" sx={{ mb: 6 }}>
          <HelpOutlineIcon sx={{ fontSize: 40, color: '#2B3F99' }} />
          <Typography 
            variant="h3" 
            sx={{ 
              color: '#2B3F99', 
              fontWeight: 700, 
              textAlign: 'center',
              fontFamily: 'Poppins Bold',
              fontSize: { xs: 28, md: 40 }
            }}
          >
            Frequently Asked Questions
          </Typography>
        </Stack>

        <Typography 
          variant="h6" 
          sx={{ 
            color: '#390797', 
            textAlign: 'center', 
            mb: 4,
            fontFamily: 'Poppins Regular',
            fontSize: { xs: 16, md: 20 }
          }}
        >
          Find answers to common questions about Memora and our dementia care platform
        </Typography>

        {/* FAQ Accordions */}
        <Box sx={{ mt: 4 }}>
          {faqData.map((faq) => (
            <Accordion
              key={faq.id}
              expanded={expanded === faq.id}
              onChange={handleChange(faq.id)}
              sx={{
                mb: 2,
                borderRadius: 2,
                boxShadow: '0 2px 8px rgba(43, 63, 153, 0.1)',
                '&:before': {
                  display: 'none',
                },
                '&.Mui-expanded': {
                  margin: '0 0 16px 0',
                },
              }}
            >
              <AccordionSummary
                expandIcon={<ExpandMoreIcon sx={{ color: '#2B3F99' }} />}
                sx={{
                  bgcolor: expanded === faq.id ? '#A0C4FD' : '#F6F4FB',
                  borderRadius: expanded === faq.id ? '8px 8px 0 0' : '8px',
                  '&:hover': {
                    bgcolor: '#A0C4FD',
                  },
                  '& .MuiAccordionSummary-content': {
                    margin: '16px 0',
                  },
                }}
              >
                <Typography
                  sx={{
                    fontWeight: 600,
                    color: '#2B3F99',
                    fontSize: { xs: 16, md: 20 },
                    fontFamily: 'Poppins Regular',
                  }}
                >
                  {faq.question}
                </Typography>
              </AccordionSummary>
              <AccordionDetails
                sx={{
                  bgcolor: '#fff',
                  borderRadius: '0 0 8px 8px',
                  pt: 2,
                  pb: 3,
                }}
              >
                <Typography
                  sx={{
                    color: '#390797',
                    fontSize: { xs: 14, md: 18 },
                    lineHeight: 1.6,
                    fontFamily: 'Poppins Regular',
                  }}
                >
                  {faq.answer}
                </Typography>
              </AccordionDetails>
            </Accordion>
          ))}
        </Box>

        {/* Contact Section */}
        <Box 
          sx={{ 
            mt: 6, 
            p: 4, 
            bgcolor: '#A0C4FD', 
            borderRadius: 3, 
            textAlign: 'center' 
          }}
        >
          <Typography 
            variant="h6" 
            sx={{ 
              color: '#2B3F99', 
              fontWeight: 600, 
              mb: 2,
              fontSize: 25,
              fontFamily: 'Poppins Bold'
            }}
          >
            Still have questions?
          </Typography>
          <Typography 
            sx={{ 
              color: '#390797', 
              mb: 2,
              fontSize: 21,
              fontFamily: 'Poppins Regular'
            }}
          >
            Can't find the answer you're looking for? Our support team is here to help.
          </Typography>
          <Typography 
            sx={{ 
              color: '#2B3F99', 
              fontWeight: 600,
              fontSize: 21,
              fontFamily: 'Poppins Regular'
            }}
          >
            Contact us at: memorademen@gmail.com
          </Typography>
        </Box>
      </Container>
    </Box>
  );
}

export default ContactInfoCards;
