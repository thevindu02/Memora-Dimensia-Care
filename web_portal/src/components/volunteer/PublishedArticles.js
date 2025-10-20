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
import PersonIcon from "@mui/icons-material/Person";
import ThumbUpIcon from "@mui/icons-material/ThumbUp";
import ChatBubbleOutlineIcon from "@mui/icons-material/ChatBubbleOutline";
import SearchIcon from "@mui/icons-material/Search";

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
  if (!timestamp) return 'Recently';
  try {
    const date = new Date(timestamp);
    if (isNaN(date.getTime())) {
      return 'Recently';
    }
    return date.toLocaleDateString('en-US', { 
      month: 'short', 
      day: 'numeric', 
      year: 'numeric' 
    });
  } catch (error) {
    console.error('Error formatting date:', error);
    return 'Recently';
  }
};

function ArticleCard({ article, onDelete, isDeleting }) {
  const navigate = useNavigate();

  return (
    <Paper
      elevation={3}
      component="article"
      role="button"
      tabIndex={0}
      aria-label={`Published article titled ${article.title} by ${article.authorName || 'You'}`}
      onClick={() => navigate(`/ViewArticle/${article.articleId}`)}
      onKeyDown={(e) => {
        if (e.key === "Enter" || e.key === " ") {
          e.preventDefault();
          navigate(`/ViewArticle/${article.articleId}`);
        }
      }}
      sx={{
        borderRadius: 3,
        cursor: "pointer",
        display: "flex",
        flexDirection: "column",
        height: 480,
        width: "100%",
        transition: "all 0.3s ease",
        "&:hover": {
          boxShadow: `0 10px 25px ${colors.deepPurple}aa`,
          transform: "translateY(-4px)",
        },
        overflow: "hidden",
        bgcolor: "#fff",
      }}
    >
      {/* Article Image - Top */}
      {article.articleImg ? (
        <Box
          component="img"
          src={article.articleImg}
          alt={`Thumbnail for ${article.title}`}
          loading="lazy"
          onError={(e) => {
            e.target.style.display = 'none';
            e.target.nextSibling.style.display = 'flex';
          }}
          sx={{
            width: "100%",
            height: 250,
            objectFit: "cover",
            flexShrink: 0,
          }}
        />
      ) : null}
      <Box
        sx={{
          width: "100%",
          height: 250,
          bgcolor: colors.softLavender,
          display: article.articleImg ? "none" : "flex",
          alignItems: "center",
          justifyContent: "center",
          flexDirection: "column",
          gap: 1,
          flexShrink: 0,
        }}
      >
        <SearchIcon sx={{ fontSize: 48, color: colors.deepPurple, opacity: 0.5 }} />
        <Typography variant="body2" sx={{ color: colors.deepPurple, opacity: 0.7 }}>
          No image available
        </Typography>
      </Box>
      
      {/* Content - Bottom */}
      <Box sx={{ p: 3, display: "flex", flexDirection: "column", flexGrow: 1, overflow: "hidden" }}>
        {/* Category Badge */}
        {article.categoryName && (
          <Box sx={{ mb: 1.5 }}>
            <Typography
              sx={{
                display: "inline-block",
                bgcolor: colors.lightSkyBlue,
                color: colors.calmNavy,
                px: 1.5,
                py: 0.5,
                borderRadius: 2,
                fontSize: 11,
                fontWeight: 600,
                textTransform: "uppercase",
                letterSpacing: 0.5,
              }}
            >
              {article.categoryName}
            </Typography>
          </Box>
        )}
        
        <Typography
          variant="h6"
          component="h2"
          sx={{
            color: colors.deepPurple,
            fontWeight: 700,
            mb: 1.5,
            overflow: "hidden",
            textOverflow: "ellipsis",
            display: "-webkit-box",
            WebkitLineClamp: 2,
            WebkitBoxOrient: "vertical",
            lineHeight: 1.3,
            userSelect: "text",
          }}
        >
          {article.title}
        </Typography>
        <Typography
          variant="body2"
          sx={{
            color: colors.calmNavy,
            flexGrow: 1,
            mb: 1.5,
            overflow: "hidden",
            textOverflow: "ellipsis",
            display: "-webkit-box",
            WebkitLineClamp: 2,
            WebkitBoxOrient: "vertical",
            userSelect: "text",
          }}
        >
          {article.summary?.substring(0, 100) || article.content?.substring(0, 100) || 'No description available'}...
        </Typography>
        
        <Box sx={{ mt: "auto" }}>
          <Box
            sx={{
              display: "flex",
              justifyContent: "space-between",
              alignItems: "center",
              fontSize: 12,
              color: colors.calmNavy,
              userSelect: "none",
              mb: 1,
            }}
          >
            <Box sx={{ display: "flex", alignItems: "center", gap: 0.5 }}>
              <PersonIcon sx={{ fontSize: 18, color: colors.lightSkyBlue }} aria-hidden="true" />
              <Typography variant="caption">{article.authorName || 'You'}</Typography>
            </Box>
            <Box sx={{ display: "flex", alignItems: "center", gap: 0.5 }}>
              <CalendarTodayIcon sx={{ fontSize: 18, color: colors.lightSkyBlue }} aria-hidden="true" />
              <Typography variant="caption">{formatDate(article.created_at)}</Typography>
            </Box>
          </Box>
          
          {/* Like and Comment Count + Action Buttons */}
          <Box sx={{ 
            display: "flex", 
            justifyContent: "space-between",
            alignItems: "center", 
            pt: 1.5, 
            borderTop: `1px solid ${colors.softLavender}` 
          }}>
            <Box sx={{ display: "flex", gap: 3, alignItems: "center" }}>
              <Box sx={{ display: "flex", alignItems: "center", gap: 0.5 }}>
                <ThumbUpIcon sx={{ fontSize: 18, color: colors.lightSkyBlue }} />
                <Typography variant="body2" sx={{ color: colors.calmNavy, fontWeight: 600 }}>
                  {article.likeCount || 0}
                </Typography>
              </Box>
              <Box sx={{ display: "flex", alignItems: "center", gap: 0.5 }}>
                <ChatBubbleOutlineIcon sx={{ fontSize: 18, color: colors.lightSkyBlue }} />
                <Typography variant="body2" sx={{ color: colors.calmNavy, fontWeight: 600 }}>
                  {article.commentCount || 0}
                </Typography>
              </Box>
            </Box>
            
            {/* Action Buttons */}
            <Stack direction="row" spacing={0.5}>
              <IconButton
                aria-label={`Delete article titled ${article.title}`}
                size="small"
                onClick={(e) => {
                  e.stopPropagation();
                  onDelete(article.articleId, article.title);
                }}
                disabled={isDeleting}
                sx={{
                  padding: "6px",
                  opacity: isDeleting ? 0.5 : 1,
                }}
              >
                <DeleteIcon sx={{ color: "#E04848", fontSize: 20 }} />
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
                <VisibilityIcon sx={{ color: colors.calmNavy, fontSize: 20 }} />
              </IconButton>
            </Stack>
          </Box>
        </Box>
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
  const [deleting, setDeleting] = useState(null); // Track which article is being deleted

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

  // Handle article deletion
  const handleDelete = async (articleId, articleTitle) => {
    if (!window.confirm(`Are you sure you want to delete "${articleTitle}"?\n\nThis action cannot be undone.`)) {
      return;
    }

    try {
      setDeleting(articleId);

      const user = AuthService.getCurrentUser();
      if (!user || !user.id) {
        alert("User not authenticated. Please log in again.");
        return;
      }

      console.log("Deleting article:", articleId);
      const response = await articleService.deleteArticle(articleId, user.id);

      if (response.success) {
        // Remove the article from the local state
        setArticles(prevArticles => prevArticles.filter(article => article.articleId !== articleId));
        alert("Article deleted successfully!");
      } else {
        alert(response.message || "Failed to delete article");
      }

    } catch (error) {
      console.error("Error deleting article:", error);
      alert("An error occurred while deleting the article. Please try again.");
    } finally {
      setDeleting(null);
    }
  };

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
                <ArticleCard 
                  article={article} 
                  onDelete={handleDelete}
                  isDeleting={deleting === article.articleId}
                />
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
