// src/components/volunteers/PublishedArticles.js
import React, { useState, useEffect } from "react";
import { useNavigate } from 'react-router-dom';

import {
  Box,
  Typography,
  Paper,
  Grid,
  Button,
  IconButton,
  Badge,
  Stack,
  CircularProgress,
  Alert,
} from "@mui/material";

import DeleteIcon from "@mui/icons-material/Delete";
import CalendarTodayIcon from "@mui/icons-material/CalendarToday";
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
  backgroundLight: "#FFFFFF",
  fallbackGray: "#f0f0f0",
};

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
    return summary.length > 150 ? summary.substring(0, 150) + '...' : summary;
  }
  
  if (content && content.trim() !== '') {
    // Remove HTML tags and get first 150 characters
    const cleanContent = content.replace(/<[^>]*>/g, '').trim();
    return cleanContent.length > 150 ? cleanContent.substring(0, 150) + '...' : cleanContent;
  }
  
  return "No content available";
};

function ArticleCard({ article }) {
  const navigate = useNavigate();

  const fallbackImage =
    "https://images.unsplash.com/photo-1515377905703-c4788e51af15?auto=format&fit=crop&w=600&q=80";

  return (
    <Paper
      elevation={4}
      tabIndex={0}
      role="article"
      aria-label={`Published article titled ${article.title}`}
      sx={{
        borderRadius: 3,
        overflow: "hidden",
        display: "flex",
        flexDirection: "column",
        height: "100%",
        width: "100%",
        minHeight: 450,
        maxWidth: "100%",
        cursor: "pointer",
        boxShadow: `0 2px 8px ${colors.softLavender}AA`,
        transition: "box-shadow 0.3s ease",
        "&:hover": {
          boxShadow: `0 10px 30px ${colors.deepPurple}88`,
        },
        outlineOffset: 2,
        outline: "none",
        "&:focus-visible": {
          outline: `2px solid ${colors.lightSkyBlue}`,
        },
      }}
      onClick={() => navigate(`/ViewArticle/${article.articleId}`)}
      onKeyDown={(e) => {
        if (e.key === "Enter" || e.key === " ") {
          e.preventDefault();
          navigate(`/ViewArticle/${article.articleId}`);
        }
      }}
    >
      <Box
        component="img"
        src={article.articleImg || fallbackImage}
        alt={article.articleImg ? `Thumbnail of ${article.title}` : "Fallback illustration"}
        loading="lazy"
        sx={{
          width: "100%",
          height: 200,
          objectFit: "cover",
          backgroundColor: colors.fallbackGray,
          flexShrink: 0,
        }}
      />
      <Box sx={{ p: 2.5, flexGrow: 1, display: "flex", flexDirection: "column", minHeight: 0 }}>
        <Typography
          variant="h6"
          sx={{
            fontWeight: 700,
            color: colors.deepPurple,
            mb: 1.5,
            overflow: "hidden",
            textOverflow: "ellipsis",
            display: "-webkit-box",
            WebkitLineClamp: 2,
            WebkitBoxOrient: "vertical",
            userSelect: "text",
            minHeight: "3.6em",
            lineHeight: 1.4,
          }}
        >
          {article.title || "Untitled Article"}
        </Typography>
        <Typography
          variant="body2"
          sx={{
            flexGrow: 1,
            color: colors.calmNavy,
            mb: 2,
            overflow: "hidden",
            textOverflow: "ellipsis",
            display: "-webkit-box",
            WebkitLineClamp: 3,
            WebkitBoxOrient: "vertical",
            userSelect: "text",
            minHeight: "4.5em",
            lineHeight: 1.5,
          }}
        >
          {generateExcerpt(article.content, article.summary)}
        </Typography>

        <Stack
          direction="row"
          justifyContent="space-between"
          alignItems="center"
          sx={{ fontSize: 12, userSelect: "none", color: colors.calmNavy, mt: "auto" }}
        >
          <Stack direction="row" alignItems="center" spacing={0.5}>
            <CalendarTodayIcon fontSize="small" sx={{ color: colors.lightSkyBlue }} />
            <time dateTime={article.created_at}>
              {formatDate(article.created_at)}
            </time>
          </Stack>

          <Stack direction="row" spacing={1}>
            <IconButton
              aria-label={`Delete article titled ${article.title}`}
              size="small"
              onClick={(e) => {
                e.stopPropagation();
                /* Confirm before deleting */
                if (window.confirm(`Are you sure you want to delete "${article.title}"?`)) {
                  alert(`Deleted article: ${article.title} (dummy)`);
                }
              }}
              sx={{
                padding: "6px",
              }}
            >
              <DeleteIcon sx={{ color: "#E04848" }} fontSize="small" />
            </IconButton>

            <IconButton
              aria-label={`View full article titled ${article.title}`}
              size="small"
              onClick={(e) => {
                e.stopPropagation();
                navigate(`/ViewArticle/${article.articleId}`);
              }}
              sx={{
                padding: "6px",
              }}
            >
              <VisibilityIcon sx={{ color: colors.calmNavy }} fontSize="small" />
            </IconButton>
          </Stack>
        </Stack>
      </Box>
    </Paper>
  );
}

export default function PublishedArticles() {
  const navigate = useNavigate();
  const [articles, setArticles] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [currentUser, setCurrentUser] = useState(null);

  const articlesCount = articles.length;

  // Fetch published articles
  const fetchPublishedArticles = async () => {
    try {
      setLoading(true);
      setError(null);

      const user = AuthService.getCurrentUser();
      if (!user || !user.id) {
        setError("User not authenticated. Please log in again.");
        return;
      }

      setCurrentUser(user);
      console.log("Fetching published articles for volunteer ID:", user.id);

      const response = await articleService.getPublishedArticles(user.id);
      
      if (response.success) {
        console.log("Published articles fetched:", response.data);
        setArticles(response.data || []);
      } else {
        setError(response.message || "Failed to fetch published articles");
      }

    } catch (error) {
      console.error("Error fetching published articles:", error);
      setError("Failed to load published articles. Please try again.");
    } finally {
      setLoading(false);
    }
  };

  // Load published articles on component mount
  useEffect(() => {
    fetchPublishedArticles();
  }, []);

  return (
    <>
      {/* Top Nav spanning full width above sidebar */}
      <Box
        sx={{
          position: "fixed",
          top: 0,
          left: 0,
          right: 0,
          height: 64,
          zIndex: 1400,
          bgcolor: colors.backgroundLight,
          boxShadow: "0 2px 8px rgb(0 0 0 / 0.1)",
        }}
      >
        <VolunteerNav />
      </Box>

      {/* Fixed Sidebar */}
      <SideBar
        volunteerName={currentUser?.firstName ? `${currentUser.firstName} ${currentUser.lastName}` : "Alex Morgan"}
        profileImage="https://randomuser.me/api/portraits/women/44.jpg"
        onNavigate={(page) => alert(`Navigate to ${page} (dummy)`)}
      />

      {/* Main content */}
      <Box
        component="main"
        role="main"
        sx={{
          minHeight: "100vh",
          pt: "130px", // nav height
          pb: 10,
          pl: { xs: 2, md: "260px" }, // leave space for sidebar on md+
          pr: { xs: 2, md: 6 },
          bgcolor: colors.backgroundLight,
          fontFamily: `"Poppins", "Lato", "Nunito", Arial, sans-serif`,
          color: colors.calmNavy,
        }}
      >
        {/* Header: title + count + new article button */}
        <Box
          sx={{
            maxWidth: 1200,
            mx: "auto",
            mb: 4,
            display: "flex",
            justifyContent: "space-between",
            alignItems: "center",
            flexWrap: "wrap",
            gap: 2,
          }}
        >
          <Box sx={{ display: "flex", alignItems: "center", gap: 2 }}>
            <Typography variant="h4" fontWeight={700} sx={{ userSelect: "none" }}>
              My Published Articles
            </Typography>
            <Badge
              color="primary"
              badgeContent={articlesCount}
              sx={{
                "& .MuiBadge-badge": {
                  bgcolor: colors.deepPurple,
                  fontWeight: 700,
                  fontSize: 16,
                  minWidth: 32,
                  height: 32,
                  borderRadius: "16px",
                  top: -6,
                },
              }}
              aria-label={`${articlesCount} articles published`}
            />
          </Box>

          <Button
            variant="contained"
            sx={{
              bgcolor: colors.deepPurple,
              "&:hover": { bgcolor: colors.calmNavy },
              textTransform: "none",
              fontWeight: 700,
              px: 3,
              py: 1,
            }}
             onClick={() => navigate("/CreateBlog")}
          >
            + New Article
          </Button>
        </Box>

        {/* Error Alert */}
        {error && (
          <Alert severity="error" sx={{ mb: 3, maxWidth: 1200, mx: "auto" }}>
            {error}
          </Alert>
        )}

        {/* Loading State */}
        {loading ? (
          <Box display="flex" justifyContent="center" alignItems="center" py={8}>
            <CircularProgress color="primary" />
            <Typography variant="body1" sx={{ ml: 2 }}>
              Loading your published articles...
            </Typography>
          </Box>
        ) : articlesCount > 0 ? (
          <Grid container spacing={3} maxWidth={1200} sx={{ mx: "auto" }}>
            {articles.map((article) => (
              <Grid 
                item 
                xs={12} 
                sm={6} 
                md={4} 
                key={article.articleId}
                sx={{ display: "flex" }}
              >
                <ArticleCard article={article} />
              </Grid>
            ))}
          </Grid>
        ) : (
          <Box
            sx={{
              mt: 12,
              color: colors.softLavender,
              textAlign: "center",
              userSelect: "none",
            }}
          >
            <Box
              component="img"
              src="https://images.unsplash.com/photo-1486312338219-ce68d2c6f44d?auto=format&fit=crop&w=240&q=80"
              alt="Empty state illustration"
              sx={{ mx: "auto", mb: 3, maxWidth: 240 }}
              loading="lazy"
            />
            <Typography variant="h6">
              You haven’t published any articles yet. Start sharing your insights!
            </Typography>
          </Box>
        )}
      </Box>

      <Box sx={{ pl: { md: "260px" } }}>
        <Footer />
      </Box>
    </>
  );
}
