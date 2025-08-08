// src/components/volunteers/VolunteerDashboard.js
import React, { useState, onNavigate } from 'react';
import {
  Box,
  Typography,
  Container,
  Stack,
  Paper,
  Grid,
  IconButton,
  Button,
  Tooltip,
  Avatar,
  List,
  ListItem,
  ListItemAvatar,
  ListItemText,
  Divider,
  Menu,
  MenuItem,
} from '@mui/material';

import MenuIcon from '@mui/icons-material/Menu';
import ArticleIcon from '@mui/icons-material/Article';
import ScheduleIcon from '@mui/icons-material/Schedule';
import ForumIcon from '@mui/icons-material/Forum';
import AccessTimeIcon from '@mui/icons-material/AccessTime';
import EditIcon from '@mui/icons-material/Edit';
import DeleteIcon from '@mui/icons-material/Delete';
import VisibilityIcon from '@mui/icons-material/Visibility';

import VolunteerNav from './VolunteerNav';
import Footer from '../home/Footer';
import SideBar from './SideBar';
import VolunteerProfile from './VolunteerProfile';

import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  BarElement,
  Legend,
  Tooltip as ChartTooltip,
} from 'chart.js';
import { Bar } from 'react-chartjs-2';

ChartJS.register(CategoryScale, LinearScale, BarElement, Legend, ChartTooltip);

// Memora color palette
const colors = {
  white: '#FFFFFF',
  softLavender: '#C3B1E1',
  deepPurple: '#390797',
  lightSkyBlue: '#A0C4FD',
  calmNavy: '#2B3F99',
  backgroundLight: '#F7F8FA',
};

// Sample volunteer info (should be provided by parent or context)
const volunteerName = "Amanda Nethmini";
const volunteerProfileImage = "https://randomuser.me/api/portraits/women/44.jpg";

const stats = [
  {
    label: "Total Blogs Published",
    value: 14,
    icon: ArticleIcon,
    bgColor: colors.softLavender,
    iconColor: colors.deepPurple,
  },
  {
    label: "Total Awareness Sessions",
    value: 7,
    icon: ScheduleIcon,
    bgColor: colors.lightSkyBlue,
    iconColor: colors.calmNavy,
  },
  {
    label: "Total Forum Replies",
    value: 34,
    icon: ForumIcon,
    bgColor: colors.calmNavy,
    iconColor: colors.white,
  },
  {
    label: "Monthly Contributions",
    value: 5,
    icon: AccessTimeIcon,
    bgColor: colors.deepPurple,
    iconColor: colors.softLavender,
  },
];

const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
const blogData = [1, 2, 1, 3, 2, 4, 2, 3, 2, 3, 4, 5];
const sessionData = [0, 1, 2, 1, 1, 0, 1, 2, 1, 3, 1, 2];

const barChartData = {
  labels: months,
  datasets: [
    {
      label: 'Blogs',
      data: blogData,
      backgroundColor: colors.deepPurple,
      borderRadius: 4,
      maxBarThickness: 20,
    },
    {
      label: 'Sessions',
      data: sessionData,
      backgroundColor: colors.lightSkyBlue,
      borderRadius: 4,
      maxBarThickness: 20,
    },
  ],
};

const barChartOptions = {
  responsive: true,
  plugins: {
    legend: { position: 'top', labels: { color: colors.calmNavy, font: { weight: 'bold' } } },
    tooltip: { enabled: true },
  },
  scales: {
    x: {
      ticks: { color: colors.calmNavy, font: { weight: '600' } },
      grid: { display: false },
    },
    y: {
      ticks: { color: colors.calmNavy, font: { weight: '600' }, stepSize: 1 },
      grid: { color: colors.softLavender },
      beginAtZero: true,
      max: 6,
    },
  },
};

const recentContributions = [
  {
    id: 1,
    type: 'Blog Post',
    title: 'Understanding Dementia Care Basics',
    timestamp: 'July 27, 2025',
    thumbnail: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=64&h=64&fit=crop',
  },
  {
    id: 2,
    type: 'Forum Reply',
    title: 'Re: Helping Caregivers Stay Patient',
    timestamp: 'July 25, 2025',
    thumbnail: 'https://randomuser.me/api/portraits/men/32.jpg',
  },
  {
    id: 3,
    type: 'Blog Post',
    title: '5 Tips for Volunteers',
    timestamp: 'July 20, 2025',
    thumbnail: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=64&h=64&fit=crop',
  },
];

const quickActions = [
  {
    label: 'Write New Blog',
    icon: <ArticleIcon sx={{ fontSize: 24 }} />,
    tooltip: 'Create and submit a new blog post',
  },
  {
    label: 'Schedule Awareness Session',
    icon: <ScheduleIcon sx={{ fontSize: 24 }} />,
    tooltip: 'Plan a new awareness session',
  },
  {
    label: 'Answer a Forum Question',
    icon: <ForumIcon sx={{ fontSize: 24 }} />,
    tooltip: 'Respond to questions in the forum',
  },
];

// Quick Action Button Component
const QuickActionButton = ({ label, icon, tooltip, onClick }) => (
  <Tooltip title={tooltip} arrow>
    <Button
      variant="outlined"
      startIcon={icon}
      onClick={onClick}
      sx={{
        textTransform: 'none',
        borderRadius: 3,
        color: colors.deepPurple,
        borderColor: colors.deepPurple,
        px: 3,
        py: 1.5,
        fontWeight: 600,
        fontFamily: 'Poppins, Lato, Nunito, Arial, sans-serif',
        transition: 'all 0.3s ease',
        whiteSpace: 'nowrap',
        '&:hover': {
          bgcolor: colors.deepPurple,
          color: colors.white,
          borderColor: colors.deepPurple,
          boxShadow: `0 4px 12px ${colors.deepPurple}66`,
          transform: 'translateY(-3px)',
        },
      }}
    >
      {icon}
      <Box ml={1}>{label}</Box>
    </Button>
  </Tooltip>
);

const StatCard = ({ label, value, icon: IconComp, bgColor, iconColor }) => (
  <Paper
    elevation={4}
    sx={{
      display: 'flex',
      alignItems: 'center',
      gap: 2,
      bgcolor: colors.white,
      borderRadius: 3,
      p: 3,
      boxShadow: `0 6px 20px ${colors.softLavender}99`,
      cursor: 'default',
      userSelect: 'none',
    }}
  >
    <Box
      sx={{
        width: 54,
        height: 54,
        bgcolor: bgColor,
        borderRadius: '50%',
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
        boxShadow: `0 2px 8px ${bgColor}bb`,
        color: iconColor,
        flexShrink: 0,
      }}
    >
      <IconComp sx={{ fontSize: 28 }} />
    </Box>
    <Box>
      <Typography variant="h5" sx={{ color: colors.deepPurple, fontWeight: 700, lineHeight: 1 }}>
        {value}
      </Typography>
      <Typography variant="body2" sx={{ color: colors.calmNavy, fontWeight: 600 }}>
        {label}
      </Typography>
    </Box>
  </Paper>
);

export default function VolunteerDashboard({ volunteerName, volunteerProfileImage, onNavigate }) {
  // Profile dropdown menu state
  const [anchorEl, setAnchorEl] = useState(null);
  const openProfileMenu = Boolean(anchorEl);

  // New state for showing profile page
  const [showProfile, setShowProfile] = useState(false);

  // Handlers
  const handleProfileClick = (event) => setAnchorEl(event.currentTarget);
  const handleProfileClose = () => setAnchorEl(null);

  const handleMenuItemClick = (option) => {
    if (option === 'Profile') {
      setShowProfile(true); // Show profile page
    } else {
      alert(`You clicked ${option}`);
    }
    handleProfileClose();
  };

  // Handlers for quick action buttons
  const handleActionClick = (action) => alert(`Action triggered: ${action}`);

  // Render profile page if showProfile is true
  if (showProfile) {
    return (
      <VolunteerProfile onBack={() => setShowProfile(false)} />
    );
  }

  return (
    <>
          <SideBar
        volunteerName={volunteerName}
        profileImage={volunteerProfileImage}
        onNavigate={onNavigate}
      />
      <VolunteerNav />
      <Box
        sx={{
          bgcolor: colors.backgroundLight,
          minHeight: '100vh',

          py: { xs: 4, md: 6 },
          px: { xs: 2, md: 4 },
          fontFamily: 'Poppins, Lato, Nunito, Arial, sans-serif',
          color: colors.calmNavy,
          position: 'relative',
          ml: { md: 30 }, 
        }}
      >
        <Container maxWidth="lg">
          {/* Header */}
          <Box
            sx={{
              display: 'flex',
              alignItems: 'center',
              mb: { xs: 4, md: 6 },
              gap: 2,
              justifyContent: 'space-between',
            }}
          >
            <Typography variant="h4" sx={{ fontWeight: 700, color: colors.deepPurple, flexGrow: 1 }}>
              Volunteer Dashboard
            </Typography>

            {/* Profile Avatar with Dropdown */}
            <IconButton
              onClick={handleProfileClick}
              size="small"
              sx={{ borderRadius: '50%' }}
              aria-controls={openProfileMenu ? 'profile-menu' : undefined}
              aria-haspopup="true"
              aria-expanded={openProfileMenu ? 'true' : undefined}
              aria-label="profile menu"
            >
              <Avatar
                alt={volunteerName}
                src={volunteerProfileImage}
                sx={{ width: 60, height: 60, border: `2px solid ${colors.deepPurple}` }}
              />
            </IconButton>

            <Menu
              id="profile-menu"
              anchorEl={anchorEl}
              open={openProfileMenu}
              onClose={handleProfileClose}
              onClick={handleProfileClose}
              PaperProps={{
                elevation: 3,
                sx: {
                  mt: 1,
                  minWidth: 160,
                  borderRadius: 2,
                  boxShadow: 'rgb(0 0 0 / 20%) 0px 2px 8px',
                },
              }}
              transformOrigin={{ horizontal: 'right', vertical: 'top' }}
              anchorOrigin={{ horizontal: 'right', vertical: 'bottom' }}
            >
              <MenuItem onClick={() => handleMenuItemClick('Profile')}>Profile</MenuItem>
              <MenuItem onClick={() => handleMenuItemClick('Sign Out')}>Sign Out</MenuItem>
            </Menu>
          </Box>

          {/* Welcome Sub-header */}
          <Typography
            variant="subtitle1"
            sx={{
              color: colors.calmNavy,
              mb: 4,
              fontStyle: 'italic',
              fontWeight: 500,
            }}
          >
            Thank you for making a difference in dementia care.
          </Typography>

          {/* Stats Cards */}
          <Grid container spacing={3} sx={{ mb: 6 }}>
            {stats.map(({ label, value, icon: IconComp, bgColor, iconColor }) => (
              <Grid item xs={12} sm={6} md={3} key={label}>
                <StatCard label={label} value={value} icon={IconComp} bgColor={bgColor} iconColor={iconColor} />
              </Grid>
            ))}
          </Grid>

          {/* Progress Visualization Section */}
          <Box
            sx={{
              bgcolor: colors.white,
              p: 4,
              borderRadius: 3,
              boxShadow: `0 8px 24px ${colors.softLavender}aa`,
              mb: 6,
            }}
          >
            <Typography
              variant="h6"
              sx={{ color: colors.calmNavy, mb: 3, fontWeight: 700, fontFamily: 'Poppins' }}
            >
              Monthly Activity
            </Typography>
            <Box sx={{ maxWidth: '100%', height: 280 }}>
              <Bar data={barChartData} options={barChartOptions} />
            </Box>
          </Box>

          {/* Recent Contributions */}
          <Box sx={{ mb: 6 }}>
            <Typography
              variant="h6"
              sx={{ color: colors.calmNavy, mb: 3, fontWeight: 700, fontFamily: 'Poppins' }}
            >
              Recent Contributions
            </Typography>
            <Paper
              sx={{
                bgcolor: colors.white,
                maxHeight: 280,
                overflowY: 'auto',
                borderRadius: 3,
                boxShadow: `0 6px 16px ${colors.softLavender}88`,
              }}
            >
              <List disablePadding>
                {recentContributions.map(({ id, type, title, timestamp, thumbnail }) => (
                  <React.Fragment key={id}>
                    <ListItem
                      secondaryAction={
                        <Stack direction="row" spacing={1}>
                          <Tooltip title="View">
                            <IconButton edge="end" size="small" color="primary" aria-label="view">
                              <VisibilityIcon />
                            </IconButton>
                          </Tooltip>
                          <Tooltip title="Edit">
                            <IconButton edge="end" size="small" color="warning" aria-label="edit">
                              <EditIcon />
                            </IconButton>
                          </Tooltip>
                          <Tooltip title="Delete">
                            <IconButton edge="end" size="small" color="error" aria-label="delete">
                              <DeleteIcon />
                            </IconButton>
                          </Tooltip>
                        </Stack>
                      }
                    >
                      <ListItemAvatar>
                        <Avatar src={thumbnail} alt={type} />
                      </ListItemAvatar>
                      <ListItemText
                        primary={
                          <Typography sx={{ fontWeight: 700, color: colors.deepPurple }}>
                            {title}
                          </Typography>
                        }
                        secondary={
                          <Typography variant="caption" sx={{ color: colors.calmNavy }}>
                            {type} — {timestamp}
                          </Typography>
                        }
                      />
                    </ListItem>
                    {id !== recentContributions.length && <Divider component="li" />}
                  </React.Fragment>
                ))}
              </List>
            </Paper>
          </Box>

          {/* Quick Actions Panel */}
          <Box>
            <Typography
              variant="h6"
              sx={{ color: colors.calmNavy, mb: 3, fontWeight: 700, fontFamily: 'Poppins' }}
            >
              Quick Actions
            </Typography>
            <Stack direction={{ xs: 'column', sm: 'row' }} spacing={3}>
              {quickActions.map(({ label, icon, tooltip }) => (
                <QuickActionButton
                  key={label}
                  label={label}
                  icon={icon}
                  tooltip={tooltip}
                  onClick={() => handleActionClick(label)}
                />
              ))}
            </Stack>
          </Box>
        </Container>
      </Box>
      <Box sx={{ pl: { md: "260px" } }}>
      <Footer />
    </Box>
    </>
  );
}
