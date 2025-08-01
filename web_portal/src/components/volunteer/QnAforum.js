// src/components/volunteers/QnAforum.js
import React, { useState, useMemo } from 'react';
import {
  Box,
  Typography,
  TextField,
  InputAdornment,
  IconButton,
  Stack,
  Paper,
  Avatar,
  Button,
  Tooltip,
  Fade,
} from '@mui/material';

import SearchIcon from '@mui/icons-material/Search';
import ClearIcon from '@mui/icons-material/Clear';
import PersonIcon from '@mui/icons-material/Person';
import ChatBubbleOutlineIcon from '@mui/icons-material/ChatBubbleOutline';
import ThumbUpOffAltIcon from '@mui/icons-material/ThumbUpOffAlt';
import AddCircleIcon from '@mui/icons-material/AddCircle';

import VolunteerNav from './VolunteerNav';
import Footer from '../home/Footer';
import SideBar from './SideBar';

const colors = {
  softLavender: '#C3B1E1',
  deepPurple: '#390797',
  lightSkyBlue: '#A0C4FD',
  calmNavy: '#2B3F99',
  white: '#FFFFFF',
  backgroundLight: '#F7F8FA',
};

// Dummy popular topics data with blurred background URLs
const popularTopics = [
  {
    id: 1,
    title: 'Medication',
    description: 'Tips for medicine management',
    imageUrl: 'https://images.unsplash.com/photo-1588776814546-4f93b6471873?auto=format&fit=crop&w=400&q=60',
  },
  {
    id: 2,
    title: 'Caregiver Tips',
    description: 'How to support your loved ones',
    imageUrl: 'https://images.unsplash.com/photo-1596495578060-f3ddbd01d6f9?auto=format&fit=crop&w=400&q=60',
  },
  {
    id: 3,
    title: 'Activities',
    description: 'Engaging dementia-friendly activities',
    imageUrl: 'https://images.unsplash.com/photo-1526045612212-70caf35c14df?auto=format&fit=crop&w=400&q=60',
  },
  {
    id: 4,
    title: 'Nutrition',
    description: 'Healthy diet guidelines',
    imageUrl: 'https://images.unsplash.com/photo-1510626176961-4b5ab9b5deeb?auto=format&fit=crop&w=400&q=60',
  },
  {
    id: 5,
    title: 'Support Groups',
    description: 'Connecting with helpers',
    imageUrl: 'https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?auto=format&fit=crop&w=400&q=60',
  },
];

// Dummy discussions list
const initialDiscussions = [
  {
    id: 101,
    thumbnail: 'https://randomuser.me/api/portraits/women/68.jpg',
    title: 'How to manage medication timings effectively?',
    description:
      'I have been struggling with keeping track of multiple medications for my father. Any tips or apps you recommend?',
    author: 'Emily R.',
    role: 'Caregiver',
    comments: 12,
    likes: 25,
  },
  {
    id: 102,
    thumbnail: 'https://randomuser.me/api/portraits/men/45.jpg',
    title: 'Best low-impact activities for dementia patients',
    description:
      'Looking for activity suggestions that keep my mother engaged without exhausting her.',
    author: 'John D.',
    role: 'Volunteer',
    comments: 8,
    likes: 18,
  },
  {
    id: 103,
    thumbnail: 'https://randomuser.me/api/portraits/women/50.jpg',
    title: 'Nutrition concerns in late stage dementia',
    description:
      'How to ensure a balanced diet when appetite is reduced?',
    author: 'Sarah K.',
    role: 'Caregiver',
    comments: 5,
    likes: 10,
  },
  // Add more if needed...
];

function RoleBadge({ role }) {
  return (
    <Box
      component="span"
      sx={{
        bgcolor: colors.lightSkyBlue,
        color: colors.deepPurple,
        px: 1.2,
        py: 0.3,
        borderRadius: '12px',
        fontWeight: 600,
        fontSize: 12,
        userSelect: 'none',
      }}
      aria-label={role}
    >
      {role}
    </Box>
  );
}

function TopicCard({ topic }) {
  return (
    <Paper
      elevation={8}
      sx={{
        position: 'relative',
        width: 160,
        height: 100,
        mr: 2,
        borderRadius: 3,
        cursor: 'pointer',
        overflow: 'hidden',
        backgroundImage: `url(${topic.imageUrl})`,
        backgroundSize: 'cover',
        backgroundPosition: 'center',
        color: colors.white,
        boxShadow: '0 8px 20px rgb(0 0 0 / 0.3)',
        userSelect: 'none',
        '&:hover': {
          filter: 'brightness(1.1)',
          transition: 'filter 0.3s ease',
        },
      }}
      role="button"
      tabIndex={0}
    >
      <Box
        sx={{
          position: 'absolute',
          inset: 0,
          bgcolor: 'rgba(0,0,0,0.35)',
          backdropFilter: 'blur(6px)',
          borderRadius: 3,
        }}
      />
      <Box
        sx={{
          position: 'absolute',
          bottom: 0,
          left: 0,
          right: 0,
          p: 1.5,
          background: 'linear-gradient(180deg, transparent 0%, rgba(0,0,0,0.7) 100%)',
          borderRadius: '0 0 12px 12px',
          textShadow: '0 1px 4px rgba(0, 0, 0, 0.75)',
        }}
      >
        <Typography variant="subtitle1" fontWeight={700} noWrap>
          {topic.title}
        </Typography>
        <Typography variant="caption" noWrap>
          {topic.description}
        </Typography>
      </Box>
    </Paper>
  );
}

function DiscussionCard({ discussion }) {
  return (
    <Paper
      elevation={3}
      sx={{
        p: 2,
        mb: 2,
        borderRadius: 3,
        display: 'flex',
        cursor: 'pointer',
        boxShadow: `0 4px 10px ${colors.softLavender}77`,
        transition: 'box-shadow 0.3s ease',
        '&:hover': {
          boxShadow: `0 10px 20px ${colors.deepPurple}aa`,
        },
      }}
      role="button"
      tabIndex={0}
      aria-label={`Discussion: ${discussion.title}`}
    >
      <Avatar
        src={discussion.thumbnail}
        alt={`${discussion.author} avatar`}
        sx={{ width: 64, height: 64, flexShrink: 0, mr: 2, border: `2px solid ${colors.lightSkyBlue}` }}
      />
      <Box sx={{ flexGrow: 1, display: 'flex', flexDirection: 'column' }}>
        <Typography variant="subtitle1" fontWeight={700} noWrap sx={{ mb: 0.5, color: colors.deepPurple }}>
          {discussion.title}
        </Typography>
        <Typography 
          variant="body2" 
          sx={{ 
            color: colors.calmNavy, 
            mb: 0.75, 
            display: '-webkit-box', 
            WebkitLineClamp: 2, 
            WebkitBoxOrient: 'vertical', 
            overflow: 'hidden', 
            textOverflow: 'ellipsis' 
          }}
        >
          {discussion.description}
        </Typography>
        <Box sx={{ display: 'flex', alignItems: 'center', mb: 1 }}>
          <PersonIcon sx={{ fontSize: 18, color: colors.lightSkyBlue, mr: 0.5 }} aria-hidden="true" />
          <Typography variant="caption" sx={{ mr: 1, fontWeight: 600 }}>
            {discussion.author}
          </Typography>
          <RoleBadge role={discussion.role} />
        </Box>
        <Box sx={{ display: 'flex', alignItems: 'center', gap: 3 }}>
          <Stack direction="row" alignItems="center" spacing={0.5} sx={{ color: colors.calmNavy }}>
            <ChatBubbleOutlineIcon fontSize="small" />
            <Typography variant="caption">{discussion.comments}</Typography>
          </Stack>
          <Stack direction="row" alignItems="center" spacing={0.5} sx={{ color: colors.calmNavy }}>
            <ThumbUpOffAltIcon fontSize="small" />
            <Typography variant="caption">{discussion.likes}</Typography>
          </Stack>
        </Box>
      </Box>
    </Paper>
  );
}

export default function QnAforum() {
  const [searchTerm, setSearchTerm] = useState('');

  // Filter discussions by search term matching title/description/authors
  const filteredDiscussions = useMemo(() => {
    const term = searchTerm.trim().toLowerCase();
    if (!term) return initialDiscussions;
    return initialDiscussions.filter(({ title, description, author }) =>
      title.toLowerCase().includes(term) ||
      description.toLowerCase().includes(term) ||
      author.toLowerCase().includes(term)
    );
  }, [searchTerm]);

  const handleClearSearch = () => setSearchTerm('');

  // Volunteer info for sidebar
  const volunteerName = "Alex Morgan";
  const volunteerProfileImage = "https://randomuser.me/api/portraits/women/44.jpg";

  // Handle navigation from sidebar
  const [currentPage, setCurrentPage] = React.useState('QnA Forum');

  const onNavigate = (page) => {
    // You can improve navigation handling here (e.g., pass up state or use React Router)
    setCurrentPage(page);
    alert(`Navigate to: ${page} (dummy)`);
  };

  // Render only QnAforum page content here; sidebar navigation can trigger page change in a parent component

  return (
    <>
      <SideBar
        volunteerName={volunteerName}
        profileImage={volunteerProfileImage}
        onNavigate={onNavigate}
      />
      <Box
        sx={{
          pl: { md: '260px' },
          minHeight: '100vh',
          bgcolor: colors.backgroundLight,
          fontFamily: 'Poppins, Lato, Nunito, Arial, sans-serif',
          color: colors.calmNavy,
          display: 'flex',
          flexDirection: 'column',
        }}
      >
        <VolunteerNav />
        <Box sx={{ flexGrow: 1, p: 2 }}>
          {/* Search Bar */}
          <Box sx={{ mb: 3 }}>
            <TextField
              variant="outlined"
              placeholder="Search discussions, tags, or authors…"
              fullWidth
              size="medium"
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              InputProps={{
                sx: {
                  borderRadius: 3,
                  bgcolor: colors.white,
                  boxShadow: `inset 2px 2px 5px ${colors.softLavender}, inset -2px -2px 5px ${colors.white}`,
                  color: colors.calmNavy,
                },
                startAdornment: (
                  <InputAdornment position="start">
                    <SearchIcon sx={{ color: colors.deepPurple }} />
                  </InputAdornment>
                ),
                endAdornment: searchTerm ? (
                  <InputAdornment position="end">
                    <IconButton
                      onClick={handleClearSearch}
                      aria-label="Clear search"
                      size="small"
                    >
                      <ClearIcon sx={{ color: colors.deepPurple }} />
                    </IconButton>
                  </InputAdornment>
                ) : null,
                'aria-label': 'Search discussions',
              }}
            />
          </Box>

          {/* Popular Topics */}
          <Box sx={{ mb: 4, overflowX: 'auto' }} aria-label="Popular topics">
            <Stack direction="row" spacing={1}>
              {popularTopics.map((topic) => (
                <TopicCard key={topic.id} topic={topic} />
              ))}
            </Stack>
          </Box>

          {/* Discussion Feed or Empty State */}
          <Box sx={{ pb: 12, minHeight: 200 }}>
            {filteredDiscussions.length > 0 ? (
              filteredDiscussions.map((d) => <DiscussionCard key={d.id} discussion={d} />)
            ) : (
              <Box
                sx={{
                  mt: 6,
                  textAlign: 'center',
                  color: colors.softLavender,
                  px: 3,
                  userSelect: 'none',
                }}
                role="status"
                aria-live="polite"
              >
                <img
                  src="https://images.unsplash.com/photo-1535223289827-42f1e9919769?auto=format&fit=crop&w=200&q=80"
                  alt="No discussions found"
                  style={{ width: 120, marginBottom: 16, opacity: 0.6, userSelect: 'none' }}
                  aria-hidden="true"
                  draggable={false}
                />
                <Typography variant="body1" sx={{ fontWeight: 600 }}>
                  No discussions found. Try different keywords.
                </Typography>
              </Box>
            )}
          </Box>

          {/* Floating Ask a Question Button */}
          <Fade in appear>
            <Button
              variant="contained"
              color="primary"
              startIcon={<AddCircleIcon />}
              sx={{
                position: 'fixed',
                bottom: 24,
                right: 24,
                borderRadius: 30,
                bgcolor: colors.lightSkyBlue,
                color: colors.white,
                px: 3,
                py: 1.5,
                fontWeight: 700,
                boxShadow: `0 6px 15px ${colors.lightSkyBlue}bb`,
                textTransform: 'none',
                "&:hover": {
                  bgcolor: colors.deepPurple,
                  boxShadow: `0 8px 20px ${colors.deepPurple}cc`,
                },
              }}
              aria-label="Ask a question"
              onClick={() => alert('Ask a Question clicked (dummy)')}
            >
              Ask a Question
            </Button>
          </Fade>
        </Box>
        <Footer />
      </Box>
    </>
  );
}

