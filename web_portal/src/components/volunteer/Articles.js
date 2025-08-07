// src/components/volunteers/Articles.js
import React, { useState, useMemo, useEffect } from "react";
import {
  Box,
  Typography,
  Paper,
  Select,
  MenuItem,
  InputBase,
  IconButton,
  Grid,
  InputAdornment,
  Container,
} from "@mui/material";

import SearchIcon from "@mui/icons-material/Search";
import ClearIcon from "@mui/icons-material/Clear";
import PersonIcon from "@mui/icons-material/Person";
import CalendarTodayIcon from "@mui/icons-material/CalendarToday";

import SideBar from "./SideBar";
import VolunteerNav from "./VolunteerNav";
import Footer from "../home/Footer";

const colors = {
  softLavender: "#C3B1E1",
  deepPurple: "#390797",
  lightSkyBlue: "#A0C4FD",
  calmNavy: "#2B3F99",
  backgroundLight: "#FFFFFF",
};

const volunteerName = "Alex Morgan";
const volunteerProfileImage = "https://randomuser.me/api/portraits/women/44.jpg";

const categories = ["All", "Awareness", "Daily Tips", "Nutrition", "Stories"];

const exampleArticles = [
  {
    id: 1,
    title: "Understanding Dementia Care Basics",
    description:
      "An introductory overview of dementia care, its challenges and how volunteers can help caregivers at home.",
    author: "Emily Rogers",
    publishedDate: "August 1, 2025",
    thumbnail:
      "https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=600&q=80",
    category: "Awareness",
    tags: ["Caregiving", "Basics"],
  },
  {
    id: 2,
    title: "5 Tips For Volunteers",
    description:
      "Practical ways to provide meaningful support and communicate effectively with dementia patients.",
    author: "John Doe",
    publishedDate: "July 26, 2025",
    thumbnail:
      "https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=600&q=80",
    category: "Daily Tips",
    tags: ["Volunteering", "Support"],
  },
  {
    id: 3,
    title: "Healthy Nutrition for Dementia",
    description:
      "A guide to balanced diets and food types that can help improve overall wellbeing for dementia patients.",
    author: "Sarah Kim",
    publishedDate: "July 15, 2025",
    thumbnail:
      "https://images.unsplash.com/photo-1526045612212-70caf35c14df?auto=format&fit=crop&w=600&q=80",
    category: "Nutrition",
    tags: ["Diet", "Health"],
  },
];

function ArticleCard({ article }) {
  return (
    <Paper
      elevation={3}
      component="article"
      role="button"
      tabIndex={0}
      aria-label={`Article titled ${article.title} by ${article.author}`}
      onClick={() => alert(`Open article: ${article.title} (dummy)`)}
      onKeyDown={(e) => {
        if (e.key === "Enter" || e.key === " ") {
          e.preventDefault();
          alert(`Open article: ${article.title} (dummy)`);
        }
      }}
      sx={{
        borderRadius: 3,
        cursor: "pointer",
        display: "flex",
        flexDirection: "column",
        height: "100%",
        transition: "box-shadow 0.3s ease",
        "&:hover": {
          boxShadow: `0 10px 25px ${colors.deepPurple}aa`,
        },
        overflow: "hidden",
      }}
    >
      <Box
        component="img"
        src={article.thumbnail}
        alt={`Thumbnail for ${article.title}`}
        loading="lazy"
        sx={{
          width: "100%",
          aspectRatio: "16 / 9",
          objectFit: "cover",
          flexShrink: 0,
        }}
      />
      <Box sx={{ p: 2, display: "flex", flexDirection: "column", flexGrow: 1 }}>
        <Typography
          variant="h6"
          component="h2"
          sx={{
            color: colors.deepPurple,
            fontWeight: 700,
            mb: 1,
            overflow: "hidden",
            textOverflow: "ellipsis",
            display: "-webkit-box",
            WebkitLineClamp: 2,
            WebkitBoxOrient: "vertical",
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
            mb: 2,
            overflow: "hidden",
            textOverflow: "ellipsis",
            display: "-webkit-box",
            WebkitLineClamp: 3,
            WebkitBoxOrient: "vertical",
            userSelect: "text",
          }}
        >
          {article.description}
        </Typography>
        <Box
          sx={{
            display: "flex",
            justifyContent: "space-between",
            fontSize: 12,
            color: colors.calmNavy,
            userSelect: "none",
          }}
        >
          <Box sx={{ display: "flex", alignItems: "center", gap: 0.5 }}>
            <PersonIcon sx={{ fontSize: 18, color: colors.lightSkyBlue }} aria-hidden="true" />
            <Typography variant="caption">{article.author}</Typography>
          </Box>
          <Box sx={{ display: "flex", alignItems: "center", gap: 0.5 }}>
            <CalendarTodayIcon sx={{ fontSize: 18, color: colors.lightSkyBlue }} aria-hidden="true" />
            <Typography variant="caption">{article.publishedDate}</Typography>
          </Box>
        </Box>
      </Box>
    </Paper>
  );
}

export default function Articles() {
  const [categoryFilter, setCategoryFilter] = useState("All");
  const [searchTerm, setSearchTerm] = useState("");

  const filteredArticles = useMemo(() => {
    return (exampleArticles || []).filter((article) => {
      const matchCategory = categoryFilter === "All" || article.category === categoryFilter;

      const lowerSearch = searchTerm.toLowerCase();
      const matchSearch =
        article.title.toLowerCase().includes(lowerSearch) ||
        article.description.toLowerCase().includes(lowerSearch) ||
        article.author.toLowerCase().includes(lowerSearch) ||
        article.tags.some((tag) => tag.toLowerCase().includes(lowerSearch));

      return matchCategory && matchSearch;
    });
  }, [categoryFilter, searchTerm]);

  // Responsive padding adjustments for sidebar and nav height
  const [windowWidth, setWindowWidth] = React.useState(window.innerWidth);
  useEffect(() => {
    function handleResize() {
      setWindowWidth(window.innerWidth);
    }
    window.addEventListener("resize", handleResize);
    return () => window.removeEventListener("resize", handleResize);
  }, []);

  // Page container padding style with flex column for full height
  const pageStyle = windowWidth >= 768 ? {
    fontFamily: `"Poppins", "Lato", "Nunito", Arial, sans-serif`,
    color: colors.calmNavy,
    backgroundColor: colors.backgroundLight,
    minHeight: "100vh",
    paddingTop: 64, // Height of navbar
    paddingBottom: 80,
    paddingLeft: 260, // Width of sidebar
    paddingRight: 24,
    boxSizing: "border-box",
    display: "flex",
    flexDirection: "column",
  } : {
    fontFamily: `"Poppins", "Lato", "Nunito", Arial, sans-serif`,
    color: colors.calmNavy,
    backgroundColor: colors.backgroundLight,
    minHeight: "100vh",
    paddingTop: 64,
    paddingBottom: 80,
    paddingLeft: 16,
    paddingRight: 16,
    boxSizing: "border-box",
    display: "flex",
    flexDirection: "column",
  };

  return (
    <>
      {/* Fixed Top Navigation Bar */}
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
      <SideBar volunteerName={volunteerName} profileImage={volunteerProfileImage} />

      {/* Main content */}
      <Box component="main" sx={pageStyle} role="main" aria-label="Volunteer articles main content">
        <Container maxWidth="lg" sx={{ flexGrow: 1, display: "flex", flexDirection: "column" }}>
          {/* Header: Title + Filter + Search */}
          <Box
            sx={{
              mb: 5,
              display: "flex",
              flexWrap: "wrap",
              justifyContent: "space-between",
              alignItems: "center",
              gap: 2,
            }}
          >
            <Typography
              variant="h4"
              component="h1"
              sx={{
                color: colors.deepPurple,
                fontWeight: 700,
                flexGrow: 1,
                minWidth: 280,
                userSelect: "none",
              }}
            >
              Explore Articles & Insights
            </Typography>

            <Select
              value={categoryFilter}
              onChange={(e) => setCategoryFilter(e.target.value)}
              aria-label="Filter articles by category"
              sx={{
                minWidth: 160,
                fontSize: 16,
                borderRadius: 2,
                boxShadow: "none",
                color: colors.deepPurple,
                "& .MuiOutlinedInput-notchedOutline": {
                  borderColor: colors.softLavender,
                },
                "&:hover .MuiOutlinedInput-notchedOutline": {
                  borderColor: colors.deepPurple,
                },
                mx: 1,
              }}
              size="small"
            >
              {categories.map((cat) => (
                <MenuItem key={cat} value={cat}>
                  {cat}
                </MenuItem>
              ))}
            </Select>

            {/* Search input */}
            <Paper
              component="form"
              sx={{
                borderRadius: 3,
                bgcolor: colors.softLavender,
                width: { xs: "100%", sm: 280 },
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
                  fontSize: 14,
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

          {/* Articles grid or empty state */}
          {filteredArticles.length > 0 ? (
            <Grid container spacing={4} aria-label="Articles grid" sx={{ pb: 6 }}>
              {filteredArticles.map((article) => (
                <Grid item xs={12} sm={6} md={4} key={article.id}>
                  <ArticleCard article={article} />
                </Grid>
              ))}
            </Grid>
          ) : (
            <Box
              sx={{
                textAlign: "center",
                mt: 12,
                color: colors.softLavender,
                userSelect: "none",
              }}
            >
              <img
                src="https://images.unsplash.com/photo-1535223289827-42f1e9919769?auto=format&fit=crop&w=200&q=80"
                alt="No articles illustration"
                style={{ width: 140, marginBottom: 16, userSelect: "none" }}
                aria-hidden="true"
                draggable={false}
              />
              <Typography variant="body1" sx={{ fontWeight: 600 }}>
                No articles available yet.
              </Typography>
            </Box>
          )}
        </Container>

        {/* Footer with padding */}
        <Box
          sx={{
            pt: 4,
            pb: 4,
            bgcolor: colors.backgroundLight,
          }}
        >
          <Footer />
        </Box>
      </Box>
    </>
  );
}





