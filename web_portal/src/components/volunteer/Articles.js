// src/components/volunteers/Articles.js
import React, { useState, useMemo } from "react";
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
import Footer from "../home/Footer";
import SideBar from "./SideBar";
import VolunteerNav from "./VolunteerNav";

const colors = {
  softLavender: "#C3B1E1",
  deepPurple: "#390797",
  lightSkyBlue: "#A0C4FD",
  calmNavy: "#2B3F99",
  backgroundLight: "#FFFFFF",
};

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
      onClick={() => alert(`Open article: ${article.title} (demo)`)}
      onKeyDown={(e) => {
        if (e.key === "Enter" || e.key === " ") {
          e.preventDefault();
          alert(`Open article: ${article.title} (demo)`);
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
        bgcolor: "#fff",
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

          {/* Filters & Search */}
          <Container maxWidth="lg" sx={{ mb: 4 }}>
            <Box
              sx={{
                display: "flex",
                flexWrap: "wrap",
                gap: 2,
                justifyContent: "center",
                alignItems: "center",
                mb: 2,
              }}
            >
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
                  bgcolor: "#fff",
                  "& .MuiOutlinedInput-notchedOutline": {
                    borderColor: colors.softLavender,
                  },
                  "&:hover .MuiOutlinedInput-notchedOutline": {
                    borderColor: colors.deepPurple,
                  },
                }}
                size="small"
              >
                {categories.map((cat) => (
                  <MenuItem key={cat} value={cat}>
                    {cat}
                  </MenuItem>
                ))}
              </Select>
              <Paper
                component="form"
                sx={{
                  borderRadius: 3,
                  bgcolor: colors.softLavender,
                  width: { xs: "100%", sm: 320 },
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
          <Container maxWidth="lg" sx={{ flexGrow: 1, display: "flex", flexDirection: "column" }}>
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
        </Box>
      </Box>

      {/* Footer */}
      <Box sx={{ width: "100%", bgcolor: colors.calmNavy, mt: "auto", pt: 4, pb: 2 }}>
        <Footer />
      </Box>
    </Box>
  );
}





