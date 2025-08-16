// src/components/volunteers/ArticleDrafts.js
import React, { useState } from "react";
import {
  Box,
  Typography,
  Container,
  Paper,
  Stack,
  Avatar,
  Button,
  IconButton,
  Divider,
  List,
  ListItem,
  ListItemAvatar,
  ListItemText,
  Tooltip,
} from "@mui/material";
import EditIcon from "@mui/icons-material/Edit";
import DeleteIcon from "@mui/icons-material/Delete";
import VisibilityIcon from "@mui/icons-material/Visibility";

import SideBar from "./SideBar";
import VolunteerNav from "./VolunteerNav";
import Footer from "../home/Footer";

const colors = {
  softLavender: "#C3B1E1",
  deepPurple: "#390797",
  lightSkyBlue: "#A0C4FD",
  calmNavy: "#2B3F99",
  white: "#FFFFFF",
  backgroundLight: "#F7F8FA",
};

// Sample draft articles data
const initialDrafts = [
  {
    id: 1,
    title: "Understanding Dementia Care Basics",
    excerpt: "An introductory overview of dementia care and what volunteers should know.",
    thumbnail: "https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=64&h=64&fit=crop",
    lastUpdated: "August 1, 2025",
  },
  {
    id: 2,
    title: "5 Tips For Volunteers",
    excerpt: "Practical tips to enhance your volunteering experience and impact.",
    thumbnail: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=64&h=64&fit=crop",
    lastUpdated: "July 26, 2025",
  },
  {
    id: 3,
    title: "Creating Dementia-Friendly Activities",
    excerpt: "How to design engaging activities suitable for dementia patients.",
    thumbnail: "https://images.unsplash.com/photo-1526045612212-70caf35c14df?w=64&h=64&fit=crop",
    lastUpdated: "July 15, 2025",
  },
];

export default function ArticleDrafts({
  volunteerName = "Alex Morgan",
  volunteerProfileImage = "https://randomuser.me/api/portraits/women/44.jpg",
  onNavigate = () => {},
}) {
  const [drafts, setDrafts] = useState(initialDrafts);

  const handleView = (id) => {
    alert(`View draft ${id} (dummy)`);
  };

  const handleEdit = (id) => {
    alert(`Edit draft ${id} (dummy)`);
  };

  const handleDelete = (id) => {
    if (window.confirm("Are you sure you want to delete this draft?")) {
      setDrafts((prev) => prev.filter((draft) => draft.id !== id));
    }
  };

  return (
    <>
      {/* Top nav fixed full width on top */}
      <Box
        sx={{
          position: "fixed",
          top: 0,
          left: 0,
          right: 0,
          zIndex: 1400,
          bgcolor: colors.white,
          boxShadow: "0 2px 8px rgb(0 0 0 / 0.1)",
        }}
      >
        <VolunteerNav />
      </Box>

      {/* Sidebar fixed on left */}
      <SideBar
        volunteerName={volunteerName}
        profileImage={volunteerProfileImage}
        onNavigate={onNavigate}
      />

      {/* Main content area with left padding for sidebar, top padding for nav */}
      <Box
        component="main"
        sx={{
          pl: { md: "260px" }, // Sidebar width
          pt: { xs: "56px", md: "130px" }, // Nav height approx
          minHeight: "100vh",
          bgcolor: colors.backgroundLight,
          fontFamily: "Poppins, Lato, Nunito, Arial, sans-serif",
          color: colors.calmNavy,
          pb: 8,
          px: { xs: 2, sm: 4, md: 6 },
        }}
      >
        <Container maxWidth="md" sx={{ py: 3 }}>
          <Typography
            variant="h4"
            sx={{ fontWeight: 700, color: colors.deepPurple, mb: 4 }}
          >
            Article Drafts
          </Typography>

          {drafts.length === 0 ? (
            <Typography variant="body1" sx={{ fontStyle: "italic", color: colors.softLavender }}>
              No saved drafts yet.
            </Typography>
          ) : (
            <List>
              {drafts.map(({ id, title, excerpt, thumbnail, lastUpdated }) => (
                <Paper
                  key={id}
                  elevation={3}
                  sx={{
                    mb: 3,
                    borderRadius: 2,
                    px: 2,
                    py: 1.5,
                    boxShadow: `0 6px 15px ${colors.softLavender}88`,
                    "&:hover": { boxShadow: `0 12px 30px ${colors.deepPurple}cc` },
                    cursor: "default",
                  }}
                >
                  <ListItem
                    secondaryAction={
                      <Stack direction="row" spacing={1}>
                        <Tooltip title="View Draft" arrow>
                          <IconButton
                            edge="end"
                            aria-label={`View draft ${title}`}
                            onClick={() => handleView(id)}
                            color="primary"
                            size="small"
                          >
                            <VisibilityIcon />
                          </IconButton>
                        </Tooltip>
                        <Tooltip title="Edit Draft" arrow>
                          <IconButton
                            edge="end"
                            aria-label={`Edit draft ${title}`}
                            onClick={() => handleEdit(id)}
                            color="secondary"
                            size="small"
                          >
                            <EditIcon />
                          </IconButton>
                        </Tooltip>
                        <Tooltip title="Delete Draft" arrow>
                          <IconButton
                            edge="end"
                            aria-label={`Delete draft ${title}`}
                            onClick={() => handleDelete(id)}
                            color="error"
                            size="small"
                          >
                            <DeleteIcon />
                          </IconButton>
                        </Tooltip>
                      </Stack>
                    }
                  >
                    <ListItemAvatar>
                      <Avatar
                        src={thumbnail}
                        alt={title}
                        sx={{ width: 64, height: 64, border: `2px solid ${colors.lightSkyBlue}` }}
                      />
                    </ListItemAvatar>
                    <ListItemText
                      primary={
                        <Typography
                          sx={{ fontWeight: 700, color: colors.deepPurple, userSelect: "text" }}
                          noWrap
                        >
                          {title}
                        </Typography>
                      }
                      secondary={
                        <>
                          <Typography
                            variant="body2"
                            sx={{ color: colors.calmNavy, userSelect: "text" }}
                            noWrap
                          >
                            {excerpt}
                          </Typography>
                          <Typography
                            variant="caption"
                            sx={{ mt: 0.5, display: "block", color: colors.softLavender }}
                          >
                            Last updated: {lastUpdated}
                          </Typography>
                        </>
                      }
                    />
                  </ListItem>
                </Paper>
              ))}
            </List>
          )}
        </Container>
      </Box>

      <Box sx={{ pl: { md: "260px" } }}>
      <Footer />
    </Box>
    </>
  );
}
