// src/components/volunteers/Articles.js
import React, { useState, useMemo, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import {
  Box,
  Typography,
  Paper,
  InputBase,
  IconButton,
  Grid,
  InputAdornment,
  Container,
  CircularProgress,
  Alert,
} from "@mui/material";
import SearchIcon from "@mui/icons-material/Search";
import ClearIcon from "@mui/icons-material/Clear";
import PersonIcon from "@mui/icons-material/Person";
import CalendarTodayIcon from "@mui/icons-material/CalendarToday";
import ThumbUpIcon from "@mui/icons-material/ThumbUp";
import ChatBubbleOutlineIcon from "@mui/icons-material/ChatBubbleOutline";
import Footer from "../home/Footer";
import SideBar from "./SideBar";
import VolunteerNav from "./VolunteerNav";
import articleService from "../../services/articleService";

const colors = {
  softLavender: "#C3B1E1",
  deepPurple: "#390797",
  lightSkyBlue: "#A0C4FD",
  calmNavy: "#2B3F99",
  backgroundLight: "#FFFFFF",
};

function ArticleCard({ article, onClick }) {
  const formatDate = (timestamp) => {
    if (!timestamp) return 'Recently';
    try {
      // timestamp is in milliseconds from backend
      const date = new Date(timestamp);
      
      // Check if date is valid
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

  return (
    <Paper
      elevation={3}
      component="article"
      role="button"
      tabIndex={0}
      aria-label={`Article titled ${article.title} by ${article.authorName || 'Unknown'}`}
      onClick={onClick}
      onKeyDown={(e) => {
        if (e.key === "Enter" || e.key === " ") {
          e.preventDefault();
          onClick();
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
              <Typography variant="caption">{article.authorName || 'Anonymous'}</Typography>
            </Box>
            <Box sx={{ display: "flex", alignItems: "center", gap: 0.5 }}>
              <CalendarTodayIcon sx={{ fontSize: 18, color: colors.lightSkyBlue }} aria-hidden="true" />
              <Typography variant="caption">{formatDate(article.created_at || article.createdAt)}</Typography>
            </Box>
          </Box>
          
          {/* Like and Comment Count */}
          <Box sx={{ display: "flex", gap: 3, alignItems: "center", pt: 1.5, borderTop: `1px solid ${colors.softLavender}` }}>
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
        </Box>
      </Box>
    </Paper>
  );
}

export default function Articles() {
  const navigate = useNavigate();
  const [searchTerm, setSearchTerm] = useState("");
  const [articles, setArticles] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  // Fetch articles from backend
  useEffect(() => {
    const fetchArticles = async () => {
      try {
        setLoading(true);
        setError(null);
        
        console.log('Fetching all published articles...');
        const response = await articleService.getAllPublishedArticles();
        
        if (response.success) {
          console.log('Articles fetched successfully:', response.data.length, 'articles');
          // Log first article to check data structure
          if (response.data.length > 0) {
            console.log('Sample article data:', response.data[0]);
            console.log('created_at field:', response.data[0].created_at);
            console.log('createdAt field:', response.data[0].createdAt);
          }
          setArticles(response.data || []);
        } else {
          console.error('Failed to fetch articles:', response.message);
          setError(response.message || 'Failed to load articles');
        }
      } catch (err) {
        console.error('Error fetching articles:', err);
        setError('Failed to load articles. Please try again.');
      } finally {
        setLoading(false);
      }
    };

    fetchArticles();
  }, []);

  const filteredArticles = useMemo(() => {
    return (articles || []).filter((article) => {
      const lowerSearch = searchTerm.toLowerCase();
      const matchSearch =
        article.title?.toLowerCase().includes(lowerSearch) ||
        article.summary?.toLowerCase().includes(lowerSearch) ||
        article.content?.toLowerCase().includes(lowerSearch) ||
        article.authorName?.toLowerCase().includes(lowerSearch) ||
        article.categoryName?.toLowerCase().includes(lowerSearch);
      return matchSearch;
    });
  }, [articles, searchTerm]);

  const handleArticleClick = (articleId) => {
    console.log('Navigating to article:', articleId);
    navigate(`/volunteer/articles/${articleId}`);
  };

  return (
    <Box
      sx={{
        minHeight: "100vh",
        background: `linear-gradient(135deg, ${colors.softLavender} 0%, ${colors.lightSkyBlue} 100%)`,
        fontFamily: `"Poppins", "Lato", "Nunito", Arial, sans-serif`,
        color: colors.calmNavy,
        display: "flex",
        flexDirection: "column",
      }}
    >
      {/* Top Navbar */}
      <VolunteerNav />

      {/* Layout with Sidebar and Main Content */}
      <Box sx={{ display: "flex", flex: 1, minHeight: "calc(100vh - 80px)" }}>
        {/* Sidebar */}
        <SideBar />

        {/* Main Content */}
        <Box
          sx={{
            flex: 1,
            pl: { md: "260px" }, // Sidebar width
            pt: { xs: 2, md: 4 },
            pb: 0,
            minHeight: "100vh",
            background: "transparent",
            display: "flex",
            flexDirection: "column",
          }}
        >
          {/* Header */}
          <Box
            sx={{
              width: "100%",
              bgcolor: "#fff",
              boxShadow: `0 2px 8px ${colors.softLavender}33`,
              py: 3,
              px: { xs: 2, md: 8 },
              mb: 4,
              borderRadius: 2,
            }}
          >
            <Typography
              variant="h4"
              sx={{
                color: colors.deepPurple,
                fontWeight: 800,
                letterSpacing: 1,
                mb: 1,
                textAlign: "center",
              }}
            >
              Explore Articles & Insights
            </Typography>
            <Typography
              sx={{
                color: colors.calmNavy,
                fontSize: 18,
                textAlign: "center",
                opacity: 0.9,
                fontWeight: 500,
              }}
            >
              Discover tips, stories, and knowledge to empower your dementia care journey.
            </Typography>
          </Box>

          {/* Search */}
          <Container maxWidth="lg" sx={{ mb: 4 }}>
            <Box
              sx={{
                display: "flex",
                justifyContent: "center",
                alignItems: "center",
              }}
            >
              <Paper
                component="form"
                sx={{
                  borderRadius: 3,
                  bgcolor: colors.softLavender,
                  width: { xs: "100%", sm: 400 },
                  display: "flex",
                  alignItems: "center",
                  pl: 1,
                  pr: 1,
                  py: 0.25,
                }}
                onSubmit={(e) => e.preventDefault()}
                aria-label="Search articles"
              >
                <InputBase
                  placeholder="Search articles, authors, tags..."
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  inputProps={{ "aria-label": "Search articles, authors, tags" }}
                  sx={{
                    ml: 1,
                    flex: 1,
                    color: colors.deepPurple,
                    fontSize: 15,
                    userSelect: "text",
                  }}
                  endAdornment={
                    searchTerm ? (
                      <InputAdornment position="end" sx={{ mr: -1 }}>
                        <IconButton
                          aria-label="Clear search"
                          onClick={() => setSearchTerm("")}
                          size="small"
                        >
                          <ClearIcon sx={{ color: colors.deepPurple }} />
                        </IconButton>
                      </InputAdornment>
                    ) : null
                  }
                />
                <IconButton aria-label="search" sx={{ color: colors.deepPurple }}>
                  <SearchIcon />
                </IconButton>
              </Paper>
            </Box>
          </Container>

          {/* Articles Grid */}
          <Container maxWidth={false} sx={{ flexGrow: 1, display: "flex", flexDirection: "column", px: 4 }}>
            {loading ? (
              <Box sx={{ display: "flex", justifyContent: "center", alignItems: "center", minHeight: "400px" }}>
                <CircularProgress sx={{ color: colors.deepPurple }} />
                <Typography variant="body1" sx={{ ml: 2, color: colors.calmNavy }}>
                  Loading articles...
                </Typography>
              </Box>
            ) : error ? (
              <Box sx={{ mt: 4 }}>
                <Alert severity="error" sx={{ mb: 2 }}>
                  {error}
                </Alert>
                <Box sx={{ textAlign: "center" }}>
                  <Typography variant="body2" sx={{ color: colors.calmNavy }}>
                    Please try refreshing the page or contact support if the problem persists.
                  </Typography>
                </Box>
              </Box>
            ) : filteredArticles.length > 0 ? (
              <Grid container spacing={3} aria-label="Articles grid" sx={{ pb: 6, width: '100%' }}>
                {filteredArticles.map((article) => (
                  <Grid item xs={12} key={article.articleId} sx={{ width: '100%' }}>
                    <ArticleCard 
                      article={article} 
                      onClick={() => handleArticleClick(article.articleId)}
                    />
                  </Grid>
                ))}
              </Grid>
            ) : (
              <Box
                sx={{
                  textAlign: "center",
                  mt: 12,
                  color: colors.calmNavy,
                  userSelect: "none",
                }}
              >
                <SearchIcon sx={{ fontSize: 80, color: colors.softLavender, mb: 2 }} />
                <Typography variant="h6" sx={{ fontWeight: 600, mb: 1, color: colors.deepPurple }}>
                  {searchTerm 
                    ? "No articles match your search" 
                    : "No articles available yet"}
                </Typography>
                <Typography variant="body2" sx={{ color: colors.calmNavy, opacity: 0.7 }}>
                  {searchTerm
                    ? "Try adjusting your search terms"
                    : "Check back later for new content"}
                </Typography>
              </Box>
            )}
          </Container>
        </Box>
      </Box>

      {/* Footer */}
      <Box sx={{ width: "100%", bgcolor: colors.calmNavy, mt: "auto", pt: 4, pb: 2 }}>
        <Footer />
      </Box>
    </Box>
  );
}





