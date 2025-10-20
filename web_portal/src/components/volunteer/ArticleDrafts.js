// src/components/volunteers/ArticleDrafts.js
import React, { useState, useEffect } from "react";
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
  Alert,
  CircularProgress,
} from "@mui/material";
import EditIcon from "@mui/icons-material/Edit";
import DeleteIcon from "@mui/icons-material/Delete";
import VisibilityIcon from "@mui/icons-material/Visibility";

import SideBar from "./SideBar";
import VolunteerNav from "./VolunteerNav";
import Footer from "../home/Footer";
import AuthService from "../../services/authService";
import articleService from "../../services/articleService";

const colors = {
  softLavender: "#C3B1E1",
  deepPurple: "#390797",
  lightSkyBlue: "#A0C4FD",
  calmNavy: "#2B3F99",
  white: "#FFFFFF",
  backgroundLight: "#F7F8FA",
};

export default function ArticleDrafts({
  volunteerName = "Alex Morgan",
  volunteerProfileImage = "https://randomuser.me/api/portraits/women/44.jpg",
  onNavigate = () => {},
}) {
  const [drafts, setDrafts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [currentUser, setCurrentUser] = useState(null);
  const [deleting, setDeleting] = useState(null); // Track which draft is being deleted

  // Format timestamp to readable date
  const formatDate = (timestamp) => {
    if (!timestamp) return "Unknown date";
    
    try {
      const date = new Date(timestamp);
      return date.toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'long',
        day: 'numeric'
      });
    } catch (error) {
      return "Unknown date";
    }
  };

  // Generate excerpt from content
  const generateExcerpt = (content, summary) => {
    if (summary && summary.trim() !== '') {
      return summary.length > 100 ? summary.substring(0, 100) + '...' : summary;
    }
    
    if (content && content.trim() !== '') {
      // Remove HTML tags and get first 100 characters
      const cleanContent = content.replace(/<[^>]*>/g, '').trim();
      return cleanContent.length > 100 ? cleanContent.substring(0, 100) + '...' : cleanContent;
    }
    
    return "No content available";
  };

  // Fetch draft articles
  const fetchDrafts = async () => {
    try {
      setLoading(true);
      setError(null);

      const user = AuthService.getCurrentUser();
      if (!user || !user.id) {
        setError("User not authenticated. Please log in again.");
        return;
      }

      setCurrentUser(user);
      console.log("Fetching drafts for volunteer ID:", user.id);

      const response = await articleService.getDraftArticles(user.id);
      
      if (response.success) {
        console.log("Draft articles fetched:", response.data);
        setDrafts(response.data || []);
      } else {
        setError(response.message || "Failed to fetch draft articles");
      }

    } catch (error) {
      console.error("Error fetching drafts:", error);
      setError("Failed to load draft articles. Please try again.");
    } finally {
      setLoading(false);
    }
  };

  // Load drafts on component mount
  useEffect(() => {
    fetchDrafts();
  }, []);

  const handleView = (draft) => {
    console.log("View draft:", draft);
    // Navigate to ViewDraft page
    window.location.href = `/ViewDraft/${draft.articleId}`;
  };

  const handleEdit = (draft) => {
    console.log("Edit draft:", draft);
    // Navigate to EditDraft page
    window.location.href = `/EditDraft/${draft.articleId}`;
  };

  const handleDelete = async (draft) => {
    if (!window.confirm(`Are you sure you want to delete the draft "${draft.title}"?\n\nThis action cannot be undone.`)) {
      return;
    }

    try {
      setDeleting(draft.articleId);

      const user = AuthService.getCurrentUser();
      if (!user || !user.id) {
        alert("User not authenticated. Please log in again.");
        return;
      }

      console.log("Deleting draft:", draft.articleId);
      const response = await articleService.deleteArticle(draft.articleId, user.id);

      if (response.success) {
        // Remove the draft from the local state
        setDrafts(prevDrafts => prevDrafts.filter(d => d.articleId !== draft.articleId));
        alert("Draft deleted successfully!");
      } else {
        alert(response.message || "Failed to delete draft");
      }

    } catch (error) {
      console.error("Error deleting draft:", error);
      alert("An error occurred while deleting the draft. Please try again.");
    } finally {
      setDeleting(null);
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
        volunteerName={currentUser?.firstName ? `${currentUser.firstName} ${currentUser.lastName}` : volunteerName}
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

          {/* Error Alert */}
          {error && (
            <Alert severity="error" sx={{ mb: 3 }}>
              {error}
            </Alert>
          )}

          {/* Loading State */}
          {loading ? (
            <Box display="flex" justifyContent="center" alignItems="center" py={4}>
              <CircularProgress color="primary" />
              <Typography variant="body1" sx={{ ml: 2 }}>
                Loading your drafts...
              </Typography>
            </Box>
          ) : drafts.length === 0 ? (
            <Paper elevation={2} sx={{ p: 4, textAlign: 'center', borderRadius: 2 }}>
              <Typography variant="body1" sx={{ fontStyle: "italic", color: colors.softLavender, mb: 2 }}>
                No saved drafts yet.
              </Typography>
              <Typography variant="body2" sx={{ color: colors.calmNavy }}>
                Start writing your first article to see drafts here.
              </Typography>
            </Paper>
          ) : (
            <List>
              {drafts.map((draft) => (
                <Paper
                  key={draft.articleId}
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
                            aria-label={`View draft ${draft.title}`}
                            onClick={() => handleView(draft)}
                            color="primary"
                            size="small"
                          >
                            <VisibilityIcon />
                          </IconButton>
                        </Tooltip>
                        <Tooltip title="Edit Draft" arrow>
                          <IconButton
                            edge="end"
                            aria-label={`Edit draft ${draft.title}`}
                            onClick={() => handleEdit(draft)}
                            color="secondary"
                            size="small"
                          >
                            <EditIcon />
                          </IconButton>
                        </Tooltip>
                        <Tooltip title="Delete Draft" arrow>
                          <IconButton
                            edge="end"
                            aria-label={`Delete draft ${draft.title}`}
                            onClick={() => handleDelete(draft)}
                            color="error"
                            size="small"
                            disabled={deleting === draft.articleId}
                            sx={{ opacity: deleting === draft.articleId ? 0.5 : 1 }}
                          >
                            <DeleteIcon />
                          </IconButton>
                        </Tooltip>
                      </Stack>
                    }
                  >
                    <ListItemAvatar sx={{ mr: 3 }}>
                      <Avatar
                        src={draft.articleImg || "https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=64&h=64&fit=crop"}
                        alt={draft.title}
                        sx={{ 
                          width: 64, 
                          height: 64, 
                          border: `2px solid ${colors.lightSkyBlue}`,
                          bgcolor: colors.softLavender 
                        }}
                      >
                        {/* Fallback to first letter of title */}
                        {draft.title?.charAt(0)?.toUpperCase()}
                      </Avatar>
                    </ListItemAvatar>
                    <ListItemText
                      primary={
                        <Typography
                          sx={{ fontWeight: 700, color: colors.deepPurple, userSelect: "text" }}
                          noWrap
                        >
                          {draft.title || "Untitled Draft"}
                        </Typography>
                      }
                      secondary={
                        <>
                          <Typography
                            variant="body2"
                            sx={{ color: colors.calmNavy, userSelect: "text" }}
                            noWrap
                          >
                            {generateExcerpt(draft.content, draft.summary)}
                          </Typography>
                          <Typography
                            variant="caption"
                            sx={{ mt: 0.5, display: "block", color: colors.softLavender }}
                          >
                            Last updated: {formatDate(draft.created_at)}
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
